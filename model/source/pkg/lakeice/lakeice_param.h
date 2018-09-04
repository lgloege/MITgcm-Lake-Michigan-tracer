c $Header: /u/gcmpack/MITgcm/pkg/lakeice/lakeice_param.h, 2007/12/12 
c
c     ==================================================================
c     HEADER lakeice_param
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
c              - Changed some variables names (package prefix: lakeice_)
c
c              Patrick Heimbach, heimbach@mit.edu  04-May-2000
c              - included lakeice_iprec, lakeice_yftype to enable easy
c                switch between 32bit/64 bit data format
c
c              Patrick Heimbach, heimbach@mit.edu  01-May-2001
c              - added obcs parameters
c
c     ==================================================================
c     HEADER lakeice_param
c     ==================================================================

c     year in seconds
      _RL     year2sec

c     Calendar data.
      _RL     repeatPeriod

C     lakeice setup 
      integer icefracstartdate1
      integer icefracstartdate2
      _RL     icefracstartdate
      _RL     icefracperiod
      _RL     icefracconst
      _RL     icefrac_lakeiceremo_intercept 
      _RL     icefrac_lakeiceremo_slope
      character*1 icefracmask
      parameter(  icefracmask = 's' )

c     File names.
      character*(128) icefracfile

C     useLakeiceYearlyFields :: when set, automatically add extension
C                           _YEAR to input file names
C     twoDigitYear       :: when set, use 2-digit year extension YR
C                           instead of _YEAR for useLakeiceYearlyFields
      logical useLakeiceYearlyFields, LakeicetwoDigitYear
      logical useLakeiceCheckRange

      common /lakeice_param_l/
     &                   useLakeiceYearlyFields, LakeicetwoDigitYear,
     &                   useLakeiceCheckRange
      common /lakeice_param_i/
     &                          icefracstartdate1,   icefracstartdate2

      common /lakeice_param_r/
C     &                          year2sec,            windstressmax,
C     &                          repeatPeriod,        icefrac_lakeice_albedo,
     &                          year2sec,
     &                          repeatPeriod,
     &                          icefracperiod,       icefracstartdate,
     &                          icefracconst

      common /lakeice_param_trend_removal/
     &                          icefrac_lakeiceremo_intercept,
     &                          icefrac_lakeiceremo_slope

      common /lakeice_param_c/
     &                          icefracfile

c     file precision and field type

      common /lakeice_param_type/ 
     &                        lakeice_iprec,
     &                        lakeice_yftype

      integer lakeice_iprec
      character*(2) lakeice_yftype

      _RL     lakeice_inscal_icefrac
      _RL     lakeice_outscal_icefrac

      common /lakeice_param_scal/
     &        lakeice_inscal_icefrac, lakeice_outscal_icefrac

#ifndef USE_LAKEICE_INTERPOLATION
c-- set dummy dimension 1
       integer MAX_LAT_INC
       parameter(MAX_LAT_INC = 1)
#else
c for lat interpolation, arraysize currently set to 2176 max data values
       integer MAX_LAT_INC
       parameter(MAX_LAT_INC = 2176)
      _RL icefrac_lon0, icefrac_lon_inc
      _RL icefrac_lat0, icefrac_lat_inc(MAX_LAT_INC)
C      INTEGER apressure_nlon,apressure_nlat

      common /lakeice_interpolation/
     & icefrac_lon0, icefrac_lon_inc,
     & icefrac_lat0, icefrac_lat_inc,
     & icefrac_nlon, icefrac_nlat
#endif
