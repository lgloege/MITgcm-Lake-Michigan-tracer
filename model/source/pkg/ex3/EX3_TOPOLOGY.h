C $Header: /u/gcmpack/MITgcm/pkg/ex3/EX3_TOPOLOGY.h,v 1.3 2006/02/06 21:09:54 edhill Exp $
C $Name:  $

C     Tile topology data
C
C     .           N
C     .    C4     E3     C3
C     .      +---------+
C     .      |         |
C     .      |         |
C     . W E4 |         | E2  E
C     .      |         |
C     .      |         |
C     .      +---------+
C     .    C1     E1     C2
C     .           S
C
C     =====  "Global" Topology  =====
C
C     The following "global" variables define a tile topology and are
C     invariant with respect to the model decomposition (that is, the
C     sets of threads & MPI processes) used.
C
C     ex3_affm           :: The eight possible 2x2 affine matricies
C     .                     for vector rotations and permutations
C     .                     between two orthogonal, adjacent grids
C     
C     ex3_t_num          :: total number of tiles
C     ex3_t_iproc(t)     :: MPI process ID for each tile
C     ex3_t_ori(t)       :: tile orientation (1=rh, -1=lh)
C     ex3_t_nxy(t)       :: number of X,Y cells in each tile
C     
C     ex3_f_ind(t)       :: face index for each tile
C     ex3_f_nxy(2,t)     :: face number of X,Y cells
C     ex3_f_oij(2,t)     :: face i,j offsets (0 for face==tile)
C     .
C     ex3_e_n(t)         :: number of E-neighbors
C     ex3_e_iam(e,t)     :: E-neighbor affine matrix index
C     ex3_e_iopt(e,t)    :: E-neighbor global tile index for the 
C     .                       opposing tile
C     ex3_e_iope(e,t)    :: E-neighbor edge index for the 
C     .                       opposing tile
C     ex3_e_dat(k,d,e,t) :: E-neighbor information for each tile
C     .                           /  1  -->  edge-alignment flag:
C     .                           |            0    : seam is NOT along
C     .                           |                   this direction
C     .                           |            1,-1 : interior is +,-
C     .                           |                   and use OLx,OLy
C     .                       k = |            -ow- : use width value 
C     .                           |                   from 3 below
C     .                           |  2  -->  first cell index or the 
C     .                           |            abutting *inside* cell
C     .                           |  3  -->  last  cell index or the 
C     .                           |            exchange width as a 
C     .                           \            distance and direction
C     .                       d =   1,2 -->  i,j directions
C     .                       e =  E-neighbor index
C     .                       t =  tile index
C
C     ex3_c_n(4,t)       :: number of C-neighbors at each corner
C     ex3_c_ind(k,4,t)   :: tile index for each C-neighbor 
C     ex3_c_num(k,4,t)   :: tile corner number for each C-neighbor
C     .                        1  -->  SW
C     .                        2  -->  SE  (per above diagram)
C     .                        3  -->  NE
C     .                        4  -->  NW
C     ex3_c_ori(k,4,t)   :: tile orientation for each C-neighbor
C
C
C     =====  "Local" Topology  =====
C
C     The following "local" variables are dependent upon the particular
C     model decomposition (threads & MPI processes) used.
C
C     ex3_p_ntile        :: number of tiles associated with this 
C     .                       (eg. MPI) process
C     ex3_p_itile(m)     :: global indicies of the tiles associated
C     .                       with this MPI process [myBxLo..myBxHi]
C     
C     ex3_e_iopt_il(e,t) :: tile locality flag:
C     .                       -1: tile is not in local memory
C     .                        1: local tile index ("bibj")
      
      INTEGER
     &     ex3_affm(4,8)
      INTEGER
     &     ex3_t_num,
     &     ex3_t_iproc(EX3_MAX_TILES),
     &     ex3_t_ori(EX3_MAX_TILES),
     &     ex3_t_nxy(2,EX3_MAX_TILES),
     &     ex3_f_ind(EX3_MAX_TILES),
     &     ex3_f_nxy(2,EX3_MAX_TILES),
     &     ex3_f_oij(2,EX3_MAX_TILES),
     &     ex3_e_n(EX3_MAX_TILES),
     &     ex3_e_iam(EX3_MAX_E_NBS,EX3_MAX_TILES),
     &     ex3_e_iopt(EX3_MAX_E_NBS,EX3_MAX_TILES),
     &     ex3_e_iope(EX3_MAX_E_NBS,EX3_MAX_TILES),
     &     ex3_e_dat(3,2,EX3_MAX_E_NBS,EX3_MAX_TILES),
     &     ex3_c_n(4,EX3_MAX_TILES),
     &     ex3_c_ind(EX3_MAX_C_NBS,4,EX3_MAX_TILES),
     &     ex3_c_num(EX3_MAX_C_NBS,4,EX3_MAX_TILES),
     &     ex3_c_ori(EX3_MAX_C_NBS,4,EX3_MAX_TILES)

      COMMON / EX3_TOPO_GLOBAL /
     &     ex3_affm,
     &     ex3_t_num,
     &     ex3_t_iproc,
     &     ex3_t_ori,
     &     ex3_t_nxy,
     &     ex3_f_ind,
     &     ex3_f_nxy,
     &     ex3_f_oij,
     &     ex3_e_n,
     &     ex3_e_iam,
     &     ex3_e_iopt,
     &     ex3_e_iope,
     &     ex3_e_dat,
     &     ex3_c_n,
     &     ex3_c_ind,
     &     ex3_c_num,
     &     ex3_c_ori

      INTEGER
     &     ex3_p_ntile,
     &     ex3_p_itile(EX3_MAX_TILES),
     &     ex3_e_iopt_il(EX3_MAX_E_NBS,EX3_MAX_TILES)

      COMMON / EX3_TOPO_LOCAL /
     &     ex3_p_ntile,
     &     ex3_p_itile,
     &     ex3_e_iopt_il


CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
