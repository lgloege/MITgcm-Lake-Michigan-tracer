
# $Header: /u/gcmpack/MITgcm/pkg/ex3/README.txt,v 1.1 2005/10/14 05:49:42 edhill Exp $
# $Name:  $

 =======
   EX3
 =======


  =====  WARNING  =====

THIS PACKAGE IS *** UNFINISHED *** AND CONTAINS SHARP, JAGGED BITS
THAT ARE LIKELY TO LEAVE NASTY CUTS !!!

HANDLE IT AT YOUR OWN RISK !

  =====  WARNING  =====


This is the "ex3" package which stands for "EXchange v3" and it has
been designed to do everything that exch2 does with the following
advantages:

  0) EX3 works on more general topologies -- not just cubes!

  1) A simplified topology "encoding" is used that expresses how the
     tiles are connected to each other only in terms of cell indicies.
     It allows for all of the topologies within exch2 plus it has the
     following advantages:

     a) Only the cell indicies need to be input by a user -- all the
        "offsets" needed for exchanging quantities at cell corners,
        cell faces, etc. are calculated by the exchange routines
        themselves based upon the simpler cell indicies.

     b) Any number [n=0,1,2,3,4,...] of tiles may be adjacent at
        corner points with sufficient information supplied for the
        vorticity path integrals,

     c) The array-to-buffer and buffer-to-array copying have been
        almost completely separated from the logic and data structures
        which determine where the data sources/sinks are located.
        This should allow the "encoding" to change without altering
        the copying routines.

     d) Tiles with "internal" or "overlapping" connections are now
        easily represented.

  2) A more efficient exchange algorithm:

     a) For vector quantities and scalars defined at vorticity points,
        a simple "N+1" exchange is first performed to fill the values
        at the sNx+1 and sNy+1 points.  A second pass then fills all
        the remaining points within the exchange regions.  This
        correctly populates the values around the corners for any
        number of tiles meeting at a corner point.  This is also in
        contrast to the three-pass algorithm required by exch2.

     b) Vectors are packed into a single buffer, reducing the number
        of MPI messages.


The main disadvantage of the ex3 package is the removal of support for
MDSIO "global" files.  With the arrival of non-cube topologies, the
cube-oriented MDSIO global file option is not practical since it is
(1) not a dense encoding of the data and (2) will require a re-working
of the existing MDSIO code.

