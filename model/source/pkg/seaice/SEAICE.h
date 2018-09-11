C $Header: /u/gcmpack/MITgcm/pkg/seaice/SEAICE.h,v 1.19 2006/03/15 19:49:04 mlosch Exp $
C $Name:  $

CBOP
C !ROUTINE: SEAICE.h

C !DESCRIPTION: \bv
C     /==========================================================\
C     | SEAICE.h                                                 |
C     | o Basic header for sea ice model.                        |
C     |   Contains most sea ice field declarations.              |
C     \==========================================================/
C
C     UICE  - zonal ice velocity in m/s
C             at South-West B-grid U point
C             >0 from West to East
C     UICEC - average of UICE(1) between last two time steps
C     VICE  - meridional ice velocity in m/s
C             at South-West B-grid U point
C             >0 from South to North
C             note: the South-West B-grid U and V points are on
C                the lower, left-hand corner of each grid cell
C     VICEC - average of VICE(1) between last two time steps
C     AREA  - fractional ice-covered area in m^2/m^2
C             at South-West B-grid tracer point
C             0 is no cover, 1 is 100% cover
C     HEFF  - effective ice thickness in m
C             at South-West B-grid tracer point
C             note: for non-zero AREA, actual ice
C                thickness is HEFF / AREA
C \ev
CEOP
      COMMON/SEAICE_DYNVARS_1/AREA
      _RL AREA       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,3,nSx,nSy)

      COMMON/SEAICE_DYNVARS_2/UICE,VICE
      _RL UICE       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,3,nSx,nSy)
      _RL VICE       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,3,nSx,nSy)

      COMMON/SEAICE_DYNVARS_3/
     &     ETA,ZETA,DRAGS,DRAGA,FORCEX,FORCEY,UICEC,VICEC
#ifndef SEAICE_CGRID
     &     , AMASS
#else 
     &     , seaiceMassC, seaiceMassU, seaiceMassV
#endif
      _RL ETA        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL ZETA       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL DRAGS      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL DRAGA      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
#ifndef SEAICE_CGRID
      _RL AMASS      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
#else
      _RL seaiceMassC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL seaiceMassU(1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL seaiceMassV(1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
#endif
      _RL FORCEX     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL FORCEY     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL UICEC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL VICEC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)

      COMMON/SEAICE_DYNVARS_4/
     &     DAIRN, DWATN, PRESS0, FORCEX0, FORCEY0, ZMAX, ZMIN
      _RL DAIRN      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL DWATN      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL PRESS0     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL FORCEX0    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL FORCEY0    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL ZMAX       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL ZMIN       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)

      COMMON/SEAICE_TRANS/HEFF,HSNOW
      _RL HEFF       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,3,nSx,nSy)
      _RL HSNOW      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)

      COMMON/ARRAY/HEFFM
#ifdef SEAICE_CGRID
     &     , seaiceMaskU, seaiceMaskV
#else
     &     , UVM
#endif
      COMMON/OFL/YNEG
      COMMON/RIV/RIVER
      COMMON/SALT_WATER/SEAICE_SALT
      _RL HEFFM      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
#ifdef SEAICE_CGRID
      _RL seaiceMaskU(1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL seaiceMaskV(1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
#else
      _RL UVM        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
#endif /* SEAICE_CGRID */
      _RL YNEG       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL RIVER      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL SEAICE_SALT(1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)

#ifdef SEAICE_MULTILEVEL
      INTEGER MULTDIM
      PARAMETER (MULTDIM=7)
      COMMON/MULTILEVEL/TICES
      _RL TICES      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,MULTDIM,nSx,nSy)
#endif

      COMMON/MIX/TMIX,TICE
      COMMON/GWATXY/GWATX,GWATY
      COMMON/WIND/WINDX,WINDY
      COMMON/RATE/FHEFF,FICE,FO,HCORR
      COMMON/QFLUX/QNETO,QNETI,QSWO,QSWI
      _RL TMIX       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL TICE       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL GWATX      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL GWATY      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL WINDX      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL WINDY      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL FHEFF      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL FICE       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL FO         (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL HCORR      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL QNETO      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL QNETI      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL QSWO       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)
      _RL QSWI       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)

      COMMON/COUNT/ICOUNT
      COMMON/DAY/IDELT
      INTEGER ICOUNT, IDELT

C--   KGEO    Level used as a proxy for geostrophic velocity.
      COMMON/SEAICE_KGEO/KGEO
      integer KGEO   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,  nSx,nSy)

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
