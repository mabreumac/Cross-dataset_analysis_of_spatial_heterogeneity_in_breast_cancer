#!/bin/bash

FILENAME="filenames.txt"

LINES=$(cat $FILENAME)

for LINE in $LINES
do
    echo sbatch trimSample.sh $LINE
done
