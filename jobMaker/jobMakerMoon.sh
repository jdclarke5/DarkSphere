rm -rf /[yourJobSubmitterFolder]
mkdir /[yourJobSubmitterFolder]

for M in `seq 0.74 0.01 1.77`;
do

printf "

#!/bin/bash

#PBS -N PLUTO_MOON_${M}
#PBS -j oe

#PBS -q long

date

cd [yourFolderContainingBuiltPlutoSim]
cp -rf [yourSim] [yourSim]Temp${M}
cd [yourSim]Temp${M}

# Write the pluto.ini file
echo \"[Grid]

X1-grid    1    1.0    128   u    12.0
X2-grid    1    0.0    128   u    3.14159265359
X3-grid    1    0.0    1      u    1.0

[Chombo Refinement]

Levels           4
Ref_ratio        2 2 2 2 2
Regrid_interval  2 2 2 2
Refine_thresh    0.3
Tag_buffer_size  3
Block_factor     8
Max_grid_size    64
Fill_ratio       0.75

[Time]

CFL              0.4
CFL_max_var      1.1
tstop            2000.0
first_dt         1.e-4

[Solver]

Solver         hll

[Boundary]

X1-beg        userdef
X1-end        userdef
X2-beg        axisymmetric
X2-end        axisymmetric
X3-beg        outflow
X3-end        outflow

[Static Grid Output]

uservar    0
dbl        2.0  -1   multiple_files
flt       -1.0  -1   single_file
vtk       -1.0  -1   single_file
dbl.h5    -1.0  -1
flt.h5    -1.0  -1
tab       40.0  -1   multiple_files
ppm       -1.0  -1
png       -1.0  -1
log        1
analysis  -1.0  -1

[Chombo HDF5 output]

Checkpoint_interval  -1.0  0
Plot_interval         2000.0  0

[Parameters]

MACH                 ${M}
BFIELD              0.0\" > pluto.ini

export LD_LIBRARY_PATH=\"[yourLocationFor]/HDF5-serial/lib:\"$LD_LIBRARY_PATH

# Run pluto
./pluto > log.log

# Copy output array(s) to Data folder
cp -f data.0001.hdf5 [yourLocationForData]/data${M}.hdf5

cd ../
rm -rf [yourSim]Temp${M}

date

"> ./[yourJobSubmitterFolder]/PLUTOjob_$M.sh

echo qsub PLUTOjob_$M.sh >> ./[yourJobSubmitterFolder]/JobSubmitter.sh

done
