#include "PTRACERS_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

CBOP
C !ROUTINE: RIVERS_DICFORCE

C !INTERFACE: ==========================================================
      SUBROUTINE RIVERS_DICFORCE(flow, rvdic, PTR_DIC,  
     O           RGDIC, 
     I           bi,bj,imin,imax,jmin,jmax,
     I           myIter,myTime,myThid)

C !DESCRIPTION:
c July 2010 - Val Bennington
c Calculates river flow effect on DIC concentrations at river mouth
c Uses flow rate and river DIC concentration
c to dilute or concentration DIC at river mouth

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
#include "GCHEM.h"
#include "rivers_param.h"
#include "rivers.h"
#include "RIVERS_OPTIONS.h"

C !INPUT PARAMETERS: ===================================================
C  myThid               :: thread number
C  myIter               :: current timestep
C  myTime               :: current time
c  PTR_DIC              :: DIC tracer field
      INTEGER myIter, myThid
      _RL myTime
      _RL flow(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL rvdic(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL PTR_DIC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr)
      INTEGER iMin,iMax,jMin,jMax, bi, bj
      character*(max_len_mbuf) msgbuf
      _RL perflow
      _RL volume_r, coeffu, sumu, mult1, mult2
c      _RL docmolmass, recipd

C !OUTPUT PARAMETERS: ===================================================
c GTDOC                   :: tendency of terrestrial DOC due river flow
c      _RL  SGDOC(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL  RGDIC(1-OLx:sNx+OLx,1-OLy:sNy+OLy) ! river effect on ALK

#ifdef ALLOW_PTRACERS

C !LOCAL VARIABLES: ====================================================
       INTEGER I,J, kLev
C
ccccccccccccccc get surface forcing fields cccccccccccccccccccccc
      kLev=1
       volume_r = recip_drF(kLev)/
     &         rA(i,j,bi,bj)
c      volume_r = 2.d-9
c      print*,'volume_r ',volume_r
c      print*,'DOC_RIVER ', DOC_RIVER
c      print*,'recip_drF ', recip_drF(kLev)
c      print*,'rA(10,10,1,1) ', rA(10,10,1,1)
c      print*,'flow(10,10,1,1) ', flow(10,10,1,1)
c      print*,'HFacC(10,10,1,1,1)',HFacC(10,10,1,1,1)

        DO j=1,sNy
         DO i=1,sNx
           IF (HFacC(i,j,kLev,bi,bj).NE.0.) THEN
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Mix river alkalinity with lake alkalinity:
             perflow =
     &       flow(i,j,bi,bj)*volume_r
c             print*,'flow ',flow(i,j,bi,bj)
c             print*,'perflow ',perflow
             RGDIC(i,j) = -1*PTR_DIC(i,j,1)*(perflow) ! percent from what was there
     &                     + rvdic(i,j,bi,bj)*perflow ! percent from river flow
c             print*,'RGALK ',RGALK(i,j)
c             print*,'rvalk ',rvalk(i,j,bi,bj)
CCCCCCCCCCCCCCCCCC DOC CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
           ELSE
              RGDIC(i,j) = 0.
           ENDIF
          ENDDO
         ENDDO

         
c         print*,'SGDOC(24,15) ',SGDOC(24,15)
c         print*,'SGDOC(24,45) ',SGDOC(24,45)
c         print*,'RGALK(24,15) ',RGALK(24,15)


#endif
        RETURN
        END
