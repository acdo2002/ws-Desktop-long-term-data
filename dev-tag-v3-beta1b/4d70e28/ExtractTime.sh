#!/bin/bash

./CheckPerformComplete.sh
./create-PERF_LOAD_IMAGE-PassedRateTimesLog-StepsTimesLog.sh
./create-PERF_RASTER_TILE_DATA-PassedRateTimesLog-StepsTimesLog.sh
./create-PERF_CONTOUR_DATA-PassedRateTimesLog-StepsTimesLog.sh
./create-PERF_CUBE_HISTOGRAM-PassedRateTimesLog-StepsTimesLog.sh
./create-PERF_REGION_SPECTRAL_PROFILE-PassedRateTimesLog-StepsTimesLog.sh
./create-PERF_ANIMATION_PLAYBACK-PassedRateTimesLog-StepsTimesLog.sh
./create-PERF_MOMENTS-PassedRateTimesLog-StepsTimesLog.sh

exit
