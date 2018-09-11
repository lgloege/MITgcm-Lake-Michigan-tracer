C $Header: /u/gcmpack/MITgcm/pkg/ex3/EX3_OPTIONS.h,v 1.1 2005/10/14 05:49:42 edhill Exp $
C $Name:  $

#ifndef EX3_OPTIONS_H
#define EX3_OPTIONS_H
#include "PACKAGES_CONFIG.h"
#ifdef ALLOW_EX3

#include "CPP_OPTIONS.h"

C---  Package-specific options go here  ---

C     #define EX3_DEBUG


C---  Defines for MPI sizes  -------------------------------
C     Comment out the following to use:
C     .   MPI_DOUBLE_PRECISION  instead of  MPI_REAL8
C     .   MPI_REAL              instead of  MPI_REAL4
#define EX3_USE_MPI_REAL8

#ifdef EX3_USE_MPI_REAL8

#ifndef EX3_MPI_TYPE_RL
#define EX3_MPI_TYPE_RL MPI_REAL8
#endif
#ifndef EX3_MPI_TYPE_RS
#define EX3_MPI_TYPE_RS MPI_REAL8
#endif
#ifndef EX3_MPI_TYPE_R8
#define EX3_MPI_TYPE_R8 MPI_REAL8
#endif
#ifndef EX3_MPI_TYPE_R4
#define EX3_MPI_TYPE_R4 MPI_REAL4
#endif

#else

#ifndef EX3_MPI_TYPE_RL
#define EX3_MPI_TYPE_RL MPI_DOUBLE_PRECISION
#endif
#ifndef EX3_MPI_TYPE_RS
#define EX3_MPI_TYPE_RS MPI_DOUBLE_PRECISION
#endif
#ifndef EX3_MPI_TYPE_R8
#define EX3_MPI_TYPE_R8 MPI_DOUBLE_PRECISION
#endif
#ifndef EX3_MPI_TYPE_R4
#define EX3_MPI_TYPE_R4 MPI_REAL
#endif

#endif
C---  Defines for MPI sizes  -------------------------------


#endif /* ALLOW_EX3 */
#endif /* EX3_OPTIONS_H */


CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
