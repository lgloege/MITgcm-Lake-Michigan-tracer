C $Header: /u/gcmpack/MITgcm/pkg/monitor/mon_set_iounit.F,v 1.2 2004/04/03 21:17:10 edhill Exp $
C $Name:  $

#include "MONITOR_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP
C     !ROUTINE: MON_SET_IOUNIT

C     !INTERFACE:
      SUBROUTINE MON_SET_IOUNIT(unit, myThid )

C     !DESCRIPTION:
C     Set default monitor unit for I/O.

C     !USES:
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "MONITOR.h"

C     !INPUT PARAMETERS:
C     unit   - Unit number to use for monitor output
C     myThid - Instance number of this call to monitor
      INTEGER unit
      INTEGER myThid
CEOP

C     Dont change before everyone is ready
      CALL BAR2( myThid )

C     Set monitor I/O unit
      mon_ioUnit = standardMessageUnit

C     Make sure everyone sees the change
      CALL BAR2( myThid )

      RETURN
      END
