#include "PTRACERS_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

CBOP
C !ROUTINE: RIVERS_ALKFORCE

C !INTERFACE: ==========================================================
      SUBROUTINE RIVERS_ALKFORCE(flow, rvalk, PTR_ALK,  
     O           RGALK, 
     I           bi,bj,imin,imax,jmin,jmax,
     I           myIter,myTime,myThid)

C !DESCRIPTION:
C  Calculate the effect of river flow on DOC in lake             
c  Feb 2010
c  river flow is input as water input rate
c  this package calculates the input of terrestrial DOC 
c  (and in the future DIC and P)
c  based on the flow rate
c  Two relationships are possible between the flow rate and DOC inputs
c  as of Feb 2010 





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
      _RL rvalk(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL PTR_ALK(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr)
      INTEGER iMin,iMax,jMin,jMax, bi, bj
      character*(max_len_mbuf) msgbuf
      _RL perflow
      _RL volume_r, coeffu, sumu, mult1, mult2
c      _RL docmolmass, recipd

C !OUTPUT PARAMETERS: ===================================================
c GTDOC                   :: tendency of terrestrial DOC due river flow
c      _RL  SGDOC(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL  RGALK(1-OLx:sNx+OLx,1-OLy:sNy+OLy) ! river effect on ALK

#ifdef ALLOW_PTRACERS

C !LOCAL VARIABLES: ====================================================
       INTEGER I,J, kLev
C
ccccccccccccccc get surface forcing fields cccccccccccccccccccccc
      kLev=1
      volume_r = recip_drF(kLev)/
     &         rA(i,j,bi,bj)
      print*,'volume_r ',volume_r
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
             RGALK(i,j) = -1*PTR_ALK(i,j,1)*(perflow) ! percent from what was there
     &                     + rvalk(i,j,bi,bj)*perflow ! percent from river flow
c             print*,'RGALK ',RGALK(i,j)
c             print*,'rvalk ',rvalk(i,j,bi,bj)
CCCCCCCCCCCCCCCCCC DOC CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
           ELSE
              RGALK(i,j) = 0.
           ENDIF
          ENDDO
         ENDDO

         
c         print*,'SGDOC(24,15) ',SGDOC(24,15)
c         print*,'SGDOC(24,45) ',SGDOC(24,45)
c         print*,'RGALK(24,15) ',RGALK(24,15)


#endif
        RETURN
        END
