#!/bin/bash

# sleep 10s
# ./export_ICD.sh

for (( n=1; n<=5; n++))
do 
 sleep 10s
 ./export_ICD.sh
done

exit
