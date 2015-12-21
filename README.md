# DarkSphere
PLUTO code for plasma wind interaction with a spherical obstacle (2D, aligned B field)

If you would like to run the below simulations you will first need to install the PLUTO simulation framework. The below were run using PLUTO v4.2 with CHOMBO v3.2 for adaptive mesh refinement, in order to simulate on a 2048x2048 equivalent grid. However, similar results can be obtained even on a 256x256 uniform grid without CHOMBO. In the following I will assume you have already read the very good documentation available at http://plutocode.ph.unito.it/files/userguide.pdf, and have the test problems running and working.

## Description of files

### /PLUTO

Herein lies the DarkSphere PLUTO simulation code files.

**definitions.h**: Sets up the 2D MHD simulation parameters. We declare two user input parameters, `MACH` and `BFIELD`, which are defined as the plasma wind mach number and the (aligned) B field strength respectively [their values are NOT set here]. We also set some `UNIT_VALUES`, but thanks to the scaling properties of the MHD equations (and the fact we are interested in only the steady state solutions) it doesn't really matter what these are except to avoid numerical small/large number problems.

**pluto.ini**: Once the pluto simulation has been made, this is the file you can feed in to change parameters for the run. **[Grid]** We run with 128x128 initial uniform grid (with 4 levels of AMR this becomes 2048x2048). **[Time]** Here tstop is set to 2000, which is overkill for the supersonic simulations, but necessary for subsonic, since matter can propagate upwind and interact with the inflow boundary. The user should run several test runs to make sure the system has come to an approximately stable configuration by time tstop. **[Boundary]** Note here that (X1,X2) are the (radial,theta) coordinates [NOT cartesian]. The X1-BEG boundary should be set to `userdef` for the Moon-like case and `reflective` for the Venus-like case [see the `init.c` file]. **[Chombo HDF5 output]** The output is set only to write the last frame to file; obviously this can be changed for testing purposes. **[Parameters]** Here one can set the input MACH and BFIELD.

**init.c**: The plasma is initialised with flat density, pressure, and velocity. Most of the action is in the `UserDefBoundary` function. We first have an **INTERNAL_BOUNDARY** condition which puts a floor on the density; this doesn't come into play for the unmagnetised simulations but can be necessary for highly magnetised simulations (such as Moon-like with BFIELD = 1). The **X1_END** boundary condition is the inflow/outflow conditions for theta above/below pi/2. The **X1_BEG** boundary is the dark sphere surface, and should be called only for the Moon-like case; it is absorbing for the windward side and reflective for the leeward side. If the user would like, the **X2_END** boundary condition can be used for the supersonic Moon-like simulations as the inflow boundary with theta=[0,pi/2] in `pluto.ini` (since why bother simulating the upwind conditions when there is no upwind activity!).

### /Data

**data.0130.hdf5**: Output data type for CHOMBO simulations. This particular file is our output for Venus-like with MACH = 1.3.

**xxxM1.30.dbl**: Output data type for uniform simulations. These files are actually created from the .hdf5 file using the python script `MakeDataFiles.py`.

**MakeDataFiles.py**: Takes in the .hdf5 files and spits out .dbl files where only every *Sk* cells are read. With e.g. Sk=8 this reduces the 2048x2048 tables to 256x256, for testing and/or to speed up the downstream analysis. It requires a working implementation of `h5py` and `pyPLUTO` (see the PLUTO documentation).

**ChangeFileNames.sh**: A shell script to change the data output file names from the job scripts [in /jobMaker] into a format `data.xxxx.hdf5` which can be read in using `pyPLUTO`.

**MakePlot.py**: Uses `pyPLUTO` to read in .hdf5 files and make a plot of e.g. density.

**Plot 130.png**: Example output from `MakePlot.py` of the density for MACH = 1.3 Venus-like simulation.

### /jobMaker

**jobMakerMoon.sh**: If you have a cluster system here is a script which will make job submit files for each MACH number you would like to run (here we have Moon-like simulations with MACH = 0.74:1.77 in steps of 0.01). Each job navigates to the location above where you already have a compiled and working version of the DarkSphere PLUTO code, copies that folder to a Temp folder, moves inside it and overwrites the `pluto.ini` file for the appropriate MACH, runs pluto, copies the output data file to some location, and then deletes the Temp folder. You can submit all the jobs (here with `qsub`) by running the `JobSubmitter.sh` file created alongside all the jobs. 


