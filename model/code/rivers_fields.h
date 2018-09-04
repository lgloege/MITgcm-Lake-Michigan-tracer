c $Header: /u/gcmpack/MITgcm/pkg/rivers/rivers_fields.h,v 1.12 2005/06/28 22:05:49 heimbach Exp $
c
c
c     ==================================================================
c     HEADER rivers_fields
c     ==================================================================
c
c     o Header file for the river flow.
c
c     started: benesh@wisc.edu Feb 2010
c
c     ==================================================================
c     HEADER rivers_fields
c     ==================================================================
c
c
c     Field definitions, units, and sign conventions:
c     ===============================================
c
c     NOTES:
c     ======
c
c     Input and output units and sign conventions can be customized
c     using variables rivers_inscal_* and rivers_outscal_*, which are set
c     by rivers_readparms.F
c
c     Arrays *0 and *1 below are used for temporal interpolation.
c
      common /rivers_rivflow_r/ rivflow
      _RL rivflow(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy,PTRACERS_num)
      common /rivers_rivflow_r1/ rivflow0, rivflow1
      _RL rivflow0(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy,PTRACERS_num)
      _RL rivflow1(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy,PTRACERS_num)

      common /rivers_rivalk_r/ rivalk
      _RL rivalk(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      common /rivers_rivalk_r1/ rivalk0, rivalk1
      _RL rivalk0(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL rivalk1(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)

      common /rivers_rivdic_r/ rivdic
      _RL rivdic(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      common /rivers_rivdic_r1/ rivdic0, rivdic1
      _RL rivdic0(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL rivdic1(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)

      common /rivers_rivdoc_r/ rivdoc
      _RL rivdoc(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      common /rivers_rivdoc_r1/ rivdoc0, rivdoc1
      _RL rivdoc0(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL rivdoc1(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
