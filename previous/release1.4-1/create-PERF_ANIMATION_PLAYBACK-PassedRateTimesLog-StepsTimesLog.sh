#!/bin/bash

perftestname=('output-PERF_ANIMATION_PLAYBACK_FITS') #
# lenperftest="${#perftestname[@]}"
# ImageName=('cube_B_02400_z00100.fits' 'cube_B_04800_z00100.fits' 'cube_B_09600_z00100.fits' 'cube_B_19200_z00100.fits' 'cube_B_02400_z00100.image' 'cube_B_04800_z00100.image' 'cube_B_09600_z00100.image' 'cube_B_19200_z00100.image' 'cube_B_02400_z00100.hdf5' 'cube_B_04800_z00100.hdf5' 'cube_B_09600_z00100.hdf5' 'cube_B_19200_z00100.hdf5')
ImageName=('cube_B_09600_z00100.fits')
# 'cube_B_09600_z00100.image' 'cube_B_09600_z00100.hdf5')
# echo "${#ImageName[@]}"

for perfname in "${perftestname[@]}"
do
# echo "$perfname"
rm -rf $perfname-PassedRateTimesLog.txt
rm -rf $perfname-Step1TimesLog.txt
rm -rf $perfname-Step2TimesLog.txt
# echo 'Date' 'Time' 'FailedNumber' 'PassedNumber' 'TotalNumber' 'TotalTimes'>>$perfname-PassedRateTimesLog.txt

perfFileList=`ls $perfname*.txt | sed "s/.txt/ /g" `
 for n in $perfFileList
 do
 echo $n
 perfFileListLine=`sed '/^$/d' $n.txt | wc -l`
 echo $perfFileListLine

 if [[ "$perfFileListLine" -ne "1" ]]; then
 time=$(echo $n | cut -d '-' -f 3)
 date=$(echo $n | cut -d '-' -f4,5,6-)
 TestResults=`grep -n "Tests:" $n*`
 echo $TestResults

  ExecuteTimes=`grep -n "Time:" $n*`
 echo $ExecuteTimes
 read ReadTimesResultLine TotalTimes1 TotalTimes2 <<<${ExecuteTimes//[^0-9]/ }
 echo $TotalTimes1'.'$TotalTimes2

 if [[ $TestResults != *"passed"* ]]; then
#   echo $TestResults
  read ReadTestsResultLine NumOfFailed NumOfTotal <<<${TestResults//[^0-9]/ }
  echo $date $time $ImageName $NumOfFailed '0' $NumOfTotal $TotalTimes1'.'$TotalTimes2>>$perfname-PassedRateTimesLog.txt
 elif [[ $TestResults != *"failed"* ]]; then
#    echo $TestResults
   read ReadTestsResultLine NumOfPassed NumOfTotal <<<${TestResults//[^0-9]/ }
   echo $date $time $ImageName '0' $NumOfPassed $NumOfTotal $TotalTimes1'.'$TotalTimes2>>$perfname-PassedRateTimesLog.txt
 elif [[ $TestResults == *"failed"* && $TestResults != *"passed" ]]; then
#    echo $TestResults
   read ReadTestsResultLine NumOfFailed NumOfPassed NumOfTotal <<<${TestResults//[^0-9]/ }
   echo $date $time $ImageName $NumOfFailed $NumOfPassed $NumOfTotal $TotalTimes1'.'$TotalTimes2>>$perfname-PassedRateTimesLog.txt
 fi 

 for img in $"${ImageName[@]}"
 do
 echo $img

 Step11=`cat $n* | grep "$img" | grep "OPEN_FILE_ACK and REGION_HISTOGRAM_DATA" | sed "s/(Step 1)/ /g" | sed "s/$img/ /g"  `
 tempStep11=`echo $Step11 | tr -d '()'`
 
 Step12=`cat $n* | grep "$img" | grep "SetImageChannels & SetCursor" | sed "s/(Step 1)/ /g" | sed "s/$img/ /g"  `
 tempStep12=`echo $Step12 | tr -d '()'`

 Step21=`cat $n* | grep "$img" | grep "Image should return" | sed "s/(Step 2)/ /g" | sed "s/$img/ /g"  `
 tempStep21=`echo $Step21 | tr -d '()'`

 echo $tempStep21
#  echo $tempStep11
#  echo $tempStep12
 if [[ $tempStep11 == *"Go to "* ]]; then
#   read time11 <<<${tempStep11//[^0-9]/ }
  if [[ $tempStep12 == *"Go to "* ]]; then
#    read time21 <<<${tempStep12//[^0-9]/ }
   echo $date $time $n $img '1' $time11 $time11 $time21 $time21>>$perfname-Step1TimesLog.txt
  else
   read time21 time22 <<<${tempStep12//[^0-9]/ }
   echo $date $time $n $img '1' $time11 $time11 $time21 $time22>>$perfname-Step1TimesLog.txt
  fi
 else
  read time11 time12 <<<${tempStep11//[^0-9]/ }
  if [[ $tempStep12 == *"Go to "* ]]; then
   echo $date $time $n $img '1' $time11 $time12 $time21 $time21>>$perfname-Step1TimesLog.txt
  else
   read time21 time22 <<<${tempStep12//[^0-9]/ }
   echo $date $time $n $img '1' $time11 $time12 $time21 $time22>>$perfname-Step1TimesLog.txt
  fi
 fi
 
 read time31 time32<<<${tempStep21//[^0-9]/ }
 if [[ $tempStep21 == *"Go to "* ]]; then
  echo $date $time $n $img '2' $time31 $time31>>$perfname-Step2TimesLog.txt
 else
  echo $date $time $n $img '2' $time31 $time32>>$perfname-Step2TimesLog.txt
 fi


 done
 else
 time=$(echo $n | cut -d '-' -f 3)
 date=$(echo $n | cut -d '-' -f4,5,6-)
 echo $date $time '36' '0' '36' '0'>>$perfname-PassedRateTimesLog.txt
 fi
 done
done


perftestname=('output-PERF_ANIMATION_PLAYBACK_CASA') #
# lenperftest="${#perftestname[@]}"
# ImageName=('cube_B_02400_z00100.fits' 'cube_B_04800_z00100.fits' 'cube_B_09600_z00100.fits' 'cube_B_19200_z00100.fits' 'cube_B_02400_z00100.image' 'cube_B_04800_z00100.image' 'cube_B_09600_z00100.image' 'cube_B_19200_z00100.image' 'cube_B_02400_z00100.hdf5' 'cube_B_04800_z00100.hdf5' 'cube_B_09600_z00100.hdf5' 'cube_B_19200_z00100.hdf5')
ImageName=('cube_B_09600_z00100.image')
# 'cube_B_09600_z00100.image' 'cube_B_09600_z00100.hdf5')
# echo "${#ImageName[@]}"

for perfname in "${perftestname[@]}"
do
# echo "$perfname"
rm -rf $perfname-PassedRateTimesLog.txt
rm -rf $perfname-Step1TimesLog.txt
rm -rf $perfname-Step2TimesLog.txt
# echo 'Date' 'Time' 'FailedNumber' 'PassedNumber' 'TotalNumber' 'TotalTimes'>>$perfname-PassedRateTimesLog.txt

perfFileList=`ls $perfname*.txt | sed "s/.txt/ /g" `
 for n in $perfFileList
 do
 echo $n
 perfFileListLine=`sed '/^$/d' $n.txt | wc -l`
 echo $perfFileListLine

 if [[ "$perfFileListLine" -ne "1" ]]; then
 time=$(echo $n | cut -d '-' -f 3)
 date=$(echo $n | cut -d '-' -f4,5,6-)
 TestResults=`grep -n "Tests:" $n*`
 echo $TestResults

  ExecuteTimes=`grep -n "Time:" $n*`
 echo $ExecuteTimes
 read ReadTimesResultLine TotalTimes1 TotalTimes2 <<<${ExecuteTimes//[^0-9]/ }
 echo $TotalTimes1'.'$TotalTimes2

 if [[ $TestResults != *"passed"* ]]; then
#   echo $TestResults
  read ReadTestsResultLine NumOfFailed NumOfTotal <<<${TestResults//[^0-9]/ }
  echo $date $time $ImageName $NumOfFailed '0' $NumOfTotal $TotalTimes1'.'$TotalTimes2>>$perfname-PassedRateTimesLog.txt
 elif [[ $TestResults != *"failed"* ]]; then
#    echo $TestResults
   read ReadTestsResultLine NumOfPassed NumOfTotal <<<${TestResults//[^0-9]/ }
   echo $date $time $ImageName '0' $NumOfPassed $NumOfTotal $TotalTimes1'.'$TotalTimes2>>$perfname-PassedRateTimesLog.txt
 elif [[ $TestResults == *"failed"* && $TestResults != *"passed" ]]; then
#    echo $TestResults
   read ReadTestsResultLine NumOfFailed NumOfPassed NumOfTotal <<<${TestResults//[^0-9]/ }
   echo $date $time $ImageName $NumOfFailed $NumOfPassed $NumOfTotal $TotalTimes1'.'$TotalTimes2>>$perfname-PassedRateTimesLog.txt
 fi 

 for img in $"${ImageName[@]}"
 do
 echo $img

 Step11=`cat $n* | grep "$img" | grep "OPEN_FILE_ACK and REGION_HISTOGRAM_DATA" | sed "s/(Step 1)/ /g" | sed "s/$img/ /g"  `
 tempStep11=`echo $Step11 | tr -d '()'`
 
 Step12=`cat $n* | grep "$img" | grep "SetImageChannels & SetCursor" | sed "s/(Step 1)/ /g" | sed "s/$img/ /g"  `
 tempStep12=`echo $Step12 | tr -d '()'`

 Step21=`cat $n* | grep "$img" | grep "Image should return" | sed "s/(Step 2)/ /g" | sed "s/$img/ /g"  `
 tempStep21=`echo $Step21 | tr -d '()'`

 echo $tempStep21
#  echo $tempStep11
#  echo $tempStep12
 if [[ $tempStep11 == *"Go to "* ]]; then
#   read time11 <<<${tempStep11//[^0-9]/ }
  if [[ $tempStep12 == *"Go to "* ]]; then
#    read time21 <<<${tempStep12//[^0-9]/ }
   echo $date $time $n $img '1' $time11 $time11 $time21 $time21>>$perfname-Step1TimesLog.txt
  else
   read time21 time22 <<<${tempStep12//[^0-9]/ }
   echo $date $time $n $img '1' $time11 $time11 $time21 $time22>>$perfname-Step1TimesLog.txt
  fi
 else
  read time11 time12 <<<${tempStep11//[^0-9]/ }
  if [[ $tempStep12 == *"Go to "* ]]; then
   echo $date $time $n $img '1' $time11 $time12 $time21 $time21>>$perfname-Step1TimesLog.txt
  else
   read time21 time22 <<<${tempStep12//[^0-9]/ }
   echo $date $time $n $img '1' $time11 $time12 $time21 $time22>>$perfname-Step1TimesLog.txt
  fi
 fi
 
 read time31 time32<<<${tempStep21//[^0-9]/ }
 if [[ $tempStep21 == *"Go to "* ]]; then
  echo $date $time $n $img '2' $time31 $time31>>$perfname-Step2TimesLog.txt
 else
  echo $date $time $n $img '2' $time31 $time32>>$perfname-Step2TimesLog.txt
 fi


 done
 else
 time=$(echo $n | cut -d '-' -f 3)
 date=$(echo $n | cut -d '-' -f4,5,6-)
 echo $date $time '36' '0' '36' '0'>>$perfname-PassedRateTimesLog.txt
 fi
 done
done

perftestname=('output-PERF_ANIMATION_PLAYBACK_HDF5') #
# lenperftest="${#perftestname[@]}"
# ImageName=('cube_B_02400_z00100.fits' 'cube_B_04800_z00100.fits' 'cube_B_09600_z00100.fits' 'cube_B_19200_z00100.fits' 'cube_B_02400_z00100.image' 'cube_B_04800_z00100.image' 'cube_B_09600_z00100.image' 'cube_B_19200_z00100.image' 'cube_B_02400_z00100.hdf5' 'cube_B_04800_z00100.hdf5' 'cube_B_09600_z00100.hdf5' 'cube_B_19200_z00100.hdf5')
ImageName=('cube_B_09600_z00100.hdf5')
# 'cube_B_09600_z00100.image' 'cube_B_09600_z00100.hdf5')
# echo "${#ImageName[@]}"

for perfname in "${perftestname[@]}"
do
# echo "$perfname"
rm -rf $perfname-PassedRateTimesLog.txt
rm -rf $perfname-Step1TimesLog.txt
rm -rf $perfname-Step2TimesLog.txt
# echo 'Date' 'Time' 'FailedNumber' 'PassedNumber' 'TotalNumber' 'TotalTimes'>>$perfname-PassedRateTimesLog.txt

perfFileList=`ls $perfname*.txt | sed "s/.txt/ /g" `
 for n in $perfFileList
 do
 echo $n
 perfFileListLine=`sed '/^$/d' $n.txt | wc -l`
 echo $perfFileListLine

 if [[ "$perfFileListLine" -ne "1" ]]; then
 time=$(echo $n | cut -d '-' -f 3)
 date=$(echo $n | cut -d '-' -f4,5,6-)
 TestResults=`grep -n "Tests:" $n*`
 echo $TestResults

  ExecuteTimes=`grep -n "Time:" $n*`
 echo $ExecuteTimes
 read ReadTimesResultLine TotalTimes1 TotalTimes2 <<<${ExecuteTimes//[^0-9]/ }
 echo $TotalTimes1'.'$TotalTimes2

 if [[ $TestResults != *"passed"* ]]; then
#   echo $TestResults
  read ReadTestsResultLine NumOfFailed NumOfTotal <<<${TestResults//[^0-9]/ }
  echo $date $time $ImageName $NumOfFailed '0' $NumOfTotal $TotalTimes1'.'$TotalTimes2>>$perfname-PassedRateTimesLog.txt
 elif [[ $TestResults != *"failed"* ]]; then
#    echo $TestResults
   read ReadTestsResultLine NumOfPassed NumOfTotal <<<${TestResults//[^0-9]/ }
   echo $date $time $ImageName '0' $NumOfPassed $NumOfTotal $TotalTimes1'.'$TotalTimes2>>$perfname-PassedRateTimesLog.txt
 elif [[ $TestResults == *"failed"* && $TestResults != *"passed" ]]; then
#    echo $TestResults
   read ReadTestsResultLine NumOfFailed NumOfPassed NumOfTotal <<<${TestResults//[^0-9]/ }
   echo $date $time $ImageName $NumOfFailed $NumOfPassed $NumOfTotal $TotalTimes1'.'$TotalTimes2>>$perfname-PassedRateTimesLog.txt
 fi 

 for img in $"${ImageName[@]}"
 do
 echo $img

 Step11=`cat $n* | grep "$img" | grep "OPEN_FILE_ACK and REGION_HISTOGRAM_DATA" | sed "s/(Step 1)/ /g" | sed "s/$img/ /g"  `
 tempStep11=`echo $Step11 | tr -d '()'`
 
 Step12=`cat $n* | grep "$img" | grep "SetImageChannels & SetCursor" | sed "s/(Step 1)/ /g" | sed "s/$img/ /g"  `
 tempStep12=`echo $Step12 | tr -d '()'`

 Step21=`cat $n* | grep "$img" | grep "Image should return" | sed "s/(Step 2)/ /g" | sed "s/$img/ /g"  `
 tempStep21=`echo $Step21 | tr -d '()'`

 echo $tempStep21
#  echo $tempStep11
#  echo $tempStep12
 if [[ $tempStep11 == *"Go to "* ]]; then
#   read time11 <<<${tempStep11//[^0-9]/ }
  if [[ $tempStep12 == *"Go to "* ]]; then
#    read time21 <<<${tempStep12//[^0-9]/ }
   echo $date $time $n $img '1' $time11 $time11 $time21 $time21>>$perfname-Step1TimesLog.txt
  else
   read time21 time22 <<<${tempStep12//[^0-9]/ }
   echo $date $time $n $img '1' $time11 $time11 $time21 $time22>>$perfname-Step1TimesLog.txt
  fi
 else
  read time11 time12 <<<${tempStep11//[^0-9]/ }
  if [[ $tempStep12 == *"Go to "* ]]; then
   echo $date $time $n $img '1' $time11 $time12 $time21 $time21>>$perfname-Step1TimesLog.txt
  else
   read time21 time22 <<<${tempStep12//[^0-9]/ }
   echo $date $time $n $img '1' $time11 $time12 $time21 $time22>>$perfname-Step1TimesLog.txt
  fi
 fi
 
 read time31 time32<<<${tempStep21//[^0-9]/ }
 if [[ $tempStep21 == *"Go to "* ]]; then
  echo $date $time $n $img '2' $time31 $time31>>$perfname-Step2TimesLog.txt
 else
  echo $date $time $n $img '2' $time31 $time32>>$perfname-Step2TimesLog.txt
 fi


 done
 else
 time=$(echo $n | cut -d '-' -f 3)
 date=$(echo $n | cut -d '-' -f4,5,6-)
 echo $date $time '36' '0' '36' '0'>>$perfname-PassedRateTimesLog.txt
 fi
 done
done

cat output-PERF_ANIMATION_PLAYBACK_FITS-PassedRateTimesLog.txt output-PERF_ANIMATION_PLAYBACK_CASA-PassedRateTimesLog.txt output-PERF_ANIMATION_PLAYBACK_HDF5-PassedRateTimesLog.txt > output-PERF_ANIMATION_PLAYBACK-PassedRateTimesLog.txt
cat output-PERF_ANIMATION_PLAYBACK_FITS-Step1TimesLog.txt output-PERF_ANIMATION_PLAYBACK_CASA-Step1TimesLog.txt output-PERF_ANIMATION_PLAYBACK_HDF5-Step1TimesLog.txt > output-PERF_ANIMATION_PLAYBACK-Step1TimesLog.txt
cat output-PERF_ANIMATION_PLAYBACK_FITS-Step2TimesLog.txt output-PERF_ANIMATION_PLAYBACK_CASA-Step2TimesLog.txt output-PERF_ANIMATION_PLAYBACK_HDF5-Step2TimesLog.txt > output-PERF_ANIMATION_PLAYBACK-Step2TimesLog.txt

exit

