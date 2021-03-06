C $Header: /u/gcmpack/MITgcm/pkg/dic/dic_aver_final.F,v 1.4 2005/08/18 18:24:29 stephd Exp $
C $Name:  $

cswdcost -- add sunroutine ---
#include "DIC_OPTIONS.h"
#include "GCHEM_OPTIONS.h"


CStartOfInterFace
      SUBROUTINE DIC_AVER_FINAL(
     I           myThid)

C     /==========================================================\
C     | SUBROUTINE DIC_AVER_FINAL  i                            |
C     |==========================================================|
      IMPLICIT NONE

C     == GLobal variables ==
#include "SIZE.h"
#include "DYNVARS.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS.h"
#include "GCHEM.h"
#include "DIC_ABIOTIC.h"
#ifdef DIC_BIOTIC
#include "DIC_BIOTIC.h"
#include "DIC_DIAGS.h"
#include "DIC_COST.h"
#endif
#ifdef ALLOW_SEAICE
#include "ICE.h"
#endif

C     == Routine arguments ==
      INTEGER myIter
      _RL myTime
      INTEGER myThid

#ifdef ALLOW_DIC_COST

C     == Local variables ==
      INTEGER i, j, bi, bj, k, it
      _RL rdt
      INTEGER nForcingPeriods,Imytm,Ifprd,Ifcyc,Iftm

cswddmonth -- end-
c
C      Normalize by integrated time
       DO bj = myByLo(myThid), myByHi(myThid)
        DO bi = myBxLo(myThid), myBxHi(myThid)
         CALL TIMEAVE_NORMALIZ(PO4ann, OBS_timetave, nR ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(O2ann, OBS_timetave, nR ,
     &                 bi,bj,myThid)
cswdmonth-add
         CALL TIMEAVE_NORMALIZ(PO4lev1, OBSM_timetave, 12 ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(PO4lev2, OBSM_timetave, 12 ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(PO4lev3, OBSM_timetave, 12 ,
     &                 bi,bj,myThid)
cQQ      CALL TIMEAVE_NORMALIZ(PO4lev4, OBSM_timetave, 12 ,
cQQ  &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(O2lev1, OBSM_timetave, 12 ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(O2lev2, OBSM_timetave, 12 ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(O2lev3, OBSM_timetave, 12 ,
     &                 bi,bj,myThid)
cQQ      CALL TIMEAVE_NORMALIZ(O2lev4, OBSM_timetave, 12 ,
cQQ  &                 bi,bj,myThid)
cswdmonth -end-
        ENDDO 
       ENDDO
#endif
c
      RETURN
      END
cswd -- end added subroutine --
