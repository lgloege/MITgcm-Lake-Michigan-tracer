C $Header: /u/gcmpack/MITgcm/pkg/rivers/rivers_readparms.F,  2007/12/12
C $Name:  $
#include "RIVERS_OPTIONS.h"

      subroutine rivers_readparms( mythid )
c     ==================================================================
c     SUBROUTINE rivers_readparms
c     ==================================================================
c     12/12/2007  this file was modified w/ rivers_readparms.F
c
c     ==================================================================
c     SUBROUTINE rivers_readparms
c     ==================================================================
c     modified by Val Bennington Jan 2008
c     modified by Val Bennington - Feb 2010
c     want to have model read in flow data (gridded field (time,z,y,x))
c     want model to be told which flow/DOC relationship to use in data.rivers
c     
      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "cal.h"
#include "rivers_param.h"
#include "rivers.h"

c     == routine arguments ==

      integer mythid

c     == local variables ==

      integer i
      integer date_array(4), difftime(4)
      integer iUnit
      character*(max_len_mbuf) msgbuf 

c     == end of interface ==

c     Surface ice-mack data.
      namelist /rivers_nml/
     &    repeatPeriod,
     &    rivflowstartdate1, 
     &    rivflowstartdate2, 
     &    rivflowperiod,
     &    rivflowfile,
     &    rivalkstartdate1, 
     &    rivalkstartdate2, 
     &    rivalkperiod,
     &    rivalkfile,
     &    rivdicstartdate1, 
     &    rivdicstartdate2, 
     &    rivdicperiod,
     &    rivdicfile,
     &    rivdocstartdate1, 
     &    rivdocstartdate2, 
     &    rivdocperiod,
     &    rivdocfile,
     &    rivers_iprec,  
     &    rivers_yftype, 
     &    DOC_RIVER, 
     &    docscheme, 
     &    docmolmass,
     &    useRiversYearlyFields, 
     &    RiverstwoDigitYear,
     &    useRiversCheckRange,
     &    rivers_inscal_rivflow,
     &    rivers_outscal_rivflow, 
     &    rivflowconst,
     &    rivflow_riversremo_intercept, 
     &    rivflow_riversremo_slope,
c     &    flow_doc,
     &    rivers_inscal_rivalk,
     &    rivers_outscal_rivalk, 
     &    rivalkconst,
     &    rivalk_riversremo_intercept, 
     &    rivalk_riversremo_slope,
     &    rivers_inscal_rivdic,
     &    rivers_outscal_rivdic, 
     &    rivdicconst,
     &    rivdic_riversremo_intercept, 
     &    rivdic_riversremo_slope,
     &    rivers_inscal_rivdoc,
     &    rivers_outscal_rivdoc, 
     &    rivdocconst,
     &    rivdoc_riversremo_intercept, 
     &    rivdoc_riversremo_slope,
#ifdef USE_RIVERS_INTERPOLATION
     &    rivflow_lon0, rivflow_lon_inc, rivflow_lat0, rivflow_lat_inc,
     &    rivflow_nlon, rivflow_nlat,
     &    rivalk_lon0, rivalk_lon_inc, rivalk_lat0, rivalk_lat_inc,
     &    rivalk_nlon, rivalk_nlat,
     &    rivdic_lon0, rivdic_lon_inc, rivdic_lat0, rivdic_lat_inc,
     &    rivdic_nlon, rivdic_nlat,
     &    rivdoc_lon0, rivdoc_lon_inc, rivdoc_lat0, rivdoc_lat_inc,
     &    rivdoc_nlon, rivdoc_nlat,
#endif

      _BEGIN_MASTER(mythid)

c     Set default values.

      year2sec           = 365.*86400.
      DOC_RIVER          = 0.
c      flow_doc           = 1.
      docmolmass         = 12.01 
      docscheme          = 3.     

c     Calendar data.
      rivflowstartdate1    = 0
      rivflowstartdate2    = 0
      rivflowperiod        = 0.0 _d 0
      rivflowconst         = 0.0 _d 0
      rivflow_riversremo_intercept = 0.0 _d 0
      rivflow_riversremo_slope = 0.0 _d 0

      rivalkstartdate1    = 0
      rivalkstartdate2    = 0
      rivalkperiod        = 0.0 _d 0
      rivalkconst         = 0.0 _d 0
      rivalk_riversremo_intercept = 0.0 _d 0
      rivalk_riversremo_slope = 0.0 _d 0
      
      rivdicstartdate1    = 0
      rivdicstartdate2    = 0
      rivdicperiod        = 0.0 _d 0
      rivdicconst         = 0.0 _d 0
      rivdic_riversremo_intercept = 0.0 _d 0
      rivdic_riversremo_slope = 0.0 _d 0
      
      rivdocstartdate1    = 0
      rivdocstartdate2    = 0
      rivdocperiod        = 0.0 _d 0
      rivdocconst         = 0.0 _d 0
      rivdoc_riversremo_intercept = 0.0 _d 0
      rivdoc_riversremo_slope = 0.0 _d 0
      
      repeatPeriod           = 0.0 _d 0

c     Data files.
      rivflowfile          = ' '
      rivalkfile           = ' '
      rivdicfile           = ' '
      rivdocfile           = ' '

c     Start dates.
      rivflowstartdate     = 0.
      rivalkstartdate      = 0.
      rivdicstartdate      = 0.
      rivdocstartdate      = 0.


c     Initialise file type and field precision
      rivers_iprec            = 32
      rivers_yftype           = 'RL'
      useRiversYearlyFields   = .FALSE.
      RiverstwoDigitYear      = .FALSE.
      useRiversCheckRange     = .TRUE.

c     Input scaling factors.
      rivers_inscal_rivflow     =  1. _d 0
      rivers_inscal_rivalk     =  1. _d 0
      rivers_inscal_rivdic     =  1. _d 0
      rivers_inscal_rivdoc     =  1. _d 0

c     Output scaling factors.
      rivers_outscal_rivflow    =  1. _d 0
      rivers_outscal_rivalk    =  1. _d 0
      rivers_outscal_rivdic    =  1. _d 0
      rivers_outscal_rivdoc    =  1. _d 0


#ifdef USE_RIVERS_INTERPOLATION
      rivflow_lon0     = thetaMin + delX(1) / 2
      rivflow_lat0     = phimin   + delY(1) / 2
      rivflow_nlon     = Nx
      rivflow_nlat     = Ny
      rivflow_lon_inc     = delX(1)
      rivalk_lon0     = thetaMin + delX(1) / 2
      rivalk_lat0     = phimin   + delY(1) / 2
      rivalk_nlon     = Nx
      rivalk_nlat     = Ny
      rivalk_lon_inc     = delX(1)
      rivdic_lon0     = thetaMin + delX(1) / 2
      rivdic_lat0     = phimin   + delY(1) / 2
      rivdic_nlon     = Nx
      rivdic_nlat     = Ny
      rivdic_lon_inc     = delX(1)
      rivdoc_lon0     = thetaMin + delX(1) / 2
      rivdoc_lat0     = phimin   + delY(1) / 2
      rivdoc_nlon     = Nx
      rivdoc_nlat     = Ny
      rivdoc_lon_inc     = delX(1)
      DO i=1,MAX_LAT_INC
         IF (i.LT.Ny) THEN
            rivflow_lat_inc(i)     = (delY(i) + delY(i)) / 2.
            rivalk_lat_inc(i)     = (delY(i) + delY(i)) / 2.
            rivdic_lat_inc(i)     = (delY(i) + delY(i)) / 2.
            rivdoc_lat_inc(i)     = (delY(i) + delY(i)) / 2.
         ELSE
            rivflow_lat_inc(i)     = 0.
            rivalk_lat_inc(i)     = 0.
            rivdic_lat_inc(i)     = 0.
            rivdoc_lat_inc(i)     = 0.
         ENDIF
      ENDDO
#endif /* USE_RIVERS_INTERPOLATION */

c     Check for the availability of the right calendar version.
      if ( calendarversion .ne. useriversscalendarversion ) then
         print*,' rivers_readparms: You are not using the appropriate'
         print*,'           version of the calendar package.'
         print*
         print*,' You are using Calendar version: ', calendarversion
         print*,' Please use    Calendar version: ', 
     &           useriversscalendarversion
         stop ' stopped in rivers_readparms.'
      endif

c     Next, read the forcing data file.
        WRITE(msgBuf,'(A)') 'RIVERS_READPARMS: opening data.rivers'
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                    SQUEEZE_RIGHT , 1)

        CALL OPEN_COPY_DATA_FILE(
     I                          'data.rivers', 'RIVERS_READPARMS',
     O                          iUnit,
     I                          myThid )
C        stop 

      READ(  iUnit, nml = rivers_nml )

      WRITE(msgBuf,'(A)') 
     &     'RIVERS_READPARMS: finished reading data.rivers'
      CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                SQUEEZE_RIGHT , 1)

      CLOSE( iUnit )
C      stop
      call rivers_check( mythid )
c      stop
c     Complete the start date specifications for the forcing
c     fields to get a complete calendar date array.

      if ( rivflowfile .NE. ' ' ) then
         write(6,*) 'debug-rivers',rivflowstartdate1,rivflowstartdate2,
     1        date_array
C         stop
         call cal_FullDate  ( rivflowstartdate1, rivflowstartdate2,
     &        date_array                       , mythid )
C         write(6,*) 'debug',date_array
C         stop
         call cal_TimePassed(modelstartdate,date_array,difftime,mythid)
         call cal_ToSeconds ( difftime,  rivflowstartdate     ,mythid )
         rivflowstartdate     = modelstart   + rivflowstartdate
C         write(6,*) 'debu-write',rivflowstartdate,modelstart
C         stop
      endif
      if ( rivalkfile .NE. ' ' ) then
         write(6,*) 'debug-riveralk',rivalkstartdate1,rivalkstartdate2,
     1        date_array
C         stop
         call cal_FullDate  ( rivalkstartdate1, rivalkstartdate2,
     &        date_array                       , mythid )
C         write(6,*) 'debug',date_array
C         stop
         call cal_TimePassed(modelstartdate,date_array,difftime,mythid)
         call cal_ToSeconds ( difftime,  rivalkstartdate     ,mythid )
         rivalkstartdate     = modelstart   + rivalkstartdate
C         write(6,*) 'debu-write',rivflowstartdate,modelstart
C         stop
      endif
      if ( rivdicfile .NE. ' ' ) then
         write(6,*) 'debug-riverdic',rivdicstartdate1,rivdicstartdate2,
     1        date_array
C         stop
         call cal_FullDate  ( rivdicstartdate1, rivdicstartdate2,
     &        date_array                       , mythid )
C         write(6,*) 'debug',date_array
C         stop
         call cal_TimePassed(modelstartdate,date_array,difftime,mythid)
         call cal_ToSeconds ( difftime,  rivdicstartdate     ,mythid )
         rivdicstartdate     = modelstart   + rivdicstartdate
C         write(6,*) 'debu-write',rivflowstartdate,modelstart
C         stop
      endif
      if ( rivdocfile .NE. ' ' ) then
         write(6,*) 'debug-riverdoc',rivdocstartdate1,rivdocstartdate2,
     1        date_array
C         stop
         call cal_FullDate  ( rivdocstartdate1, rivdocstartdate2,
     &        date_array                       , mythid )
C         write(6,*) 'debug',date_array
C         stop
         call cal_TimePassed(modelstartdate,date_array,difftime,mythid)
         call cal_ToSeconds ( difftime,  rivdocstartdate     ,mythid )
         rivdocstartdate     = modelstart   + rivdocstartdate
C         write(6,*) 'debu-write',rivflowstartdate,modelstart
C         stop
      endif


      _END_MASTER( mythid )

      _BARRIER

c--   Summarize the External forcing's setup.
      call rivers_summary( mythid )

c$$$c--   set climatology parameters
c$$$      call rivers_clim_readparms( mythid )
c$$$
c$$$c--   summarize climatologic forcing configuration
c$$$      call rivers_clim_summary( mythid )
c$$$
      end
