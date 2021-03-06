C $Header: /u/gcmpack/MITgcm/pkg/aim_v23/aim_aim2dyn_exchanges.F,v 1.3 2004/05/21 17:49:59 jmc Exp $
C $Name:  $

#include "AIM_OPTIONS.h"

CStartOfInterface
      SUBROUTINE AIM_AIM2DYN_EXCHANGES(
     I           myTime, myIter, myThid)
C     /==========================================================\
C     | S/R AIM_AIM2DYN_EXCHANGES                                |
C     | o Do overlap exchanges for AIM related quantities.       |
C     |   AIM does not compute into overlaps so exchanges        |
C     |   are needed for AIM quantities.                         |
C     \==========================================================/
      IMPLICIT NONE

C     == Global data ==
#include "SIZE.h" 
#include "EEPARAMS.h"
#include "PARAMS.h"
c #include "DYNVARS.h"

#include "AIM2DYN.h"

#ifdef ALLOW_THSICE
# include "THSICE_VARS.h"
#endif

C     == Routine arguments ==
      _RL myTime
      INTEGER myIter
      INTEGER myThid
CEndOfInterface

#ifdef ALLOW_AIM

C     == Local variables ==
      INTEGER bi,bj

      _EXCH_XY_R8( aim_drag, myThid )
c     _EXCH_XYZ_R8( gT, myThid )
c     _EXCH_XYZ_R8( gS, myThid )
c     _EXCH_XYZ_R8( gTNM1, myThid )
c     _EXCH_XYZ_R8( gSNM1, myThid )

#ifdef ALLOW_THSICE
      IF (useThSIce)  _EXCH_XY_R8( iceMask, myThid )
#endif

#ifdef COMPONENT_MODULE
      IF ( useCoupler ) THEN
       DO bj=myByLo(myThid),myByHi(myThid)
        DO bi=myBxLo(myThid),myBxHi(myThid)
          CALL ATM_STORE_TAUX( bi,bj, myTime, myIter, myThid )
          CALL ATM_STORE_TAUY( bi,bj, myTime, myIter, myThid )
        ENDDO
       ENDDO
      ENDIF
#endif /* COMPONENT_MODULE */

#endif /* ALLOW_AIM */

      RETURN
      END
