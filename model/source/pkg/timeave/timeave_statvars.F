C $Header: /u/gcmpack/MITgcm/pkg/timeave/timeave_statvars.F,v 1.23 2005/11/04 01:35:33 jmc Exp $
C $Name:  $
#include "TIMEAVE_OPTIONS.h"

      SUBROUTINE TIMEAVE_STATVARS(
     I     myTime, myIter, bi, bj, myThid)
C     /==========================================================\
C     | SUBROUTINE TIMEAVE_STATVARS                              |
C     | o Time averaging routine for eta, U, V, W, T, S, UT, VT  |
C     |   in model main time-stepping                            |
C     \==========================================================/
      IMPLICIT NONE

C     == Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "DYNVARS.h"
#include "GRID.h"
#include "TIMEAVE_STATV.h"

      LOGICAL  DIFFERENT_MULTIPLE
      EXTERNAL DIFFERENT_MULTIPLE

C     == Routine arguments ==
C     myThid - Thread number for this instance of the routine.
C     myIter - Iteration number
C     myTime - Current time of simulation ( s )
      INTEGER myThid
      INTEGER myIter, bi, bj
      _RL     myTime

#ifdef ALLOW_TIMEAVE

C     == Local variables ==
      INTEGER k
      _RL DDTT
#ifdef ALLOW_CAL
      INTEGER thisdate(4), prevdate(4)
#endif
 
C-    Initialize fields for the first call ever
      IF ( myIter .EQ. nIter0 ) THEN
        CALL TIMEAVE_RESET(uFluxtave, 1,  bi, bj, myThid)
        CALL TIMEAVE_RESET(vFluxtave, 1,  bi, bj, myThid)
        CALL TIMEAVE_RESET(tFluxtave, 1,  bi, bj, myThid)
        CALL TIMEAVE_RESET(sFluxtave, 1,  bi, bj, myThid)
        CALL TIMEAVE_RESET(etatave,   1,  bi, bj, myThid)
        CALL TIMEAVE_RESET(thetatave, Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(salttave,  Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(uVeltave,  Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(vVeltave,  Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(wVeltave,  Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(phiHydLowtave,1, bi, bj, myThid)
        CALL TIMEAVE_RESET(UTtave,    Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(VTtave,    Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(WTtave,    Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(UStave,    Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(VStave,    Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(WStave,    Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(Eta2tave,  1,  bi, bj, myThid)
        CALL TIMEAVE_RESET(TTtave,    Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(UUtave,    Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(VVtave,    Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(UVtave,    Nr, bi, bj, myThid)
c       CALL TIMEAVE_RESET(KEtave,    Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(TdiffRtave,Nr, bi, bj, myThid)
#ifdef ALLOW_MOM_VECINV
        CALL TIMEAVE_RESET(uZetatave, Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(vZetatave, Nr, bi, bj, myThid)
#endif
        CALL TIMEAVE_RESET(phiHydtave,Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(phiHydLow2Tave,1, bi, bj, myThid)
        CALL TIMEAVE_RESET(ConvectCountTave,Nr,bi,bj,myThid)
#ifdef NONLIN_FRSURF
        CALL TIMEAVE_RESET(hUtave,    Nr, bi, bj, myThid)
        CALL TIMEAVE_RESET(hVtave,    Nr, bi, bj, myThid)
c       CALL TIMEAVE_RESET(hFacCtave, Nr, bi, bj, myThid)
c       CALL TIMEAVE_RESET(hFacWtave, Nr, bi, bj, myThid)
c       CALL TIMEAVE_RESET(hFacStave, Nr, bi, bj, myThid)
#endif /* NONLIN_FRSURF */
        DO k=1,Nr
         TimeAve_half(k,bi,bj)=0.
         TimeAve_full(k,bi,bj)=0.
        ENDDO
      ENDIF
      
C--   Cumulate state-variables with Half or Full time step : 
      DDTT = deltaTclock
      IF ( myIter .EQ. nIter0 ) THEN
        DDTT = deltaTclock*(1. _d 0 - tave_lastIter)
#ifdef ALLOW_CAL
      ELSEIF ( calendarDumps .AND. (
     &       ( taveFreq.GE. 2592000 .AND. taveFreq.LE. 2678400 ) .OR.
     &       ( taveFreq.GE.31104000 .AND. taveFreq.LE.31968000 ))) THEN
C--   Convert approximate months (30-31 days) and years (360-372 days)
C     to exact calendar months and years.
C-    First determine calendar dates for this and previous time step.
       call cal_GetDate( myiter  ,mytime            ,thisdate,mythid )
       call cal_GetDate( myiter-1,mytime-deltaTClock,prevdate,mythid )
C-    Monthly taveFreq:
       IF(taveFreq.GE. 2592000 .AND. taveFreq.LE. 2678400 .AND.
     &  (thisdate(1)-prevdate(1)).GT.50  )DDTT=deltaTclock*tave_lastIter
C-    Yearly  taveFreq:
       IF(taveFreq.GE.31104000 .AND. taveFreq.LE.31968000 .AND.
     &  (thisdate(1)-prevdate(1)).GT.5000)DDTT=deltaTclock*tave_lastIter
#endif
      ELSEIF ( DIFFERENT_MULTIPLE(taveFreq,myTime,deltaTClock) ) THEN
        DDTT = deltaTclock*tave_lastIter
      ENDIF

      IF ( DDTT .NE. 0. _d 0) THEN

C-    Time Averages of single fields (no hFactor)
      CALL TIMEAVE_CUMULATE(etatave,  etaN,  1 , DDTT, bi, bj, myThid)
      CALL TIMEAVE_CUMULATE(thetatave,theta, Nr, DDTT, bi, bj, myThid)
      CALL TIMEAVE_CUMULATE(salttave, salt,  Nr, DDTT, bi, bj, myThid)
      CALL TIMEAVE_CUMULATE(uVeltave, uVel,  Nr, DDTT, bi, bj, myThid)
      CALL TIMEAVE_CUMULATE(vVeltave, vVel,  Nr, DDTT, bi, bj, myThid)
      CALL TIMEAVE_CUMULATE(wVeltave, wVel,  Nr, DDTT, bi, bj, myThid)

C-    Time Averages of "double" fields (no hFactor)
      CALL TIMEAVE_CUMUL_2V(Eta2tave, etaN,etaN, 1,  0,
     &     DDTT, bi, bj, myThid)
      CALL TIMEAVE_CUMUL_2V(TTtave, theta,theta, Nr, 0,
     &     DDTT, bi, bj, myThid)
      CALL TIMEAVE_CUMUL_2V(UUtave, uVel,  uVel, Nr, 0,
     &     DDTT, bi, bj, myThid)
      CALL TIMEAVE_CUMUL_2V(VVtave, vVel,  vVel, Nr, 0,
     &     DDTT, bi, bj, myThid)
      CALL TIMEAVE_CUMUL_2V(UVtave, uVel,  vVel, Nr, 12,
     &     DDTT, bi, bj, myThid)
c     CALL TIMEAVE_CUMUL_KE(KEtave, uVel,  vVel, Nr,
c    &     DDTT, bi, bj, myThid)
      CALL TIMEAVE_CUMUL_2V(WTtave, theta, wVel, Nr, 3,
     &     DDTT, bi, bj, myThid)
      CALL TIMEAVE_CUMUL_2V(WStave, salt,  wVel, Nr, 3,
     &     DDTT, bi, bj, myThid)

#ifdef NONLIN_FRSURF

c     CALL TIMEAVE_CUMUL_FC(hFacCtave,hFacC, Nr, DDTT, bi, bj, myThid)
c     CALL TIMEAVE_CUMUL_FC(hFacWtave,hFacW, Nr, DDTT, bi, bj, myThid)
c     CALL TIMEAVE_CUMUL_FC(hFacStave,hFacS, Nr, DDTT, bi, bj, myThid)

C-    Time Averages of single fields (* hFactor)
      CALL TIMEAVE_CUMUL_1VFC(hUtave,  uVel,  hFacW, Nr,
     &     DDTT, bi, bj, myThid)
      CALL TIMEAVE_CUMUL_1VFC(hVtave,  vVel,  hFacS, Nr,
     &     DDTT, bi, bj, myThid)

#endif /* NONLIN_FRSURF */

C-    Time Averages of "double" fields (* hFactor)
      CALL TIMEAVE_CUMUL_2VFC(UTtave, theta, uVel,  hFacW, Nr, 1,
     &     DDTT, bi, bj, myThid)
      CALL TIMEAVE_CUMUL_2VFC(VTtave, theta, vVel,  hFacS, Nr, 2,
     &     DDTT, bi, bj, myThid)
      CALL TIMEAVE_CUMUL_2VFC(UStave, salt, uVel,  hFacW, Nr, 1,
     &     DDTT, bi, bj, myThid)
      CALL TIMEAVE_CUMUL_2VFC(VStave, salt, vVel,  hFacS, Nr, 2,
     &     DDTT, bi, bj, myThid)

C-    Time Averages of "double" fields (no hFactor)
c     CALL TIMEAVE_CUMUL_2V(UTtave, theta, uVel, Nr, 1,
c    &     DDTT, bi, bj, myThid)
c     CALL TIMEAVE_CUMUL_2V(VTtave, theta, vVel, Nr, 2,
c    &     DDTT, bi, bj, myThid)
c     CALL TIMEAVE_CUMUL_2V(UStave, salt, uVel, Nr, 1,
c    &     DDTT, bi, bj, myThid)
c     CALL TIMEAVE_CUMUL_2V(VStave, salt, vVel, Nr, 2,
c    &     DDTT, bi, bj, myThid)

C-    Keep record of how much time has been integrated over
      DO K=1,Nr
        TimeAve_half(k,bi,bj)=TimeAve_half(k,bi,bj)+DDTT
      ENDDO

C-- end if DDTT ...
      ENDIF

C-    Time Averages of "intermediate" fields (no hFactor)
      IF ( myIter .NE. nIter0 ) THEN
 
C-    Time Averages of surface fluxes
C     <- moved to external_forcing_surf

        CALL TIMEAVE_CUMULATE(phiHydLowtave, phiHydLow, 1,
     &                                   deltaTclock, bi, bj, myThid)
        CALL TIMEAVE_CUMULATE(phiHydtave, totPhihyd,  Nr, 
     &                                   deltaTclock, bi, bj, myThid)
        CALL TIMEAVE_CUMUL_2V(phiHydLow2Tave, 
     &       phiHydLow,phiHydLow, 1,  0, deltaTclock, bi, bj, myThid)
        DO K=1,Nr
         TimeAve_full(k,bi,bj)=TimeAve_full(k,bi,bj)+deltaTclock
        ENDDO
      ENDIF

#endif /* ALLOW_TIMEAVE */ 

      RETURN
      END
