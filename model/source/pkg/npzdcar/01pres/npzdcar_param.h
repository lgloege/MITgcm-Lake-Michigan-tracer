c $Header: /u/gcmpack/MITgcm/pkg/npzdcar/npzdcar_param.h, 2007/12/12 
c
c     ==================================================================
c     HEADER npzdcar_param
c     ==================================================================
c
c     o Header file for the surface flux data. Used by the external
c       forcing package.
c
c     started: Christian Eckert eckert@mit.edu  30-Jun-1999
c
c     changed: Christian Eckert eckert@mit.edu  14-Jan-2000
c              - Restructured the original version in order to have a
c                better interface to the MITgcmUV.
c
c              Christian Eckert eckert@mit.edu  12-Feb-2000
c              - Changed some variables names (package prefix: npzdcar_)
c
c              Patrick Heimbach, heimbach@mit.edu  04-May-2000
c              - included npzdcar_iprec, npzdcar_yftype to enable easy
c                switch between 32bit/64 bit data format
c
c              Patrick Heimbach, heimbach@mit.edu  01-May-2001
c              - added obcs parameters
c
c     ==================================================================
c     HEADER npzdcar_param
c     ==================================================================
C     need to add other variables, only fice, so far (12/17/2007)

Cc     year in seconds
C      _RL     year2sec

c     Calendar data.
      _RL     npzdcar_repeatPeriod

C     npzdcar setup 
      integer ficestartdate1
      integer ficestartdate2
      _RL     ficestartdate
      _RL     ficeperiod
      _RL     ficeconst
      _RL     fice_npzdcarremo_intercept 
      _RL     fice_npzdcarremo_slope
      character*1 ficemask
      parameter(  ficemask = 's' )

c     File names.
      character*(128) ficefile

C     useNpzdcarYearlyFields :: when set, automatically add extension
C                           _YEAR to input file names
C     twoDigitYear       :: when set, use 2-digit year extension YR
C                           instead of _YEAR for useNpzdcarYearlyFields
      logical useNpzdcarYearlyFields, NpzdcartwoDigitYear
      logical useNpzdcarCheckRange

      common /npzdcar_param_l/
     &                   useNpzdcarYearlyFields, NpzdcartwoDigitYear,
     &                   useNpzdcarCheckRange
      common /npzdcar_param_i/
     &                          ficestartdate1,   ficestartdate2

      common /npzdcar_param_r/
C     &                          year2sec,            windstressmax,
C     &                          repeatPeriod,        fice_npzdcar_albedo,
C     &                          year2sec,
     &                          npzdcar_repeatPeriod,
     &                          ficeperiod,       ficestartdate,
     &                          ficeconst

      common /npzdcar_param_trend_removal/
     &                          fice_npzdcarremo_intercept,
     &                          fice_npzdcarremo_slope

      common /npzdcar_param_c/
     &                          ficefile

c     file precision and field type

      common /npzdcar_param_type/ 
     &                        npzdcar_iprec,
     &                        npzdcar_yftype

      integer npzdcar_iprec
      character*(2) npzdcar_yftype

      _RL     npzdcar_inscal_fice

      _RL     npzdcar_outscal_fice

      common /npzdcar_param_scal/
     &                      npzdcar_inscal_fice

      character*(5) npzdcarexternalforcingversion
      character*(5) usenpzdcarscalendarversion
      parameter( npzdcarexternalforcingversion = '0.2.2' ) 
      parameter( usenpzdcarscalendarversion    = '0.2.0' )

      _RL npzdcar_one
      parameter( npzdcar_one  =  1.0d0)

C#ifndef USE_NPZDCAR_INTERPOLATION
c-- set dummy dimension 1
       integer MAX_LAT_INC
       parameter(MAX_LAT_INC = 1)
C#else
Cc for lat interpolation, arraysize currently set to 2176 max data values
C       integer MAX_LAT_INC
C       parameter(MAX_LAT_INC = 2176)
C      _RL fice_lon0, fice_lon_inc
C      _RL fice_lat0, fice_lat_inc(MAX_LAT_INC)
CC      INTEGER apressure_nlon,apressure_nlat
C
C      common /npzdcar_interpolation/
C     & fice_lon0, fice_lon_inc,
C     & fice_lat0, fice_lat_inc,
C     & fice_nlon, fice_nlat
C#endif
