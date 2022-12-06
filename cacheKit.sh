#!/bin/bash

# check if vmtouch exist
which  vmtouch
if [ $? -ne 0 ]; then
  echo "no vmtouch exist"
  exit 1
else
  echo "vmtouch is installed~"
fi

# check if pcstat exist
which pcstat
if [ $? -ne 0 ]; then
  echo "no pcstat exist"
  exit 1
else
  echo "pcstat is installed~"
fi



function release_cache(){
  for file in `ls $1`
  do
    if [ -d $1"/"$file ]
    then
      release_cache $1"/"$file
    else
      lsof $1"/"$file
      if [ $? -ne 0 ]; then
        isCache=$(pcstat $1"/"$file | awk '{print $8}' | awk 'NR==4')
        if [ $isCache -eq "0" ]; then
          echo "file not cached:" $1"/"$file
        else
          vmtouch -ev $1"/"$file
          echo "evict file:" $1"/"$file
        fi
      fi
    fi
  done
}


release_cache $1
