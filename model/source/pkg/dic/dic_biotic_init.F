C $Header: /u/gcmpack/MITgcm/pkg/dic/dic_biotic_init.F,v 1.5 2005/08/18 18:24:29 stephd Exp $
C $Name:  $

#include "DIC_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

CBOP
C !ROUTINE: DIC_BIOTIC_INIT

C !INTERFACE: ==========================================================
      SUBROUTINE DIC_BIOTIC_INIT( myThid )

C !DESCRIPTION:
C  DIC diagnostic initialization                   

C !USES: ===============================================================
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#ifdef DIC_BIOTIC
#include "DIC_BIOTIC.h"
#endif

c!INPUT PARAMETERS: ===================================================
C  myThid               :: thread number
      INTEGER myThid


C !LOCAL VARIABLES: ====================================================
      INTEGER bi, bj, k
      CHARACTER*(MAX_LEN_MBUF) suff
CEOP

#ifdef DIC_BIOTIC
#ifdef ALLOW_TIMEAVE

c set arrays to zero if first timestep
        DO bj = myByLo(myThid), myByHi(myThid)
         DO bi = myBxLo(myThid), myBxHi(myThid)
          CALL TIMEAVE_RESET(BIOave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(CARave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(SURave,   1,  bi, bj, myThid)
          CALL TIMEAVE_RESET(SUROave,   1,  bi, bj, myThid)
          CALL TIMEAVE_RESET(pCO2ave,   1,  bi, bj, myThid)
          CALL TIMEAVE_RESET(pHave,   1,  bi, bj, myThid)
          CALL TIMEAVE_RESET(fluxCO2ave,   1,  bi, bj, myThid)
          CALL TIMEAVE_RESET(OmegaCave,   Nr,  bi, bj, myThid)
          CALL TIMEAVE_RESET(pfluxave,   1,  bi, bj, myThid)
          CALL TIMEAVE_RESET(cfluxave,   1,  bi, bj, myThid)
          print*,'QQ start timeave'
          do k=1,Nr
            DIC_TimeAve(bi,bj,k)=0.d0
          enddo
         ENDDO
        ENDDO

#endif /* ALLOW_TIMEAVE */
      
#endif /* DIC_BIOTIC   */
      
      RETURN
      END
