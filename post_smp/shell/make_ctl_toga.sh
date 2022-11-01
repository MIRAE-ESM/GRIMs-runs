#!/bin/csh -xvf
#
###################################################################
#
#    Make ctl file for smp run
#
#    Program history :
#
#    01-19-2004   Young-Hwa Byun       Initial development
#    08-19-2008   Kyung-Hee Seol       Nudging options, lsm options
#    03-19-2011   Song-You Hong        Clean up, grims setup
#
###################################################################
#
if ( $#argv !=  4 ) then
	echo " Usage : $0 rundir gr_stime INTSIG ENDHOUR
	exit 1
endif
#
  set ddir=$1
  set stime = $2
  set dtv = $3
  set ehr = $4
  set nfile = `expr $ehr / $dtv`
  @ nfile = $nfile + 1
  cd $ddir
#
# ... make ctl file ...
#
cat << EOF_CTL > fgb.ctl
dset ^fgb.%y4%m2%d2%h2
dtype grib
format yrev template
index ^fgb.idx
undef -999.0
title EXP
xdef     1 linear    0.000  1.000
ydef     2 linear   41.072 48.928
zdef     1 levels 1
tdef   $nfile linear          $stime     ${dtv}hr
vars    53
UFLX       0 124,1,0 Zonal component of momentum flux (N/m**2)
VFLX       0 125,1,0 Meridional component of momentum flux (N/m**2)
SHTFL      0 122,1,0 Sensible heat flux (W/m**2)
LHTFL      0 121,1,0 Latent heat flux (W/m**2)
TMPsfc     0 11,1,0 Temperature (K)
SOILW      0 144,112,10 Volumetric soil moisture content (fraction)
TMPdlr     0 11,112,10 Temperature (K)
WEASD      0 65,1,0 Water equiv. of accum. snow depth (kg/m**2)
DLWRF      0 205,1,0 Downward long wave radiation flux (W/m**2)
ULWRFsfc   0 212,1,0 Upward long wave radiation flux (W/m**2)
ULWRFtoa   0 212,8,0 Upward long wave radiation flux (W/m**2)
USWRFtoa   0 211,8,0 Upward solar radiation flux (W/m**2)
USWRFsfc   0 211,1,0 Upward solar radiation flux (W/m**2)
DSWRFsfc   0 204,1,0 Downward solar radiation flux (W/m**2)
TCDChcl    0 71,234,0 Total cloud cover (percent)
PREShct    0 1,233,0 Pressure (Pa)
PREShcb    0 1,232,0 Pressure (Pa)
TMPhct     0 11,233,0 Temperature (K)
TCDCmcl    0 71,224,0 Total cloud cover (percent)
PRESmct    0 1,223,0 Pressure (Pa)
PRESmcb    0 1,222,0 Pressure (Pa)
TMPmct     0 11,223,0 Temperature (K)
TCDClcl    0 71,214,0 Total cloud cover (percent)
PRESlct    0 1,213,0 Pressure (Pa)
PRESlcb    0 1,212,0 Pressure (Pa)
TMPlct     0 11,213,0 Temperature (K)
PRATE      0 59,1,0 Precipitation rate (kg/m**2/s)
CPRAT      0 214,1,0 Convective precipitation rate (kg/m**2/s)
GFLUX      0 155,1,0 Ground heat flux (W/m**2)
LAND       0 81,1,0 Land-sea mask (1=land; 0=sea) (integer)
ICEC       0 91,1,0 Ice concentration (ice=1; no ice=0) (1/0)
UGRD       0 33,105,10 u wind (m/s)
VGRD       0 34,105,10 v wind (m/s)
TMPhag     0 11,105,2 Temperature (K)
SPFH       0 51,105,2 Specific humidity (kg/kg)
PRESsfc    0 1,1,0 Pressure (Pa)
TMAX       0 15,105,2 Maximum temperature (K)
TMIN       0 16,105,2 Minimum temperature (K)
RUNOF      0 90,1,0 Runoff (kg/m**2)
PEVPR      0 145,1,0 Potential evaporation rate (w/m**/)
CWORK      0 146,200,0 Cloud work function (J/Kg)
UGWD       0 147,1,0 Zonal gravity wave stress (N/m**2)
VGWD       0 148,1,0 Meridional gravity wave stress (N/m**2)
HPBL       0 221,1,0 PBL height (m)
PWAT       0 54,200,0 Precipitable water (kg/m**2)
SRWEQ      0 64,1,0 Snowfall rate water equivalent (kg/m**2/s)
SNOEV      0 230,1,0 Snow sublimation heat fulx (W/m**2)
SNOHF      0 229,1,0 Snow melt heat flux (W/m**2)
SDTU       0 202,1,0 Std dev of time tend of zonal wind (m/s)
SDTV       0 203,1,0 Std dev of time tend of merid wind (m/s)
DSWRFtoa   0 204,8,0 Downward solar radiation flux (W/m**2)
TCDCclm    0 71,200,0 Total cloud cover (percent)
ALBDO      0 84,1,0 Albedo (percent)
endvars
EOF_CTL
#
cat << EOF_PCTL > pgb.ctl
dset ^pgb.%y4%m2%d2%h2
dtype grib
format yrev template
index ^pgb.idx
undef -999.0
title EXP
xdef     1 linear    0.000  1.000
ydef     2 linear   41.072 48.928
zdef    40 levels
 1000 975 950 925 900 875 850 825 800 775 750 725 700 675 650
  625 600 575 550 525 500 475 450 425 400 375 350 325 300 275
  250 225 200 175 150 125 100  75  50  25
tdef   $nfile linear          $stime    ${dtv}hr
vars    18
HGTprs    40 7,100,0 Geopotential height (gpm)
UGRD      40 33,100,0 u wind (m/s)
VGRD      40 34,100,0 v wind (m/s)
RH        40 52,100,0 Relative humidity (percent)
SPFH      40 51,100,0 Specific humidity (kg/kg)
TMP       40 11,100,0 Temperature (K)
VVEL      40 39,100,0 Pressure vertical velocity (Pa/s)
ABSV      40 41,100,0 Absolute vorticity (/s)
QC        40 153,100,0 Cloud water (kg/m**2)
QR        40 152,100,0 Rain water (kg/m**2)
PRESsfc    0 1,1,0 Pressure (Pa)
PWAT       0 54,200,0 Precipitable water (kg/m**2)
HGTsfc     0 7,1,0 Geopotential height (gpm)
PRESmsl    0 1,102,0 Pressure (Pa)
AQC        0 76,200,0 Cloud water (kg/m**2)
AQR        0 77,200,0 Rain water (kg/m**2)
AQI        0 67,200,0 Ice water (kg/m**2)
AQS        0 68,200,0 Snow water (kg/m**2)
endvars
EOF_PCTL
#
cat << EOF_DCTL > sasdiag.ctl
dset ^sasdiag.ft%f2
format yrev template
undef -999.0
title EXP
xdef     1 linear    0.000  1.000
ydef     2 linear   41.072 48.928
zdef    40 levels
    0.995 0.970 0.945 0.920 0.895 0.870 0.846 0.821 0.796 0.771
    0.746 0.721 0.696 0.672 0.647 0.622 0.597 0.572 0.547 0.522
    0.497 0.473 0.448 0.423 0.398 0.373 0.348 0.323 0.298 0.274
    0.249 0.224 0.199 0.174 0.149 0.124 0.099 0.075 0.050 0.025

tdef   $nfile linear          $stime     ${dtv}hr
vars   16
dcu    40 99 du_conv
dcv    40 99 dv_conv
dct    40 99 dt_conv
dcq    40 99 dq_conv
dch    40 99 dh_conv
fcu    40 99 mass flux by updraft
fcd    40 99 mass flux by downdraft
dlt    40 99 dt_large_scale
dlq    40 99 dq_large_scale
dlh    40 99 dh_large_scale
deltb   0 99 column dt_conv
delqb   0 99 column dq_conv
delhb   0 99 column dh_conv
cbp     0 99 cloud base pressure by SAS
ctp     0 99 cloud top pressure by SAS
cbmf    0 99 cloud base mass flux 
endvars
EOF_DCTL
#
cat << EOF_DSIG > dg3cld.ctl
dset ^dg3cld.%y4%m2%d2%h2
dtype grib
format yrev template
index ^dg3cld.idx
undef -9.99E+33
title EXP
xdef     1 linear    0.000  1.000
ydef     2 linear   41.072 48.928
zdef    40 levels
    9948    9700    9451    9202    8953    8705    8456    8207    7959    7710
    7461    7212    6964    6715    6466    6218    5969    5720    5472    5223
    4974    4725    4477    4228    3979    3731    3482    3233    2984    2736
    2487    2238    1990    1741    1492    1244     995     746     497     249
*    0.995 0.970 0.945 0.920 0.895 0.870 0.846 0.821 0.796 0.771
*    0.746 0.721 0.696 0.672 0.647 0.622 0.597 0.572 0.547 0.522
*    0.497 0.473 0.448 0.423 0.398 0.373 0.348 0.323 0.298 0.274
*    0.249 0.224 0.199 0.174 0.149 0.124 0.099 0.075 0.050 0.025

tdef   $nfile linear          $stime     ${dtv}hr
vars    32
CDCONsfc   0 72,1,0 Convective cloud cover (percent)
CSULF      0 162,8,0 Clear sky upward long wave flux (W/m**2)
CSUSFtoa   0 160,8,0 Clear sky upward solar flux (W/m**2)
CSDLF      0 163,1,0 Clear sky downward long wave flux (W/m**2)
CSDSF      0 161,1,0 Clear sky downward solar flux (W/m**2)
CSUSFsfc   0 160,1,0 Clear sky upward solar flux (W/m**2)
CFNSFtoa   0 164,8,0 Cloud forcing net solar flux (W/m**2)
CFNSFsfc   0 164,1,0 Cloud forcing net solar flux (W/m**2)
CFNSFclm   0 164,200,0 Cloud forcing net solar flux (W/m**2)
CFNLFtoa   0 165,8,0 Cloud forcing net long wave flux (W/m**2)
CFNLFsfc   0 165,1,0 Cloud forcing net long wave flux (W/m**2)
CFNLFclm   0 165,200,0 Cloud forcing net long wave flux (W/m**2)
LRGHR     40 241,107,0 Large scale condensation heating rate (K/s)
CNVHR     40 242,107,0 Deep convective heating rate (K/s)
CNVMR     40 243,107,0 Deep convective moistening rate (kg/kg/s)
SHAHR     40 244,107,0 Shallow convective heating rate (K/s)
SHAMR     40 245,107,0 Shallow convective moistening rate (kg/kg/s)
VDFHR     40 246,107,0 Vertical diffusion heating rate (K/s)
VDFUA     40 247,107,0 Vertical diffusion zonal accel (m/s/s)
VDFVA     40 248,107,0 Vertical diffusion meridional accel (m/s/s)
VDFMR     40 249,107,0 Vertical diffusion moistening rate (kg/kg/s)
SWHR      40 250,107,0 Solar radiative heating rate (K/s)
LWHR      40 251,107,0 Longwave radiative heating rate (K/s)
TCDCsig   40 71,107,0 Total cloud cover (percent)
CDCONsig  40 72,107,0 Convective cloud cover (percent)
qcicnv    40 185,107,0 Convective Qci (kg/kg)
qrscnv    40 186,107,0 Convective Qrs (kg/kg)
qcilrg    40 187,107,0 Large-scale Qci (kg/kg)
qrslrg    40 188,107,0 Large-scale Qci (kg/kg)
taucld    40 189,107,0 tau_zero (1/Pa)
cldwp     40 190,107,0 cloud water path (kg/m**2)
cldip     40 191,107,0 cloud ice path (kg/m**2)
endvars
EOF_DSIG
#
 gribmap -0 -i fgb.ctl
 gribmap -0 -i dg3cld.ctl     
 gribmap -i pgb.ctl
#
exit
