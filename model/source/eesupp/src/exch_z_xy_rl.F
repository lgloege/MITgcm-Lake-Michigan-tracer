C $Header: /u/gcmpack/MITgcm/eesupp/src/exch_z_xy_rx.template,v 1.5 2004/09/22 15:24:46 jmc Exp $
C $Name:  $

#include "PACKAGES_CONFIG.h"
#include "CPP_EEOPTIONS.h"

CBOP

C     !ROUTINE: EXCH_Z_XY_RL

C     !INTERFACE:
      SUBROUTINE EXCH_Z_XY_RL(
     U                       phi,
     I                       myThid )
      IMPLICIT NONE

C     !DESCRIPTION:
C     *==========================================================*
C     | SUBROUTINE EXCH_Z_XY_RL                                   
C     | o Handle exchanges for _RL, 2-dim zeta coord array.       
C     *==========================================================*
C     | Branch to correct exchange for particular grid operating
C     | on a zeta coord array.
C     *==========================================================*

C     !USES:
C     == Global variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
#include "EXCH.h"

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine arguments ==
C     phi    :: Array with overlap regions are to be exchanged
C               Note - The interface to EXCH_RL assumes that
C               the standard Fortran 77 sequence association rules
C               apply.
C     myThid :: My thread id.
      _RL phi(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER myThid

C     !LOCAL VARIABLES:
C     == Local variables ==
C     OL[wens]       :: Overlap extents in west, east, north, south.
C     exchWidth[XY]  :: Extent of regions that will be exchanged.
      INTEGER OLw, OLe, OLn, OLs, exchWidthX, exchWidthY, myNz
CEOP

#ifdef ALLOW_EXCH2
      CALL EXCH2_Z_XY_RL( phi, myThid )
      RETURN
#endif

      OLw        = OLx
      OLe        = OLx
      OLn        = OLy
      OLs        = OLy
      exchWidthX = OLx
      exchWidthY = OLy
      myNz       = 1
C     ** NOTE ** The exchange routine we use here does not
C                require the preceeding and following barriers.
C                However, the slow, simple exchange interface
C                that is calling it here is meant to ensure
C                that threads are synchronised before exchanges
C                begine.
      IF (useCubedSphereExchange) THEN
       CALL EXCH_Z_RL_CUBE( phi,
     I            OLw, OLe, OLs, OLn, myNz,
     I            exchWidthX, exchWidthY,
     I            FORWARD_SIMULATION, EXCH_UPDATE_CORNERS, myThid )
      ELSE
       CALL EXCH_RL( phi,
     I            OLw, OLe, OLs, OLn, myNz,
     I            exchWidthX, exchWidthY,
     I            FORWARD_SIMULATION, EXCH_UPDATE_CORNERS, myThid )
      ENDIF

      RETURN
      END
