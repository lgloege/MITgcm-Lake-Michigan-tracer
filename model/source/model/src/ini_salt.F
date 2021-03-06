C $Header: /u/gcmpack/MITgcm/model/src/ini_salt.F,v 1.17 2005/11/08 23:01:10 cnh Exp $
C $Name:  $

#include "CPP_OPTIONS.h"

CBOP
C     !ROUTINE: INI_SALT
C     !INTERFACE:
      SUBROUTINE INI_SALT ( myThid )
C     !DESCRIPTION: \bv
C     *==========================================================*
C     | SUBROUTINE INI_SALT                                       
C     | o Set model initial salinity field.                       
C     *==========================================================*
C     | There are several options for setting the initial         
C     | temperature file                                          
C     |  1. Inline code                                           
C     |  2. Vertical profile ( uniform S in X and Y )             
C     |  3. Three-dimensional data from a file. For example from  
C     |     Levitus or from a checkpoint file from a previous     
C     |     integration.                                          
C     | In addition to setting the salinity field we also         
C     | set the initial salinity tendency term here.              
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE
C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine arguments ==
C     myThid -  Number of this instance of INI_SALT 
      INTEGER myThid

C     !LOCAL VARIABLES:
C     == Local variables ==
C     bi,bj  - Loop counters
C     I,J,K
      INTEGER bi, bj
      INTEGER I, J, K, localWarnings
      CHARACTER*(MAX_LEN_MBUF) msgBuf
CEOP

C--   Initialise salinity field to the vertical reference profile
      DO bj = myByLo(myThid), myByHi(myThid)
       DO bi = myBxLo(myThid), myBxHi(myThid)
        DO K=1,Nr
         DO J=1-Oly,sNy+Oly
          DO I=1-Olx,sNx+Olx
           salt(I,J,K,bi,bj) = sRef(K)
          ENDDO
         ENDDO
        ENDDO
       ENDDO
      ENDDO
      _BARRIER

      IF ( hydrogSaltFile .NE. ' ' ) THEN
C      _BEGIN_MASTER( myThid )
       CALL READ_FLD_XYZ_RL( hydrogSaltFile, ' ', salt, 0, myThid )
C      _END_MASTER(myThid)
       _EXCH_XYZ_R8(salt  , myThid )
      ENDIF

C     Apply mask and test consistancy
      localWarnings=0
      DO bj = myByLo(myThid), myByHi(myThid)
       DO bi = myBxLo(myThid), myBxHi(myThid)
        DO K=1,Nr
         DO J=1-Oly,sNy+Oly
          DO I=1-Olx,sNx+Olx
           IF (maskC(I,J,K,bi,bj).EQ.0.) salt(I,J,K,bi,bj) = 0.
          ENDDO
         ENDDO
         IF ( sRef(k).NE.0. ) THEN
          DO J=1,sNy
           DO I=1,sNx
            IF ( maskC(I,J,K,bi,bj).NE.0.
     &      .AND. salt(I,J,K,bi,bj).EQ.0. ) THEN
              localWarnings=localWarnings+1
            ENDIF
           ENDDO
          ENDDO
         ENDIF
        ENDDO
       ENDDO
      ENDDO
      IF (localWarnings.NE.0) THEN
       WRITE(msgBuf,'(A,A)')
     &  'S/R INI_SALT: salt = 0 identically. If this is intentional',
     &  'you will need to edit ini_salt.F to avoid this safety check'
       CALL PRINT_ERROR( msgBuf , myThid)
       STOP 'ABNORMAL END: S/R INI_SALT'
      ENDIF

      CALL PLOT_FIELD_XYZRL( salt, 'Initial Salinity' , Nr, 1, myThid )

      RETURN
      END
