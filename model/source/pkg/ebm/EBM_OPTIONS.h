C $Header: /u/gcmpack/MITgcm/pkg/ebm/EBM_OPTIONS.h,v 1.1 2004/05/14 21:10:33 heimbach Exp $
C $Name:  $

C CPP options file for EBM package
C
C Use this file for selecting CPP options within the EBM package

#ifndef EBM_OPTIONS_H
#define EBM_OPTIONS_H
#include "PACKAGES_CONFIG.h"
#include "AD_CONFIG.h"
#ifdef ALLOW_EBM

#include "CPP_OPTIONS.h"

C CPP macros go here

#undef EBM_WIND_PERT
#undef EBM_CLIMATE_CHANGE
#undef EBM_VERSION_1BASIN

#endif /* ALLOW_EBM */
#endif /* CD_EBM_OPTIONS_H */
