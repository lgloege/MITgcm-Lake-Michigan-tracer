C $Header: /u/gcmpack/MITgcm/pkg/ptracers/PTRACERS.h,v 1.18 2005/10/14 12:45:05 mlosch Exp $
C $Name:  $

#ifdef ALLOW_PTRACERS

CBOP
C    !ROUTINE: PTRACERS.h
C    !INTERFACE:
C #include PTRACERS.h
 
C    !DESCRIPTION:
C Contains passive tracer fields and parameters.

C     Package flag
      logical PTRACERSisON
      COMMON /PTRACERS_PACKAGE/ PTRACERSisON

C     PTRACERS_taveFreq :: Frequency with which time-averaged PTRACERS
C                          are written to post-processing files.
C     PTRACERS_Iter0    :: timestep number when tracers are initialized
C     PTRACERS_ref      :: vertical profile for passive tracers, in
C                          analogy to tRef and sRef, hence the name

C     PTRACERS parameters
      _RL PTRACERS_dumpFreq
      _RL PTRACERS_taveFreq
      _RL PTRACERS_monitorFreq
      _RL PTRACERS_diffKh(PTRACERS_num)
      _RL PTRACERS_diffK4(PTRACERS_num)
      _RL PTRACERS_diffKrNr(Nr,PTRACERS_num)
      _RL PTRACERS_ref(Nr,PTRACERS_num)
      INTEGER PTRACERS_Iter0
      INTEGER PTRACERS_numInUse
      INTEGER PTRACERS_advScheme(PTRACERS_num)
      LOGICAL PTRACERS_ImplVertAdv(PTRACERS_num)
      LOGICAL PTRACERS_useGMRedi(PTRACERS_num)
      LOGICAL PTRACERS_useKPP(PTRACERS_num)
      LOGICAL PTRACERS_useRecords
      CHARACTER*(MAX_LEN_FNAM) PTRACERS_initialFile(PTRACERS_num)
      CHARACTER*(MAX_LEN_FNAM) PTRACERS_names(PTRACERS_num)
      CHARACTER*(MAX_LEN_FNAM) PTRACERS_long_names(PTRACERS_num)
      CHARACTER*(MAX_LEN_FNAM) PTRACERS_units(PTRACERS_num)
      LOGICAL 
     &     PTRACERS_monitor_mnc, PTRACERS_monitor_stdio,
     &     PTRACERS_timeave_mdsio, PTRACERS_snapshot_mdsio,
     &     PTRACERS_pickup_write_mdsio, PTRACERS_pickup_read_mdsio,
     &     PTRACERS_timeave_mnc, PTRACERS_snapshot_mnc,
     &     PTRACERS_pickup_write_mnc, PTRACERS_pickup_read_mnc
      COMMON /PTRACERS_PARAMS/
     &     PTRACERS_dumpFreq,
     &     PTRACERS_taveFreq,
     &     PTRACERS_monitorFreq,
     &     PTRACERS_diffKh,
     &     PTRACERS_diffK4,
     &     PTRACERS_diffKrNr,
     &     PTRACERS_ref,
     &     PTRACERS_Iter0,
     &     PTRACERS_numInUse,
     &     PTRACERS_advScheme,
     &     PTRACERS_ImplVertAdv,
     &     PTRACERS_useGMRedi,
     &     PTRACERS_useKPP,
     &     PTRACERS_useRecords,
     &     PTRACERS_initialFile,
     &     PTRACERS_names,
     &     PTRACERS_long_names,
     &     PTRACERS_units,
     &     PTRACERS_timeave_mdsio, PTRACERS_snapshot_mdsio,
     &     PTRACERS_pickup_write_mdsio, PTRACERS_pickup_read_mdsio,
     &     PTRACERS_monitor_stdio, PTRACERS_monitor_mnc,
     &     PTRACERS_timeave_mnc, PTRACERS_snapshot_mnc,
     &     PTRACERS_pickup_write_mnc, PTRACERS_pickup_read_mnc


C     pTracer  :: passive tracer concentration (tr per unit volume).
C     gPtr     :: work-space for time-stepping
C     gPtrNM1  :: work-space for time-stepping
      _RL  pTracer (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy,
     &              PTRACERS_num)
      _RL  gPtr    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy,
     &              PTRACERS_num)
      _RL  gPtrNM1 (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy,
     &              PTRACERS_num)
      _RL  surfaceForcingPtr (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy,
     &              PTRACERS_num)
      COMMON /PTRACERS_FIELDS/
     &              pTracer, gPtr, gPtrNM1, surfaceForcingPtr

CEOP
#endif /* ALLOW_PTRACERS */

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
