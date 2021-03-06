C $Header: /u/gcmpack/MITgcm/pkg/rw/write_fld_xyz_rl.F,v 1.2 2005/08/22 23:00:58 jmc Exp $
C $Name:  $

#include "RW_OPTIONS.h"

      SUBROUTINE WRITE_FLD_XYZ_RL( pref,suff,field,myIter,myThid)
C WRITE_FLD_XYZ_RL is a "front-end" interface to the low-level I/O
C routines. It assumes single record files.
      IMPLICIT NONE
C Global
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
C Arguments
      CHARACTER*(*) pref,suff
      _RL field(1-Olx:sNx+Olx,1-Oly:sNy+Oly,Nr,nSx,nSy)
      INTEGER myIter
      INTEGER myThid
C Functions
      INTEGER ILNBLNK,IFNBLNK
C Common
      COMMON /RD_WR_FLD/ globalFile
      LOGICAL globalFile
C Local
      CHARACTER*(2) fType
      INTEGER nNz
      INTEGER irec
      INTEGER s1Lo,s1Hi,s2Lo,s2Hi
      CHARACTER*(80) fullName
C
C--   Build file name
C     Name has form 'prefix.suffix'
C     e.g. U.0000000100
      s1Lo = IFNBLNK(pref)
      s1Hi = ILNBLNK(pref)
      IF ( suff .EQ. ' ' ) THEN
       WRITE( fullName, '(A)' ) pref(s1Lo:s1Hi)
      ELSE
       s2Lo = IFNBLNK(suff)
       s2Hi = ILNBLNK(suff)
       WRITE( fullName, '(A,A)' ) pref(s1Lo:s1Hi),suff(s2Lo:s2Hi)
      ENDIF
C
      fType='RL'
      nNz=Nr
      irec=1
#ifdef ALLOW_MDSIO
      CALL MDSWRITEFIELD( fullName, writeBinaryPrec, globalFile,
     &     fType, nNz, field, irec, myIter, myThid )
#endif
      RETURN
      END
