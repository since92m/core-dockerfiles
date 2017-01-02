docker save ubuntu:14.04 | bzip2 > ubuntu14.04.tar.bz2
bzip2 -dc ubuntu14.04.tar.bz2 | docker load
