#! /bin/bash

ssh -N -L 12323:10.0.0.131:22 -L 12324:10.0.0.122:22 -L 12325:10.0.0.129:22 silo7.sciencedata.dk
