This is the master branch of Motr (MOuse TRacker)
======

Motr is a collaborative project between Janelia Farm and Caltech to
create a reliable, long-term multiple mice tracker.

Motr documentation can be found here: 
  
    http://motr.janelia.org/

This repository includes compiled binary MEX files for the 64-bit
Windows platform.  So if you plan to run Motr on 64-bit Windows, there
is no need to compile anything.  However, you will need the Microsoft
Visual C++ Reditributable for Visual Studio 2012, available here:

    http://www.microsoft.com/en-us/download/details.aspx?id=30679

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

