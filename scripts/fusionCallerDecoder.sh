#!/bin/bash
#This script builds a file decoder for use with downstream analysis tools by parsing relevant fields from the filenames provided in a list of files of interest
#we attempt to extract the following from the filename: 
#SAMPLE_ID
#PATIENT_ID
#TIMEPOINT
#BATCH
#ILELOC
#We have somewhat inconsistent filestructure, so we test batch first and select the downstream parsing methods by batch
#the filelist can be obtained using find iefind . -wholename "*FusionCatcher*1.00*final-list_candidate-fusion-genes.txt"   
#the input filelist may be generated by the findAndPrepFusionCallerOutputs.sh script

set -eou pipefail

################ CREATE NEEDED VARIABLES #########################

#We'll record the date for recordkeeping purposes
today=$(date +"%d%m%Y")

#the input fileList is looped over to generate the parsed output
fileList=$1
header="SAMPLE_ID\tPATIENT_ID\tTIMEPOINT\tBATCH\tFILELOC"
FILELOCstem="/mnt/mobydisk/groupshares/alee/shared/ovarian_Cancer_Project/tumor_Samples/"
#sampleList='/mnt/mobydisk/groupshares/alee/shared/ovarian_Cancer_Project/tumor_Samples/AOCS_Samples/AOCSSampleList.txt'

printf "%s\t%s\t%s\t%s\t%s\n" "SAMPLE_ID" "PATIENT_ID" "TIMEPOINT" "BATCH" "FILELOC" >> $2"/fusionCatcherDecoded_""${today}"".tsv"
printf "%s\t%s\t%s\t%s\t%s\n" "SAMPLE_ID" "PATIENT_ID" "TIMEPOINT" "BATCH" "FILELOC" >> $2"/STARFusionDecoded_""${today}"".tsv"

while read sample
do

#The parser is written to record absolute file locations, so the filelist should be generated upstream of tumor_Samples/ to allow that
FILELOC="${sample}"

#the output file location and name are parsedv
if echo "${sample}" | grep -q "STARFusion"; then
    outputName=$2"/STARFusionDecoded_""${today}"".tsv"
    
elif echo "${sample}" | grep -q "FusionCatcher"; then
    outputName=$2"/fusionCatcherDecoded_""${today}"".tsv"
fi


#we construct the input and output based on the paired directory structure
if echo "${sample}" | grep -q "AOCS"; then
  
  BATCH="AOCS"
  SAMPLE_ID=$(echo "${sample}" | sed -e 's/.*\(AOCS-OV-[0-9][0-9][0-9][0-9]-[0-9][0-9]\).*/\1/')
  PATIENT_ID=$(echo "${sample}" | sed -e 's/.*AOCS-OV-\([0-9][0-9][0-9][0-9]\).*/\1/')

  if echo "${sample}" | grep -q "02"; then
    TIMEPOINT="Late"
  else
    TIMEPOINT="Early"
  fi

elif echo "${sample}" | grep -q "TCGA"; then
  
  BATCH="TCGA"
  SAMPLE_ID=$(echo "${sample}" | sed -e 's/.*\(TCGA-[0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9]\).*/\1/')
  PATIENT_ID=$(echo "${sample}" | sed -e 's/.*TCGA-\([0-9][0-9]-[0-9][0-9][0-9][0-9]\).*/\1/')

  if echo "${sample}" | grep -q "02"; then
    TIMEPOINT="Late"
  else
    TIMEPOINT="Early"
  fi

elif echo "${sample}" | grep -q "CCLE"; then
  BATCH="CCLE"
  TIMEPOINT="None"

elif echo "${sample}" | grep -q "OVCA_"; then

  BATCH="FROZEN"
  SAMPLE_ID=$(echo "${sample}" | sed -e 's/.*\(OVCA_[0-9][0-9]_[A-Z][0-9]\).*/\1/')
  PATIENT_ID=$(echo "${sample}" | sed -e 's/.*\(OVCA_[0-9][0-9]\)_[A-Z][0-9].*/\1/')


  if echo "${sample}" | grep -q "L[1-2]"; then
    TIMEPOINT="Late"
  else
    TIMEPOINT="Early"
  fi

fi

printf '%s\t%s\t%s\t%s\t%s\n' "${SAMPLE_ID}" "${PATIENT_ID}" "${TIMEPOINT}" "${BATCH}" "${FILELOC}" >> "${outputName}"

done < "${fileList}"