c $Header: /u/gcmpack/MITgcm/pkg/rivers/rivers_getforcing.F,v 1.22 2006/03/02 15:30:11 heimbach Exp $

#include "RIVERS_OPTIONS.h"

CBOI
C
C !TITLE: EXTERNAL FORCING
C !AUTHORS: mitgcm developers ( support@mitgcm.org )
C !AFFILIATION: Massachussetts Institute of Technology
C !DATE:
C !INTRODUCTION: External forcing package
c \bv
c * The external forcing package, in conjunction with the
c   calendar package (cal), enables the handling of realistic forcing
c   fields of differing temporal forcing patterns.
c * It comprises climatological restoring and relaxation
c * Bulk formulae are implemented to convert atmospheric fields
c   to surface fluxes.
c * An interpolation routine provides on-the-fly interpolation of
c   forcing fields an arbitrary grid onto the model grid.
c * A list of RIVERS variables and units is in rivers_fields.h
c
C     !CALLING SEQUENCE:
c ...
c  rivers_getforcing (TOP LEVEL ROUTINE)
c  |
c  |-- rivers_getclim (get climatological fields used e.g. for relax.)
c  |   |--- exf_set_climtemp (relax. to 3-D temperature field)
c  |   |--- exf_set_climsalt (relax. to 3-D salinity field)
c  |   |--- exf_set_climsst  (relax. to 2-D SST field)
c  |   |--- exf_set_climsss  (relax. to 2-D SSS field)
c  |   o
c  |
c  |-- rivers_getffields <- this one does almost everything
c  |   |   1. reads in fields, either flux or atmos. state,
c  |   |      depending on CPP options (for each variable two fields
c  |   |      consecutive in time are read in and interpolated onto
c  |   |      current time step).
c  |   |   2. If forcing is atmos. state and control is atmos. state,
c  |   |      then the control variable anomalies are read here
c  |   |          * ctrl_getatemp
c  |   |          * ctrl_getaqh
c  |   |          * ctrl_getuwind
c  |   |          * ctrl_getvwind
c  |   |      If forcing and control are fluxes, then
c  |   |      controls are added later.
c  |   o
c  |
c  |-- rivers_check_range
c  |   |   1. Check whether read fields are within assumed range
c  |   |      (may capture mismatches in units)
c  |   o
c  |
c  |-- exf_bulkformulae
c  |   |   1. Compute net or downwelling radiative fluxes via
c  |   |      Stefan-Boltzmann law in case only one is known.
c  |   |   2. Compute air-sea momentum and buoyancy fluxes from
c  |   |      atmospheric state following Large and Pond, JPO, 1981/82
c  |   o
c  |
c  |-- < add time-mean river runoff here, if available >
c  |
c  |-- < update tile edges here >
c  |
c  |-- rivers_getsurfacefluxes
c  |   |   1. If forcing and control are fluxes, then
c  |   |      controls are added here.
c  |   o
c  |
c  |-- < treatment of hflux w.r.t. swflux >
c  |
c  |-- rivers_diagnostics_fill
c  |   |   1. Do RIVERS-related diagnostics output here.
c  |   o
c  |
c  |-- exf_mapfields
c  |   |   1. Map the EXF variables onto the core MITgcm
c  |   |      forcing fields.
c  |   o
c  |
c  |-- exf_bulkformulae
c  |   If ALLOW_BULKFORMULAE, compute fluxes via bulkformulae
c  |
c  |-- exf_getsurfacefluxes
c  |   If forcing and control is flux, then the
c  |   control vector anomalies are read here
c  |      * ctrl_getheatflux
c  |      * ctrl_getsaltflux
c  |      * ctrl_getzonstress
c  |      * call ctrl_getmerstress
c  |
c  |-- exf_mapfields
c  |   Forcing fields from exf package are mapped onto
c  |   mitgcm forcing arrays.
c  |   Mapping enables a runtime rescaling of fields
c
c \ev
CEOI

CBOP
C     !ROUTINE: rivers_getforcing
C     !INTERFACE:
      subroutine rivers_getforcing( mytime, myiter, mythid )

C     !DESCRIPTION: \bv
c     *=================================================================
c     | SUBROUTINE rivers_getforcing
c     *=================================================================
c     o Get the forcing fields for the current time step. The switches
c       for the inclusion of the individual forcing components have to
c       be set in RIVERS_OPTIONS.h (or ECCO_CPPOPTIONS.h).
c       A note on surface fluxes:
c       The MITgcmUV's vertical coordinate z is positive upward.
c       This implies that a positive flux is out of the ocean
c       model. However, the wind stress forcing is not treated
c       this way. A positive zonal wind stress accelerates the
c       model ocean towards the east.
c       started: eckert@mit.edu, heimbach@mit.edu, ralf@ocean.mit.edu
c       mods for pkg/seaice: menemenlis@jpl.nasa.gov 20-Dec-2002
c     *=================================================================
c     | SUBROUTINE rivers_getforcing
c     *=================================================================
C     \ev

C     !USES:
      implicit none

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "GRID.h"
#include "FFIELDS.h"
C
#include "rivers_param.h"
#include "rivers_fields.h"

c     == global variables ==

C     !INPUT/OUTPUT PARAMETERS:
c     == routine arguments ==
      integer mythid
      integer myiter
      _RL     mytime

C     !LOCAL VARIABLES:
c     == local variables ==

      integer bi,bj
      integer i,j,k
      character*(max_len_mbuf) msgbuf

c     == end of interface ==
CEOP

c$$$
c     Get the surface forcing fields.
      call rivers_getffields( mytime, myiter, mythid )

      do bj = mybylo(mythid),mybyhi(mythid)
      do bi = mybxlo(mythid),mybxhi(mythid)
          k = 1
          do j = 1,sny
            do i = 1,snx
              rivflow(i,j,bi,bj) = rivflow(i,j,bi,bj)*maskc(i,j,1,bi,bj)
c              print*,'i',i,'j',j,'rivflow(i,j,bi,bj)',rivflow(i,j,bi,bj)
              rivalk(i,j,bi,bj) = rivalk(i,j,bi,bj)*maskc(i,j,1,bi,bj)
c              print*,'i',i,'j',j,'rivalk(i,j,bi,bj)',rivalk(i,j,bi,bj)
              rivdic(i,j,bi,bj) = rivdic(i,j,bi,bj)*maskc(i,j,1,bi,bj)
c              print*,'i',i,'j',j,'rivalk(i,j,bi,bj)',rivalk(i,j,bi,bj)
              rivdoc(i,j,bi,bj) = rivdoc(i,j,bi,bj)*maskc(i,j,1,bi,bj)
c              print*,'i',i,'j',j,'rivalk(i,j,bi,bj)',rivalk(i,j,bi,bj)
            enddo
          enddo
      enddo
      enddo

c     Update the tile edges.
      _EXCH_XY_R8(rivflow,   mythid)
      _EXCH_XY_R8(rivdic,   mythid)
      _EXCH_XY_R8(rivdoc,   mythid)
      _EXCH_XY_R8(rivalk,   mythid)
c$$$   modified by Val Bennington Jan 2008
c$$$   allows for latent heat due to ice melt/formation
c$$$   update tile edges

c$$$      call debug_prxy('debug write before-fu',myTime,
c$$$     1     fu(1-OLx,1-OLy,bi,bj),
c$$$     2     1-OLx, sNx+OLx, 1, 1-OLy, sNy+OLy, 1, 0.D0)

c     Diagnostics output
      call rivers_diagnostics_fill( mytime, myiter, mythid )

      return
      end
