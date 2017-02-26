#!/bin/bash
cdir=$(pwd)/../..
docker run --name uc \
	-v $cdir/ucore_os_lab:/labs \
	-v $cdir/os_tutorial_lab:/tut \
	-ti --rm ucore-env /bin/bash
