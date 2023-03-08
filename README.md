# freeview.AppImage

This repository provides a way to build an
[AppImage](https://appimage.org/) of
[freeview](https://surfer.nmr.mgh.harvard.edu/fswiki/FreeviewGuide/FreeviewIntroduction)
using Linux containers.

## Installation

```shell
# obtain a FreeSurfer license from here:
# https://surfer.nmr.mgh.harvard.edu/registration.html
# download the license file and set the variable FS_LICENSE.
# NOTE: this step is unnecessary for FNNDSC Linux computers
export FS_LICENSE=...

# download freeview
wget 'https://github.com/FNNDSC/freeview.AppImage/releases/download/release%2Ffreesurfer-7.3.2%2F1/freeview.AppImage'
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

