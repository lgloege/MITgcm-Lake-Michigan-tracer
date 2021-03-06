C$Header: /u/gcmpack/MITgcm/pkg/exch2/exch2_get_send_bounds.F,v 1.1 2004/01/09 20:46:09 afe Exp $

      SUBROUTINE EXCH2_GET_SEND_BOUNDS(
     I           fCode, eWdth,
     O           tiStride, tjStride,
     U           tIlo, tIhi, tJlo, tJhi )
C
      IMPLICIT NONE
C
      CHARACTER*2 fCode
      INTEGER     eWdth
      INTEGER     tiStride, tjStride
      INTEGER     tIlo, tIhi, tJlo, tJhi
C
      IF ( tIlo .EQ. tIhi .AND. tIlo .EQ. 0 ) THEN
C      Sending to a west edge
       tIlo=1-eWdth
       tIhi=0
       tistride=1
       IF ( tJlo .LE. tJhi ) THEN
        tJlo=tJlo-eWdth+1
        tJhi=tJhi+eWdth-1
        tjstride=1
       ELSE
        tJlo=tJlo+eWdth-1
        tJhi=tJhi-eWdth+1
        tjstride=-1
       ENDIF
      ENDIF
      IF ( tIlo .EQ. tIhi .AND. tIlo .GT. 1 ) THEN
C      Sending to an east edge
       tIhi=tIhi+eWdth-1
       tistride=1
       IF ( tJlo .LE. tJhi ) THEN
        tJlo=tJlo-eWdth+1
        tJhi=tJhi+eWdth-1
        tjstride=1
       ELSE
        tJlo=tJlo+eWdth-1
        tJhi=tJhi-eWdth+1
        tjstride=-1
       ENDIF
      ENDIF
      IF ( tJlo .EQ. tJhi .AND. tJlo .EQ. 0 ) THEN
C      Sending to a south edge
       tJlo=1-eWdth
       tJhi=0
       tjstride=1
       IF ( tIlo .LE. tIhi ) THEN
        tIlo=tIlo-eWdth+1
        tIhi=tIhi+eWdth-1
        tistride=1
       ELSE
        tIlo=tIlo+eWdth-1
        tIhi=tIhi-eWdth+1
        tistride=-1
       ENDIF
      ENDIF
      IF ( tJlo .EQ. tJhi .AND. tJlo .GT. 1 ) THEN
C      Sending to an north edge
       tJhi=tJhi+eWdth-1
       tjstride=1
       IF ( tIlo .LE. tIhi ) THEN
        tIlo=tIlo-eWdth+1
        tIhi=tIhi+eWdth-1
        tistride=1
       ELSE
        tIlo=tIlo+eWdth-1
        tIhi=tIhi-eWdth+1
        tistride=-1
       ENDIF
      ENDIF

      RETURN
      END
