C $Header: /u/gcmpack/MITgcm/pkg/exch2/exch2_send_rx2.template,v 1.5 2005/07/24 01:21:36 jmc Exp $
C $Name:  $

#include "CPP_EEOPTIONS.h"
#include "W2_OPTIONS.h"

      SUBROUTINE EXCH2_SEND_RL2 (
     I       tIlo, tIhi, tiStride,
     I       tJlo, tJhi, tjStride,
     I       tKlo, tKhi, tkStride,
     I       thisTile, nN,
     I       e2Bufr1_RL, e2BufrRecSize,
     I       e2Bufr2_RL,
     I       array1,
     I       i1Lo, i1Hi, j1Lo, j1Hi, k1Lo, k1Hi,
     I       array2,
     I       i2Lo, i2Hi, j2Lo, j2Hi, k2Lo, k2Hi,
     O       e2_msgHandle1,
     O       e2_msgHandle2,
     I       commSetting, withSigns, myThid )

C     Vector exchange with bufr1 along +i axis in target tile and
C     bufr2 along +j axis in target tile.

      IMPLICIT NONE

#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
#include "W2_EXCH2_TOPOLOGY.h"

C     === Routine arguments ===
      INTEGER tILo, tIHi, tiStride
      INTEGER tJLo, tJHi, tjStride
      INTEGER tKLo, tKHi, tkStride
      INTEGER i1Lo, i1Hi, j1Lo, j1Hi, k1Lo, k1Hi
      INTEGER i2Lo, i2Hi, j2Lo, j2Hi, k2Lo, k2Hi
      INTEGER thisTile, nN
      INTEGER e2BufrRecSize 
      _RL     e2Bufr1_RL( e2BufrRecSize )
      _RL     e2Bufr2_RL( e2BufrRecSize )
      _RL     array1(i1Lo:i1Hi,j1Lo:j1Hi,k1Lo:k1Hi)
      _RL     array2(i2Lo:i2Hi,j2Lo:j2Hi,k2Lo:k2Hi)
      INTEGER e2_msgHandle1(1)
      INTEGER e2_msgHandle2(1)
      INTEGER myThid
      CHARACTER commSetting
      LOGICAL   withSigns

C     == Local variables ==
C     itl, jtl, ktl  :: Loop counters
C                    :: itl etc... target local
C                    :: itc etc... target canonical
C                    :: isl etc... source local
C                    :: isc etc... source canonical
      INTEGER itl, jtl, ktl
      INTEGER itc, jtc
      INTEGER isc, jsc
      INTEGER isl, jsl
c     INTEGER ktc, ksc, ksl
C     tt         :: Target tile
C     itb, jtb   :: Target local to canonical offsets
C
      INTEGER  tt
      INTEGER itb, jtb
      INTEGER isb, jsb
      INTEGER pi(2), pj(2), oi, oj, oi_c, oi_f, oj_c, oj_f
      _RL     sa1, sa2, val1, val2
      INTEGER iBufr1, iBufr2
      INTEGER itlreduce
      INTEGER jtlreduce

C     MPI setup
#ifdef ALLOW_USE_MPI
      INTEGER theTag1, theTag2, theType, theHandle1, theHandle2
      INTEGER sProc, tProc, mpiRc
#endif
      CHARACTER*(MAX_LEN_MBUF) messageBuffer

      IF     ( commSetting .EQ. 'P' ) THEN
C      Need to check that buffer synchronisation token is decremented 
C      before filling buffer. This is needed for parallel processing
C      shared memory modes only.
      ENDIF

      tt=exch2_neighbourId(nN, thisTile )
      itb=exch2_tbasex(tt)
      jtb=exch2_tbasey(tt)
      isb=exch2_tbasex(thisTile)
      jsb=exch2_tbasey(thisTile)
      pi(1)=exch2_pi(1,nN,thisTile)
      pi(2)=exch2_pi(2,nN,thisTile)
      pj(1)=exch2_pj(1,nN,thisTile)
      pj(2)=exch2_pj(2,nN,thisTile)

C     Extract into bufr1 (target i-index array)
C     if pi(1) is  1 then +i in target <=> +i in source so bufr1 should get +array1
C     if pi(1) is -1 then +i in target <=> -i in source so bufr1 should get -array1
C     if pj(1) is  1 then +i in target <=> +j in source so bufr1 should get +array2
C     if pj(1) is -1 then +i in target <=> -j in source so bufr1 should get -array2
      sa1 = pi(1)
      sa2 = pj(1)
      IF ( .NOT. withSigns ) THEN
       sa1 = ABS(sa1)
       sa2 = ABS(sa2)
      ENDIF
      oi_c=exch2_oi(nN,thisTile)
      oi_f=exch2_oi_f(nN,thisTile)
      oi=oi_c
      oj_c=exch2_oj(nN,thisTile)
      oj_f=exch2_oj_f(nN,thisTile)
      oj=oj_c
C     if pi(1) is 1 then +i in source aligns with +i in target
C     if pj(1) is 1 then +i in source aligns with +j in target
      itlreduce=0
      jtlreduce=0
      IF ( pi(1) .EQ. -1 ) THEN
       oi=oi_f
       itlreduce=1
      ENDIF
      IF ( pj(1) .EQ. -1 ) THEN
       oj=oj_f
       itlreduce=1
      ENDIF
      iBufr1=0
#ifdef W2_E2_DEBUG_ON
      WRITE(messageBuffer,'(A,I4,A,I4)') 'EXCH2_SEND_RL2 sourceTile= ', 
     &                                   thisTile,
     &                                   ' targetTile= ',tt
      CALL PRINT_MESSAGE(messageBuffer,
     I      standardMessageUnit,SQUEEZE_BOTH,
     I      myThid)
#endif /* W2_E2_DEBUG_ON */
      DO ktl=tKlo,tKhi,tKStride
       DO jtl=tJLo+jtlreduce, tJHi, tjStride
        DO itl=tILo+itlreduce, tIHi, tiStride
C      DO jtl=1,32,31
C       DO itl=1,32,31
         iBufr1=iBufr1+1
         itc=itl+itb
         jtc=jtl+jtb
         isc=pi(1)*itc+pi(2)*jtc+oi
         jsc=pj(1)*itc+pj(2)*jtc+oj
         isl=isc-isb
         jsl=jsc-jsb
         val1=sa1*array1(isl,jsl,ktl)
     &       +sa2*array2(isl,jsl,ktl)
         e2Bufr1_RL(iBufr1)=val1
#ifdef W2_E2_DEBUG_ON
         WRITE(messageBuffer,'(A,2I4)') 
     &           'EXCH2_SEND_RL2 target  u(itl, jtl) = ', itl, jtl
         CALL PRINT_MESSAGE(messageBuffer,
     I         standardMessageUnit,SQUEEZE_RIGHT,
     I         myThid)
         IF (     pi(1) .EQ. 1 ) THEN
C         i index aligns
          WRITE(messageBuffer,'(A,2I4)') 
     &           '               source +u(isl, jsl) = ', isl, jsl
         ELSEIF ( pi(1) .EQ. -1 ) THEN
C         reversed i index aligns
          WRITE(messageBuffer,'(A,2I4)') 
     &            '               source -u(isl, jsl) = ', isl, jsl
         ELSEIF ( pj(1) .EQ.  1 ) THEN
          WRITE(messageBuffer,'(A,2I4)') 
     &            '               source +v(isl, jsl) = ', isl, jsl
         ELSEIF ( pj(1) .EQ. -1 ) THEN
          WRITE(messageBuffer,'(A,2I4)') 
     &            '               source -v(isl, jsl) = ', isl, jsl
         ENDIF
         CALL PRINT_MESSAGE(messageBuffer,
     I         standardMessageUnit,SQUEEZE_RIGHT,
     I         myThid)
         IF ( isl .LT. i1Lo .OR. isl .GT. i1Hi ) THEN
          WRITE(messageBuffer,'(A,2I4)') 
     &           '               *** isl is out of bounds '
          CALL PRINT_MESSAGE(messageBuffer,
     I     standardMessageUnit,SQUEEZE_RIGHT,
     I     myThid)
         ENDIF
         IF ( jsl .LT. j1Lo .OR. jsl .GT. j1Hi ) THEN
          WRITE(messageBuffer,'(A,2I4)') 
     &           '               *** jsl is out of bounds '
          CALL PRINT_MESSAGE(messageBuffer,
     I     standardMessageUnit,SQUEEZE_RIGHT,
     I     myThid)
         ENDIF
#endif /* W2_E2_DEBUG_ON */
#ifdef   W2_USE_E2_SAFEMODE
         IF ( iBufr1 .GT. e2BufrRecSize ) THEN
C         Ran off end of buffer. This should not happen
          STOP 'EXCH2_SEND_RL2:: E2BUFR LIMIT EXCEEDED'
         ENDIF
         IF ( isl .LT. i1Lo .OR. isl .GT. i1Hi ) THEN
C         Forward mode send getting from points outside of the
C         tiles exclusive domain bounds in X. This should not happen
          WRITE(messageBuffer,'(A,I4,I4)') 
     &     'EXCH2_SEND_RL2 tIlo, tIhi =', tIlo, tIhi
          CALL PRINT_MESSAGE(messageBuffer,
     I     standardMessageUnit,SQUEEZE_BOTH,
     I     myThid)
          WRITE(messageBuffer,'(A,3I4)') 
     &     'EXCH2_SEND_RL2 itl, jtl, isl =', itl, jtl, isl
          CALL PRINT_MESSAGE(messageBuffer,
     I     standardMessageUnit,SQUEEZE_BOTH,
     I     myThid)
          STOP 'EXCH2_SEND_RL2:: ISL OUTSIDE TILE EXCLUSIVE DOMAIN'
         ENDIF
         IF ( jsl .LT. j1Lo .OR. jsl .GT. j1Hi ) THEN
C         Forward mode send getting from points outside of the
C         tiles exclusive domain bounds in Y. This should not happen
          WRITE(messageBuffer,'(A,I4,I4)') 
     &     'EXCH2_SEND_RL2 tJlo, tJhi =', tJlo, tJhi
          CALL PRINT_MESSAGE(messageBuffer,
     I     standardMessageUnit,SQUEEZE_BOTH,
     I     myThid)
          WRITE(messageBuffer,'(A,2I4)') 
     &     'EXCH2_SEND_RL2 itl, jtl =', itl, jtl
          CALL PRINT_MESSAGE(messageBuffer,
     I     standardMessageUnit,SQUEEZE_BOTH,
     I     myThid)
          WRITE(messageBuffer,'(A,2I4)') 
     &     'EXCH2_SEND_RL2 isl, jsl =', isl, jsl     
          CALL PRINT_MESSAGE(messageBuffer,
     I     standardMessageUnit,SQUEEZE_BOTH,
     I     myThid)

          STOP 'EXCH2_SEND_RL2:: JSL OUTSIDE TILE EXCLUSIVE DOMAIN'
         ENDIF
#endif /* W2_USE_E2_SAFEMODE */
        ENDDO
       ENDDO
      ENDDO

C     Extract values into bufr2
C     if pi(2) is  1 then +j in target <=> +i in source so bufr1 should get +array1
C     if pi(2) is -1 then +j in target <=> -i in source so bufr1 should get -array1
C     if pj(2) is  1 then +j in target <=> +j in source so bufr1 should get +array2
C     if pj(2) is -1 then +j in target <=> -j in source so bufr1 should get -array2
      sa1 = pi(2)
      sa2 = pj(2)
      IF ( .NOT. withSigns ) THEN
       sa1 = ABS(sa1)
       sa2 = ABS(sa2)
      ENDIF
      oi_c=exch2_oi(nN,thisTile)
      oi_f=exch2_oi_f(nN,thisTile)
      oi=oi_c
      oj_c=exch2_oj(nN,thisTile)
      oj_f=exch2_oj_f(nN,thisTile)
      oj=oj_c
C     if pi(2) is 1 then +i in source aligns with +j in target
C     if pj(2) is 1 then +j in source aligns with +j in target
      itlreduce=0
      jtlreduce=0
      IF ( pi(2) .EQ. -1 ) THEN
       jtlreduce=1
       oi=oi_f
      ENDIF
      IF ( pj(2) .EQ. -1 ) THEN
       jtlreduce=1
       oj=oj_f
      ENDIF
      iBufr2=0
#ifdef W2_E2_DEBUG_ON
      WRITE(messageBuffer,'(A,I4,A,I4)') 'EXCH2_SEND_RL2 sourceTile= ', 
     &                                   thisTile,
     &                                   ' targetTile= ',tt
      CALL PRINT_MESSAGE(messageBuffer,
     I      standardMessageUnit,SQUEEZE_BOTH,
     I      myThid)
#endif /* W2_E2_DEBUG_ON */
      DO ktl=tKlo,tKhi,tKStride
       DO jtl=tJLo+jtlreduce, tJHi, tjStride
        DO itl=tILo+itlreduce, tIHi, tiStride
C      DO jtl=1,32,31
C       DO itl=1,32,31
         iBufr2=iBufr2+1
         itc=itl+itb
         jtc=jtl+jtb
         isc=pi(1)*itc+pi(2)*jtc+oi
         jsc=pj(1)*itc+pj(2)*jtc+oj
         isl=isc-isb
         jsl=jsc-jsb
         val2=sa1*array1(isl,jsl,ktl)
     &       +sa2*array2(isl,jsl,ktl)
         e2Bufr2_RL(iBufr2)=val2
#ifdef W2_E2_DEBUG_ON
         WRITE(messageBuffer,'(A,2I4)') 
     &            'EXCH2_SEND_RL2 target  v(itl, jtl) = ', itl, jtl
         CALL PRINT_MESSAGE(messageBuffer,
     I         standardMessageUnit,SQUEEZE_RIGHT,
     I         myThid)
         IF (     pi(2) .EQ. 1 ) THEN
C         i index aligns
          WRITE(messageBuffer,'(A,2I4)') 
     &        	'               source +u(isl, jsl) = ', isl, jsl
         ELSEIF ( pi(2) .EQ. -1 ) THEN
C         reversed i index aligns
          WRITE(messageBuffer,'(A,2I4)') 
     &		'               source -u(isl, jsl) = ', isl, jsl
         ELSEIF ( pj(2) .EQ.  1 ) THEN
          WRITE(messageBuffer,'(A,2I4)') 
     &		'               source +v(isl, jsl) = ', isl, jsl
         ELSEIF ( pj(2) .EQ. -1 ) THEN
          WRITE(messageBuffer,'(A,2I4)') 
     &		'               source -v(isl, jsl) = ', isl, jsl
         ENDIF
         CALL PRINT_MESSAGE(messageBuffer,
     I         standardMessageUnit,SQUEEZE_RIGHT,
     I         myThid)
         IF ( isl .LT. i1Lo .OR. isl .GT. i1Hi ) THEN
          WRITE(messageBuffer,'(A,2I4)') 
     &		'               *** isl is out of bounds '
          CALL PRINT_MESSAGE(messageBuffer,
     I     standardMessageUnit,SQUEEZE_RIGHT,
     I     myThid)
         ENDIF
         IF ( jsl .LT. j1Lo .OR. jsl .GT. j1Hi ) THEN
          WRITE(messageBuffer,'(A,2I4)') 
     &		'               *** jsl is out of bounds '
          CALL PRINT_MESSAGE(messageBuffer,
     I     standardMessageUnit,SQUEEZE_RIGHT,
     I     myThid)
         ENDIF

#endif /* W2_E2_DEBUG_ON */
#ifdef   W2_USE_E2_SAFEMODE
         IF ( iBufr2 .GT. e2BufrRecSize ) THEN
C         Ran off end of buffer. This should not happen
          STOP 'EXCH2_SEND_RL2:: E2BUFR LIMIT EXCEEDED'
         ENDIF
         IF ( isl .LT. i1Lo .OR. isl .GT. i1Hi ) THEN
C         Forward mode send getting from points outside of the
C         tiles exclusive domain bounds in X. This should not happen
          WRITE(messageBuffer,'(A,I4,I4)') 
     &     'EXCH2_SEND_RL2 tIlo, tIhi =', tIlo, tIhi
          CALL PRINT_MESSAGE(messageBuffer,
     I     standardMessageUnit,SQUEEZE_BOTH,
     I     myThid)
          WRITE(messageBuffer,'(A,3I4)') 
     &     'EXCH2_SEND_RL2 itl, jtl, isl =', itl, jtl, isl
          CALL PRINT_MESSAGE(messageBuffer,
     I     standardMessageUnit,SQUEEZE_BOTH,
     I     myThid)
          STOP 'EXCH2_SEND_RL2:: ISL OUTSIDE TILE EXCLUSIVE DOMAIN'
         ENDIF
         IF ( jsl .LT. j1Lo .OR. jsl .GT. j1Hi ) THEN
C         Forward mode send getting from points outside of the
C         tiles exclusive domain bounds in Y. This should not happen
          WRITE(messageBuffer,'(A,I4,I4)') 
     &     'EXCH2_SEND_RL2 tJlo, tJhi =', tJlo, tJhi
          CALL PRINT_MESSAGE(messageBuffer,
     I     standardMessageUnit,SQUEEZE_BOTH,
     I     myThid)
          WRITE(messageBuffer,'(A,2I4)') 
     &     'EXCH2_SEND_RL2 itl, jtl =', itl, jtl
          CALL PRINT_MESSAGE(messageBuffer,
     I     standardMessageUnit,SQUEEZE_BOTH,
     I     myThid)
          WRITE(messageBuffer,'(A,2I4)') 
     &     'EXCH2_SEND_RL2 isl, jsl =', isl, jsl     
          CALL PRINT_MESSAGE(messageBuffer,
     I     standardMessageUnit,SQUEEZE_BOTH,
     I     myThid)

          STOP 'EXCH2_SEND_RL2:: JSL OUTSIDE TILE EXCLUSIVE DOMAIN'
         ENDIF
#endif /* W2_USE_E2_SAFEMODE */
        ENDDO
       ENDDO
      ENDDO

C     Do data transport depending on communication mechanism between source and target tile
      IF     ( commSetting .EQ. 'P' ) THEN
C      Need to set data ready assertion (increment buffer 
C      synchronisation token) for multithreaded mode, for now do 
C      nothing i.e. assume only one thread per process.
      ELSEIF ( commSetting .EQ. 'M' ) THEN
#ifdef ALLOW_USE_MPI
C      Setup MPI stuff here
       theTag1 =  (thisTile-1)*MAX_NEIGHBOURS*2 + nN-1
     &           + 10000*(
     &             (tt-1)*MAX_NEIGHBOURS*2 + nN-1
     &            )
       theTag2 =  (thisTile-1)*MAX_NEIGHBOURS*2 + MAX_NEIGHBOURS + nN-1
     &           + 10000*(
     &             (tt-1)*MAX_NEIGHBOURS*2 + MAX_NEIGHBOURS + nN-1
     &            )
       tProc = exch2_tProc(tt)-1
       sProc = exch2_tProc(thisTile)-1
       theType = MPI_REAL8
#ifdef W2_E2_DEBUG_ON
       WRITE(messageBuffer,'(A,I4,A,I4,A)') ' SEND FROM TILE=', thisTile,
     &                                   ' (proc = ',sProc,')'
       CALL PRINT_MESSAGE(messageBuffer,
     I      standardMessageUnit,SQUEEZE_RIGHT,
     I      myThid)
       WRITE(messageBuffer,'(A,I4,A,I4,A)') '        TO TILE=', tt,
     &                                   ' (proc = ',tProc,')'
       CALL PRINT_MESSAGE(messageBuffer,
     I      standardMessageUnit,SQUEEZE_RIGHT,
     I      myThid)
       WRITE(messageBuffer,'(A,I10)') '            TAG1=', theTag1
       CALL PRINT_MESSAGE(messageBuffer,
     I      standardMessageUnit,SQUEEZE_RIGHT,
     I      myThid)
       WRITE(messageBuffer,'(A,I4)') '            NEL1=', iBufr1
       CALL PRINT_MESSAGE(messageBuffer,
     I      standardMessageUnit,SQUEEZE_RIGHT,
     I      myThid)
       WRITE(messageBuffer,'(A,I10)') '            TAG2=', theTag2
       CALL PRINT_MESSAGE(messageBuffer,
     I      standardMessageUnit,SQUEEZE_RIGHT,
     I      myThid)
       WRITE(messageBuffer,'(A,I4)') '            NEL2=', iBufr2
       CALL PRINT_MESSAGE(messageBuffer,
     I      standardMessageUnit,SQUEEZE_RIGHT,
     I      myThid)
#endif /* W2_E2_DEBUG_ON */
       CALL MPI_Isend( e2Bufr1_RL, iBufr1, theType,
     I                 tProc, theTag1, MPI_COMM_MODEL, 
     O                 theHandle1, mpiRc )
       CALL MPI_Isend( e2Bufr2_RL, iBufr2, theType,
     I                 tProc, theTag2, MPI_COMM_MODEL, 
     O                 theHandle2, mpiRc )
C      Store MPI_Wait token in messageHandle.
       e2_msgHandle1(1) = theHandle1
       e2_msgHandle2(1) = theHandle2
#endif
      ELSE
       STOP 'EXCH2_SEND_RL2:: commSetting VALUE IS INVALID'
      ENDIF
 
      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
