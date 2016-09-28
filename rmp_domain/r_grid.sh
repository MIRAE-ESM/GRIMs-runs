#!/bin/sh
################################################################################
#
# This script visualize domain setup for rmp.
# Note that ncarg should be provided at the environment.
#
################################################################################
#
if [ $# -ne 1 ] ; then
        echo 'Usage: r_grid.sh r_domain.nml'
        echo 'e.g., "r_grid.sh rmp_108x85_60km_nps.korea"'
        echo "`date` $0: Wrong usage." >>ERROR.out
        exit 8
fi
#
PROG=r_grid
#
cp $PROG.f map.f
##/usr/local/ncarg4/pgi/bin/ncargf90 map.f || exit
ncargf90 map.f -o map.exe || exit
#
rm gmeta
./map.exe < $1 || exit
rm ./map.exe
#
echo "idt?(y/n)[y]"
read ans
if [ -z $ans ] || [ $ans != n ]; then
    idt gmeta
fi
#
echo "lpr?(y/n)[n]"
read ans
if [ ! -z $ans ] && [ $ans != y ]; then
    ctrans -d ps.mono gmeta | lpr -PpredhpPS  -h
fi
#
echo "Postscript?(y/n)[y]"
read ans
if [ -z $ans ] || [ $ans != n ]; then
    ctrans -d ps.mono gmeta > gmeta.ps
fi
#
rm gmeta map.f map.o DCNSM.nml fort.72
