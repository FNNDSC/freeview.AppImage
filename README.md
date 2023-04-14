# freeview.AppImage

This repository provides a way to build an
[AppImage](https://appimage.org/) of
[freeview](https://surfer.nmr.mgh.harvard.edu/fswiki/FreeviewGuide/FreeviewIntroduction)
using Linux containers.

## Motivation

`freeview` is a GUI program from FreeSurfer. It can be hard to get working
because of its graphical dependencies (libGL and Qt). Typically, installation
and dependency hell is solved by Linux containers, however it is inconvenient
to run GUI applications using a container runtime.
[AppImage](https://appimage.org/) solves this problem by providing a
user-friendly solution for packaging (typically GUI) programs with their 
dependencies into a single executable file.

Another problem is that often, a user wants to use just `freeview`
(a common user story is to run `recon_all` in a container on a computer
cluster, e.g. via [_ChRIS_](https://chrisproject.org)).
The status quo of how to obtain `freeview` is by downloading the entire
FreeSurfer package, which is a 14GiB in size. It is slow to download and
wasteful of disk space.
Our solution packages `freeview` in a single 109MiB file.

## Installation

```shell
# obtain a FreeSurfer license from here:
# https://surfer.nmr.mgh.harvard.edu/registration.html
# download the license file and set the variable FS_LICENSE.
# NOTE: this step is unnecessary for FNNDSC Linux computers
export FS_LICENSE=...

# download freeview
wget -O freeview.AppImage 'https://github.com/FNNDSC/freeview.AppImage/releases/download/release%2Ffreesurfer-7.3.2%2F2/Freeview-7.3.2.build2-x86_64.AppImage'
chmod +x freeview.AppImage

# alright! it's ready to use.
./freeview.AppImage --help

# optional: install for all users
sudo mv freeview.AppImage /opt/freeview.AppImage
sudo ln -sv /opt/freeview.AppImage /usr/local/bin/freeview
freeview --help

# example: read a NIFTI
wget -O /tmp/brain.nii 'https://github.com/FNNDSC/SAG-anon-nii/raw/b04fab8ec5a036734880971093cac167a8aad687/SAG-anon.nii'
./freeview.AppImage /tmp/brain.nii
# or, if installed for all users:
freeview /tmp/brain.nii
```

## Build

Instructions for developers of `freeview.AppImage`

Requirements:

- Linux on x86_64 architecture
- GNU coreutils
- GNU make
- wget
- Docker or Podman

```shell
make
```
