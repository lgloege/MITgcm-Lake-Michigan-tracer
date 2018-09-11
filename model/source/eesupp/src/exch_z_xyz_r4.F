C $Header: /u/gcmpack/MITgcm/eesupp/src/exch_z_xyz_rx.template,v 1.4 2004/04/03 04:46:34 edhill Exp $
C $Name:  $

#include "CPP_EEOPTIONS.h"

CBOP
C     !ROUTINE: EXCH_Z_XYZ_R4

C     !INTERFACE:
      SUBROUTINE EXCH_Z_XYZ_R4(
     U                       phi,
     I                       myThid )
      IMPLICIT NONE
C     !DESCRIPTION:
C     *==========================================================*
C     | SUBROUTINE EXCH_Z_XYZ_R4                                  
C     | o Handle exchanges for _R4, 3-dim, zeta coord arrays.    
C     *==========================================================*
C     | Branch to appropriate exchange routine for a zeta coord
C     | array on the current grid scheme.
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
C               Note - The interface to EXCH_R4 assumes that
C               the standard Fortran 77 sequence association rules
C               apply.
C     myThid :: My thread id.
      _R4 phi(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      INTEGER myThid

C     !LOCAL VARIABLES:
C     == Local variables ==
C     OL[wens]       :: Overlap extents in west, east, north, south.
C     exchWidth[XY]  :: Extent of regions that will be exchanged.
      INTEGER OLw, OLe, OLn, OLs, exchWidthX, exchWidthY, myNz
CEOP

      OLw        = OLx
      OLe        = OLx
      OLn        = OLy
      OLs        = OLy
      exchWidthX = OLx
      exchWidthY = OLy
      myNz       = Nr
C     ** NOTE ** The exchange routine we use here does not
C                require the preceeding and following barriers.
C                However, the slow, simple exchange interface
C                that is calling it here is meant to ensure
C                that threads are synchronised before exchanges
C                begine.
      IF (useCubedSphereExchange) THEN
       CALL EXCH_Z_R4_CUBE( phi,
     I            OLw, OLe, OLs, OLn, myNz,
     I            exchWidthX, exchWidthY,
     I            FORWARD_SIMULATION, EXCH_UPDATE_CORNERS, myThid )
      ELSE
       CALL EXCH_R4( phi,
     I            OLw, OLe, OLs, OLn, myNz,
     I            exchWidthX, exchWidthY,
     I            FORWARD_SIMULATION, EXCH_UPDATE_CORNERS, myThid )
      ENDIF

      RETURN
      END
