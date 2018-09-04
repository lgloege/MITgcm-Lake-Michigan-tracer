C $Header: /u/gcmpack/MITgcm/pkg/lakeice/LAKEICE.h, 2007/12/12 
C $Name:  $

CBOP
C !ROUTINE: LAKEICE.h

C !DESCRIPTION: \bv
C     /==========================================================\
C     | LAKEICE.h                                                 |
C     | o Basic header for lake ice model.                        |
C     |   Contains most lake ice field declarations.              |
C     \==========================================================/
C
C     AREA  - fractional ice-covered area in m^2/m^2
C             at South-West B-grid tracer point
C             0 is no cover, 1 is 100% cover
C \ev
CEOP
C      COMMON/LAKEICE_DYNVARS_1/AREA
C      _RL iceAREA(1-OLx:sNx+OLx,1-OLy:sNy+OLy,3,nSx,nSy)

      character*(5) lakeiceexternalforcingversion
      character*(5) uselakeicescalendarversion
      parameter( lakeiceexternalforcingversion = '0.2.2' )
      parameter( uselakeicescalendarversion    = '0.2.0' )

      _RL lakeice_one
      parameter( lakeice_one  =  1.0d0)
