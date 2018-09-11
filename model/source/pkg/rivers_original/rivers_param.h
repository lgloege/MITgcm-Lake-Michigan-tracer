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
      _RL    docmolmass
      _RL    flow_doc
      INTEGER docscheme

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
      integer rivalkstartdate1
      integer rivalkstartdate2
      _RL     rivalkstartdate
      _RL     rivalkperiod
      _RL     rivalkconst
      _RL     rivalk_riversremo_intercept 
      _RL     rivalk_riversremo_slope
      character*1 rivalkmask
      parameter(  rivalkmask = 's' )
      integer rivdicstartdate1
      integer rivdicstartdate2
      _RL     rivdicstartdate
      _RL     rivdicperiod
      _RL     rivdicconst
      _RL     rivdic_riversremo_intercept 
      _RL     rivdic_riversremo_slope
      character*1 rivdicmask
      parameter(  rivdicmask = 's' )

      integer rivdocstartdate1
      integer rivdocstartdate2
      _RL     rivdocstartdate
      _RL     rivdocperiod
      _RL     rivdocconst
      _RL     rivdoc_riversremo_intercept 
      _RL     rivdoc_riversremo_slope
      character*1 rivdocmask
      parameter(  rivdocmask = 's' )

c     File names.
      character*(128) rivflowfile
      character*(128) rivalkfile
      character*(128) rivdicfile
      character*(128) rivdocfile

C     useLakeiceYearlyFields :: when set, automatically add extension
C                           _YEAR to input file names
C     twoDigitYear       :: when set, use 2-digit year extension YR
C                           instead of _YEAR for useLakeiceYearlyFields
      logical useRiversYearlyFields, RiverstwoDigitYear
      logical useRiversCheckRange

      common /rivers_param_l/
     &                   useRiversYearlyFields, RiverstwoDigitYear,
     &                   useRiversCheckRange, docscheme
      common /rivers_param_i/
     &                          rivflowstartdate1,   rivflowstartdate2,
     &                          rivalkstartdate1,   rivalkstartdate2,
     &                          rivdicstartdate1,   rivdicstartdate2,
     &                          rivdocstartdate1,   rivdocstartdate2

      common /rivers_param_r/
C     &                          year2sec,            windstressmax,
C     &                          repeatPeriod,        rivflow_rivers_albedo,
     &                          DOC_RIVER,           flow_doc,
     &                          year2sec,
     &                          repeatPeriod,
     &                          rivflowperiod,       rivflowstartdate,
     &                          rivflowconst,        docmolmass,
     &                          rivalkperiod,       rivalkstartdate,
     &                          rivalkconst,      
     &                          rivdocperiod,       rivdocstartdate,
     &                          rivdocconst,      
     &                          rivdicperiod,       rivdicstartdate,
     &                          rivdicconst

      common /rivers_param_trend_removal/
     &                          rivflow_riversremo_intercept,
     &                          rivflow_riversremo_slope,
     &                          rivalk_riversremo_intercept,
     &                          rivalk_riversremo_slope,
     &                          rivdic_riversremo_intercept,
     &                          rivdic_riversremo_slope,
     &                          rivdoc_riversremo_intercept,
     &                          rivdoc_riversremo_slope

      common /rivers_param_c/
     &                          rivflowfile,
     &                          rivalkfile,
     &                          rivdicfile,
     &                          rivdocfile

c     file precision and field type

      common /rivers_param_type/ 
     &                        rivers_iprec,
     &                        rivers_yftype

      integer rivers_iprec
      character*(2) rivers_yftype

      _RL     rivers_inscal_rivflow
      _RL     rivers_outscal_rivflow
      _RL     rivers_inscal_rivalk
      _RL     rivers_outscal_rivalk
      _RL     rivers_inscal_rivdic
      _RL     rivers_outscal_rivdic
      _RL     rivers_inscal_rivdoc
      _RL     rivers_outscal_rivdoc

      common /rivers_param_scal/
     &        rivers_inscal_rivflow, rivers_outscal_rivflow,
     &        rivers_inscal_rivalk, rivers_outscal_rivalk,
     &        rivers_inscal_rivdic, rivers_outscal_rivdic,
     &        rivers_inscal_rivdoc, rivers_outscal_rivdoc

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
      _RL rivalk_lon0, rivalk_lon_inc
      _RL rivalk_lat0, rivalk_lat_inc(MAX_LAT_INC)
      _RL rivdic_lon0, rivdic_lon_inc
      _RL rivdic_lat0, rivdic_lat_inc(MAX_LAT_INC)
      _RL rivdoc_lon0, rivdoc_lon_inc
      _RL rivdoc_lat0, rivdoc_lat_inc(MAX_LAT_INC)
C      INTEGER apressure_nlon,apressure_nlat

      common /rivers_interpolation/
     & rivflow_lon0, rivflow_lon_inc,
     & rivflow_lat0, rivflow_lat_inc,
     & rivflow_nlon, rivflow_nlat,
     & rivalk_lon0, rivalk_lon_inc,
     & rivalk_lat0, rivalk_lat_inc,
     & rivalk_nlon, rivalk_nlat,
     & rivdic_lon0, rivdic_lon_inc,
     & rivdic_lat0, rivdic_lat_inc,
     & rivdic_nlon, rivdic_nlat,
     & rivdoc_lon0, rivdoc_lon_inc,
     & rivdoc_lat0, rivdoc_lat_inc,
     & rivdoc_nlon, rivdoc_nlat
#endif
