#include "GCHEM_OPTIONS.h"

CBOP
C !ROUTINE: ALK_SURFFORCING

C !INTERFACE: ==========================================================
      SUBROUTINE ALK_SURFFORCING( PTR_ALK , GALK, 
     I           bi,bj,imin,imax,jmin,jmax,
     I           myIter,myTime,myThid)

C !DESCRIPTION:
C Calculate the alkalinity change due to freshwater flux
C Update alkalinity tendency term

C !USES: ===============================================================
      IMPLICIT NONE
#include "SIZE.h"
#include "DYNVARS.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "FFIELDS.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS.h"
#include "NPZDCAR.h"

C !INPUT PARAMETERS: ===================================================
C  myThid               :: thread number
C  myIter               :: current timestep
C  myTime               :: current time
C  bi,bj                :: tile indices
C  PTR_ALK              :: alkalinity field
      INTEGER myIter, myThid
      _RL myTime
      _RL  PTR_ALK(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr)
      INTEGER iMin,iMax,jMin,jMax, bi, bj

C !OUTPUT PARAMETERS: ==================================================
C  GALK                 :: tendency term of alkalinity
      _RL  GALK(1-OLx:sNx+OLx,1-OLy:sNy+OLy)

#ifdef ALLOW_GCHEM
#ifdef ALLOW_NPZDCAR

C !LOCAL VARIABLES: ====================================================
C  i,j                  :: loop indices
      INTEGER i,j
CEOP

        DO j=1,sNy
          DO i=1,sNx
            IF (maskC(i,j,1,bi,bj).NE.0.) THEN
c calculate virtual flux
c EminusPforV = dS/dt*(1/Sglob)
C NOTE: Be very careful with signs here!
C Positive EminusPforV => loss of water to atmos and increase
C in salinity. Thus, also increase in other surface tracers
C (i.e. positive virtual flux into surface layer)
cQQ           GALK(i,j)=gsm_ALK*ftotflux(i,j,bi,bj)/gsm_S
              GALK(i,j)=gsm_ALK*surfaceForcingS(i,j,bi,bj)*
     &                  recip_drF(1)/gsm_S
c OR
c let virtual flux be zero
c             GALK(i,j)=0.d0
c
            ELSE
              GALK(i,j)=0. _d 0
            ENDIF
          ENDDO
         ENDDO

#endif
#endif
        RETURN
        END
