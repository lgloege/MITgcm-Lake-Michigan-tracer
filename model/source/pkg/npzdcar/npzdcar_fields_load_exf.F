#include "NPZDCAR_OPTIONS.h"
c$$$#include "CPP_OPTIONS.h"
c$$$#include "PTRACERS_OPTIONS.h"
c$$$#include "GCHEM_OPTIONS.h"

#ifdef ALLOW_PTRACERS
#ifdef ALLOW_NPZDCAR

CStartOfInterFace
      SUBROUTINE NPZDCAR_FIELDS_LOAD_EXF (
     I           myIter,myTime,myThid)

C     /==========================================================\
C     | SUBROUTINE NPZDCAR_FIELDS_LOAD                           |
C     | o Read in fields needed for ice fraction and             |
C     | iron aeolian flux terms                                  |
C     | modified w/ exf: calendar system 12/17/2007
C     |==========================================================|
      IMPLICIT NONE

C     == GLobal variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
C#include "PTRACERS_SIZE.h"
C#include "PTRACERS.h"
#include "NPZDCAR.h"
#include "NPZDCAR_LOAD.h"
C#include "GCHEM.h"
#include "npzdcar_param.h"
c
C#ifdef ALLOW_SEAICE
C#include "ICE.h"
C#endif

C     == Routine arguments ==
      INTEGER myIter
      _RL myTime
      INTEGER myThid
C     == Local variables ==
      INTEGER bi,bj
      INTEGER i,j !,intime0,intime1
C      _RL aWght,bWght,rdt
      INTEGER nForcingPeriods,Imytm,Ifprd,Ifcyc,Iftm
c     
C     for ice fraction
      call npzdcar_set_gen (
     &     ficefile, ficestartdate, ficeperiod,
     &     ficestartdate1, ficestartdate2,
     &     npzdcar_inscal_fice,
     &     fice_npzdcarremo_intercept, fice_npzdcarremo_slope,
     &     fice, fice0, fice1, ficemask,
     &     mytime, myiter, mythid )
C     for iron from air
      call npzdcar_set_gen (
     &     featmosfile, featmosstartdate, featmosperiod,
     &     featmosstartdate1, featmosstartdate2,
     &     npzdcar_inscal_featmos,
     &     featmos_npzdcarremo_intercept, featmos_npzdcarremo_slope,
     &     inputFe, featmos0, featmos1, featmosmask,
     &     mytime, myiter, mythid )
C     for wind speed
      call npzdcar_set_gen (
     &     wspeedfile, wspeedstartdate, wspeedperiod,
     &     wspeedstartdate1, wspeedstartdate2,
     &     npzdcar_inscal_wspeed,
     &     wspeed_npzdcarremo_intercept, wspeed_npzdcarremo_slope,
     &     wspeed, wspeed0, wspeed1, wspeedmask,
     &     mytime, myiter, mythid )
C     for PAR -- shortwave radiation
      call npzdcar_set_gen (
     &     sur_parfile, sur_parstartdate, sur_parperiod,
     &     sur_parstartdate1, sur_parstartdate2,
     &     npzdcar_inscal_sur_par,
     &     sur_par_npzdcarremo_intercept, sur_par_npzdcarremo_slope,
     &     sur_par, sur_par0, sur_par1, sur_parmask,
     &     mytime, myiter, mythid )
C     for atmospheric pressure
      call npzdcar_set_gen (
     &     atmospfile, atmospstartdate, atmospperiod,
     &     atmospstartdate1, atmospstartdate2,
     &     npzdcar_inscal_atmosp,
     &     atmosp_npzdcarremo_intercept, atmosp_npzdcarremo_slope,
     &     atmosp, atmosp0, atmosp1, atmospmask,
     &     mytime, myiter, mythid )

c     Update the tile edges.
      _EXCH_XY_R8(fice,   mythid)
      _EXCH_XY_R8(inputFe,mythid)
      _EXCH_XY_R8(wspeed, mythid)
      _EXCH_XY_R8(sur_par,mythid)
      _EXCH_XY_R8(atmosp, mythid)

C     debugging
      if(mod(myIter,5000).eq.0) then
         do bj = mybylo(mythid),mybyhi(mythid)
         do bi = mybxlo(mythid),mybxhi(mythid)
            write(6,*) 'debug npzdcar_exf_field_load myTime=',myTime
            call debug_prxy('debug write after npzdcar_set_gen Ice',
     1           myTime/3600./24.,
     1           fice(1-OLx,1-OLy,bi,bj),
     2           1-OLx, sNx+OLx, 1, 1-OLy, sNy+OLy, 1, 0.D0)
            call debug_prxy('debug write after npzdcar_set_gen Wind SP',
     1           myTime/3600./24.,
     1           wspeed(1-OLx,1-OLy,bi,bj),
     2           1-OLx, sNx+OLx, 1, 1-OLy, sNy+OLy, 1, 0.D0)
         enddo
         enddo
      endif
C      stop
C     temporary set up of other input data (artificial value)
      DO bj = myByLo(myThid), myByHi(myThid)
      DO bi = myBxLo(myThid), myBxHi(myThid)
         DO j=1-Oly,sNy+Oly
            DO i=1-Olx,sNx+Olx
               inputFe(i,j,bi,bj)=0.
C               wspeed(i,j,bi,bj)=0.
C               sur_par(i,j,bi,bj)=0.
               atmosp(i,j,bi,bj)=1.
            ENDDO
         ENDDO
      ENDDO
      ENDDO
      return

c$$$      IF ( periodicExternalForcing ) THEN
c$$$
c$$$C First call requires that we initialize everything to zero for safety
c$$$cQQQ need to check timing
c$$$       IF ( myIter .EQ. nIter0 ) THEN
c$$$         CALL LEF_ZERO( fice0,myThid )
c$$$         CALL LEF_ZERO( fice1,myThid )
c$$$         CALL LEF_ZERO( featmos0,myThid )
c$$$         CALL LEF_ZERO( featmos1,myThid )
c$$$         CALL LEF_ZERO( wspeed0,myThid )
c$$$         CALL LEF_ZERO( wspeed1,myThid )
c$$$         CALL LEF_ZERO( sur_par0,myThid )
c$$$         CALL LEF_ZERO( sur_par1,myThid )
c$$$         CALL LEF_ZERO( atmosp0,myThid )
c$$$         CALL LEF_ZERO( atmosp1,myThid )
c$$$       ENDIF
c$$$
c$$$
c$$$C Now calculate whether it is time to update the forcing arrays
c$$$       rdt=1. _d 0 / deltaTclock
c$$$       nForcingPeriods=
c$$$     &  int(externForcingCycle/externForcingPeriod+0.5)
c$$$       Imytm=int(myTime*rdt+0.5)
c$$$       Ifprd=int(externForcingPeriod*rdt+0.5)
c$$$       Ifcyc=int(externForcingCycle*rdt+0.5)
c$$$       Iftm=mod( Imytm+Ifcyc-Ifprd/2 ,Ifcyc)
c$$$
c$$$       intime0=int(Iftm/Ifprd)
c$$$       intime1=mod(intime0+1,nForcingPeriods)
c$$$       aWght=float( Iftm-Ifprd*intime0 )/float( Ifprd )
c$$$       bWght=1.-aWght
c$$$
c$$$       intime0=intime0+1
c$$$       intime1=intime1+1
c$$$
c$$$
c$$$cQQ something funny about timing here - need nIter0+1
c$$$c   but seems okay for remaining timesteps
c$$$       IF (
c$$$     &   Iftm-Ifprd*(intime0-1) .EQ. 0
c$$$     &   .OR. myIter .EQ. nIter0
c$$$     &    ) THEN
c$$$
c$$$
c$$$        _BEGIN_MASTER(myThid)
c$$$
c$$$C      If the above condition is met then we need to read in
c$$$C      data for the period ahead and the period behind myTime.
c$$$        WRITE(*,*)
c$$$     &    'S/R EXTERNAL_FIELDS_LOAD: Reading npzd forcing data',
c$$$     &                 myTime,myIter
c$$$
c$$$       IF ( IceFile .NE. ' '  ) THEN
c$$$         CALL READ_REC_XY_RS( IceFile,fice0,intime0,
c$$$     &        myIter,myThid ) 
c$$$         CALL READ_REC_XY_RS( IceFile,fice1,intime1,
c$$$     &        myIter,myThid )
c$$$       ENDIF
c$$$       IF ( IronFile .NE. ' '  ) THEN
c$$$         CALL READ_REC_XY_RS( IronFile,featmos0,intime0,
c$$$     &        myIter,myThid )
c$$$         CALL READ_REC_XY_RS( IronFile,featmos1,intime1,
c$$$     &        myIter,myThid )
c$$$       ENDIF
c$$$       IF ( WindFile .NE. ' '  ) THEN
c$$$         CALL READ_REC_XY_RS( WindFile,wspeed0,intime0,
c$$$     &        myIter,myThid )
c$$$         CALL READ_REC_XY_RS( WindFile,wspeed1,intime1,
c$$$     &        myIter,myThid )
c$$$       ENDIF
c$$$       IF ( Filename1 .NE. ' '  ) THEN
c$$$         CALL READ_REC_XY_RS( Filename1,sur_par0,intime0,
c$$$     &        myIter,myThid )
c$$$         CALL READ_REC_XY_RS( Filename1,sur_par1,intime1,
c$$$     &        myIter,myThid )
c$$$       ENDIF
c$$$       IF ( AtmospFile .NE. ' '  ) THEN
c$$$         CALL READ_REC_XY_RS( AtmospFile,atmosp0,intime0,
c$$$     &        myIter,myThid )
c$$$         CALL READ_REC_XY_RS( AtmospFile,atmosp1,intime1,
c$$$     &        myIter,myThid )
c$$$       ENDIF
c$$$
c$$$
c$$$       _END_MASTER(myThid)
c$$$C
c$$$       _EXCH_XY_R4(fice0, myThid )
c$$$       _EXCH_XY_R4(fice1, myThid )
c$$$       _EXCH_XY_R4(featmos0, myThid )
c$$$       _EXCH_XY_R4(featmos1, myThid )
c$$$       _EXCH_XY_R4(wspeed0, myThid )
c$$$       _EXCH_XY_R4(wspeed1, myThid )
c$$$       _EXCH_XY_R4(sur_par0, myThid )
c$$$       _EXCH_XY_R4(sur_par1, myThid )
c$$$       _EXCH_XY_R4(atmosp0, myThid )
c$$$       _EXCH_XY_R4(atmosp1, myThid )
c$$$C
c$$$       ENDIF
c$$$
c$$$       DO bj = myByLo(myThid), myByHi(myThid)
c$$$        DO bi = myBxLo(myThid), myBxHi(myThid)
c$$$         DO j=1-Oly,sNy+Oly
c$$$          DO i=1-Olx,sNx+Olx
c$$$cQQ need to include ice moel here, if used
c$$$           IF ( IceFile .NE. ' '  ) THEN
c$$$            fice(i,j,bi,bj)   = bWght*fice0(i,j,bi,bj)
c$$$     &                         +aWght*fice1(i,j,bi,bj)
c$$$           ELSE
c$$$            fice(i,j,bi,bj)  = 0.d0
c$$$           ENDIF
c$$$           IF ( IronFile .NE. ' '  ) THEN
c$$$            inputFe(i,j,bi,bj)   = bWght*featmos0(i,j,bi,bj)
c$$$     &                            +aWght*featmos1(i,j,bi,bj)
c$$$c convert to mmol/m2/s
c$$$            inputFe(i,j,bi,bj)   = 1000.d0*inputFe(i,j,bi,bj)
c$$$           ELSE
c$$$            inputFe(i,j,bi,bj)  = 0.d0
c$$$           ENDIF
c$$$c wind speed
c$$$           IF ( WindFile .NE. ' '  ) THEN
c$$$            wspeed(i,j,bi,bj)   = bWght*wspeed0(i,j,bi,bj)
c$$$     &                         +aWght*wspeed1(i,j,bi,bj)
c$$$           ELSE
c$$$            wspeed(i,j,bi,bj)  =  5.d0*maskC(i,j,1,bi,bj)
c$$$           ENDIF
c$$$c light
c$$$           IF ( Filename1 .NE. ' '  ) THEN
c$$$            sur_par(i,j,bi,bj)   = bWght*sur_par0(i,j,bi,bj)
c$$$     &                         +aWght*sur_par1(i,j,bi,bj)
c$$$           ELSE
c$$$            sur_par(i,j,bi,bj)  =  10.d0*maskC(i,j,1,bi,bj)
c$$$           ENDIF
c$$$c wind speed
c$$$           IF ( AtmospFile .NE. ' '  ) THEN
c$$$            atmosp(i,j,bi,bj)   = bWght*atmosp0(i,j,bi,bj)
c$$$     &                         +aWght*atmosp1(i,j,bi,bj)
c$$$           ELSE
c$$$            atmosp(i,j,bi,bj)  =  1.d0*maskC(i,j,1,bi,bj)
c$$$           ENDIF
c$$$
c$$$          ENDDO
c$$$         ENDDO
c$$$        ENDDO
c$$$       ENDDO
c$$$
c$$$C endif for periodicForcing
c$$$       ENDIF

      RETURN
      END
#endif
#endif

