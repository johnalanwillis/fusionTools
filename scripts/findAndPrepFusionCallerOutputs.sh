#!/bin/bash
#this script runs a simple find command for each of the fusion callers of interest
#the sample details are parsed from the filename

######Declare Key Vars############
#the script takes a runLoc as an input
#it specifies where the find commands will be run from
runLoc=$1
#the script takes a outLoc as an input
#it specifies where the output files will be written
outLoc=$2


####################Run Script Componenets###############
##########FusionCatcher#####################
#finds fusionCatcher outputs from the runLoc adn records them in a text file
#the output is saved to "${outLoc}""/fusionCatcherFileLocs.txt"
fCatcherLocsFile="${outLoc}""/fusioncatcher_V1.00_outputLocs.txt"

find "${runLoc}" -wholename "*FusionCatcher*1.00*final-list_candidate-fusion-genes.txt" > \
  "${fCatcherLocsFile}"

#Next parsse those ouptput locs with the parser scripts
bash ~/projects/FusionTools/FusionTools/scripts/fusionCallerDecoder.sh \
    "${fCatcherLocsFile}" \
    "${outLoc}"


#next read in the oncofuse data the same way
oncofuseFromFCatcherLocsFile="${outLoc}""/oncofuseFromFusioncatcher_V1.00_outputLocs.txt"

find "${runLoc}" -wholename "*OncoFuseFromFusionCatcher*OncoFuseFromFusionCatcher-v1.00.tsv" > \
    "${oncofuseFromFCatcherLocsFile}"

#Next parsse those ouptput locs with the parser scripts
bash ~/projects/FusionTools/FusionTools/scripts/fusionCallerDecoder.sh \
    "${oncofuseFromFCatcherLocsFile}" \
    "${outLoc}"



##########STARFusion#####################
#finds fusionCatcher outputs from the runLoc adn records them in a text file
#the output is saved to "${outLoc}""/fusionCatcherFileLocs.txt"
sFusionLocsFile="${outLoc}""/STARFusion_V1.5_outputLocs.txt"

find "${runLoc}" -wholename "*STARFusion*1.5*/star-fusion.fusion_predictions.tsv" > \
  "${sFusionLocsFile}"

#Next parsse those ouptput locs with the parser scripts
bash ~/projects/FusionTools/FusionTools/scripts/fusionCallerDecoder.sh \
    "${sFusionLocsFile}" \
    "${outLoc}"

#next read in the oncofuse data the same way
oncofuseFromSFusionLocsFile="${outLoc}""/oncofuseFromSTARFusion_V1.5_outputLocs.txt"

find "${runLoc}" -wholename "*OncoFuseFromSTARFusion*OncoFuseFromSTARFusion-v1.5.tsv" > \
    "${oncofuseFromSFusionLocsFile}"

#Next parsse those ouptput locs with the parser scripts
bash ~/projects/FusionTools/FusionTools/scripts/fusionCallerDecoder.sh \
    "${oncofuseFromFCatcherLocsFile}" \
    "${outLoc}"



