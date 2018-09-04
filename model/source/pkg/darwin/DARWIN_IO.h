#include "GCHEM_OPTIONS.h"

c DARWIN_IO.h
c --------------------------------------------------------------------
c  Description:  input and daignostic output for DARWIN pkg
c          Stephanie Dutkiewicz: Spring 2006
c NOTE: additional diagnostics still needed
c --------------------------------------------------------------------      
c INPUT:
c    fice           - ice fraction
c    inputFe        - aeolian input of iron
c    sur_par        - surface PAR
      COMMON /DARWIN_INPUT/
     &       fice, inputFe, sur_par
c
       _RL   fice(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
       _RL   inputFe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
       _RL   sur_par(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)

c
c OUPUT DIAGNOSTICS
c    PPave        - average primary production
c    Zoograzave   - average zooplankton consumption
c    Parave       - average PAR
c    Chlave       - average chlorophyll
c    npzd_timeave  - time for averaging

      COMMON /DARWIN_OUPUT/
     &      PPave, Zoograzave,
     &      Parave, Chlave,
     &      npzd_timeave
c  
       _RL  PPave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  Zoograzave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  Parave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  Chlave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  NPZD_timeave(nR,nSx,nSy)

