C $Header: /u/gcmpack/MITgcm/pkg/thsice/thsice_read_pickup.F,v 1.3 2005/09/17 03:17:06 edhill Exp $
C $Name:  $

#include "THSICE_OPTIONS.h"

CBOP
C     !ROUTINE: THSICE_READ_PICKUP
C     !INTERFACE:
      SUBROUTINE THSICE_READ_PICKUP( prec, myIter, myThid )

C     !DESCRIPTION: \bv
C     *==========================================================*
C     | S/R THSICE_READ_PICKUP
C     | o Read thsice pickup file
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE

C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "THSICE_PARAMS.h"
#include "THSICE_VARS.h"

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine arguments ==
      INTEGER prec
      INTEGER myIter
      INTEGER myThid
CEOP

#ifdef ALLOW_THSICE

C     == Local variables ==
      CHARACTER*(MAX_LEN_FNAM) fn
      
      IF ( .NOT. thSIce_pickup_write_mnc ) THEN

        WRITE(fn,'(A,I10.10)') 'pickup_ic.',myIter
        CALL MDSREADFIELD(fn,prec,'RL',1,iceMask,   1,myThid)
        CALL MDSREADFIELD(fn,prec,'RL',1,iceHeight, 2,myThid)
        CALL MDSREADFIELD(fn,prec,'RL',1,snowHeight,3,myThid)
        CALL MDSREADFIELD(fn,prec,'RL',1,Tsrf,      4,myThid)
        CALL MDSREADFIELD(fn,prec,'RL',1,Tice1,     5,myThid)
        CALL MDSREADFIELD(fn,prec,'RL',1,Tice2,     6,myThid)
        CALL MDSREADFIELD(fn,prec,'RL',1,Qice1,     7,myThid)
        CALL MDSREADFIELD(fn,prec,'RL',1,Qice2,     8,myThid)
        CALL MDSREADFIELD(fn,prec,'RL',1,snowAge,   9,myThid)

        IF ( stepFwd_oceMxL .AND. startIceModel.EQ.0 )  THEN
          CALL MDSREADFIELD(fn,prec,'RL',1,tOceMxL,  10,myThid)
          CALL MDSREADFIELD(fn,prec,'RL',1,sOceMxL,  11,myThid)
        ENDIF

      ENDIF

#ifdef ALLOW_MNC
      IF ( thSIce_pickup_write_mnc ) THEN
        WRITE(fn,'(A)') 'pickup_ic'
        CALL MNC_CW_SET_CITER(fn, 3, 3, myIter, 0, myThid)
        CALL MNC_FILE_CLOSE_ALL_MATCHING(fn, myThid)
        CALL MNC_CW_SET_UDIM(fn, 1, myThid)
        CALL MNC_CW_RL_R('D',fn,0,0,'iceMask',   iceMask,   myThid)
        CALL MNC_CW_RL_R('D',fn,0,0,'iceHeight', iceHeight, myThid)
        CALL MNC_CW_RL_R('D',fn,0,0,'snowHeight',snowHeight,myThid)
        CALL MNC_CW_RL_R('D',fn,0,0,'Tsrf',      Tsrf,      myThid)
        CALL MNC_CW_RL_R('D',fn,0,0,'Tice1',     Tice1,     myThid)
        CALL MNC_CW_RL_R('D',fn,0,0,'Tice2',     Tice1,     myThid)
        CALL MNC_CW_RL_R('D',fn,0,0,'Qice1',     Qice1,     myThid)
        CALL MNC_CW_RL_R('D',fn,0,0,'Qice2',     Qice2,     myThid)
        CALL MNC_CW_RL_R('D',fn,0,0,'snowAge',   snowAge,   myThid)
        IF ( stepFwd_oceMxL ) THEN
          CALL MNC_CW_RL_R('D',fn,0,0,'tOceMxL',tOceMxL,myThid)
          CALL MNC_CW_RL_R('D',fn,0,0,'sOceMxL',sOceMxL,myThid)
        ENDIF
      ENDIF
#endif  /* ALLOW_MNC */

#endif  /* ALLOW_THSICE */
      RETURN
      END
