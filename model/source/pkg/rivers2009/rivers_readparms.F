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
c     includes possibility of latent heat from ice melt/formation

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
C     &    windstressmax,    repeatPeriod,      rivers_albedo,
     &    repeatPeriod,
     &    rivflowstartdate1, rivflowstartdate2, rivflowperiod,
     &    rivflowfile,
     &    DOC_RIVER,
     &    rivers_iprec,  rivers_yftype, 
     &    useRiversYearlyFields, RiverstwoDigitYear,
     &    useRiversCheckRange,
     &    rivers_inscal_rivflow,
     &    rivers_outscal_rivflow, 
     &    rivflowconst,
     &    rivflow_riversremo_intercept, rivflow_riversremo_slope,
#ifdef USE_RIVERS_INTERPOLATION
     & rivflow_lon0, rivflow_lon_inc, rivflow_lat0, rivflow_lat_inc,
     & rivflow_nlon, rivflow_nlat,
#endif

      _BEGIN_MASTER(mythid)

c     Set default values.

      year2sec           = 365.*86400.
      DOC_RIVER          = 0.

c     Calendar data.
      rivflowstartdate1    = 0
      rivflowstartdate2    = 0
      rivflowperiod        = 0.0 _d 0
      rivflowconst         = 0.0 _d 0
      rivflow_riversremo_intercept = 0.0 _d 0
      rivflow_riversremo_slope = 0.0 _d 0
c      icelatentstartdate1    = 0
c      icelatentstartdate2    = 0
c      icelatentperiod        = 0.0 _d 0
c      icelatentconst         = 0.0 _d 0
c      icelatent_riversremo_intercept = 0.0 _d 0
c      icelatent_riversremo_slope = 0.0 _d 0


      repeatPeriod           = 0.0 _d 0
C      rivers_albedo             = 0.1 _d 0

c     Data files.
      rivflowfile          = ' '
c      icelatentfile        = ' '

c     Start dates.
      rivflowstartdate     = 0.
c     icelatentstartdate   = 0.

c     Initialise file type and field precision
      rivers_iprec            = 32
      rivers_yftype           = 'RL'
      useRiversYearlyFields   = .FALSE.
      RiverstwoDigitYear      = .FALSE.
      useRiversCheckRange     = .TRUE.

c     Input scaling factors.
      rivers_inscal_rivflow     =  1. _d 0
c      rivers_inscal_icelatent   =  1. _d 0

c     Output scaling factors.
      rivers_outscal_rivflow    =  1. _d 0
c      rivers_outscal_icelatent  =  1. _d 0

#ifdef USE_RIVERS_INTERPOLATION
      rivflow_lon0     = thetaMin + delX(1) / 2
      rivflow_lat0     = phimin   + delY(1) / 2
      rivflow_nlon     = Nx
      rivflow_nlat     = Ny
      rivflow_lon_inc     = delX(1)
c      icelatent_lon0     = thetaMin + delX(1) / 2
c      icelatent_lat0     = phimin   + delY(1) / 2
c      icelatent_nlon     = Nx
c      icelatent_nlat     = Ny
c      icelatent_lon_inc     = delX(1)
      DO i=1,MAX_LAT_INC
         IF (i.LT.Ny) THEN
            rivflow_lat_inc(i)     = (delY(i) + delY(i)) / 2.
c            icelatent_lat_inc(i)     = (delY(i) + delY(i)) / 2.
         ELSE
            rivflow_lat_inc(i)     = 0.
c            icelatent_lat_inc(i)     = 0.
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
