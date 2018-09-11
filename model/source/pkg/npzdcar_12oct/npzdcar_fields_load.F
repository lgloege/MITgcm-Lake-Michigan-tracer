#include "CPP_OPTIONS.h"
#include "PTRACERS_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

#ifdef ALLOW_PTRACERS
#ifdef ALLOW_NPZDCAR

CStartOfInterFace
      SUBROUTINE NPZDCAR_FIELDS_LOAD (
     I           myIter,myTime,myThid)

C     /==========================================================\
C     | SUBROUTINE NPZDCAR_FIELDS_LOAD                           |
C     | o Read in fields needed for ice fraction and             |
C     | iron aeolian flux terms                                  |
C     |==========================================================|
      IMPLICIT NONE

C     == GLobal variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS.h"
#include "NPZDCAR.h"
#include "NPZDCAR_LOAD.h"
#include "GCHEM.h"
c
#ifdef ALLOW_SEAICE
#include "ICE.h"
#endif

C     == Routine arguments ==
      INTEGER myIter
      _RL myTime
      INTEGER myThid
C     == Local variables ==
       INTEGER bi,bj,i,j,intime0,intime1
      _RL aWght,bWght,rdt
      INTEGER nForcingPeriods,Imytm,Ifprd,Ifcyc,Iftm
c
c
      IF ( periodicExternalForcing ) THEN

C First call requires that we initialize everything to zero for safety
cQQQ need to check timing
       IF ( myIter .EQ. nIter0 ) THEN
         CALL LEF_ZERO( fice0,myThid )
         CALL LEF_ZERO( fice1,myThid )
         CALL LEF_ZERO( featmos0,myThid )
         CALL LEF_ZERO( featmos1,myThid )
         CALL LEF_ZERO( wspeed0,myThid )
         CALL LEF_ZERO( wspeed1,myThid )
         CALL LEF_ZERO( sur_par0,myThid )
         CALL LEF_ZERO( sur_par1,myThid )
         CALL LEF_ZERO( atmosp0,myThid )
         CALL LEF_ZERO( atmosp1,myThid )
       ENDIF


C Now calculate whether it is time to update the forcing arrays
       rdt=1. _d 0 / deltaTclock
       nForcingPeriods=
     &  int(externForcingCycle/externForcingPeriod+0.5)
       Imytm=int(myTime*rdt+0.5)
       Ifprd=int(externForcingPeriod*rdt+0.5)
       Ifcyc=int(externForcingCycle*rdt+0.5)
       Iftm=mod( Imytm+Ifcyc-Ifprd/2 ,Ifcyc)

       intime0=int(Iftm/Ifprd)
       intime1=mod(intime0+1,nForcingPeriods)
       aWght=float( Iftm-Ifprd*intime0 )/float( Ifprd )
       bWght=1.-aWght

       intime0=intime0+1
       intime1=intime1+1


cQQ something funny about timing here - need nIter0+1
c   but seems okay for remaining timesteps
       IF (
     &   Iftm-Ifprd*(intime0-1) .EQ. 0
     &   .OR. myIter .EQ. nIter0
     &    ) THEN


        _BEGIN_MASTER(myThid)

C      If the above condition is met then we need to read in
C      data for the period ahead and the period behind myTime.
        WRITE(*,*)
     &    'S/R EXTERNAL_FIELDS_LOAD: Reading npzd forcing data',
     &                 myTime,myIter

       IF ( IceFile .NE. ' '  ) THEN
         CALL READ_REC_XY_RS( IceFile,fice0,intime0,
     &        myIter,myThid ) 
         CALL READ_REC_XY_RS( IceFile,fice1,intime1,
     &        myIter,myThid )
       ENDIF
       IF ( IronFile .NE. ' '  ) THEN
         CALL READ_REC_XY_RS( IronFile,featmos0,intime0,
     &        myIter,myThid )
         CALL READ_REC_XY_RS( IronFile,featmos1,intime1,
     &        myIter,myThid )
       ENDIF
       IF ( WindFile .NE. ' '  ) THEN
         CALL READ_REC_XY_RS( WindFile,wspeed0,intime0,
     &        myIter,myThid )
         CALL READ_REC_XY_RS( WindFile,wspeed1,intime1,
     &        myIter,myThid )
       ENDIF
       IF ( Filename1 .NE. ' '  ) THEN
         CALL READ_REC_XY_RS( Filename1,sur_par0,intime0,
     &        myIter,myThid )
         CALL READ_REC_XY_RS( Filename1,sur_par1,intime1,
     &        myIter,myThid )
       ENDIF
       IF ( AtmospFile .NE. ' '  ) THEN
         CALL READ_REC_XY_RS( AtmospFile,atmosp0,intime0,
     &        myIter,myThid )
         CALL READ_REC_XY_RS( AtmospFile,atmosp1,intime1,
     &        myIter,myThid )
       ENDIF


       _END_MASTER(myThid)
C
       _EXCH_XY_R4(fice0, myThid )
       _EXCH_XY_R4(fice1, myThid )
       _EXCH_XY_R4(featmos0, myThid )
       _EXCH_XY_R4(featmos1, myThid )
       _EXCH_XY_R4(wspeed0, myThid )
       _EXCH_XY_R4(wspeed1, myThid )
       _EXCH_XY_R4(sur_par0, myThid )
       _EXCH_XY_R4(sur_par1, myThid )
       _EXCH_XY_R4(atmosp0, myThid )
       _EXCH_XY_R4(atmosp1, myThid )
C
       ENDIF

       DO bj = myByLo(myThid), myByHi(myThid)
        DO bi = myBxLo(myThid), myBxHi(myThid)
         DO j=1-Oly,sNy+Oly
          DO i=1-Olx,sNx+Olx
cQQ need to include ice moel here, if used
           IF ( IceFile .NE. ' '  ) THEN
            fice(i,j,bi,bj)   = bWght*fice0(i,j,bi,bj)
     &                         +aWght*fice1(i,j,bi,bj)
           ELSE
            fice(i,j,bi,bj)  = 0.d0
           ENDIF
           IF ( IronFile .NE. ' '  ) THEN
            inputFe(i,j,bi,bj)   = bWght*featmos0(i,j,bi,bj)
     &                            +aWght*featmos1(i,j,bi,bj)
c convert to mmol/m2/s
            inputFe(i,j,bi,bj)   = 1000.d0*inputFe(i,j,bi,bj)
           ELSE
            inputFe(i,j,bi,bj)  = 0.d0
           ENDIF
c wind speed
           IF ( WindFile .NE. ' '  ) THEN
            wspeed(i,j,bi,bj)   = bWght*wspeed0(i,j,bi,bj)
     &                         +aWght*wspeed1(i,j,bi,bj)
           ELSE
            wspeed(i,j,bi,bj)  =  5.d0*maskC(i,j,1,bi,bj)
           ENDIF
c light
           IF ( Filename1 .NE. ' '  ) THEN
            sur_par(i,j,bi,bj)   = bWght*sur_par0(i,j,bi,bj)
     &                         +aWght*sur_par1(i,j,bi,bj)
           ELSE
            sur_par(i,j,bi,bj)  =  10.d0*maskC(i,j,1,bi,bj)
           ENDIF
c wind speed
           IF ( AtmospFile .NE. ' '  ) THEN
            atmosp(i,j,bi,bj)   = bWght*atmosp0(i,j,bi,bj)
     &                         +aWght*atmosp1(i,j,bi,bj)
           ELSE
            atmosp(i,j,bi,bj)  =  1.d0*maskC(i,j,1,bi,bj)
           ENDIF

          ENDDO
         ENDDO
        ENDDO
       ENDDO

C endif for periodicForcing
       ENDIF

      RETURN
      END
#endif
#endif

