
c     Define dummy weights as a placeholder
      common /ctrl_weights_dummy_r/
     &                        wtheta, wsalt
      _RL wtheta   ( nr,nsx,nsy )
      _RL wsalt    ( nr,nsx,nsy )

#if (defined (ALLOW_OBCSN_COST_CONTRIBUTION) || defined (ALLOW_OBCSN_CONTROL))
      common /ctrl_cost_weights_obcsn/
     &                      wobcsn, wobcsnLev
      _RL wobcsn     (                      nr,nobcs)
      _RL wobcsnLev  (1-olx:snx+olx,nr,nsx,nsy,nobcs)
#endif
#if (defined (ALLOW_OBCSS_COST_CONTRIBUTION) || defined (ALLOW_OBCSS_CONTROL))
      common /ctrl_cost_weights_obcss/
     &                      wobcss, wobcssLev
      _RL wobcss     (                      nr,nobcs)
      _RL wobcssLev  (1-olx:snx+olx,nr,nsx,nsy,nobcs)
#endif
#if (defined (ALLOW_OBCSW_COST_CONTRIBUTION) || defined (ALLOW_OBCSW_CONTROL))
      common /ctrl_cost_weights_obcsw/
     &                      wobcsw, wobcswLev
      _RL wobcsw     (                      nr,nobcs)
      _RL wobcswLev  (1-oly:sny+oly,nr,nsx,nsy,nobcs)
#endif
#if (defined (ALLOW_OBCSE_COST_CONTRIBUTION) || defined (ALLOW_OBCSE_CONTROL))
      common /ctrl_cost_weights_obcse/
     &                      wobcse, wobcseLev
      _RL wobcse     (                      nr,nobcs)
      _RL wobcseLev  (1-oly:sny+oly,nr,nsx,nsy,nobcs)
#endif
