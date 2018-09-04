#include "GCHEM_OPTIONS.h"

CBOP
C !ROUTINE: NPZDCAR_AREAMEANS
C !INTERFACE: ==========================================================
      SUBROUTINE NPZDCAR_AREAMEANS(myTime,myIter, myThid )

C !DESCRIPTION:
C     calculate some of the global means need for virtual fluxes

C !USES: ===============================================================
      IMPLICIT NONE
#include "SIZE.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS.h"
#include "NPZDCAR.h"

C !INPUT PARAMETERS: ===================================================
C  myThid               :: thread number
      INTEGER myThid, myIter
      _RL myTime

c!LOCAL VARIABLES: ====================================================
C  i,j                  :: loop indices
C  bi,bj                :: tile indices
C  k                    :: vertical level
      INTEGER bi,bj,imin,imax,jmin,jmax
      INTEGER i,j
CEOP

#ifdef ALLOW_GCHEM

       _BARRIER
       _BEGIN_MASTER( mythid )

ccccccccccccccccccccccccc
c global calculations   c
ccccccccccccccccccccccccc
c find global surface averages
       gsm_s = 0.d0
       gsm_dic = 0.d0
       gsm_alk = 0.d0
       call tracer_meanarea(myThid,salt, 1,gsm_s)
       call tracer_meanarea(myThid,
     &               ptracer(1-Olx,1-Oly,1,1,1,13), 1, gsm_dic)
       call tracer_meanarea(myThid,

     &               ptracer(1-Olx,1-Oly,1,1,1,19), 1, gsm_alk)
       print*,'mean surface dic,s,alk', gsm_dic,gsm_s,gsm_alk
ccccccccccccccccccccccccccccccccccccccccccc

      _END_MASTER( mythid )
      _BARRIER

#endif /* ALLOW_GCHEM */

      RETURN
      END

