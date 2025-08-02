#!/bin/bash

git clone https://github.com/ehabets/RIR-Generator.git
cd RIR-Generator
matlab -batch "mex -setup C++; mex rir_generator.cpp rir_generator_core.cpp"
cd ..
echo "Changing RIR directory name"
mv RIR-Generator RIR
echo "Done installing and compiling RIR Generator"
sleep 5
