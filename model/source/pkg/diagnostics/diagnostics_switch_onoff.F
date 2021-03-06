C $Header: /u/gcmpack/MITgcm/pkg/diagnostics/diagnostics_switch_onoff.F,v 1.13 2005/10/16 18:38:55 molod Exp $
C $Name:  $

#include "DIAG_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
C     !ROUTINE: DIAGNOSTICS_SWITCH_ONOFF

C     !INTERFACE:
      SUBROUTINE DIAGNOSTICS_SWITCH_ONOFF( myTime, myIter, myThid )

C     !DESCRIPTION:
C-----
C     Called at the beginning of the time-step,
C     to switch on/off diagnostics for snap-shot output
C-----
C      during iterations that are multiple of |freq|,
C      switch ON diagnostics (ndiag>=0) that will become active
C      and then can be written at the end of the time-step ;
C      otherwise, put diagnostics in non-active mode (ndiag=-1)
C-----

C     !USES:
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "DIAGNOSTICS_SIZE.h"
#include "DIAGNOSTICS.h"

C     !INPUT PARAMETERS:
C     myTime     :: current Time of simulation ( s )
C     myIter     :: current Iteration number
C     myThid     :: my Thread Id number
      _RL     myTime
      INTEGER myIter
      INTEGER myThid
CEOP

C     !LOCAL VARIABLES:
C      newIter :: future iteration number
C      j,m,n   :: loop index
c     CHARACTER*(MAX_LEN_MBUF) msgBuf
c     INTEGER newIter
      INTEGER m, n, nd
      INTEGER bi, bj, ip, iSp
      LOGICAL time4SnapShot
      _RL     phiSec, freqSec
      LOGICAL dBugFlag
#ifdef ALLOW_FIZHI
      logical alarm2,alarm2next
      character *9 tagname
#endif

      LOGICAL  DIFF_PHASE_MULTIPLE
      EXTERNAL DIFF_PHASE_MULTIPLE

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

c     newIter = 1 + myIter
      DO n = 1,nlists

       IF ( freq(n).LT.0. ) THEN
C--    Select diagnostics list that uses instantaneous output

        freqSec = freq(n)
        phiSec = phase(n)
        time4SnapShot = DIFF_PHASE_MULTIPLE( phiSec, freqSec,
     &                                       myTime, deltaTclock )
#ifdef ALLOW_FIZHI
        if( useFIZHI) then
         write(tagname,'(A,I2.2)')'diagtag',n
         time4SnapShot = alarm2next(tagname,deltaT)
        endif
#endif

        DO bj=myByLo(myThid), myByHi(myThid)
         DO bi=myBxLo(myThid), myBxHi(myThid)
          IF ( time4SnapShot ) THEN
C--       switch ON diagnostics of output-stream # n
            DO m=1,nActive(n)
c             nd = jdiag(m,n)
c             IF (ndiag(nd).NE.0) WRITE(0,*) myIter,nd,ndiag(nd),' ->',0
              ip = idiag(m,n)
              IF (ip.GT.0) ndiag(ip,bi,bj) = 0
            ENDDO
          ELSE
C--       switch OFF diagnostics of output-stream # n
            DO m=1,nActive(n)
c             nd = jdiag(m,n)
c             IF (ndiag(nd).NE.-1) WRITE(0,*) myIter,nd,ndiag(nd),' ->',-1
              ip = idiag(m,n)
              IF (ip.GT.0) ndiag(ip,bi,bj) = -1
            ENDDO
          ENDIF
         ENDDO
        ENDDO

       ENDIF
      ENDDO

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

      DO n = 1,diagSt_nbLists

       IF ( diagSt_freq(n).LT.0. ) THEN
C--    Select diagnostics list that uses instantaneous output

        dBugFlag = debugLevel.GT.debLevB

        freqSec = diagSt_freq(n)
        phiSec = diagSt_phase(n)
        time4SnapShot = DIFF_PHASE_MULTIPLE( phiSec, freqSec,
     &                                       myTime, deltaTclock )

#ifdef ALLOW_FIZHI
        if( useFIZHI) then
         write(tagname,'(A,I2.2)')'diagStg',n
         time4SnapShot = alarm2next(tagname,deltaT)
        endif
#endif

        DO bj=myByLo(myThid), myByHi(myThid)
         DO bi=myBxLo(myThid), myBxHi(myThid)
          dBugFlag = dBugFlag.AND.(bi.EQ.1.AND.bj.EQ.1.AND.myThid.EQ.1)
          IF ( time4SnapShot ) THEN
C--     switch ON diagnostics of output-stream # n
            DO m=1,diagSt_nbActv(n)
             iSp = iSdiag(m,n)
             IF (iSp.GT.0) THEN
               nd = jSdiag(m,n)
               IF (dBugFlag.AND.qSdiag(0,0,iSp,bi,bj).NE. 0.)
     &          WRITE(0,'(I8,I4,3A,1PE10.3,A,I3)') myIter,
     &           nd,' ',cdiag(nd),' :',qSdiag(0,0,iSp,bi,bj),' ->', 0
               qSdiag(0,0,iSp,bi,bj) = 0.
             ENDIF
            ENDDO
          ELSE
C--     switch OFF diagnostics of output-stream # n
            DO m=1,diagSt_nbActv(n)
             iSp = iSdiag(m,n)
             IF (iSp.GT.0) THEN
               nd = jSdiag(m,n)
               IF (dBugFlag.AND.qSdiag(0,0,iSp,bi,bj).NE.-1.)
     &          WRITE(0,'(I8,I4,3A,1PE10.3,A,I3)') myIter,
     &           nd,' ',cdiag(nd),' :',qSdiag(0,0,iSp,bi,bj),' ->',-1
               qSdiag(0,0,iSp,bi,bj) = -1.
             ENDIF
            ENDDO
          ENDIF
         ENDDO
        ENDDO

       ENDIF
      ENDDO

      RETURN
      END
