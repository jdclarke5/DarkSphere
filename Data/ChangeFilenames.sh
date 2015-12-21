M100=73
for M in `seq 0.74 0.01 1.77`;
do

echo $M
M100=`expr $M100 + 1`
M100=`printf "%03d" $M100`
echo $M100

mv data${M}.hdf5 data.0${M100}.hdf5

done
