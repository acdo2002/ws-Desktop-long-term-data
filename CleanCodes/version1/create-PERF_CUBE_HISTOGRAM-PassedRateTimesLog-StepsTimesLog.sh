#!/bin/bash

perftestname=('PERF_CUBE_HISTOGRAM') # 'PERF_CONTOUR_DATA' 'PERF_CUBE_HISTOGRAM' 'PERF_REGION_SPECTRAL_PROFILE' 'PERF_ANIMATION_PLAYBACK')
# lenperftest="${#perftestname[@]}"
ImageName=('cube_B_02400_z00100.fits' 'cube_B_04800_z00100.fits' 'cube_B_09600_z00100.fits' 'cube_B_19200_z00100.fits' 'cube_B_02400_z00100.image' 'cube_B_04800_z00100.image' 'cube_B_09600_z00100.image' 'cube_B_19200_z00100.image' 'cube_B_02400_z00100.hdf5' 'cube_B_04800_z00100.hdf5' 'cube_B_09600_z00100.hdf5' 'cube_B_19200_z00100.hdf5')
# echo "${#ImageName[@]}"

for perfname in "${perftestname[@]}"
do
# echo "$perfname"
rm -rf $perfname-PassedRateTimesLog.txt
rm -rf $perfname-Step1TimesLog.txt
rm -rf $perfname-Step2TimesLog.txt
# echo 'Date' 'Time' 'FailedNumber' 'PassedNumber' 'TotalNumber' 'TotalTimes'>>$perfname-PassedRateTimesLog.txt

perfFileList=`ls *$perfname*.txt | sed "s/.txt/ /g" `
 for n in $perfFileList
 do
 echo $n
 time=$(echo $n | cut -d '-' -f 3)
 date=$(echo $n | cut -d '-' -f4,5,6-)
 TestResults=`grep -n "Tests:" *$n*`
 echo $TestResults

  ExecuteTimes=`grep -n "Time:" *$n*`
 echo $ExecuteTimes
 read ReadTimesResultLine TotalTimes1 TotalTimes2 <<<${ExecuteTimes//[^0-9]/ }
 echo $TotalTimes1'.'$TotalTimes2

 if [[ $TestResults != *"passed"* ]]; then
#   echo $TestResults
  read ReadTestsResultLine NumOfFailed NumOfTotal <<<${TestResults//[^0-9]/ }
  echo $date $time $NumOfFailed '0' $NumOfTotal $TotalTimes1'.'$TotalTimes2>>$perfname-PassedRateTimesLog.txt
 elif [[ $TestResults != *"failed"* ]]; then
#    echo $TestResults
   read ReadTestsResultLine NumOfPassed NumOfTotal <<<${TestResults//[^0-9]/ }
   echo $date $time '0' $NumOfPassed $NumOfTotal $TotalTimes1'.'$TotalTimes2>>$perfname-PassedRateTimesLog.txt
 elif [[ $TestResults == *"failed"* && $TestResults != *"passed" ]]; then
#    echo $TestResults
   read ReadTestsResultLine NumOfFailed NumOfPassed NumOfTotal <<<${TestResults//[^0-9]/ }
   echo $date $time $NumOfFailed $NumOfPassed $NumOfTotal $TotalTimes1'.'$TotalTimes2>>$perfname-PassedRateTimesLog.txt
 fi 

 for img in $"${ImageName[@]}"
 do
 echo $img

 Step11=`cat *$n* | grep "$img" | grep "OPEN_FILE_ACK and REGION_HISTOGRAM_DATA" | sed "s/(Step 1)/ /g" | sed "s/$img/ /g"  `
 tempStep11=`echo $Step11 | tr -d '()'`
 
 Step12=`cat *$n* | grep "$img" | grep "SetImageChannels & SetCursor" | sed "s/(Step 1)/ /g" | sed "s/$img/ /g"  `
 tempStep12=`echo $Step12 | tr -d '()'`

 Step21=`cat *$n* | grep "$img" | grep "REGION_HISTOGRAM_DATA should arrive completely within" | sed "s/(Step 2)/ /g" | sed "s/$img/ /g"  `
 tempStep21=`echo $Step21 | tr -d '()'`
 echo $tempStep21
#  echo $tempStep11
#  echo $tempStep12
 if [[ $tempStep11 == *"Go to "* ]]; then
#   read time11 <<<${tempStep11//[^0-9]/ }
  if [[ $tempStep12 == *"Go to "* ]]; then
#    read time21 <<<${tempStep12//[^0-9]/ }
   echo $date $time $n $img '1' '7000' '7000' '5000' '5000'>>$perfname-Step1TimesLog.txt
  else
   read time21 time22 <<<${tempStep12//[^0-9]/ }
   echo $date $time $n $img '1' '7000' '7000' $time21 $time22>>$perfname-Step1TimesLog.txt
  fi
 else
  read time11 time12 <<<${tempStep11//[^0-9]/ }
  if [[ $tempStep12 == *"Go to "* ]]; then
   echo $date $time $n $img '1' $time11 $time12 '5000' '5000'>>$perfname-Step1TimesLog.txt
  else
   read time21 time22 <<<${tempStep12//[^0-9]/ }
   echo $date $time $n $img '1' $time11 $time12 $time21 $time22>>$perfname-Step1TimesLog.txt
  fi
 fi

 if [[ $tempStep21 == *"Go to "* ]]; then
  read time31 time32 <<<${tempStep21//[^0-9]/ }
  echo $date $time $n $img '2' $time31 $time31>>$perfname-Step2TimesLog.txt
 else
  read time31 time32 <<<${tempStep21//[^0-9]/ }
  echo $date $time $n $img '2' $time31 $time32>>$perfname-Step2TimesLog.txt
 fi

 done
 done
done



exit

