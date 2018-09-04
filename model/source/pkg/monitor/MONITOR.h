C $Header: /u/gcmpack/MITgcm/pkg/monitor/MONITOR.h,v 1.8 2004/09/07 23:51:22 jmc Exp $
C $Name:  $
C

CBOP
C     !ROUTINE: MONITOR.h

C     !INTERFACE:
C     #include "MONITOR.h"

C     !DESCRIPTION:
C     Contains the state (parameters) for the ``monitor'' package.
C
C     Monitor routines (prefixed MON\_) provide a simple set of
C     utilities for outputting useful runtime diagnostic
C     information. They use a standard format so that the monitor output
C     can be parsed offline to help in trouble shooting.
C
C     Monitor setup params should be set through appropriate MON\_
C     routines to ensure that changes are made in a thread-safe fashion.

CEOP

C--   Monitor head and tail strings
      CHARACTER*(*) mon_head
      PARAMETER ( mon_head = '%MON'       )
      CHARACTER*(*) mon_foot_min
      PARAMETER ( mon_foot_min = '_min'   )
      CHARACTER*(*) mon_foot_max
      PARAMETER ( mon_foot_max = '_max'   )
      CHARACTER*(*) mon_foot_sd 
      PARAMETER ( mon_foot_sd = '_sd'     )
      CHARACTER*(*) mon_foot_mean
      PARAMETER ( mon_foot_mean = '_mean' )
      CHARACTER*(*) mon_foot_volint
      PARAMETER ( mon_foot_volint = '_volint' )
      CHARACTER*(*) mon_foot_volmean
      PARAMETER ( mon_foot_volmean = '_volmean' )
      CHARACTER*(*) mon_foot_del2
      PARAMETER ( mon_foot_del2 = '_del2' )
      CHARACTER*(*) mon_foot_vol
      PARAMETER ( mon_foot_vol = '_vol' )     
      CHARACTER*(*) mon_string_none
      PARAMETER ( mon_string_none = 'NONE')

C--   COMMON /MON_I/ Monitor integer variables
C     mon_ioUnit - Used to specify the output unit for monitor IO.
C     mon_prefL  - Prefix length of current mon_ prefix
      COMMON /MON_I/ mon_ioUnit, mon_prefL
      INTEGER mon_ioUnit 
      INTEGER mon_prefL

C--   COMMON /MON_C/ Monitor character variables
C     mon_pref   - Prefix used for monitor output
      COMMON /MON_C/ mon_pref
      CHARACTER*(MAX_LEN_MBUF) mon_pref

C--   COMMON /MON_L/ Monitor logical variables
C     mon_overrideStop - Allow code to continue even if model state is
C                        heading out of bounds
C     mon_write_stdout - hold True when writing monitor to standard output
C     mon_write_mnc    - hold True when writing monitor to MNC file
      COMMON /MON_L/ mon_overrideStop, 
     &               mon_write_stdout, mon_write_mnc
      LOGICAL mon_overrideStop
      LOGICAL mon_write_stdout, mon_write_mnc

C     File names and time steps
C     mon_fname    ::  monitor file group name
      COMMON /MON_F/ 
     &     mon_fname
      CHARACTER*(MAX_LEN_MBUF) mon_fname

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
