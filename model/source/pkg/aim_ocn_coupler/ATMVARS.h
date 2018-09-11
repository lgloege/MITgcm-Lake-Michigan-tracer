C $Header: /u/gcmpack/MITgcm/pkg/aim_ocn_coupler/ATMVARS.h,v 1.2 2004/05/21 19:31:50 jmc Exp $
C $Name:  $

C     /==========================================================\
C     | ATMVARS.h Declare arrays for holding data on the atmos.  |
C     |           grid. Arrays may need adding or removing       |
C     |           different couplings.                           |
C     \==========================================================/
C     AtmDepths_atm  - Atmos. depths on atmos. grid
C     OcMxlD_atm     - Ocean mixed-layer depths on atmos. grid (m)
C     SST_atm        - Sea surface temperature on atmos. grid ( oC).
C     SSS_atm        - Sea surface temperature on atmos. grid (psu).
C     vSq_atm        - Sea surface velocity square on atmos. grid (m2/s2)
C     atmSLPr_atm    - Sea Level atmos. pressure on atmos. grid (Pa)
C     HeatFlux_atm   - net Heat flux on atmos. grid (W/m2, +=upward)
C     qShortWave_atm - net shortwave radiation on atmos. grid (W/m2, +=upward)
C     TauX_atm       - Zonal momentum flux on atmos. grid ( N/m^2, same
C                      sign as the wind ; positive wind == westward flow)
C     TauY_atm       - Meridional momentum flux on atmos. grid ( N/m^2, same
C                      sign as the wind ; positive wind == northward flow)
C     EvMPr_atm      - Fresh water flux (=Evap-Precip) on atmos. grid 
C                      ( m/s, positive into atmosphere).
C     RunOff_atm     - Fresh water flux (=RunOff) on atmos. grid 
C                      ( m/s, positive is leaving the land bucket)
C     ROEnFx_atm     - Energy carried by RunOff on atmos. grid 
C                      ( W/m2, +=leaving land bucket)
C     SaltFlx_atm    - salt flux from sea-ice compon. on atmos. grid
C                      (+=upward=leaving the ocean)
C     sIceMass_atm   - sea-ice mass  on atmos. grid (kg/m2)

      COMMON /ATMVARS_R/
     &       AtmDepths_atm,
     &       OcMxlD_atm, SST_atm, SSS_atm, vSq_atm,
     &       atmSLPr_atm, HeatFlux_atm, qShortWave_atm,
c    &       qLatent_atm, qSensible_atm, qLongWave_atm,
c    &       uVelGround_atm, vVelGround_atm,
     &       TauX_atm, TauY_atm,
     &       EvMPr_atm, RunOff_atm, ROEnFx_atm,
     &       SaltFlx_atm, sIceMass_atm

      _RS AtmDepths_atm  (Nx_atm,Ny_atm)
      _RL OcMxlD_atm     (Nx_atm,Ny_atm)
      _RL SST_atm        (Nx_atm,Ny_atm)
      _RL SSS_atm        (Nx_atm,Ny_atm)
      _RL vSq_atm        (Nx_atm,Ny_atm)
      _RL atmSLPr_atm    (Nx_atm,Ny_atm)
      _RL HeatFlux_atm   (Nx_atm,Ny_atm)
      _RL qShortWave_atm (Nx_atm,Ny_atm)
c     _RL qLatent_atm    (Nx_atm,Ny_atm)
c     _RL qSensible_atm  (Nx_atm,Ny_atm)
c     _RL qLongWave_atm  (Nx_atm,Ny_atm)
c     _RL uVelGround_atm (Nx_atm,Ny_atm)
c     _RL vVelGround_atm (Nx_atm,Ny_atm)
      _RL TauX_atm       (Nx_atm,Ny_atm)
      _RL TauY_atm       (Nx_atm,Ny_atm)
      _RL EvMPr_atm      (Nx_atm,Ny_atm)
      _RL RunOff_atm     (Nx_atm,Ny_atm)
      _RL ROEnFx_atm     (Nx_atm,Ny_atm)
      _RL SaltFlx_atm    (Nx_atm,Ny_atm)
      _RL sIceMass_atm   (Nx_atm,Ny_atm)
