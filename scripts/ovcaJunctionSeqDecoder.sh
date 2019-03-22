

#!/bin/bash
#This script builds a file decoder for use with downstream analysis tools by parsing relevant fields from the filenames provided in a list of files of interest
#we attempt to extract the following from the filename: 
#SAMPLE_ID
#PATIENT_ID
#TIMEPOINT
#BATCH
#FILELOC
#We have somewhat inconsistent filestructure, so we test batch first and select the downstream parsing methods by batch
#the filelist can be obtained using find ie
set -eou pipefail
################ CREATE NEEDED VARIABLES #########################
fileList="/mnt/mobydisk/groupshares/alee/shared/ovarian_Cancer_Project/analysis/exon-expression/JunctionSeqFromQoRts/ovca/ovca-decoder.txt"
outputName=$1
header="SAMPLE_ID\tPATIENT_ID\tTIMEPOINT\tBATCH\tFILELOC"
FILELOCstem="/mnt/mobydisk/groupshares/alee/shared/ovarian_Cancer_Project/analysis/exon-expression/JunctionSeqFromQoRts/ovca/"
#sampleList='/mnt/mobydisk/groupshares/alee/shared/ovarian_Cancer_Project/tumor_Samples/AOCS_Samples/AOCSSampleList.txt'

printf "%s\t%s\t%s\t%s\t%s\n" "SAMPLE_ID" "PATIENT_ID" "TIMEPOINT" "BATCH" "FILELOC" > "${outputName}"

while read sample
do

#The parser is written to record absolute file locations, so the filelist should be generated upstream of tumor_Samples/ to allow that
FILELOCpre="${sample}""/QC.spliceJunctionAndExonCounts.forJunctionSeq.txt.gz"
FILELOC="${FILELOCstem}""/""${FILELOCpre}"

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
