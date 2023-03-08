FROM docker.io/freesurfer/freesurfer:7.3.2

# install graphical dependencies into the freesurfer image so that it can run freeview
RUN dnf install -y mesa-libGLU mesa-dri-drivers fontconfig libpng libxcb
