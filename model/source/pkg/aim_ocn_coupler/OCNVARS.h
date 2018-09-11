C $Header: /u/gcmpack/MITgcm/pkg/aim_ocn_coupler/OCNVARS.h,v 1.2 2004/05/21 19:31:50 jmc Exp $
C $Name:  $

C     /==========================================================\
C     | OCNVARS.h Declare arrays for holding data on the ocean   |
C     |           grid. Arrays may need adding or removing       |
C     |           different couplings.                           |
C     \==========================================================/
C     AtmDepths_ocn  - Atmos. depth on ocean grid     ( Pa )
C     OcMxlD_ocn       - Ocean mixed-layer depths on ocean grid (m)
C     SST_ocn        - Sea surface temperature on ocean grid ( oC).
C     SSS_ocn        - Sea surface temperature on ocean grid (psu).
C     vSq_ocn        - Sea surface velocity square on ocean grid (m2/s2)
C     atmSLPr_ocn    - Sea Level atmos. pressure on ocean grid (Pa)
C     HeatFlux_ocn   - net Heat flux on ocean grid (W/m2, +=upward)
C     qShortWave_ocn - net shortwave radiation on ocean grid (W/m2, +=upward)
C     TauX_ocn       - Zonal momentum flux on ocean grid ( N/m^2, same
C                      sign as the wind ; positive wind == westward flow)
C     TauY_ocn       - Meridional momentum flux on ocean grid ( N/m^2, same
C                      sign as the wind ; positive wind == northward flow)
C     FWFlux_ocn     - Fresh water flux on ocean grid ( m/s, positive out
C                      of ocean).
C     SaltFlx_ocn    - salt flux from sea-ice compon. on ocean grid
C                      (+=upward=leaving the ocean)
C     sIceMass_ocn   - sea-ice mass  on ocean grid (kg/m2)

      COMMON /OCNVARS_R/
     &       AtmDepths_ocn,
     &       OcMxlD_ocn, SST_ocn, SSS_ocn, vSq_ocn,
     &       atmSLPr_ocn, HeatFlux_ocn, qShortWave_ocn,
c    &       qLatent_ocn, qSensible_ocn, qLongWave_ocn,
c    &       uVelGround_ocn, vVelGround_ocn,
     &       TauX_ocn, TauY_ocn,
     &       FWFlux_ocn,
     &       SaltFlx_ocn, sIceMass_ocn

      _RS AtmDepths_ocn  (Nx_ocn,Ny_ocn)
      _RL OcMxlD_ocn     (Nx_ocn,Ny_ocn)
      _RL SST_ocn        (Nx_ocn,Ny_ocn)
      _RL SSS_ocn        (Nx_ocn,Ny_ocn)
      _RL vSq_ocn        (Nx_ocn,Ny_ocn)
      _RL atmSLPr_ocn    (Nx_ocn,Ny_ocn)
      _RL HeatFlux_ocn   (Nx_ocn,Ny_ocn)
      _RL qShortWave_ocn (Nx_ocn,Ny_ocn)
c     _RL qLatent_ocn    (Nx_ocn,Ny_ocn)
c     _RL qSensible_ocn  (Nx_ocn,Ny_ocn)
c     _RL qLongWave_ocn  (Nx_ocn,Ny_ocn)
c     _RL uVelGround_ocn (Nx_ocn,Ny_ocn)
c     _RL vVelGround_ocn (Nx_ocn,Ny_ocn)
      _RL TauX_ocn       (Nx_ocn,Ny_ocn)
      _RL TauY_ocn       (Nx_ocn,Ny_ocn)
      _RL FWFlux_ocn     (Nx_ocn,Ny_ocn)
      _RL SaltFlx_ocn    (Nx_ocn,Ny_ocn)
      _RL sIceMass_ocn   (Nx_ocn,Ny_ocn)
