C $Header: /u/gcmpack/MITgcm/pkg/diagnostics/diagnostics_utils.F,v 1.22 2005/07/11 16:20:10 molod Exp $
C $Name:  $

#include "DIAG_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
C     !ROUTINE: GETDIAG

C     !INTERFACE:
      SUBROUTINE GETDIAG(
     I                    levreal, undef,
     O                    qtmp,
     I                    ndId, mate, ip, im, bi, bj, myThid )

C     !DESCRIPTION:
C     Retrieve averaged model diagnostic

C     !USES:
      IMPLICIT NONE
#include "EEPARAMS.h"
#include "SIZE.h"
#include "DIAGNOSTICS_SIZE.h"
#include "DIAGNOSTICS.h"

C     !INPUT PARAMETERS:
C     levreal :: Diagnostic LEVEL
C     undef   :: UNDEFINED VALUE
C     ndId    :: DIAGNOSTIC NUMBER FROM MENU
C     mate    :: counter DIAGNOSTIC NUMBER if any ; 0 otherwise
C     ip      :: pointer to storage array location for diag.
C     im      :: pointer to storage array location for mate
C     bi      :: X-direction tile number
C     bj      :: Y-direction tile number
C     myThid  :: my thread Id number
      _RL levreal
      _RL undef
      INTEGER ndId, mate, ip, im
      INTEGER bi,bj, myThid

C     !OUTPUT PARAMETERS:
C     qtmp    ..... AVERAGED DIAGNOSTIC QUANTITY
      _RL qtmp(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
CEOP

C     !LOCAL VARIABLES:
      _RL factor
      INTEGER i, j, ipnt,ipCt
      INTEGER lev, levCt, klev

      IF (ndId.GE.1) THEN
       lev = NINT(levreal)
       klev = kdiag(ndId)
       IF (lev.LE.klev) THEN

        IF ( mate.EQ.0 ) THEN
C-      No counter diagnostics => average = Sum / ndiag :

          ipnt = ip + lev - 1
          factor = FLOAT(ndiag(ip,bi,bj))
          IF (ndiag(ip,bi,bj).NE.0) factor = 1. _d 0 / factor

          DO j = 1,sNy+1
            DO i = 1,sNx+1
              IF ( qdiag(i,j,ipnt,bi,bj) .LE. undef ) THEN
                qtmp(i,j) = qdiag(i,j,ipnt,bi,bj)*factor
              ELSE
                qtmp(i,j) = undef
              ENDIF
            ENDDO
          ENDDO

        ELSE
C-      With counter diagnostics => average = Sum / counter:

          ipnt = ip + lev - 1
          levCt= MIN(lev,kdiag(mate))
          ipCt = im + levCt - 1
          DO j = 1,sNy+1
            DO i = 1,sNx+1
              IF ( qdiag(i,j,ipCt,bi,bj) .NE. 0. ) THEN
                qtmp(i,j) = qdiag(i,j,ipnt,bi,bj)
     &                    / qdiag(i,j,ipCt,bi,bj)
              ELSE
                qtmp(i,j) = undef
              ENDIF
            ENDDO
          ENDDO

        ENDIF
       ENDIF
      ENDIF

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CBOP 0
C     !ROUTINE: DIAGNOSTICS_COUNT
C     !INTERFACE:
      SUBROUTINE DIAGNOSTICS_COUNT (chardiag,
     I                              biArg, bjArg, myThid)

C     !DESCRIPTION:
C***********************************************************************
C   routine to increment the diagnostic counter only
C***********************************************************************
C     !USES:
      IMPLICIT NONE

C     == Global variables ===
#include "EEPARAMS.h"
#include "SIZE.h"
#include "DIAGNOSTICS_SIZE.h"
#include "DIAGNOSTICS.h"

C     !INPUT PARAMETERS:
C***********************************************************************
C  Arguments Description
C  ----------------------
C     chardiag :: Character expression for diag to increment the counter
C     biArg    :: X-direction tile number, or 0 if called outside bi,bj loops
C     bjArg    :: Y-direction tile number, or 0 if called outside bi,bj loops
C     myThid   :: my thread Id number
C***********************************************************************
      CHARACTER*8 chardiag
      INTEGER biArg, bjArg
      INTEGER myThid
CEOP

C     !LOCAL VARIABLES:
C ===============
      INTEGER m, n
      INTEGER bi, bj
      INTEGER ipt
c     CHARACTER*(MAX_LEN_MBUF) msgBuf

C--   Run through list of active diagnostics to find which counter
C     to increment (needs to be a valid & active diagnostic-counter)
      DO n=1,nlists
       DO m=1,nActive(n)
        IF ( chardiag.EQ.flds(m,n) .AND. idiag(m,n).GT.0 ) THEN
         ipt = idiag(m,n)
         IF (ndiag(ipt,1,1).GE.0) THEN
C-    Increment the counter for the diagnostic
          IF ( biArg.EQ.0 .AND. bjArg.EQ.0 ) THEN
           DO bj=myByLo(myThid), myByHi(myThid)
            DO bi=myBxLo(myThid), myBxHi(myThid)
             ndiag(ipt,bi,bj) = ndiag(ipt,bi,bj) + 1
            ENDDO
           ENDDO
          ELSE
             bi = MIN(biArg,nSx)
             bj = MIN(bjArg,nSy)
             ndiag(ipt,bi,bj) = ndiag(ipt,bi,bj) + 1
          ENDIF
C-    Increment is done
         ENDIF
        ENDIF
       ENDDO
      ENDDO

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CBOP 0
C     !ROUTINE: DIAGS_MK_UNITS

C     !INTERFACE:
      CHARACTER*16 FUNCTION DIAGS_MK_UNITS(
     I                            diagUnitsInPieces, myThid )

C     !DESCRIPTION:
C     *==========================================================*
C     | FUNCTION DIAGS_MK_UNITS
C     | o Return the diagnostic units string (16c) removing
C     |   blanks from the input string
C     *==========================================================*

C     !USES:
      IMPLICIT NONE
#include "EEPARAMS.h"

C     !INPUT PARAMETERS:
C     diagUnitsInPieces :: string for diagnostic units: in several
C                          pieces, with blanks in between
C     myThid            ::  my thread Id number
      CHARACTER*(*) diagUnitsInPieces
      INTEGER      myThid
CEOP

C     !LOCAL VARIABLES:
      CHARACTER*(MAX_LEN_MBUF) msgBuf
      INTEGER i,j,n

      DIAGS_MK_UNITS = '          '
      n = LEN(diagUnitsInPieces)

      j = 0
      DO i=1,n
       IF (diagUnitsInPieces(i:i) .NE. ' ' ) THEN
         j = j+1
         IF ( j.LE.16 ) DIAGS_MK_UNITS(j:j) = diagUnitsInPieces(i:i)
       ENDIF
      ENDDO

      IF ( j.GT.16 ) THEN
         WRITE(msgBuf,'(2A,I4,A)') '**WARNING** ',
     &   'DIAGS_MK_UNITS: too long (',j,' >16) input string'
        CALL PRINT_MESSAGE( msgBuf, errorMessageUnit,
     &       SQUEEZE_RIGHT , myThid)
         WRITE(msgBuf,'(3A)') '**WARNING** ',
     &   'DIAGS_MK_UNITS: input=', diagUnitsInPieces
        CALL PRINT_MESSAGE( msgBuf, errorMessageUnit,
     &       SQUEEZE_RIGHT , myThid)
      ENDIF

      RETURN
      END
C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
C     !ROUTINE: diagnostics_get_pointers
C     !INTERFACE:
      subroutine diagnostics_get_pointers(diagName,ipoint,jpoint,myThid)

C     !DESCRIPTION:
C     *==========================================================*
C     | subroutine diagnostics_get_pointers
C     | o Returns the idiag and jdiag pointers for a
C     |   specified diagnostic - returns 0 if not active
C     *==========================================================*

C     !USES:
      IMPLICIT NONE
#include "EEPARAMS.h"
#include "SIZE.h"
#include "DIAGNOSTICS_SIZE.h"
#include "DIAGNOSTICS.h"

C     !INPUT PARAMETERS:
C     diagName   ::  diagnostic identificator name (8 characters long)
C     myThid     ::  my thread Id number
C     !OUTPUT PARAMETERS:
C     ipoint     ::  pointer value into qdiag array
C     jpoint     ::  pointer value into diagnostics list

      CHARACTER*8 diagName
      INTEGER ipoint, jpoint, myThid
CEOP

C     !LOCAL VARIABLES:
      INTEGER n,m

      ipoint = 0
      jpoint = 0

C-    search for this diag. in the active 2D/3D diagnostics list
      DO n=1,nlists
       DO m=1,nActive(n)
        IF ( diagName.EQ.flds(m,n) .AND. idiag(m,n).NE.0 ) THEN
          ipoint = abs(idiag(m,n))
          jpoint = jdiag(m,n)
        ENDIF
       ENDDO
      ENDDO

      RETURN
      END
