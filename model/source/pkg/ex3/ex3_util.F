C $Header: /u/gcmpack/MITgcm/pkg/ex3/ex3_util.F,v 1.2 2005/10/16 06:55:48 edhill Exp $
C $Name:  $

#include "EX3_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
C     !ROUTINE: EX3_GET_BUFFTAG

C     !INTERFACE:
      SUBROUTINE EX3_GET_BUFFTAG(
     I     i_sendtile, i_recvtile, i_neigh, 
     O     bufftag,
     I     myThid )

C     !DESCRIPTION:
C     Vector exchange routine which copies values from two input arrays,
C     performs a rotation/permutation of the values, writes the values
C     to two buffers in the specified order and then, if necessary,
C     calls the appropriate MPI send functions.

C     !USES:
      IMPLICIT NONE
#include "EX3_SIZE.h"

C     !INPUT PARAMETERS:
      INTEGER i_sendtile, i_recvtile, i_neigh
      INTEGER bifftag
      INTEGER myThid
CEOP

C     !LOCAL VARIABLES
      INTEGER bufftag

C     Probably a 32-bit (signed or unsigned?) int so things are fine as
C     when: (EX3_MAX_E_NBS * EX3_MAX_TILES) < 21,000

C     .  2^32 = 4294967296
C     .  2^31 = 2147483648
C     .  2^30 = 1073741824
C
C     .         2100021000
C     .         rrrrrsssss
C     .         0987654321
      bufftag = 
     &     (i_sendtile - 1)*EX3_MAX_E_NBS + i_neigh
     &     + 100000*( (i_recvtile - 1)*EX3_MAX_E_NBS + i_neigh )

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

