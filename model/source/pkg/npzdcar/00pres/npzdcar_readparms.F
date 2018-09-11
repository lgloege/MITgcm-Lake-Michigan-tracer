C $Header: /u/gcmpack/MITgcm/pkg/npzdcar/npzdcar_readparms.F,  2007/12/12
C $Name:  $
#include "NPZDCAR_OPTIONS.h"

      subroutine npzdcar_readparms( mythid )
c     ==================================================================
c     SUBROUTINE npzdcar_readparms
c     ==================================================================
c     12/12/2007  this file was modified w/ npzdcar_readparms.F
c
c     ==================================================================
c     SUBROUTINE npzdcar_readparms
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "cal.h"
#include "npzdcar_param.h"
#include "NPZDCAR.h"

c     == routine arguments ==

      integer mythid

c     == local variables ==

      integer i
      integer date_array(4), difftime(4)
      integer iUnit
      character*(max_len_mbuf) msgbuf 

c     == end of interface ==

c     Surface ice-mack data.
      namelist /npzdcar_nml/
C     &    windstressmax,    repeatPeriod,      npzdcar_albedo,
     &    npzdcar_repeatPeriod,
     &    ficestartdate1, ficestartdate2, ficeperiod,
     &    ficefile,
     &    npzdcar_iprec,  npzdcar_yftype, 
     &    useNpzdcarYearlyFields, NpzdcartwoDigitYear,
     &    useNpzdcarCheckRange,
     &    npzdcar_inscal_fice,
     &    npzdcar_outscal_fice, 
     &    ficeconst,
     &    fice_npzdcarremo_intercept, fice_npzdcarremo_slope
c$$$#ifdef USE_NPZDCAR_INTERPOLATION
c$$$     & ,fice_lon0, fice_lon_inc, fice_lat0, fice_lat_inc,
c$$$     & fice_nlon, fice_nlat,
c$$$#endif

      _BEGIN_MASTER(mythid)

c     Set default values.

C      year2sec           = 365.*86400.

c     Calendar data.
      ficestartdate1    = 0
      ficestartdate2    = 0
      ficeperiod        = 0.0 _d 0
      ficeconst         = 0.0 _d 0
      fice_npzdcarremo_intercept = 0.0 _d 0
      fice_npzdcarremo_slope = 0.0 _d 0

      npzdcar_repeatPeriod           = 0.0 _d 0
C      npzdcar_albedo             = 0.1 _d 0

c     Data files.
      ficefile          = ' '

c     Start dates.
      ficestartdate     = 0.

c     Initialise file type and field precision
      npzdcar_iprec            = 32
      npzdcar_yftype           = 'RL'
      useNpzdcarYearlyFields   = .FALSE.
      NpzdcartwoDigitYear      = .FALSE.
      useNpzdcarCheckRange     = .TRUE.

c     Input scaling factors.
      npzdcar_inscal_fice     =  1. _d 0

c     Output scaling factors.
      npzdcar_outscal_fice    =  1. _d 0

c$$$#ifdef USE_NPZDCAR_INTERPOLATION
c$$$      fice_lon0     = thetaMin + delX(1) / 2
c$$$      fice_lat0     = phimin   + delY(1) / 2
c$$$      fice_nlon     = Nx
c$$$      fice_nlat     = Ny
c$$$      fice_lon_inc     = delX(1)
c$$$      DO i=1,MAX_LAT_INC
c$$$         IF (i.LT.Ny) THEN
c$$$            fice_lat_inc(i)     = (delY(i) + delY(i)) / 2.
c$$$         ELSE
c$$$            fice_lat_inc(i)     = 0.
c$$$         ENDIF
c$$$      ENDDO
c$$$#endif /* USE_NPZDCAR_INTERPOLATION */

c     Check for the availability of the right calendar version.
      if ( calendarversion .ne. usenpzdcarscalendarversion ) then
         print*,' npzdcar_readparms: You are not using the appropriate'
         print*,'           version of the calendar package.'
         print*
         print*,' You are using Calendar version: ', calendarversion
         print*,' Please use    Calendar version: ', 
     &           usenpzdcarscalendarversion
         stop ' stopped in npzdcar_readparms.'
      endif

c     Next, read the forcing data file.
        WRITE(msgBuf,'(A)') 'NPZDCAR_READPARMS: opening data.npzdcar'
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                    SQUEEZE_RIGHT , 1)

        CALL OPEN_COPY_DATA_FILE(
     I                          'data.npzdcar', 'NPZDCAR_READPARMS',
     O                          iUnit,
     I                          myThid )
C        stop 

      READ(  iUnit, nml = npzdcar_nml )

      WRITE(msgBuf,'(A)') 
     &     'NPZDCAR_READPARMS: finished reading data.npzdcar'
      CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                SQUEEZE_RIGHT , 1)

      CLOSE( iUnit )
C      stop
      call npzdcar_check( mythid )
C      write(6,*) 'debug-write come here: done'
C      stop
c     Complete the start date specifications for the forcing
c     fields to get a complete calendar date array.

      if ( ficefile .NE. ' ' ) then
C         write(6,*) 'debug-npzdcar',ficestartdate1, ficestartdate2,
C     1        date_array, mythid
C         stop
         call cal_FullDate  ( ficestartdate1, ficestartdate2,
     &        date_array                       , mythid )
C         write(6,*) 'debug',date_array
C         stop
         call cal_TimePassed(modelstartdate,date_array,difftime,mythid)
         call cal_ToSeconds ( difftime,  ficestartdate     ,mythid )
         ficestartdate     = modelstart   + ficestartdate
C         write(6,*) 'debu-write',ficestartdate,modelstart
C         stop
      endif
C      write(6,*) 'debu-write ficefile=',ficefile
C      stop

      _END_MASTER( mythid )

      _BARRIER

c--   Summarize the External forcing's setup.
      call npzdcar_summary( mythid )

c$$$c--   set climatology parameters
c$$$      call npzdcar_clim_readparms( mythid )
c$$$
c$$$c--   summarize climatologic forcing configuration
c$$$      call npzdcar_clim_summary( mythid )
c$$$
      end
