C $Header: /u/gcmpack/MITgcm/verification/dic_example/code/GCHEM_OPTIONS.h,v 1.4 2005/07/21 19:01:53 stephd Exp $
C $Name:  $

#ifndef GCHEM_OPTIONS_H
#define GCHEM_OPTIONS_H
#include "PACKAGES_CONFIG.h"
#ifdef ALLOW_GCHEM

#include "CPP_OPTIONS.h"

CBOP
C    !ROUTINE: GCHEM_OPTIONS.h
C    !INTERFACE:

C    !DESCRIPTION:
c options for biogeochemistry package
CEOP

#define GCHEM_SEPARATE_FORCING
#undef  DIC_BIOTIC
#undef  ALLOW_FE
#undef  CAR_DISS
#undef  READ_PAR
#undef  MINFE

#endif /* ALLOW_GCHEM */
#endif /* GCHEM_OPTIONS_H */
