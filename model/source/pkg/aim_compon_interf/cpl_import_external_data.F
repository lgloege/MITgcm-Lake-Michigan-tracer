C $Header: /u/gcmpack/MITgcm/pkg/aim_compon_interf/cpl_import_external_data.F,v 1.2 2004/05/21 20:00:48 jmc Exp $
C $Name:  $  

#include "CPP_OPTIONS.h"

CStartOfInterface
      SUBROUTINE CPL_IMPORT_EXTERNAL_DATA(
     I                      myIter, myTime, myThid )
C     /==========================================================\
C     | SUBROUTINE CPL_IMPORT_EXTERNAL_DATA                      |
C     | o Routine for controlling import of coupling data from   |
C     |   coupler layer.                                         |
C     |==========================================================|
C     | This version talks to the MIT Coupler. It uses the MIT   |
C     | Coupler "checkpoint1" library calls.                     |
C     \==========================================================/
      IMPLICIT NONE

#include "EEPARAMS.h"
#include "CPL_PARAMS.h"

C     == Routine arguments ==
C     myIter - Current timestep number.
C     myTime - Current internal time.
C     myThid - Thread number for this instance of the routine.
      INTEGER myIter
      _RL     myTime
      INTEGER myThid
CEndOfInterface

#ifdef COMPONENT_MODULE
C     == Local variables ==

C     Fetch data from coupling layer. Note MIT Coupler checkpoint1
C     does not allow asynchronous extraction of data, so ordering 
C     has to be consistent with ordering coupling layer.

      IF ( (myIter/cplSendFrq_iter)*cplSendFrq_iter .EQ. myIter ) THEN
       WRITE(0,*) ' Importing oceanic fields at iteration ', myIter
       CALL ATM_IMPORT_FIELDS( myThid )
      ENDIF

#endif /* COMPONENT_MODULE */

      RETURN
      END
