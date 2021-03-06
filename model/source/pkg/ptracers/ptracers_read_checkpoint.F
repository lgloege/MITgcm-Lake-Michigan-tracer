C $Header: /u/gcmpack/MITgcm/pkg/ptracers/ptracers_read_checkpoint.F,v 1.10 2005/09/10 18:30:07 edhill Exp $
C $Name:  $

#include "PTRACERS_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP
C     !ROUTINE: PTRACERS_READ_CHECKPOINT

C     !INTERFACE:
      SUBROUTINE PTRACERS_READ_CHECKPOINT( myIter, myThid )

C     !DESCRIPTION:
C     Reads current state of passive tracers from a pickup file

C     !USES:
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS.h"

C     !INPUT PARAMETERS:
C     myIter            :: time-step number
C     myThid            :: thread number
      INTEGER myIter
      INTEGER myThid

#ifdef ALLOW_PTRACERS

C     !LOCAL VARIABLES:
C     iTracer		:: loop indices
C     iRec    		:: record number
C     fn   		:: character buffer for creating filename
C     prec 		:: precision of pickup files
C     fn                :: suffix for pickup file (eg. 0000000010)
      INTEGER iTracer,prec,iRec
      CHARACTER*(MAX_LEN_MBUF) fn
CEOP

#ifdef ALLOW_MNC
      IF ( PTRACERS_pickup_read_mnc ) THEN
C       Read variables from the pickup file
        WRITE(fn,'(a)') 'pickup_ptracers'
        CALL MNC_FILE_CLOSE_ALL_MATCHING(fn, myThid)
        CALL MNC_CW_SET_UDIM(fn, 1, myThid)
        CALL MNC_CW_SET_CITER(fn, 3, 3, myIter, -1, myThid)
        DO iTracer = 1,PTRACERS_numInUse
          CALL MNC_CW_RL_R('D',fn,0,0, PTRACERS_names(iTracer),
     &         gPtrNm1(1-OLx,1-OLy,1,1,1,iTracer),myThid)
        ENDDO
        CALL MNC_CW_SET_UDIM(fn, 2, myThid)
        DO iTracer = 1,PTRACERS_numInUse
          CALL MNC_CW_RL_R('D',fn,0,0, PTRACERS_names(iTracer),
     &         pTracer(1-OLx,1-OLy,1,1,1,iTracer),myThid)
        ENDDO
      ENDIF
#endif /*  ALLOW_MNC  */
         
      IF ( PTRACERS_pickup_read_mdsio ) THEN

      WRITE(fn,'(A,I10.10)') 'pickup_ptracers.',myIter
      prec = precFloat64
      
      IF ( usePickupBeforeC54 ) THEN
C       Read fields as consecutive records
        DO iTracer=1,PTRACERS_num
          iRec = iTracer
          CALL MDSREADFIELD(fn,prec,'RL',Nr,
     &         pTracer(1-Olx,1-Oly,1,1,1,iTracer),iRec,myThid)
      _EXCH_XYZ_R8(pTracer(1-Olx,1-Oly,1,1,1,iTracer),myThid)
        ENDDO

C       Read historical tendancies as consecutive records
        DO iTracer=1,PTRACERS_num
          iRec = iTracer + PTRACERS_num
          CALL MDSREADFIELD(fn,prec,'RL',Nr,
     &         gPtr(1-Olx,1-Oly,1,1,1,iTracer),iRec,myThid)
      _EXCH_XYZ_R8(gPtr(1-Olx,1-Oly,1,1,1,iTracer),myThid)
        ENDDO
        DO iTracer=1,PTRACERS_num
          iRec = iTracer + PTRACERS_num*2
          CALL MDSREADFIELD(fn,prec,'RL',Nr,
     &         gPtrNm1(1-Olx,1-Oly,1,1,1,iTracer),iRec,myThid)
      _EXCH_XYZ_R8(gPtrNm1(1-Olx,1-Oly,1,1,1,iTracer),myThid)
        ENDDO

      ELSE
C       Read fields & tendancies (needed for AB) as consecutive records,
C       one tracer after the other, only for tracers "InUse".  Note:
C       this allow to restart from a pickup with a different number of
C       tracers, with write_pickup dumping all of them (PTRACERS_num).
        DO iTracer=1,PTRACERS_numInUse
          iRec = 2*iTracer -1 
          CALL MDSREADFIELD(fn,prec,'RL',Nr,
     &         pTracer(1-Olx,1-Oly,1,1,1,iTracer),iRec,myThid)
          iRec = 2*iTracer
          CALL MDSREADFIELD(fn,prec,'RL',Nr,
     &         gPtrNm1(1-Olx,1-Oly,1,1,1,iTracer),iRec,myThid)
      _EXCH_XYZ_R8(pTracer(1-Olx,1-Oly,1,1,1,iTracer),myThid)
      _EXCH_XYZ_R8(gPtrNm1(1-Olx,1-Oly,1,1,1,iTracer),myThid)
        ENDDO
        
      ENDIF

      ENDIF

#endif /* ALLOW_PTRACERS */

      RETURN
      END
