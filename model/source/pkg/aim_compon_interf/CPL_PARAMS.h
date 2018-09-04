C $Header: /u/gcmpack/MITgcm/pkg/aim_compon_interf/CPL_PARAMS.h,v 1.2 2004/05/21 20:00:48 jmc Exp $
C $Name:  $

#ifdef COMPONENT_MODULE
C     *==========================================================*
C     | CPL_PARAMS.h
C     | o Header file for Coupling component interface
C     *==========================================================*
C     |   this version is specific to 1 component (atmos)
C     *==========================================================*

C--   COMMON /CPL_ATM_PAR_L/: logical parameters
C     cpl_earlyExpImpCall :: call coupler early in the time stepping call sequence
C     cpl_oldPickup :: restart from an old pickup (= until checkpoint 52m_post)
C     useImportMxlD :: True => use Imported Mix.Layer Detph from coupler
C     useImportSST  :: True => use the Imported SST from coupler
C     useImportSSS  :: True => use the Imported SSS from coupler
C     useImportVsq  :: True => use the Imported Surf. velocity^2
      COMMON /CPL_ATM_PAR_L/
     &  cpl_earlyExpImpCall, cpl_oldPickup,
     &  useImportMxlD, useImportSST, useImportSSS, useImportVsq

      LOGICAL cpl_earlyExpImpCall
      LOGICAL cpl_oldPickup
      LOGICAL useImportMxlD, useImportSST, useImportSSS, useImportVsq

C--   COMMON /CPL_ATM_PAR_I/: Integer valued parameters
C     cplSendFrq_iter :: send data to coupler every "cplSendFrq" iter
      COMMON /CPL_ATM_PAR_I/
     &  cplSendFrq_iter
      INTEGER cplSendFrq_iter

C--   COMMON /CPL_ATM_PAR_C/: Character valued parameters
c     CHARACTER*(MAX_LEN_FNAM) cpl_atmFile

C--   COMMON /CPL_ATM_PAR_R/: real-type parameters
C     cpl_atmSendFrq  :: Frequency^-1 for sending data to coupler (s)
c     COMMON /CPL_ATM_PAR_R/ 
c    &    cpl_atmSendFrq

#endif /* COMPONENT_MODULE */ 
