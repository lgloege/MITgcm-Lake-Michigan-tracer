#include "PTRACERS_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

CBOP
C !ROUTINE: RIVERS_DOCFORCE

C !INTERFACE: ==========================================================
      SUBROUTINE RIVERS_DOCFORCE(flow,rvdoc,
     O           SGDOC,  
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

c  if flow_doc == 1
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c  default relationship is from Urban et al., 2005 (JGR)
c  Carbon Cycling in Lake Superior
c  from observations in Lake Superior (Ontonogan, Sturgeon, Bad Rivers)
c  find relationship of:
c  DOC (mg/L) = 2.25*Ln(Flow)+1.66  (Flow in m3/sec)
c  r2 = 0.43

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c if flow_doc = 2
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c use average DOC concentration that is specific to each river
c must create an input file with mean DOC at all river mouths





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
      _RL rvdoc(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER iMin,iMax,jMin,jMax, bi, bj
      character*(max_len_mbuf) msgbuf
      _RL docmol
      _RL perflow
      _RL volume_r, coeffu, sumu, mult1, mult2
      _RL docmolmass, recipd

C !OUTPUT PARAMETERS: ===================================================
c GTDOC                   :: tendency of terrestrial DOC due river flow
      _RL  SGDOC(1-OLx:sNx+OLx,1-OLy:sNy+OLy)

#ifdef ALLOW_PTRACERS

C !LOCAL VARIABLES: ====================================================
       INTEGER I,J, kLev
C

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      kLev=1
      volume_r = recip_drF(kLev)/
     &         rA(i,j,bi,bj)
c      volume_r = 2.d-9
      coeffu = 2.25
      sumu = 1.66
      mult1 = 1000
      mult2 = 1.d-3
      recipd = 1/docmolmass
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
CCCCCCCCCCCCCCCCCC DOC CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCCCCCCCCCCCCCCCC URBAN CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C COMMENTED OUT BY LUKE
c           IF (docscheme.EQ.URBAN) THEN
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c get moles of doc entering grid box per second from flow rate, river [DOC] and
c converting mg of DOC to moles of DOC
c             IF (flow(i,j,bi,bj).gt.0.48) THEN
c              docmol = 
c     &         ( coeffu * log ( flow(i,j,bi,bj) ) + sumu) ! [DOC] in mg/L 
c     &       * flow(i,j,bi,bj) * mult1 ! mass of DOC in mg entering grid box per sec              
c     &       *recipd*(mult2) ! mol of DOC entering grid box per sec
c              print*,'docmol urban ',docmol
c             ELSEIF (flow(i,j,bi,bj).lt.0.48) THEN
c              docmol = 0
c             ENDIF               
c           ENDIF
c
ccc
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C COMMENTED OUT BY LUKE
c           IF (docscheme.EQ.RIVSPEC) THEN
c              docmol = flow(i,j,bi,bj)*
c     &                 rvdoc(i,j,bi,bj)
c           ENDIF
CCCCCCCCCCCCCCCCCC DOC CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC






CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c
C COMMENTED OUT BY LUKE
C           constant flow/DOC relationship
c           IF (docscheme.EQ.CONSTANT) THEN
c              docmol = DOC_RIVER
c     &         *flow(i,j,bi,bj)
C           print*,'docmol constant ',docmol
c           ENDIF
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c divide by grid box volume to get change in concentration caused by river input
              SGDOC(i,j) = 
     &         docmol*recip_drF(1)/
     &         rA(i,j,bi,bj)

c               print*,'rA',rA(i,j,bi,bj)
c               print*,'i',i,' j',j,' flow',flow(i,j,bi,bj)
c               print*,'SGDOC',SGDOC(i,j) 
           ELSE
              SGDOC(i,j) = 0. 
           ENDIF
          ENDDO
         ENDDO

         
c         print*,'SGDOC(24,15) ',SGDOC(24,15)


#endif
        RETURN
        END
