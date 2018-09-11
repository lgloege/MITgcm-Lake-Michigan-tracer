#include "CPP_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

#ifdef ALLOW_PTRACERS
#ifdef ALLOW_NPZDCAR

      SUBROUTINE NPZDCAR_INIT_VARI( myThid )
C     /==========================================================\
C     | SUBROUTINE NPZDCAR_INIT_VAR                              | 
C     \==========================================================/
      IMPLICIT NONE

C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "DYNVARS.h"
#include "GRID.h"
#include "MONITOR.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS.h"
#include "NPZDCAR.h"
#include "NPZDCAR_LOAD.h"

C     == Routine arguments ==
C     myTime - Current time of simulation ( s )
C     myIter - Iteration number
C     myThid -  Number of this instance of INI_FORCING
      _RL     myTime
      INTEGER myIter
      INTEGER myThid

C     == Local variables ==
      LOGICAL  DIFFERENT_MULTIPLE
      EXTERNAL DIFFERENT_MULTIPLE
      INTEGER i,j,k,bi, bj
      CHARACTER*(MAX_LEN_MBUF) suff
      CHARACTER*(MAX_LEN_MBUF) msgBuf

      INTEGER iTracer

c set global mean surface values to zero
      gsm_s = 0.
      gsm_dic = 0.
      gsm_alk = 0.

c
c set all carbon/oxygen chem variables to zero
      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)
        DO j=1-OLy,sNy+OLy
         DO i=1-OLx,sNx+OLx
          ak0(i,j,bi,bj)=0.d0
          ak1(i,j,bi,bj)=0.d0
          ak2(i,j,bi,bj)=0.d0
          akw(i,j,bi,bj)=0.d0
          akb(i,j,bi,bj)=0.d0
          akf(i,j,bi,bj)=0.d0
          ak1p(i,j,bi,bj)=0.d0
          ak2p(i,j,bi,bj)=0.d0
          ak3p(i,j,bi,bj)=0.d0
          aksi(i,j,bi,bj)=0.d0
          ff(i,j,bi,bj)=0.d0
          ft(i,j,bi,bj)=0.d0
          st(i,j,bi,bj)=0.d0
          bt(i,j,bi,bj)=0.d0
         ENDDO
        ENDDO
       ENDDO
      ENDDO


#ifdef ALLOW_TIMEAVE

c set arrays to zero if first timestep
        DO bj = myByLo(myThid), myByHi(myThid)
         DO bi = myBxLo(myThid), myBxHi(myThid)
          CALL TIMEAVE_RESET(Phygrow1ave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(Phygrow2ave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(Zoograzave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(Parave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(Chlave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(FluxCO2ave,   1,  bi, bj, myThid)
          CALL TIMEAVE_RESET(FluxO2ave,   1,  bi, bj, myThid)
          CALL TIMEAVE_RESET(pHave,   1,  bi, bj, myThid)
          CALL TIMEAVE_RESET(pCO2ave,   1,  bi, bj, myThid)
          CALL TIMEAVE_RESET(virtCO2fluxave,   1,  bi, bj, myThid)
cswdterms -- add ---
#ifdef PTR_CALC_TERMS
          CALL TIMEAVE_RESET(wopave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(uopave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(vopave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(wipave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(uipave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(vipave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(wosave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(uosave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(vosave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(wisave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(uisave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(visave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(wofave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(uofave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(vofave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(wifave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(uifave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(vifave,   Nr,  bi, bj, myThid)
#endif
cswdterms -- end add ---
          print*,'QQ start timeave'
          do k=1,nR
            NPZD_TimeAve(k,bi,bj)=0.d0
          enddo
         ENDDO
        ENDDO
c
         
#endif /* ALLOW_TIMEAVE */


      RETURN
      END
#endif /* NPZDCAR      */
#endif

