## 12/12/2007 this directory was created here. 
## develop ICE-cover module

necessary functions:
(1) set up initial conditions: rivers_init.F
                               rivers_readparms.F
Do-loop
no-use -- lake_model.F (12/18/2007)
(2-1) read input ice-fraction from file          :rivers_model.F
(2-2) interpolate ice-fraction in each time step :rivers_model.F
(2-3) compute intersction between ice and heat   :rivers_model.F
(2-4) monitor ice-fraction data
(3)  output if need: ?

  THE_MAIN_LOOP--? see ALLOW SEAICE options/ header file
  DO_OCEANIC_PHYS---:
                  |--- EXTERNAL_FORCING_SURF: use of surfaceForcingT

could be modified here
C     Heat Flux (restoring term) :
          surfaceForcingT(i,j,bi,bj) = 
     &      -lambdaThetaClimRelax(i,j,bi,bj) * (1-AREA(i,j,1,bi,bj))
     &         *(theta(i,j,ks,bi,bj)-SST(i,j,bi,bj))
     &         *drF(ks)*hFacC(i,j,ks,bi,bj)
    I should use AREA(,,,)

  PACKAGES_INIT_FIXED---
                      |--- RIVERS_INIT_FIXED

  PACKAGES_INIT_VARIABLES---
                          |--- RIVERS_INIT---
                          |                 |--- rivers_init_gen

  FORWARD_STEP---
               |--- RIVERS_GETFORCING :: External forcing package. ( pkg/rivers )
               |--- EXTERNAL_FIELDS_LOAD :: Control loading time dep. external data
               |                         :: Simple interpolcation between end-points
               |                            <-- no use for exf (define Qnet, fu,fv, <-- forcing variables))
               |                            Qnet, Qsw are set up at defined 
               |                            --> surface forcing term: surfaceForcingT
               |--- RIVERS_MODEL :: Compute sea-ice terms. ( pkg/seaice )  

  MONITOR---monitoring variable
          |--- RIVERS_MONITOR: 



   |-DO_THE_MODEL_IO---  :: Standard diagnostic I/O.  
                     |--- SEAICE_DO_DIAGS     :: SEAICE diags. see pkg/seaice  

  -RIVERS_READPARMS---
                  |--- PRINT_MESSAGE
                  |--- OPEN_COPY_DATA_FILE
                  |--- rivers_check
                  |--- cal_FullDate
                  |--- cal_TimePassed
                  |--- cal_ToSeconds
                  |--- rivers_summery

   vs. cal_set.F

# other pacages: exf
  exf_getforcing.F---
                   |--- exf_mapfields (Qnet=heat flux)
