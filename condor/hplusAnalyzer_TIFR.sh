#!/bin/bash

#REFERENCE
#https://github.com/florez/CONDOR

#------------------------------------------------
#pass the arguments to Analysis/runMe.sh script 
#these arguments will go to the hplusAnalyzer.C
#------------------------------------------------

inNtupleFile=$1
outAnalFile=$2
outAnalDir=$3
date

#------------------------------------------------
#this script runs on some remote condor machine.
#link lxplus to this remote machine, using scram.
#copy the compiled lxplus package to this machine

#//////////// T3 /////////////////////////////////
echo "CONDOR DIR: $_CONDOR_SCRATCH_DIR"
cd ${_CONDOR_SCRATCH_DIR}
cp -r /home/rverma/t3store3/AN-18-061/Analyze2017Data/CMSSW_8_0_25/ .

#------------------------------------------------
#copy the lxplus package to the remote machine
#and run the codes at remote machine
#------------------------------------------------
cd CMSSW_8_0_25/src/HplusTMVA/
source /cvmfs/cms.cern.ch/cmsset_default.sh
eval `scram runtime -sh`
./runMe.sh $inNtupleFile $outAnalFile $outAnalDir

#---------------------------------------------
#copy the output from remote machine to the lxplus
#or to any other place e.g. Tier-2
#Remove the package, after copying the output
#------------------------------------------------
echo "OUTPUT: "
ls ${_CONDOR_SCRATCH_DIR}/CMSSW_8_0_25/src/HplusTMVA/13TeV/$outAnalDir
cp -rf ${_CONDOR_SCRATCH_DIR}/CMSSW_8_0_25/src/HplusTMVA/13TeV/$outAnalDir/* /home/rverma/t3store3/AN-18-061/CondorOut/AnalysisCondorOut/AllCondorOut
cd ${_CONDOR_SCRATCH_DIR}
rm -rf CMSSW_8_0_25
echo "DONE"
date

