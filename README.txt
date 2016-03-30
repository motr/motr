This is the master branch of Motr (MOuse TRacker)
======

Motr is a collaborative project between Janelia Farm and Caltech to
create a reliable, long-term multiple mice tracker.

Motr documentation can be found here: 
  
    http://motr.janelia.org/

This repository includes compiled binary MEX files for the 64-bit
Windows platform.  So if you plan to run Motr on 64-bit Windows, there
is no need to compile anything.  However, you will need the Microsoft
Visual C++ Redistributable for Visual Studio 2008, available here:

    https://www.microsoft.com/en-us/download/details.aspx?id=15336

(You want the one named vcredist_x64.exe.)

See the documentation for more details on downloading and installing
Motr.

Motr incorporates code from the Ctrax project
(http://ctrax.sourceforge.net), described in:

Branson, K., Robie, A. A., Bender, J., Perona, P. & Dickinson,
M. H. (2009). High-throughput ethomics in large groups of
Drosophila. Nature Methods 6:451-457. DOI:10.1038/nmeth.1328

In particular, the Motr GUI (Catalytic) for manually correcting 
tracks is a fork of the Ctrax FixErrors GUI for correcting fly 
tracks.

All code in Motr is licensed under the GNU General Public License,
Version 2 (GPLv2).


Release History
---------------

1.0   Nov 10, 2014     First puclicly available tagged release.

1.01  Nov 10, 2014     Added "Release History" section to README.txt.

1.02  Jan  4, 2015     Fixed small bug in Catalytic that reared when
                       first video frame had no contrast.

1.03  Mar 13, 2015     Catalytic now works properly when there are no 
                       suspicious sequences.  Also now prompts user 
                       to locate a missing movie file.

1.04  May  8, 2015     Performance improvements when reading .avi 
                       files.  Added utility function to convert 
                       .avi files to .mj2 files.

1.05  Feb 24, 2015     Added support for .ufmf files.  Added support
                       for higher-resolution videos.   Made Motr use
                       JAABA video-reading code, to add support for
                       even more video formats, and ease maintenance.
                       In several places, Motr will now prompt user to
                       locate a missing file.

1.06  Mar 30, 2015     Changed to release 2.0 of XMLTree.

