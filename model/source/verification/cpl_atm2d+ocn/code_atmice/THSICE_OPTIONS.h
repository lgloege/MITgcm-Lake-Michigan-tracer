C $Header: /u/gcmpack/MITgcm/verification/cpl_atm2d+ocn/code_atmice/THSICE_OPTIONS.h,v 1.1 2009/09/02 21:59:42 jscott Exp $
C $Name:  $

#ifndef THSICE_OPTIONS_H
#define THSICE_OPTIONS_H
#include "PACKAGES_CONFIG.h"

#ifdef ALLOW_THSICE

#include "CPP_OPTIONS.h"

C- use continuous power-law function for partition of energy between lateral
C  melting/freezing and thinning/thickening ; otherwise, use step function.
#undef THSICE_FRACEN_POWERLAW

C- allow single grid-point debugging write to standard-output
#define ALLOW_DBUG_THSICE

C- only to check conservation
C  (change content of ICE_qleft,fresh,salFx-T files)
#undef CHECK_ENERGY_CONSERV

C CPP Macros go here

#endif /* ALLOW_THSICE */
#endif /* THSICE_OPTIONS_H */

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
