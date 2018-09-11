C $Header: /u/gcmpack/MITgcm/pkg/rivers/RIVERS.h, 2007/12/12 
C $Name:  $

CBOP
C !ROUTINE: RIVERS.h

C !DESCRIPTION: \bv
C     /==========================================================\
C     | RIVERS.h                                                 |
C     | o Basic header for river model.                          |
C     |   Contains most river field declarations.                |
C     \==========================================================/
C     Flow in m^3/sec only by river entries into lake
C     FLow only affects DOC concentrations (July 2008)
C     Flow does not affect momentum, temp, etc
C
C \ev
CEOP
C      COMMON/RIVERS_DYNVARS_1/AREA
C      _RL iceAREA(1-OLx:sNx+OLx,1-OLy:sNy+OLy,3,nSx,nSy)

      character*(5) riversexternalforcingversion
      character*(5) useriversscalendarversion
      parameter( riversexternalforcingversion = '0.2.2' )
      parameter( useriversscalendarversion    = '0.2.0' )

      _RL rivers_one
      parameter( rivers_one  =  1.0d0)
