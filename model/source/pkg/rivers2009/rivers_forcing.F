#include "PTRACERS_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

CBOP
C !ROUTINE: RIVERS_FORCING

C !INTERFACE: ==========================================================
      SUBROUTINE RIVERS_FORCING(flow,  
     O           GTDOC, 
     I           bi,bj,imin,imax,jmin,jmax,
     I           myIter,myTime,myThid)

C !DESCRIPTION:
C  Calculate the effect of river flow on DOC in lake             
c  July 2008

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
      INTEGER iMin,iMax,jMin,jMax, bi, bj
      character*(max_len_mbuf) msgbuf

C !OUTPUT PARAMETERS: ===================================================
c GTDOC                   :: tendency due river flow
      _RL  GTDOC(1-OLx:sNx+OLx,1-OLy:sNy+OLy)


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
c            rivflow(i,j,bi,bj) = rivflow(i,j,bi,bj)*maskc(i,j,1,bi,bj)
c         ENDDO
c         ENDDO
c      ENDDO 
c      ENDDO

c  update tile edges
c      _EXCH_XY_R8(rivflow,  mythid)
c diagnostics
c      CALL RIVERS_DIAGNOSTICS_FILL( mytime, myiter, mythid )

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      kLev=1

      print*,'DOC_RIVER ', DOC_RIVER
c      print*,'recip_drF ', recip_drF(kLev)
c      print*,'rA(10,10,1,1) ', rA(10,10,1,1)
c      print*,'flow(10,10,1,1) ', flow(10,10,1,1)
c      print*,'HFacC(10,10,1,1,1)',HFacC(10,10,1,1,1)

        DO j=1,sNy
         DO i=1,sNx
           IF (HFacC(i,j,kLev,bi,bj).NE.0.) THEN
              GTDOC(i,j) = 
     &         DOC_RIVER
     &         *flow(i,j,bi,bj)*recip_drF(kLev)/
     &         rA(i,j,bi,bj)  
c               print*,'rA',rA(i,j,bi,bj)
               print*,'i',i,' j',j,' flow',flow(i,j,bi,bj)
               print*,'GTDOC',GTDOC(i,j) 
           ELSE
              GTDOC(i,j) = 0. 
           ENDIF
          ENDDO
         ENDDO

         
c         print*,'GTDOC(10,10) ',GTDOC(10,10)

#endif
        RETURN
        END
