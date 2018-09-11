C $Header: /u/gcmpack/MITgcm/pkg/ex3/EX3_SIZE.h,v 1.1 2005/10/14 05:49:42 edhill Exp $
C $Name:  $


C     Tiling topology sizes
C
C     EX3_MAX_TILES  :: Max number of tiles
C     EX3_MAX_E_NBS  :: Max number of "edge" neighbors per tile
C     EX3_MAX_C_NBS  :: Max number of "corner" neighbors per tile
C     EX3_BUFF_FAC   :: multiplicative "safety factor" used to 
C     .                 increase the exchange buffer size

C     WARNING: if (EX3_MAX_E_NBS * EX3_MAX_TILES) > 21,000 then there is
C     a potential problem constructing the unique MPI tag.  Please see
C     the code in EX3_GET_BUFFTAG().

      INTEGER EX3_MAX_TILES
      INTEGER EX3_MAX_E_NBS
      INTEGER EX3_MAX_C_NBS
      INTEGER EX3_BUFF_FAC
      PARAMETER ( EX3_MAX_TILES =    100  )
      PARAMETER ( EX3_MAX_E_NBS =     10  )
      PARAMETER ( EX3_MAX_C_NBS =     10  )
      PARAMETER ( EX3_BUFF_FAC  =      3  )


CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
