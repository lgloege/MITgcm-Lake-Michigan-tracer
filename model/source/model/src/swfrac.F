C $Header: /u/gcmpack/MITgcm/model/src/swfrac.F,v 1.12 2004/04/18 20:36:56 mlosch Exp $
C $Name:  $

#include "PACKAGES_CONFIG.h"
#include "CPP_OPTIONS.h"

CBOP
C     !ROUTINE: SWFRAC
C     !INTERFACE:
      SUBROUTINE SWFRAC(
     I     imax, fact,
     I     mytime, mythid,
     U     swdk )
C     !DESCRIPTION: \bv
C     *==========================================================*
C     | SUBROUTINE SWFRAC                                         
C     | o Compute solar short-wave flux penetration.
C     *==========================================================*
C     | Compute fraction of solar short-wave flux penetrating to  
C     | specified depth, swdk, due to exponential decay in        
C     | Jerlov water type jwtype.                                 
C     | Reference : Two band solar absorption model of Paulson    
C     |             and Simpson (1977, JPO, 7, 952-956)           
C     | Notes                                                     
C     | =====                                                     
C     | Parameter jwtype is hardcoded to 3 for time being.        
C     | Below 200m the solar penetration gets set to zero,        
C     | otherwise the limit for the exponent (+/- 5678) needs to   
C     | be taken care of.                                         
C     | Written by   : Jan Morzel                                 
C     | Date         : July 12, 1995                              
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE

C     !INPUT/OUTPUT PARAMETERS:
C     === Routine arguments ===
C     input arguments
C     imax    :: number of vertical grid points
C     fact    :: scale  factor to apply to depth array
C     myTime  :: current time in simulation
C     myThid  :: thread number for this instance of the routine.
      INTEGER imax
      _RL     fact
      _RL     mytime
      integer mythid
C     input/output arguments
C     swdk    :: on input: vertical depth for desired sw fraction
C               (fact*swdk) is negative distance (m) from surface
C     swdk    :: on output: short wave (radiation) fractional decay
      _RL     swdk(imax)

C     !LOCAL VARIABLES:
C     === Local variables ===
C     max number of different water types 
      integer   nwtype  , jwtype
      PARAMETER(nwtype=5)
      _RL facz
      _RL rfac(nwtype),a1(nwtype),a2(nwtype)
      INTEGER i
#ifdef ALLOW_CAL
      _RL     fac
      logical first, changed
      integer count0, count1
      integer myiter
      integer jerl(12)
      data jerl / 2 , 2 , 2 , 3 , 3 , 3 , 4 , 4 , 4 , 4 , 3 , 2 /
#endif /* ALLOW_CAL */
C
C     Jerlov water type :  I       IA      IB      II      III
C                jwtype    1       2       3       4       5
C
      DATA rfac         /  0.58 ,  0.62 ,  0.67 ,  0.77 ,  0.78 /
      DATA a1           /  0.35 ,  0.6  ,  1.0  ,  1.5  ,  1.4  /
      DATA a2           / 23.0  , 20.0  , 17.0  , 14.0  ,  7.9  /
CEOP

#ifdef ALLOW_CAL
ceh3 this should have an IF ( useCALENDAR ) THEN
CML(
C     myIter = 0 makes cal_getMonthsRec always return count0=12
C     so that jerl(count0) = 2.
C     The following lines are meant to be an example of how to
C     include time dependent water types. However, it would probably
C     make more sense to first think about a regionally varying
C     water type before implementing a time dependence.
CML      myiter=0
CML      call  cal_GetMonthsRec(
CML     O     fac, first, changed, count0, count1,
CML     I     mytime, myiter, mythid )
CML      jwtype=jerl(count0)
CML)
      jwtype=2
#else /* ALLOW_CAL undef */
      jwtype=2
#endif /* ALLOW_CAL */

      DO i = 1,imax
         facz = fact*swdk(i)
         IF (facz .LT. (-200.)) THEN
            swdk(i) = 0.
         ELSE
            swdk(i) =       rfac(jwtype)  * exp(facz/a1(jwtype))
     $                + (1.-rfac(jwtype)) * exp(facz/a2(jwtype))
         ENDIF
      ENDDO

      RETURN
      END
