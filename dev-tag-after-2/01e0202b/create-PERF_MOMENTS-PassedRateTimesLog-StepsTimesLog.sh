#!/bin/bash

perftestname=('output-PERF_MOMENTS_FITS') #  'PERF_REGION_SPECTRAL_PROFILE' 'PERF_ANIMATION_PLAYBACK')
# lenperftest="${#perftestname[@]}"
ImageName=('S255_IR_sci.spw25.cube.I.pbcor.fits')
# 'HD163296_CO_2_1.image' 'HD163296_CO_2_1.hdf5')
# echo "${#ImageName[@]}"

for perfname in "${perftestname[@]}"
do
# echo "$perfname"
rm -rf $perfname-PassedRateTimesLog.txt
rm -rf $perfname-Step1TimesLog.txt
rm -rf $perfname-Step2TimesLog.txt
rm -rf $perfname-Step3TimesLog.txt
# echo 'Date' 'Time' 'FailedNumber' 'PassedNumber' 'TotalNumber' 'TotalTimes'>>$perfname-PassedRateTimesLog.txt

perfFileList=`ls $perfname*.txt | sed "s/.txt/ /g" `
 for n in $perfFileList
 do
 echo $n
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
 
 Step21=`cat $n* | grep "$img" | grep "Set region" | sed "s/(Step 2)/ /g" | sed "s/$img/ /g"  `
 tempStep21=`echo $Step21 | tr -d '()'`

 Step31=`cat $n* | grep "$img" | grep "Receive a series of moment progress" | sed "s/(Step 3)/ /g" | sed "s/$img/ /g"  `
 tempStep31=`echo $Step31 | tr -d '()'`

 echo $tempStep11
 echo $tempStep21
 echo $tempStep31


 if [[ $tempStep11 == *"Go to "* ]]; then
  echo $date $time $n $img '1' '5000' '5000'>>$perfname-Step1TimesLog.txt
 else
  read time11 time12 <<<${tempStep11//[^0-9]/ }
  echo $date $time $n $img '1' $time11 $time12>>$perfname-Step1TimesLog.txt
 fi

  if [[ $tempStep21 == *"Go to "* ]]; then
  echo $date $time $n $img '2' '5000' '5000'>>$perfname-Step2TimesLog.txt
 else
  read time21 time22 <<<${tempStep21//[^0-9]/ }
  echo $date $time $n $img '2' $time21 $time22>>$perfname-Step2TimesLog.txt
 fi


 if [[ $tempStep31 == *"Go to "* ]]; then
  echo $date $time $n $img '3' '400000' '400000'>>$perfname-Step3TimesLog.txt
 else
  read time31 time32 <<<${tempStep31//[^0-9]/ }
  echo $date $time $n $img '3' $time31 $time32>>$perfname-Step3TimesLog.txt
 fi


 done
 done
done

perftestname=('output-PERF_MOMENTS_CASA') #  'PERF_REGION_SPECTRAL_PROFILE' 'PERF_ANIMATION_PLAYBACK')
# lenperftest="${#perftestname[@]}"
ImageName=('S255_IR_sci.spw25.cube.I.pbcor.image')
# 'HD163296_CO_2_1.image' 'HD163296_CO_2_1.hdf5')
# echo "${#ImageName[@]}"

for perfname in "${perftestname[@]}"
do
# echo "$perfname"
rm -rf $perfname-PassedRateTimesLog.txt
rm -rf $perfname-Step1TimesLog.txt
rm -rf $perfname-Step2TimesLog.txt
rm -rf $perfname-Step3TimesLog.txt
# echo 'Date' 'Time' 'FailedNumber' 'PassedNumber' 'TotalNumber' 'TotalTimes'>>$perfname-PassedRateTimesLog.txt

perfFileList=`ls $perfname*.txt | sed "s/.txt/ /g" `
 for n in $perfFileList
 do
 echo $n
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
 
 Step21=`cat $n* | grep "$img" | grep "Set region" | sed "s/(Step 2)/ /g" | sed "s/$img/ /g"  `
 tempStep21=`echo $Step21 | tr -d '()'`

 Step31=`cat $n* | grep "$img" | grep "Receive a series of moment progress" | sed "s/(Step 3)/ /g" | sed "s/$img/ /g"  `
 tempStep31=`echo $Step31 | tr -d '()'`

 echo $tempStep11
 echo $tempStep21
 echo $tempStep31


 if [[ $tempStep11 == *"Go to "* ]]; then
  echo $date $time $n $img '1' '5000' '5000'>>$perfname-Step1TimesLog.txt
 else
  read time11 time12 <<<${tempStep11//[^0-9]/ }
  echo $date $time $n $img '1' $time11 $time12>>$perfname-Step1TimesLog.txt
 fi

  if [[ $tempStep21 == *"Go to "* ]]; then
  echo $date $time $n $img '2' '5000' '5000'>>$perfname-Step2TimesLog.txt
 else
  read time21 time22 <<<${tempStep21//[^0-9]/ }
  echo $date $time $n $img '2' $time21 $time22>>$perfname-Step2TimesLog.txt
 fi


 if [[ $tempStep31 == *"Go to "* ]]; then
  echo $date $time $n $img '3' '400000' '400000'>>$perfname-Step3TimesLog.txt
 else
  read time31 time32 <<<${tempStep31//[^0-9]/ }
  echo $date $time $n $img '3' $time31 $time32>>$perfname-Step3TimesLog.txt
 fi

 done
 done
done

perftestname=('output-PERF_MOMENTS_HDF5') #  'PERF_REGION_SPECTRAL_PROFILE' 'PERF_ANIMATION_PLAYBACK')
# lenperftest="${#perftestname[@]}"
ImageName=('S255_IR_sci.spw25.cube.I.pbcor.hdf5')
# 'HD163296_CO_2_1.image' 'HD163296_CO_2_1.hdf5')
# echo "${#ImageName[@]}"

for perfname in "${perftestname[@]}"
do
# echo "$perfname"
rm -rf $perfname-PassedRateTimesLog.txt
rm -rf $perfname-Step1TimesLog.txt
rm -rf $perfname-Step2TimesLog.txt
rm -rf $perfname-Step3TimesLog.txt
# echo 'Date' 'Time' 'FailedNumber' 'PassedNumber' 'TotalNumber' 'TotalTimes'>>$perfname-PassedRateTimesLog.txt

perfFileList=`ls $perfname*.txt | sed "s/.txt/ /g" `
 for n in $perfFileList
 do
 echo $n
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
 
 Step21=`cat $n* | grep "$img" | grep "Set region" | sed "s/(Step 2)/ /g" | sed "s/$img/ /g"  `
 tempStep21=`echo $Step21 | tr -d '()'`

 Step31=`cat $n* | grep "$img" | grep "Receive a series of moment progress" | sed "s/(Step 3)/ /g" | sed "s/$img/ /g"  `
 tempStep31=`echo $Step31 | tr -d '()'`

 echo $tempStep11
 echo $tempStep21
 echo $tempStep31


 if [[ $tempStep11 == *"Go to "* ]]; then
  echo $date $time $n $img '1' '5000' '5000'>>$perfname-Step1TimesLog.txt
 else
  read time11 time12 <<<${tempStep11//[^0-9]/ }
  echo $date $time $n $img '1' $time11 $time12>>$perfname-Step1TimesLog.txt
 fi

  if [[ $tempStep21 == *"Go to "* ]]; then
  echo $date $time $n $img '2' '5000' '5000'>>$perfname-Step2TimesLog.txt
 else
  read time21 time22 <<<${tempStep21//[^0-9]/ }
  echo $date $time $n $img '2' $time21 $time22>>$perfname-Step2TimesLog.txt
 fi


 if [[ $tempStep31 == *"Go to "* ]]; then
  echo $date $time $n $img '3' '400000' '400000'>>$perfname-Step3TimesLog.txt
 else
  read time31 time32 <<<${tempStep31//[^0-9]/ }
  echo $date $time $n $img '3' $time31 $time32>>$perfname-Step3TimesLog.txt
 fi

 done
 done
done

cat output-PERF_MOMENTS_FITS-PassedRateTimesLog.txt output-PERF_MOMENTS_CASA-PassedRateTimesLog.txt output-PERF_MOMENTS_HDF5-PassedRateTimesLog.txt > output-PERF_MOMENTS-PassedRateTimesLog.txt
cat output-PERF_MOMENTS_FITS-Step1TimesLog.txt output-PERF_MOMENTS_CASA-Step1TimesLog.txt output-PERF_MOMENTS_HDF5-Step1TimesLog.txt > output-PERF_MOMENTS-Step1TimesLog.txt
cat output-PERF_MOMENTS_FITS-Step2TimesLog.txt output-PERF_MOMENTS_CASA-Step2TimesLog.txt output-PERF_MOMENTS_HDF5-Step2TimesLog.txt > output-PERF_MOMENTS-Step2TimesLog.txt
cat output-PERF_MOMENTS_FITS-Step3TimesLog.txt output-PERF_MOMENTS_CASA-Step3TimesLog.txt output-PERF_MOMENTS_HDF5-Step3TimesLog.txt > output-PERF_MOMENTS-Step3TimesLog.txt

exit



