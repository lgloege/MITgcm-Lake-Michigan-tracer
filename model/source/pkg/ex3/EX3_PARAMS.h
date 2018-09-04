C $Header: /u/gcmpack/MITgcm/pkg/ex3/EX3_PARAMS.h,v 1.2 2006/02/06 21:09:54 edhill Exp $
C $Name:  $

C     Character parameters
      CHARACTER*(MAX_LEN_FNAM) EX3_ATOPO_INAME
      CHARACTER*(MAX_LEN_FNAM) EX3_ATOPO_ONAME
      CHARACTER*(MAX_LEN_FNAM) EX3_ATOPO_OVER
      COMMON / EX3_PARAM_C /
     &     EX3_ATOPO_INAME, EX3_ATOPO_ONAME, EX3_ATOPO_OVER

C     EX3 send/receive buffers
      INTEGER EX3_MAX_BL
      PARAMETER ( EX3_MAX_BL = EX3_BUFF_FAC*(sNx*OLy + sNy*OLx)*Nr )
      _RL EX3_B_RL ( EX3_MAX_BL, 2*EX3_MAX_E_NBS, nSx*nSy )
      _RS EX3_B_RS ( EX3_MAX_BL, 2*EX3_MAX_E_NBS, nSx*nSy )
      _R4 EX3_B_R4 ( EX3_MAX_BL, 2*EX3_MAX_E_NBS, nSx*nSy )
      _R8 EX3_B_R8 ( EX3_MAX_BL, 2*EX3_MAX_E_NBS, nSx*nSy )
      COMMON / EX3_BUFF_RL /  EX3_B_RL
      COMMON / EX3_BUFF_RS /  EX3_B_RS
      COMMON / EX3_BUFF_R4 /  EX3_B_R4
      COMMON / EX3_BUFF_R8 /  EX3_B_R8

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
