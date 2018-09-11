C$Header: /u/gcmpack/MITgcm/pkg/gchem/gchem_fields_load.F,v 1.5 2005/08/18 19:29:51 stephd Exp $
C$Name:  $

#include "GCHEM_OPTIONS.h"

CBOP
C !ROUTINE: GCHEM_FIELDS_LOAD

C !INTERFACE: ==========================================================
      SUBROUTINE GCHEM_FIELDS_LOAD (
     I           myTime,myIter, myThid)

C !DESCRIPTION:
C  calls routines which read in fields needed for any tracer experiment
C  modified w/ exf: calendar system 12/17/2007
C !USES: ===============================================================
      IMPLICIT NONE
      INTEGER myThid, myIter
      _RL myTime 

C !INPUT PARAMETERS: ===================================================
C  myThid               :: thread number
C  myIter               :: current timestep
C  myTime               :: current timestep

C !LOCAL VARIABLES: ====================================================
CEOP

#ifdef ALLOW_GCHEM

         _BEGIN_MASTER( mythid )
c
c
cccccccccccccccccccccccccc
c load external data     c
cccccccccccccccccccccccccc
#ifdef ALLOW_DIC
       call  DIC_FIELDS_LOAD (myIter,myTime,myThid)
#endif

c
#ifdef ALLOW_CFC
       call CFC_FIELDS_LOAD(myIter,myTime,myThid)
#endif

#ifdef ALLOW_DARWIN
       call DARWIN_FIELDS_LOAD(myIter,myTime,myThid)
#endif

c$$$#ifdef ALLOW_NPZDCAR
c$$$       call NPZDCAR_FIELDS_LOAD(myIter,myTime,myThid)
c$$$#endif
c ALLOW_EXF stuff commented out by Lukes
c#ifdef ALLOW_EXF
c       call NPZDCAR_FIELDS_LOAD_EXF(myIter,myTime,myThid)
c#else
c       call NPZDCAR_FIELDS_LOAD(myIter,myTime,myThid)
c#endif

         _BARRIER


         _END_MASTER(mythid)

#endif /* ALLOW_GCHEM */

      RETURN
      END

