#!/bin/bash -e
# purpose: run freeview in a container and copy its
#          runtime binary dependencies out to the host.

IMAGE=localhost/fnndsc/freesurfer:gui

HERE="$(dirname "$(readlink -f "$0")")"

# verbose output
set -x

# create a temporary directory
tmpdir=$(mktemp -d freeview-builder-XXXXXX -p /tmp)

# build an image of freesurfer + GUI dependencies
docker build -t $IMAGE .

# run freeview in the background
docker run --rm -d -u "$(id -u):$(id -g)" --name freeview \
    -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY \
    $IMAGE freeview

# wait for freeview to start up
sleep 5

# copy the maps file from host, which mentions every file opened by freeview
pid=$(docker top freeview | tail -n 1 | awk '{print $2}')
cp -v /proc/$pid/maps $tmpdir/maps.txt

# stop freeview container
docker kill -s KILL freeview

# extract list of opened files from maps.txt
cd $tmpdir
cat maps.txt | awk '{print $6}' | grep /usr | sort | uniq > runtime_usr_files.txt

# remove files to exclude
cd "$HERE/file_lists"
to_exclude=$(cat full_dirs.txt excluded.txt)
cd $tmpdir
linebreak=$'\n'
or='\|'
grep -v "${to_exclude//$linebreak/$or}" runtime_usr_files.txt > reduced.txt

# join included files and manually specified dirs
cat reduced.txt "$HERE/file_lists/full_dirs.txt" > needed.txt

# copy needed files within a container
docker run --name freeview-copier -v "$tmpdir/needed.txt:/needed.txt:ro" $IMAGE \
    bash -ec 'mkdir /dist && for f in $(< /needed.txt); do
        target="/dist$f"
        mkdir -vp "${target%/*}"
        cp -rv "$f" "/dist$f"
    done'
docker cp freeview-copier:/dist "$HERE/freesurfer-copied-binaries"
docker rm freeview-copier

# manual fixes
cd "$HERE/freesurfer-copied-binaries"
cd usr/lib64
ln -sv libffi.so.6.0.2 libffi.so.6
ln -sv libGLU.so.1.3.1 libGLU.so.1
ln -sv libgfortran.so.5.0.0 libgfortran.so.5
ln -sv libquadmath.so.0.0.0 libquadmath.so.0

# clean up
set +e
rm -rf $tmpdir
