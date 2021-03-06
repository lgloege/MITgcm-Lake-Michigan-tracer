C $Header: /u/gcmpack/MITgcm/eesupp/src/exch_uv_xy_rx.template,v 1.5 2004/11/16 17:21:40 jmc Exp $
C $Name:  $

#include "PACKAGES_CONFIG.h"
#include "CPP_EEOPTIONS.h"

CBOP
C     !ROUTINE: EXCH_UV_XY_R8

C     !INTERFACE:
      SUBROUTINE EXCH_UV_XY_R8(
     U                       Uphi, Vphi,
     I                       withSigns, myThid )
      IMPLICIT NONE
C     !DESCRIPTION:
C     *==========================================================*
C     | SUBROUTINE EXCH_UV_XY_R8                                  
C     | o Handle exchanges for _R8, two-dimensional arrays.    
C     *==========================================================*
C     | Driver exchange routine which branches to cube sphere or
C     | global, simple cartesian index grid. Exchange routine is
C     | called with two arrays that are components of a vector.
C     | These components are rotated and interchanged on the 
C     | rotated grid during cube exchanges.
C     *==========================================================*

C     !USES:
C     === Global data ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
#include "EXCH.h"

C     !INPUT/OUTPUT PARAMETERS:
C     === Routine arguments ===
C     Uphi      :: Arrays with overlap regions are to be exchanged
C     Vphi         Note - The interface to EXCH_ assumes that
C                  the standard Fortran 77 sequence association rules
C                  apply.
C     myThid    :: My thread id.
C     withSigns :: Flag controlling whether vector is signed.
      _R8 Uphi(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _R8 Vphi(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      LOGICAL withSigns
      INTEGER myThid

C     !LOCAL VARIABLES:
C     == Local variables ==
C     OL[wens]       :: Overlap extents in west, east, north, south.
C     exchWidth[XY]  :: Extent of regions that will be exchanged.
      INTEGER OLw, OLe, OLn, OLs, exchWidthX, exchWidthY, myNz
CEOP

#ifdef ALLOW_EXCH2
      CALL EXCH2_UV_XY_R8(
     U                       Uphi, Vphi,
     I                       withSigns, myThid )
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
       CALL EXCH_UV_R8_CUBE( Uphi, Vphi, withSigns,
     I            OLw, OLe, OLs, OLn, myNz,
     I            exchWidthX, exchWidthY,
     I            FORWARD_SIMULATION, EXCH_UPDATE_CORNERS, myThid )
      ELSE
c      CALL EXCH_R8( Uphi,
c    I            OLw, OLe, OLs, OLn, myNz,
c    I            exchWidthX, exchWidthY,
c    I            FORWARD_SIMULATION, EXCH_UPDATE_CORNERS, myThid )
c      CALL EXCH_R8( Vphi,
c    I            OLw, OLe, OLs, OLn, myNz,
c    I            exchWidthX, exchWidthY,
c    I            FORWARD_SIMULATION, EXCH_UPDATE_CORNERS, myThid )
c_jmc: for JAM compatibility, replace the 2 CALLs above by the 2 CPP_MACROs:
       _EXCH_XY_R8( Uphi, myThid )
       _EXCH_XY_R8( Vphi, myThid )
      ENDIF

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
