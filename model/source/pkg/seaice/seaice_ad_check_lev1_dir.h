CADJ STORE area          = comlev1, key = ikey_dynamics
CADJ STORE heff          = comlev1, key = ikey_dynamics
CADJ STORE hsnow         = comlev1, key = ikey_dynamics
CADJ STORE tice          = comlev1, key = ikey_dynamics
CADJ STORE runoff        = comlev1, key = ikey_dynamics
# ifdef SEAICE_ALLOW_DYNAMICS
CADJ STORE uvel          = comlev1, key = ikey_dynamics
CADJ STORE vvel          = comlev1, key = ikey_dynamics
CADJ STORE uice          = comlev1, key = ikey_dynamics
CADJ STORE vice          = comlev1, key = ikey_dynamics
# endif
# ifdef SEAICE_MULTILEVEL
CADJ STORE tices         = comlev1, key = ikey_dynamics
# endif
