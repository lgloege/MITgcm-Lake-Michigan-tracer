c$$$#include "GLS_CLOSURE_OPTIONS.h"
c$$$      subroutine gls_closure_prxy(label,time,a,im,iskp,jm,jskp,scala)
c$$$      subroutine debug_prxy(label,time,a,im,iskp,jm,jskp,scala)
      subroutine debug_prxy(label,time,a,ims,ime,iskp,jms,jme,jskp,
     1     scala)
C **********************************************************************
C *                                                                    *
C * FUNCTION    :  Writes a horizontal 2-D field.                      *
C *                                                                    *
C *                label ....... label for output                      *
C *                time ........ time (days)                           *
C *                a(im,jm,kb).. array to be printed                   *
C *                iskp ........ skipping interval for i               *
C *                jskp ........ skipping interval for j               *
C *                scala ....... < 0 for floating point numbers output *
C *                              0 for integer output, divisor for a   *
C *                                based on magnitudes of |a| values   *
C *                              > 0 for integer output, divisor for a *
C *                                given by scala                      *
C *                                                                    *
C **********************************************************************
C
      implicit none
C
c$$$      integer im,jm
c$$$      real a(im,jm)
c$$$      real time,scala
c$$$      real amx,scale
      integer ims,ime,jms,jme
      real*8 a(ims:ime,jms:jme)
      real*8 time,scala
      real*8 amx,scale
      integer i,ib,ie,j,jwr,cols
      integer iskp,jskp
      character label*(*)
C
c$$$      write(6,*) 'in prxy ims,ime,jms,jme=',ims,ime,jms,jme
c$$$#ifdef ALLOW_GLS_CLOSURE
      if(scala.ge.0.e0) then
        cols=24
      else
        cols=12
      endif
C
      if (scala.lt.0.e0) scale = 1.e0
      if (scala.eq.0.e0) then
        amx=1.e-12
c$$$        do j=1,jm,jskp
        do j=jms,jme,jskp
c$$$          do i=1,im,iskp
          do i=ims,ime,iskp
            amx=max(abs(a(i,j)),amx)
          end do
        end do
          scale=10.e0**(int(log10(amx)+100.e0)-103)
        endif
      if(scala.gt.0.e0) scale=scala
C
      write(6,1) label
    1 format(1x,a40/)
      write(6,2) time,scale
    2 format(' Time = ',f9.4,' days    multiply all values by ',1pe8.2)
C
c$$$      do ib=1,im,cols*iskp
      do ib=ims,ime,cols*iskp
C
        ie=ib+(cols-1)*iskp
c$$$        if(ie.gt.im) ie=im
        if(ie.gt.ime) ie=ime
C
        if(scala.ge.0.e0) then
          write(6,3) (i,i=ib,ie,iskp)
    3     format(/,2x,24i5,/)
        else
          write(6,4) (i,i=ib,ie,iskp)
    4     format(/,12i10,/)
        endif
C
c$$$        do j=1,jm,jskp
        do j=jms,jme,jskp
c$$$          jwr=jm+1-j
          jwr=jme+jms-j
          if(scala.ge.0.e0) then
            write(6,5) jwr,(nint(a(i,jwr)/scale),i=ib,ie,iskp)
    5       format(1x,i3,24i5)
          else
            write(6,6) jwr,(a(i,jwr),i=ib,ie,iskp)
    6       format(1x,i2,12(e10.2))
          endif
        end do
C
        write(6,7)
    7   format(//)
C
      end do
C
c$$$#endif /* ALLOW_GLS_CLOSURE */
      return
      end
C
c$$$      SUBROUTINE PRXY (LABEL,TIME,A,IM,ISKP,JM,JSKP,SCALA)
c$$$C >>>
c$$$C     THIS WRITES A 2-D FIELD
c$$$C     TIME=TIME IN DAYS
c$$$C     A = ARRAY(IM,JM) TO BE PRINTED
c$$$C     ISKP=PRINT SKIP FOR I
c$$$C     JSKP=PRINT SKIP FOR J
c$$$C     SCALE=DIVISOR FOR VALUES OF A
c$$$C
c$$$C   IMPLICIT HALF PRECISION (A-H,O-Z)
c$$$      DIMENSION A(IM,JM),NUM(350),LINE(350)
c$$$c$$$      DIMENSION A(IM,JM),NUM(150),LINE(150)
c$$$      CHARACTER LABEL*(*)
c$$$      DATA ZERO /1.E-12/
c$$$C
c$$$      SCALE=SCALA
c$$$      IF (SCALE.GT.ZERO) GO TO 160
c$$$      AMX=ZERO
c$$$      DO 150 J=1,JM,JSKP
c$$$      DO 150 I=1,IM,ISKP
c$$$      AMX=MAX(ABS(A(I,J)),AMX)
c$$$  150 CONTINUE
c$$$      IF(AMX.EQ.0.) THEN   
c$$$       SCALEI=0.   
c$$$       GOTO 165  
c$$$      ENDIF    
c$$$      SCALE=10.E0**(INT(LOG10(AMX)+1.E2)-103)
c$$$  160 CONTINUE
c$$$      SCALEI=1.E0/SCALE
c$$$  165 CONTINUE
c$$$      WRITE(6,170) LABEL
c$$$  170 FORMAT(1X,A40)
c$$$      WRITE(6,180) TIME,SCALE
c$$$  180 FORMAT(' TIME =',F9.4,' DAYS     MULTIPLY ALL VALUES BY',1PE9.2)
c$$$      DO 190 I=1,IM
c$$$  190 NUM(I)=I
c$$$      IB=1
c$$$C
c$$$  200 CONTINUE
c$$$      IE=IB+25*ISKP
c$$$c$$$      IE=IB+23*ISKP
c$$$      IF(IE.GT.IM) IE=IM
c$$$      WRITE(6,210) (NUM(I),I=IB,IE,ISKP)
c$$$C< Satrt-*---------*---------*---------*---------*---- N.Kimura 05/01/03
c$$$  210 FORMAT(/,2X,26I6/)
c$$$c$$$  210 FORMAT(/,2X,24I6/)
c$$$c$$$c$$$  210 FORMAT(/,2X,24I5,/)
c$$$C--------*---------*---------*---------*---------*---------*-------> End
c$$$      DO 260 J=1,JM,JSKP
c$$$      JWR=JM+1-J
c$$$      DO 220 I=IB,IE,ISKP
c$$$  220 LINE(I)=INT(SCALEI*A(I,JWR))
c$$$      WRITE(6,240) JWR,(LINE(I),I=IB,IE,ISKP)
c$$$C< Satrt-*---------*---------*---------*---------*---- N.Kimura 05/01/03
c$$$  240 FORMAT(1X,I3,26(1X,I5))
c$$$c$$$  240 FORMAT(1X,I3,24(1X,I5))
c$$$c$$$c$$$  240 FORMAT(1X,I3,24I5)
c$$$C--------*---------*---------*---------*---------*---------*-------> End
c$$$  260 CONTINUE
c$$$      WRITE(6,280)
c$$$  280 FORMAT(//)
c$$$      IF(IE.GE.IM) RETURN
c$$$      IB=IB+26*ISKP
c$$$c$$$      IB=IB+24*ISKP
c$$$      GO TO 200
c$$$      END
