#include "PTRACERS_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

CBOP
C !ROUTINE: RIVERS_FORCING

C !INTERFACE: ==========================================================
      SUBROUTINE RIVERS_FORCING(flow, rvalk, PTR_ALK,  
     O           SGDOC, RGALK, 
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
c Noel Urban's student at Michigan Tech studied relationship between
c DOC and Sturgeon River flow in Lake Michigan
c Geffert [1999] - his Masters thesis






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
      _RL docmol
      _RL perflow
      _RL volume_r, coeffu, sumu, mult1, mult2
c      _RL docmolmass, ! commented out by luke, already defined 
      _RL recipd

C !OUTPUT PARAMETERS: ===================================================
c GTDOC                   :: tendency of terrestrial DOC due river flow
      _RL  SGDOC(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL  RGALK(1-OLx:sNx+OLx,1-OLy:sNy+OLy) ! river effect on ALK

#ifdef ALLOW_PTRACERS

C !LOCAL VARIABLES: ====================================================
       INTEGER I,J, kLev
C
ccccccccccccccc get surface forcing fields cccccccccccccccccccccc
c      CALL RIVERS_GETFORCING( mytime, myiter, mythid )

c     call rivers_getffields( mytime, myiter, mythid )
     
c      DO bj = mybylo(mythid),mybyhi(mythid)
c      DO bi = mybxlo(mythid),mymxhi(mythid)
c         k = 1
c         DO j = 1,Sny
c         DO i = 1,Snx
c            flow(i,j,bi,bj) = flow(i,j,bi,bj)*maskc(i,j,1,bi,bj)
c         ENDDO
c         ENDDO
c      ENDDO 
c      ENDDO

c  update tile edges
c      _EXCH_XY_R8(flow,  mythid)
c diagnostics
c      CALL RIVERS_DIAGNOSTICS_FILL( mytime, myiter, mythid )

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      kLev=1
      volume_r = 2.d-9
      coeffu = 2.25
      sumu = 1.66
      mult1 = 1000
      mult2 = 1.d-3
      recipd = 1/docmolmass
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
             RGALK(i,j) = -1*PTR_ALK(i,j,1)*(perflow) ! percent from what was there
     &                     + rvalk(i,j,bi,bj)*perflow ! percent from river flow
c             print*,'RGALK ',RGALK(i,j)
c             print*,'rvalk ',rvalk(i,j,bi,bj)
CCCCCCCCCCCCCCCCCC DOC CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCCCCCCCCCCCCCCCC URBAN CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
           IF (docscheme.EQ.URBAN) THEN
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c get moles of doc entering grid box per second from flow rate, river [DOC] and
c converting mg of DOC to moles of DOC
              docmol = 
     &         ( coeffu * log ( flow(i,j,bi,bj) ) + sumu) ! [DOC] in mg/L 
     &       * flow(i,j,bi,bj) * mult1 ! mass of DOC in mg entering grid box per sec              
     &       *recipd*(mult2) ! mol of DOC entering grid box per sec
              print*,'docmol urban ',docmol
           ENDIF
c
ccc
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c           IF (docscheme.EQ.GEFFER) THEN
c              docmol =
c     &         ! (geffer relationship)
c           ENDIF
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c
c           constant flow/DOC relationship
           IF (docscheme.EQ.CONSTANT) THEN
              docmol = DOC_RIVER
     &         *flow(i,j,bi,bj)
c           print*,'docmol constant ',docmol
           ENDIF
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
