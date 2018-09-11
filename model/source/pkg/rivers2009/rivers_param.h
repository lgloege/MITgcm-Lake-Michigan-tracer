c $Header: /u/gcmpack/MITgcm/pkg/rivers/rivers_param.h, 2007/12/12 
c
c     ==================================================================
c     HEADER rivers_param
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
c              - Changed some variables names (package prefix: rivers_)
c
c              Patrick Heimbach, heimbach@mit.edu  04-May-2000
c              - included rivers_iprec, rivers_yftype to enable easy
c                switch between 32bit/64 bit data format
c
c              Patrick Heimbach, heimbach@mit.edu  01-May-2001
c              - added obcs parameters
c
c     ==================================================================
c     HEADER rivers_param
c     ==================================================================

c     year in seconds
      _RL     year2sec

c     Calendar data.
      _RL     repeatPeriod
      
C     River Concentration of DOC
      _RL    DOC_RIVER

C     rivers setup 
      integer rivflowstartdate1
      integer rivflowstartdate2
      _RL     rivflowstartdate
      _RL     rivflowperiod
      _RL     rivflowconst
      _RL     rivflow_riversremo_intercept 
      _RL     rivflow_riversremo_slope
      character*1 rivflowmask
      parameter(  rivflowmask = 's' )

c     File names.
      character*(128) rivflowfile

C     useLakeiceYearlyFields :: when set, automatically add extension
C                           _YEAR to input file names
C     twoDigitYear       :: when set, use 2-digit year extension YR
C                           instead of _YEAR for useLakeiceYearlyFields
      logical useRiversYearlyFields, RiverstwoDigitYear
      logical useRiversCheckRange

      common /rivers_param_l/
     &                   useRiversYearlyFields, RiverstwoDigitYear,
     &                   useRiversCheckRange
      common /rivers_param_i/
     &                          rivflowstartdate1,   rivflowstartdate2

      common /rivers_param_r/
C     &                          year2sec,            windstressmax,
C     &                          repeatPeriod,        rivflow_rivers_albedo,
     &                          DOC_RIVER,
     &                          year2sec,
     &                          repeatPeriod,
     &                          rivflowperiod,       rivflowstartdate,
     &                          rivflowconst

      common /rivers_param_trend_removal/
     &                          rivflow_riversremo_intercept,
     &                          rivflow_riversremo_slope

      common /rivers_param_c/
     &                          rivflowfile

c     file precision and field type

      common /rivers_param_type/ 
     &                        rivers_iprec,
     &                        rivers_yftype

      integer rivers_iprec
      character*(2) rivers_yftype

      _RL     rivers_inscal_rivflow
      _RL     rivers_outscal_rivflow

      common /rivers_param_scal/
     &        rivers_inscal_rivflow, rivers_outscal_rivflow

#ifndef USE_RIVERS_INTERPOLATION
c-- set dummy dimension 1
       integer MAX_LAT_INC
       parameter(MAX_LAT_INC = 1)
#else
c for lat interpolation, arraysize currently set to 2176 max data values
       integer MAX_LAT_INC
       parameter(MAX_LAT_INC = 2176)
      _RL rivflow_lon0, rivflow_lon_inc
      _RL rivflow_lat0, rivflow_lat_inc(MAX_LAT_INC)
C      INTEGER apressure_nlon,apressure_nlat

      common /rivers_interpolation/
     & rivflow_lon0, rivflow_lon_inc,
     & rivflow_lat0, rivflow_lat_inc,
     & rivflow_nlon, rivflow_nlat
#endif
