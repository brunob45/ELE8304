#!/usr/bin/env tcsh
#-----------------------------------------------------------------------------
# Project    : Tutoriel du GRM
#-----------------------------------------------------------------------------
# File       : setup.csh
# Author     : Mickael Fiorentino <mickael.fiorentino@polymtl.ca>
#            : Erika Miller-Jolicoeur <erika.miller-jolicoeur@polymtl.ca>
# Lab        : grm@polymtl
# Created    : 2018-06-19
# Last update: 2018-09-07
#-----------------------------------------------------------------------------
# Description: Project Setup
#-----------------------------------------------------------------------------

source /CMC/scripts/cmc.2017.12.csh
setenv KIT_HOME  /CMC/kits/AMSKIT616_GPDK
setenv WORK_HOME `pwd`

#===========================================================================#
# WORK                                                                      #
#===========================================================================#

setenv TUTO_INV $WORK_HOME/Tuto/inverseur
setenv TUTO_CPT $WORK_HOME/Tuto/compteur

setenv TUTO_CPT_SCRIPT  $TUTO_CPT/scripts
setenv TUTO_CPT_SRC     $TUTO_CPT/sources
setenv TUTO_CPT_SIM     $TUTO_CPT/simulation
setenv TUTO_CPT_IMP     $TUTO_CPT/implementation

setenv TUTO_CPT_SRC_HDL $TUTO_CPT_SRC/hdl
setenv TUTO_CPT_SRC_CST $TUTO_CPT_SRC/ctr

setenv TUTO_CPT_SIM_BEH $TUTO_CPT_SIM/beh
setenv TUTO_CPT_SIM_SYN $TUTO_CPT_SIM/syn
setenv TUTO_CPT_SIM_PNR $TUTO_CPT_SIM/pnr

setenv TUTO_CPT_SYN     $TUTO_CPT_IMP/syn
setenv TUTO_CPT_SYN_NET $TUTO_CPT_SYN/netlist
setenv TUTO_CPT_SYN_REP $TUTO_CPT_SYN/reports

setenv TUTO_CPT_PNR     $TUTO_CPT_IMP/pnr
setenv TUTO_CPT_PNR_OUT $TUTO_CPT_PNR/netlist
setenv TUTO_CPT_PNR_REP $TUTO_CPT_PNR/reports
setenv TUTO_CPT_PNR_PWR $TUTO_CPT_PNR_REP/power
setenv TUTO_CPT_PNR_LEC $TUTO_CPT_PNR_REP/lec

#===========================================================================#
# GPDK45 LIBRARY                                                            #
#===========================================================================#

setenv LIB_TECHDIR   $KIT_HOME/tech
setenv LIB_SIMDIR    $KIT_HOME/simlib

setenv LIBSC         gsclib045
setenv LIBSCTECH     gsclib045_tech
setenv LIBSCSIM      fast_vdd1v0_basicCells
setenv LIBSCHOME     $LIB_TECHDIR/$LIBSC/$LIBSC
setenv LIBSCVHDL     $LIBSCHOME/vhdl
setenv LIBSCVER      $LIBSCHOME/verilog
setenv LIBSCTIM      $LIBSCHOME/timing
setenv LIBSCCDB      $LIBSCHOME/celtic
setenv LIBSCLEF      $LIBSCHOME/lef
setenv LIBSCOA       $LIBSCHOME/oa22/gsclib045
setenv LIBSCQRC      $LIBSCHOME/qrc/qx

setenv LIBIO         giolib045
setenv LIBIOHOME     $LIB_TECHDIR/$LIBIO/$LIBIO
setenv LIBIOVHDL     $LIBIOHOME}/vhdl
setenv LIBIOVER      $LIBIOHOME/vlog
setenv LIBIOLEF      $LIBIOHOME/lef
setenv LIBIOOA       $LIBIOHOME/oa22/giolib045

setenv LIBDESIGNOA   ele8304

#===========================================================================#
# FUNCTIONS                                                                 #
#===========================================================================#

setenv MANPATH $LIB_TECHDIR 
alias prpath  'set path = (\!* $path)'
alias prpathm 'set MANPATH = (\!* $MANPATH)'
alias appath  'set path = ($path \!*)'
alias appathm 'set MANPATH = ($MANPATH \!*)'
alias rmpath  'set path = (`echo $path | sed -e "s@[^ ]*\!:1[^ ]*@@g"`)'

#===========================================================================#
# TOOLS                                                                     #
#===========================================================================#

# Read the project .cdsenv file
setenv CDS_LOAD_ENV addCWD

# Sets all the Cadence tools to run in 64-bit
setenv CDS_AUTO_64BIT ALL

# Modelsim 
source /CMC/scripts/mentor.modelsim.10.7.csh
alias vsim "vsim -modelsimini $LIB_SIMDIR/modelsim.ini"

# Virtuoso (layout) 
source  /CMC/scripts/cadence.ic617.csh

if (! -e /export/tmp/$user ) then
     mkdir -p /export/tmp/$user
endif
setenv  DRCTEMPDIR           /export/tmp/$user
setenv  DD_DONT_DO_OS_LOCKS  set
setenv  DD_USE_LIBDEFS       no
setenv  CDS_Netlisting_Mode  Analog
setenv  CDS_USE_PALETTE      true
appathm $CMC_CDS_IC_HOME/share/man
alias virtuoso "virtuoso -log virtuoso.log"

## if not set LD_...
if (! $?LD_LIBRARY_PATH) then
    setenv LD_LIBRARY_PATH ""
endif

# MMSIM  
source  /CMC/scripts/cadence.mmsim15.10.518.csh

# PVS 
source /CMC/scripts/cadence.2014.12.csh
setenv CMC_CDS_PVS_HOME /CMC/tools/cadence/PVS16.12.000_${CMC_CDS_ARCH}
appath $CMC_CDS_PVS_HOME/bin
# source  /CMC/scripts/cadence.pvs16.12.000.csh

# EXT
source /CMC/scripts/cadence.ext17.21.000.csh 

# GENUS 
source  /CMC/scripts/cadence.genus17.10.000.csh
appathm $CMC_CDS_GENUS_HOME/share/synth/man_legacy
appathm $CMC_CDS_GENUS_HOME/share/synth/man_common
alias genus "genus -overwrite"

# INNOVUS
source  /CMC/scripts/cadence.innovus17.11.000.csh
appathm $CMC_CDS_INNOVUS_HOME/share/innovus/man
alias innovus "innovus -overwrite -no_logv"

# VOLTUS 
source  /CMC/scripts/cadence.ssv16.16.000.csh
appathm $CMC_CDS_SSV_HOME/share/voltus/man
alias voltus "voltus -overwrite -no_logv"

# CONFORMAL 
source  /CMC/scripts/cadence.2014.12.csh
setenv  CMC_CDS_CFML_HOME /CMC/tools/cadence/CONFRML17.10.140_${CMC_CDS_ARCH}
appath  $CMC_CDS_CFML_HOME/bin
appathm $CMC_CDS_CFML_HOME/share/cfm/man
# source  /CMC/scripts/cadence.conformal14.20.100.csh
