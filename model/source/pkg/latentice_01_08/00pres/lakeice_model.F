C $Header: /u/gcmpack/MITgcm/pkg/lakeice/lakeice_model.F,v 1.30 2006/03/06 13:17:37 mlosch Exp $
C $Name:  $

#include "LAKEICE_OPTIONS.h"
 
CBOP
C !ROUTINE: LAKEICE_MODEL

C !INTERFACE: ==========================================================
      SUBROUTINE lakeice_model( myTime, myIter, myThid )

C !DESCRIPTION: \bv
C     /===========================================================\
C     | SUBROUTINE LAKEICE_MODEL                                   |
C     | o Time stepping of multipling icefraco to Qnet, Qsw, fu & fv|
C     |===========================================================|
C     \===========================================================/
      IMPLICIT NONE
c \ev
 
C !USES: ===============================================================
C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "DYNVARS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "FFIELDS.h"
C#include "LAKEICE.h"
#include "lakeice_param.h"
#include "lakeice_fields.h"

c$$$#ifdef LAKEICE_EXTERNAL_FORCING
c$$$#endif

c$$$#ifdef ALLOW_AUTODIFF_TAMC
c$$$# include "tamc.h"
c$$$#endif

C !INPUT PARAMETERS: ===================================================
C     === Routine arguments ===
C     myTime - Simulation time
C     myIter - Simulation timestep number
C     myThid - Thread no. that called this routine.
      _RL     myTime
      INTEGER myIter
      INTEGER myThid
CEndOfInterface

C !LOCAL VARIABLES: ====================================================
C     === Local variables ===
C     i,j,bi,bj - Loop counters
      INTEGER i, j, bi, bj
      LOGICAL  DIFFERENT_MULTIPLE
      EXTERNAL DIFFERENT_MULTIPLE
      integer  iMin,iMax,jMin,jMax

CEOP
      return
C     no use 
C**   need to add some treatment for heat
C     Qnet, Qsw are involved in FFIELDS.h 
C     simply times MET forcing by icefrac 
      iMin = 1-OLx
      iMax = sNx+OLx
      jMin = 1-OLy
      jMax = sNy+OLy

c$$$c$$$      DO j=jMin,jMax
c$$$c$$$        DO i=iMin,iMax
c$$$c$$$           Qnet(i,j,bi,bj)= Qnet(i,j,bi,bj)*(1.d0-icefrac(i,j,bi,bj))
c$$$c$$$           Qsw(i,j,bi,bj) = Qsw(i,j,bi,bj)*(1.d0-icefrac(i,j,bi,bj))
c$$$c$$$           fu(i,j,bi,bj)  = fu(i,j,bi,bj)*(1.d0-icefrac(i,j,bi,bj))
c$$$c$$$           fv(i,j,bi,bj)  = fv(i,j,bi,bj)*(1.d0-icefrac(i,j,bi,bj))
c$$$c$$$        ENDDO
c$$$      ENDDO
C
      write(6,*) 'debug lakeice_model myTime=',myTime
      call debug_prxy('debug write icefrac',myTime,
     1     icefrac(1-OLx,1-OLy,bi,bj),
     2     1-OLx, sNx+OLx, 1, 1-OLy, sNy+OLy, 1, 0.D0)
      call debug_prxy('debug write fu',myTime,
     1     fu(1-OLx,1-OLy,bi,bj),
     2     1-OLx, sNx+OLx, 1, 1-OLy, sNy+OLy, 1, 0.D0)
      if(myIter.eq.100) stop
C      if(mod(myIter,10).eq.0) stop
      RETURN

c$$$#ifdef LAKEICE_EXTERNAL_FORCING
c$$$C--   Atmospheric state and runoff are from
c$$$C     pkg/exf, which does not update edges.
c$$$      CALL EXCH_UV_XY_RL(uwind,vwind,.TRUE.,myThid)
c$$$      _EXCH_XY_R8( atemp,  myThid )
c$$$      _EXCH_XY_R8( aqh,    myThid )
c$$$      _EXCH_XY_R8( lwdown, myThid )
c$$$      _EXCH_XY_R8( swdown, mythid )
c$$$      _EXCH_XY_R8( precip, myThid )
c$$$      _EXCH_XY_R8( evap,   myThid )
c$$$      _EXCH_XY_R8( runoff, myThid )
c$$$#else /* LAKEICE_EXTERNAL_FORCING */
c$$$C--   Load atmospheric state and runoff.
c$$$      CALL LAKEICE_GET_FORCING ( myTime, myIter, myThid )
c$$$#endif /* LAKEICE_EXTERNAL_FORCING */
c$$$
c$$$#ifdef ALLOW_AUTODIFF_TAMC
c$$$CADJ STORE uwind = comlev1, key = ikey_dynamics
c$$$CADJ STORE vwind = comlev1, key = ikey_dynamics
c$$$CADJ STORE heff  = comlev1, key = ikey_dynamics
c$$$# ifdef LAKEICE_ALLOW_DYNAMICS
c$$$CADJ STORE area  = comlev1, key = ikey_dynamics
c$$$# endif
c$$$#endif /* ALLOW_AUTODIFF_TAMC */
c$$$
c$$$C solve ice momentum equations and calculate ocean surface stress
c$$$      IF ( 
c$$$     &  DIFFERENT_MULTIPLE(LAKEICE_deltaTdyn,myTime,LAKEICE_deltaTtherm)
c$$$     &   ) THEN
c$$$#ifdef LAKEICE_CGRID
c$$$         CALL TIMER_START('LAKEICE_DYNSOLVER   [LAKEICE_MODEL]',myThid)
c$$$         CALL LAKEICE_DYNSOLVER ( myTime, myIter, myThid )
c$$$         CALL TIMER_STOP ('LAKEICE_DYNSOLVER   [LAKEICE_MODEL]',myThid)
c$$$#else
c$$$         CALL TIMER_START('DYNSOLVER          [LAKEICE_MODEL]',myThid)
c$$$         CALL DYNSOLVER ( myTime, myIter, myThid )
c$$$         CALL TIMER_STOP ('DYNSOLVER          [LAKEICE_MODEL]',myThid)
c$$$#endif /* LAKEICE_CGRID */
c$$$      ENDIF
c$$$
c$$$#ifdef ALLOW_AUTODIFF_TAMC
c$$$# ifdef LAKEICE_ALLOW_DYNAMICS
c$$$CADJ STORE heff  = comlev1, key = ikey_dynamics
c$$$CADJ STORE area  = comlev1, key = ikey_dynamics
c$$$CADJ STORE uice  = comlev1, key = ikey_dynamics
c$$$CADJ STORE vice  = comlev1, key = ikey_dynamics
c$$$# endif
c$$$#endif /* ALLOW_AUTODIFF_TAMC */
c$$$C NOW DO ADVECTION and DIFFUSION
c$$$      CALL LAKEICE_ADVDIFF( myTime, myIter, myThid ) 
c$$$
c$$$C NOW DO GROWTH
c$$$C     MUST CALL GROWTH ONLY AFTER CALLING ADVECTION
c$$$      CALL GROWTH( myTime, myIter, myThid )
c$$$
c$$$C--   Update overlap regions for a bunch of stuff
c$$$      _BARRIER
c$$$      CALL LAKEICE_EXCH( HEFF, myThid )
c$$$      CALL LAKEICE_EXCH( AREA, myThid )
c$$$      CALL EXCH_UV_XY_RS(fu,fv,.TRUE.,myThid)
c$$$      _EXCH_XY_R4(EmPmR, myThid )
c$$$      _EXCH_XY_R4(Qnet , myThid )
c$$$#ifdef SHORTWAVE_HEATING
c$$$      _EXCH_XY_R4(Qsw  , myThid )
c$$$#endif
c$$$      _EXCH_XYZ_R8(theta , myThid )
c$$$
c$$$C--   Sea ice diagnostics.
c$$$C     <= moved to S/R do_the_model_io with other pkgs
c$$$
c$$$C--   Write sea ice restart files
c$$$C     <= moved to S/R packages_write_pickup with other pkgs
c$$$
c$$$C---------------------------------------------------
c$$$C OOH NOOOO we need to move the whole stuff
c$$$C---------------------------------------------------
c$$$#ifdef ALLOW_AUTODIFF_TAMC
c$$$CRG CADJ store UICE,VICE,AREA,HEFF,fu,fv,EmPmR,Qnet,Qsw = comlev1_bibj
c$$$#endif
c$$$
c$$$C--   Call sea-ice cost function routine
c$$$CRG      CALL SEAICE_COST( myTime, myIter, myThid )

      END
