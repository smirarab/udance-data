python levelorder_blratio.py sim16k/udance.maxqs.nwk.nodert | sed "s/$/\tsim/g" > bratiosl_level.csv
python levelorder_blratio.py 16k/06-12-2022-16k-v4-loof-backbonenextiter.nwk.rt | sed "s/$/\treal/g" >> bratiosl_level.csv
