C $Header: /u/gcmpack/MITgcm/pkg/ex3/ex3_set_glbe_inds.F,v 1.1 2006/02/06 21:09:54 edhill Exp $
C $Name:  $

#include "EX3_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP             
C     !ROUTINE: EX3_SET_GLBE_INDS

C     !INTERFACE:
      SUBROUTINE EX3_SET_GLBE_INDS

C     !DESCRIPTION:
C     Determine the global/local buffer indicies for send/recv
C     operations at each edge

C     !USES:
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
#include "EX3_SIZE.h"
#include "EX3_PARAMS.h"
#include "EX3_TOPOLOGY.h"
CEOP

C     !LOCAL VARIABLES:
      INTEGER ke, kt, ii, itile

C     The idea here is that RECV operations should *ALWAYS* happen
C     within the first buffer of the receiving tile and send operations
C     will happen in either:
C     
C     .  MPI    ::   the second index of the sending tile
C     .  LOCAL  ::   the first index of the receiving tile
C
C     So, whenever possible, local operations will bypass MPI.

C     First set all tiles to non-local status
      DO kt = 1,EX3_MAX_TILES
        DO ke = 1,EX3_MAX_E_NBS
          ex3_e_iopt_il(ke,kt) = -1
        ENDDO
      ENDDO

C     EX3_B_RL ( EX3_MAX_BL, 2*EX3_MAX_E_NBS, nSx*nSy )

C     Then, for only the local tiles, set the flag to the local buffer
C     index to use for for send operations
      DO ii = 1,ex3_p_ntile
        itile = ex3_p_itile(ii)
        DO ke = 1,EX3_MAX_E_NBS
          ex3_e_iopt_il(ke,itile) = 
     &         (ii-1)*2*EX3_MAX_E_NBS + 2*(ke-1) + 1
        ENDDO
      ENDDO

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
