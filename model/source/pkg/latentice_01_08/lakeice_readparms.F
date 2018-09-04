C $Header: /u/gcmpack/MITgcm/pkg/lakeice/lakeice_readparms.F,  2007/12/12
C $Name:  $
#include "LAKEICE_OPTIONS.h"

      subroutine lakeice_readparms( mythid )
c     ==================================================================
c     SUBROUTINE lakeice_readparms
c     ==================================================================
c     12/12/2007  this file was modified w/ lakeice_readparms.F
c
c     ==================================================================
c     SUBROUTINE lakeice_readparms
c     ==================================================================
c modified by Val Bennington Jan 2008
c includes possibility of latent heat from ice melt/formation

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "cal.h"
#include "lakeice_param.h"
#include "lakeice.h"

c     == routine arguments ==

      integer mythid

c     == local variables ==

      integer i
      integer date_array(4), difftime(4)
      integer iUnit
      character*(max_len_mbuf) msgbuf 

c     == end of interface ==

c     Surface ice-mack data.
      namelist /lakeice_nml/
C     &    windstressmax,    repeatPeriod,      lakeice_albedo,
     &    repeatPeriod,
     &    icefracstartdate1, icefracstartdate2, icefracperiod,
     &    icefracfile,
     &    lakeice_iprec,  lakeice_yftype, 
     &    useLakeiceYearlyFields, LakeicetwoDigitYear,
     &    useLakeiceCheckRange,
     &    lakeice_inscal_icefrac,
     &    lakeice_outscal_icefrac, 
     &    icefracconst,
     &    icefrac_lakeiceremo_intercept, icefrac_lakeiceremo_slope,
#ifdef USE_LAKEICE_INTERPOLATION
     & icefrac_lon0, icefrac_lon_inc, icefrac_lat0, icefrac_lat_inc,
     & icefrac_nlon, icefrac_nlat,
#endif

      _BEGIN_MASTER(mythid)

c     Set default values.

      year2sec           = 365.*86400.

c     Calendar data.
      icefracstartdate1    = 0
      icefracstartdate2    = 0
      icefracperiod        = 0.0 _d 0
      icefracconst         = 0.0 _d 0
      icefrac_lakeiceremo_intercept = 0.0 _d 0
      icefrac_lakeiceremo_slope = 0.0 _d 0
      icelatentstartdate1    = 0
      icelatentstartdate2    = 0
      icelatentperiod        = 0.0 _d 0
      icelatentconst         = 0.0 _d 0
      icelatent_lakeiceremo_intercept = 0.0 _d 0
      icelatent_lakeiceremo_slope = 0.0 _d 0


      repeatPeriod           = 0.0 _d 0
C      lakeice_albedo             = 0.1 _d 0

c     Data files.
      icefracfile          = ' '
      icelatentfile        = ' '

c     Start dates.
      icefracstartdate     = 0.
      icelatentstartdate   = 0.

c     Initialise file type and field precision
      lakeice_iprec            = 32
      lakeice_yftype           = 'RL'
      useLakeiceYearlyFields   = .FALSE.
      LakeicetwoDigitYear      = .FALSE.
      useLakeiceCheckRange     = .TRUE.

c     Input scaling factors.
      lakeice_inscal_icefrac     =  1. _d 0
      lakeice_inscal_icelatent   =  1. _d 0

c     Output scaling factors.
      lakeice_outscal_icefrac    =  1. _d 0
      lakeice_outscal_icelatent  =  1. _d 0

#ifdef USE_LAKEICE_INTERPOLATION
      icefrac_lon0     = thetaMin + delX(1) / 2
      icefrac_lat0     = phimin   + delY(1) / 2
      icefrac_nlon     = Nx
      icefrac_nlat     = Ny
      icefrac_lon_inc     = delX(1)
      icelatent_lon0     = thetaMin + delX(1) / 2
      icelatent_lat0     = phimin   + delY(1) / 2
      icelatent_nlon     = Nx
      icelatent_nlat     = Ny
      icelatent_lon_inc     = delX(1)
      DO i=1,MAX_LAT_INC
         IF (i.LT.Ny) THEN
            icefrac_lat_inc(i)     = (delY(i) + delY(i)) / 2.
            icelatent_lat_inc(i)     = (delY(i) + delY(i)) / 2.
         ELSE
            icefrac_lat_inc(i)     = 0.
            icelatent_lat_inc(i)     = 0.
         ENDIF
      ENDDO
#endif /* USE_LAKEICE_INTERPOLATION */

c     Check for the availability of the right calendar version.
      if ( calendarversion .ne. uselakeicescalendarversion ) then
         print*,' lakeice_readparms: You are not using the appropriate'
         print*,'           version of the calendar package.'
         print*
         print*,' You are using Calendar version: ', calendarversion
         print*,' Please use    Calendar version: ', 
     &           uselakeicescalendarversion
         stop ' stopped in lakeice_readparms.'
      endif

c     Next, read the forcing data file.
        WRITE(msgBuf,'(A)') 'LAKEICE_READPARMS: opening data.lakeice'
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                    SQUEEZE_RIGHT , 1)

        CALL OPEN_COPY_DATA_FILE(
     I                          'data.lakeice', 'LAKEICE_READPARMS',
     O                          iUnit,
     I                          myThid )
C        stop 

      READ(  iUnit, nml = lakeice_nml )

      WRITE(msgBuf,'(A)') 
     &     'LAKEICE_READPARMS: finished reading data.lakeice'
      CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                SQUEEZE_RIGHT , 1)

      CLOSE( iUnit )
C      stop
      call lakeice_check( mythid )
c      stop
c     Complete the start date specifications for the forcing
c     fields to get a complete calendar date array.

      if ( icefracfile .NE. ' ' ) then
         write(6,*) 'debug-lakeice',icefracstartdate1,icefracstartdate2,
     1        date_array
C         stop
         call cal_FullDate  ( icefracstartdate1, icefracstartdate2,
     &        date_array                       , mythid )
C         write(6,*) 'debug',date_array
C         stop
         call cal_TimePassed(modelstartdate,date_array,difftime,mythid)
         call cal_ToSeconds ( difftime,  icefracstartdate     ,mythid )
         icefracstartdate     = modelstart   + icefracstartdate
C         write(6,*) 'debu-write',icefracstartdate,modelstart
C         stop
      endif
      if ( icelatentfile .NE. ' ' ) then
         write(6,*) 'debug-lakeice',icelatentstartdate1,icelatentstartdate2,
     1        date_array
C         stop
         call cal_FullDate  ( icelatentstartdate1, icelatentstartdate2,
     &        date_array                       , mythid )
C         write(6,*) 'debug',date_array
C         stop
         call cal_TimePassed(modelstartdate,date_array,difftime,mythid)
         call cal_ToSeconds ( difftime,  icefracstartdate     ,mythid )
         call cal_ToSeconds ( difftime,  icelatentstartdate   ,mythid )
         icefracstartdate     = modelstart   + icefracstartdate
         icelatentstartdate   = modelstart   + icelatentstartdate
C         write(6,*) 'debu-write',icefracstartdate,modelstart
C         stop
      endif


      _END_MASTER( mythid )

      _BARRIER

c--   Summarize the External forcing's setup.
      call lakeice_summary( mythid )

c$$$c--   set climatology parameters
c$$$      call lakeice_clim_readparms( mythid )
c$$$
c$$$c--   summarize climatologic forcing configuration
c$$$      call lakeice_clim_summary( mythid )
c$$$
      end
