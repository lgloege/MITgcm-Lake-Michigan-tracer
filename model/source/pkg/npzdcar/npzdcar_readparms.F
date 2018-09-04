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
     & npzdcar_repeatPeriod,
     & ficestartdate1,    ficestartdate2,    ficeperiod,    ficefile,
     & featmosstartdate1, featmosstartdate2, featmosperiod, featmosfile,
     & wspeedstartdate1,  wspeedstartdate2,  wspeedperiod,  wspeedfile,
     & sur_parstartdate1, sur_parstartdate2, sur_parperiod, sur_parfile,
     & atmospstartdate1,  atmospstartdate2,  atmospperiod,  atmospfile,
     & npzdcar_iprec,  npzdcar_yftype, 
     & useNpzdcarYearlyFields, NpzdcartwoDigitYear,
     & useNpzdcarCheckRange,
     & npzdcar_inscal_fice,    npzdcar_outscal_fice,    ficeconst,
     & npzdcar_inscal_featmos, npzdcar_outscal_featmos, featmosconst,
     & npzdcar_inscal_wspeed,  npzdcar_outscal_wspeed,  wspeedconst,
     & npzdcar_inscal_sur_par, npzdcar_outscal_sur_par, sur_parconst,
     & npzdcar_inscal_atmosp,  npzdcar_outscal_atmosp,  atmospconst,
     & fice_npzdcarremo_intercept,    fice_npzdcarremo_slope,
     & featmos_npzdcarremo_intercept, featmos_npzdcarremo_slope,
     & wspeed_npzdcarremo_intercept,  wspeed_npzdcarremo_slope,
     & sur_par_npzdcarremo_intercept, sur_par_npzdcarremo_slope,
     & atmosp_npzdcarremo_intercept,  atmosp_npzdcarremo_slope
c$$$#ifdef USE_NPZDCAR_INTERPOLATION
c$$$     & ,fice_lon0, fice_lon_inc, fice_lat0, fice_lat_inc,
c$$$     & fice_nlon, fice_nlat,
c$$$#endif

      _BEGIN_MASTER(mythid)

c     Set default values.
C      year2sec           = 365.*86400.

c     Calendar data.
C     for ice-fraction
      ficestartdate1    = 0
      ficestartdate2    = 0
      ficeperiod        = 0.0 _d 0
      ficeconst         = 0.0 _d 0
      fice_npzdcarremo_intercept = 0.0 _d 0
      fice_npzdcarremo_slope = 0.0 _d 0
C     for iron : inputFe
      featmosstartdate1    = 0
      featmosstartdate2    = 0
      featmosperiod        = 0.0 _d 0
      featmosconst         = 0.0 _d 0
      featmos_npzdcarremo_intercept = 0.0 _d 0
      featmos_npzdcarremo_slope = 0.0 _d 0
C     for wind speed 
      wspeedstartdate1    = 0
      wspeedstartdate2    = 0
      wspeedperiod        = 0.0 _d 0
      wspeedconst         = 0.0 _d 0
      wspeed_npzdcarremo_intercept = 0.0 _d 0
      wspeed_npzdcarremo_slope = 0.0 _d 0
C     for PAR -- shortwave radiation
      sur_parstartdate1    = 0
      sur_parstartdate2    = 0
      sur_parperiod        = 0.0 _d 0
      sur_parconst         = 0.0 _d 0
      sur_par_npzdcarremo_intercept = 0.0 _d 0
      sur_par_npzdcarremo_slope = 0.0 _d 0
C     for Atmosheric preccure
      atmospstartdate1    = 0
      atmospstartdate2    = 0
      atmospperiod        = 0.0 _d 0
      atmospconst         = 0.0 _d 0
      atmosp_npzdcarremo_intercept = 0.0 _d 0
      atmosp_npzdcarremo_slope = 0.0 _d 0

      npzdcar_repeatPeriod           = 0.0 _d 0
C      npzdcar_albedo             = 0.1 _d 0

c     Data files.
      ficefile          = ' '
      featmosfile       = ' '
      wspeedfile        = ' '
      sur_parfile       = ' '
      atmospfile        = ' '

c     Start dates.
      ficestartdate     = 0.
      featmosstartdate  = 0.
      wspeedstartdate   = 0.
      sur_parstartdate  = 0.
      atmospstartdate   = 0.

c     Initialise file type and field precision
      npzdcar_iprec            = 32
      npzdcar_yftype           = 'RL'
      useNpzdcarYearlyFields   = .FALSE.
      NpzdcartwoDigitYear      = .FALSE.
      useNpzdcarCheckRange     = .TRUE.

c     Input scaling factors.
      npzdcar_inscal_fice     =  1. _d 0
      npzdcar_inscal_featmos  =  1. _d 0
      npzdcar_inscal_wspeed   =  1. _d 0
      npzdcar_inscal_sur_par  =  1. _d 0
      npzdcar_inscal_atmosp   =  1. _d 0

c     Output scaling factors.
      npzdcar_outscal_fice    =  1. _d 0
      npzdcar_outscal_featmos =  1. _d 0
      npzdcar_outscal_wspeed  =  1. _d 0
      npzdcar_outscal_sur_par =  1. _d 0
      npzdcar_outscal_atmosp  =  1. _d 0

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
      if ( featmosfile .NE. ' ' ) then
         call cal_FullDate  ( featmosstartdate1, featmosstartdate2,
     &        date_array                       , mythid )
         call cal_TimePassed(modelstartdate,date_array,difftime,mythid)
         call cal_ToSeconds ( difftime, featmosstartdate, mythid )
         featmosstartdate = modelstart + featmosstartdate
      endif
      if ( wspeedfile .NE. ' ' ) then
         call cal_FullDate  ( wspeedstartdate1, wspeedstartdate2,
     &        date_array                       , mythid )
         call cal_TimePassed(modelstartdate,date_array,difftime,mythid)
         call cal_ToSeconds ( difftime, wspeedstartdate, mythid )
         wspeedstartdate = modelstart + wspeedstartdate
      endif
      if ( sur_parfile .NE. ' ' ) then
         call cal_FullDate  ( sur_parstartdate1, sur_parstartdate2,
     &        date_array                       , mythid )
         call cal_TimePassed(modelstartdate,date_array,difftime,mythid)
         call cal_ToSeconds ( difftime, sur_parstartdate, mythid )
         sur_parstartdate = modelstart + sur_parstartdate
      endif
      if ( atmospfile .NE. ' ' ) then
         call cal_FullDate  ( atmospstartdate1, atmospstartdate2,
     &        date_array                       , mythid )
         call cal_TimePassed(modelstartdate,date_array,difftime,mythid)
         call cal_ToSeconds ( difftime, atmospstartdate, mythid )
         atmospstartdate = modelstart + atmospstartdate
      endif

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
