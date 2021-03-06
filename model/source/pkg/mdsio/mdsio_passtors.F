C $Header: /u/gcmpack/MITgcm/pkg/mdsio/mdsio_passtors.F,v 1.1 2005/11/03 16:06:57 jmc Exp $
C $Name:  $

#include "MDSIO_OPTIONS.h"

C     ==================================================================

      SUBROUTINE MDS_PASStoRS(local,arr,k,nNz,copyTo,myThid)

C Arguments:
C
C local		RL	local 2-D array (Input/Output if copyTo=T/F)
C arr		RS	model 3-D tiled array (Output/Input if copyTo=T/F)
C k		integer level index to fill in / to extract from 3-D array
C nNz		integer	size of third dimension of 3-D array "arr"
C copyTo	logical	if =T, copy 2-D -> 3-D ; if =F: copy 2-D <- 3-D
C myThid	integer thread identifier
C
C MDS_PASStoRS transfert 2-D RL array to 3-D RS array,
C              or the reverse, depending on "copyTo" value.

      IMPLICIT NONE

C Global variables / common blocks
#include "EEPARAMS.h"
#include "SIZE.h"

C Routine arguments
      INTEGER nNz
      _RL local(1-oLx:sNx+oLx,1-oLy:sNy+oLy,nSx,nSy)
      _RS arr  (1-oLx:sNx+oLx,1-oLy:sNy+oLy,nNz,nSx,nSy)
      INTEGER k
      LOGICAL copyTo
      INTEGER myThid

C Local variables
      INTEGER i,j,bi,bj

      IF ( copyTo ) THEN
        DO bj = myByLo(myThid), myByHi(myThid)
          DO bi = myBxLo(myThid), myBxHi(myThid)
            DO j=1-Oly,sNy+Oly
              DO i=1-Olx,sNx+Olx
                arr(i,j,k,bi,bj) = local(i,j,bi,bj)
              ENDDO
            ENDDO
          ENDDO
        ENDDO
      ELSE
        DO bj = myByLo(myThid), myByHi(myThid)
          DO bi = myBxLo(myThid), myBxHi(myThid)
            DO j=1-Oly,sNy+Oly
              DO i=1-Olx,sNx+Olx
                local(i,j,bi,bj) = arr(i,j,k,bi,bj)
              ENDDO
            ENDDO
          ENDDO
        ENDDO
      ENDIF

      RETURN
      END
