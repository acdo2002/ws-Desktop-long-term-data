#!/bin/bash

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/casacore/lib:/usr/local/zfp/lib:/usr/local/lib
export LD_LIBRARY_PATH

now="$(date +'%Ss%Mm%Hh-%d-%m-%Y')"

sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_LOAD_IMAGE_FITS-$now.txt
sleep 5s
npm test PERF_LOAD_IMAGE_FITS.test.ts -- --watchAll=false --no-color 2>output-PERF_LOAD_IMAGE_FITS-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s

sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_LOAD_IMAGE_CASA-$now.txt
sleep 5s
npm test PERF_LOAD_IMAGE_CASA.test.ts -- --watchAll=false --no-color 2>output-PERF_LOAD_IMAGE_CASA-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s

sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_LOAD_IMAGE_HDF5-$now.txt
sleep 5s
npm test PERF_LOAD_IMAGE_HDF5.test.ts -- --watchAll=false --no-color 2>output-PERF_LOAD_IMAGE_HDF5-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s


sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_RASTER_TILE_DATA_FITS-$now.txt
sleep 5s
npm test PERF_RASTER_TILE_DATA_FITS.test.ts -- --watchAll=false --no-color 2>output-PERF_RASTER_TILE_DATA_FITS-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s

sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_RASTER_TILE_DATA_CASA-$now.txt
sleep 5s
npm test PERF_RASTER_TILE_DATA_CASA.test.ts -- --watchAll=false --no-color 2>output-PERF_RASTER_TILE_DATA_CASA-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s

sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_RASTER_TILE_DATA_HDF5-$now.txt
sleep 5s
npm test PERF_RASTER_TILE_DATA_HDF5.test.ts -- --watchAll=false --no-color 2>output-PERF_RASTER_TILE_DATA_HDF5-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s


sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_CONTOUR_DATA_Mode2-$now.txt
sleep 5s
npm test PERF_CONTOUR_DATA_Mode2.test.ts -- --watchAll=false --no-color 2>output-PERF_CONTOUR_DATA_Mode2-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s

sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_CONTOUR_DATA_Mode0-$now.txt
sleep 5s
npm test PERF_CONTOUR_DATA_Mode0.test.ts -- --watchAll=false --no-color 2>output-PERF_CONTOUR_DATA_Mode0-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s

sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_CONTOUR_DATA_Mode1-$now.txt
sleep 5s
npm test PERF_CONTOUR_DATA_Mode1.test.ts -- --watchAll=false --no-color 2>output-PERF_CONTOUR_DATA_Mode1-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s


sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_CUBE_HISTOGRAM_FITS-$now.txt
sleep 5s
npm test PERF_CUBE_HISTOGRAM_FITS.test.ts -- --watchAll=false --no-color 2>output-PERF_CUBE_HISTOGRAM_FITS-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s

sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_CUBE_HISTOGRAM_CASA-$now.txt
sleep 5s
npm test PERF_CUBE_HISTOGRAM_CASA.test.ts -- --watchAll=false --no-color 2>output-PERF_CUBE_HISTOGRAM_CASA-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s

sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_CUBE_HISTOGRAM_HDF5-$now.txt
sleep 5s
npm test PERF_CUBE_HISTOGRAM_HDF5.test.ts -- --watchAll=false --no-color 2>output-PERF_CUBE_HISTOGRAM_HDF5-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s


sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_REGION_SPECTRAL_PROFILE_FITS-$now.txt
sleep 5s
npm test PERF_REGION_SPECTRAL_PROFILE_FITS.test.ts -- --watchAll=false --no-color 2>output-PERF_REGION_SPECTRAL_PROFILE_FITS-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s

sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_REGION_SPECTRAL_PROFILE_CASA-$now.txt
sleep 5s
npm test PERF_REGION_SPECTRAL_PROFILE_CASA.test.ts -- --watchAll=false --no-color 2>output-PERF_REGION_SPECTRAL_PROFILE_CASA-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s

sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_REGION_SPECTRAL_PROFILE_HDF5-$now.txt
sleep 5s
npm test PERF_REGION_SPECTRAL_PROFILE_HDF5.test.ts -- --watchAll=false --no-color 2>output-PERF_REGION_SPECTRAL_PROFILE_HDF5-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s


sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_ANIMATION_PLAYBACK_FITS-$now.txt
sleep 5s
npm test PERF_ANIMATION_PLAYBACK_FITS.test.ts -- --watchAll=false --no-color 2>output-PERF_ANIMATION_PLAYBACK_FITS-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s

sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_ANIMATION_PLAYBACK_CASA-$now.txt
sleep 5s
npm test PERF_ANIMATION_PLAYBACK_CASA.test.ts -- --watchAll=false --no-color 2>output-PERF_ANIMATION_PLAYBACK_CASA-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s

sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_ANIMATION_PLAYBACK_HDF5-$now.txt
sleep 5s
npm test PERF_ANIMATION_PLAYBACK_HDF5.test.ts -- --watchAll=false --no-color 2>output-PERF_ANIMATION_PLAYBACK_HDF5-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s


sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_MOMENTS_FITS-$now.txt
sleep 5s
npm test PERF_MOMENTS_FITS.test.ts -- --watchAll=false --no-color 2>output-PERF_MOMENTS_FITS-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s

sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_MOMENTS_CASA-$now.txt
sleep 5s
npm test PERF_MOMENTS_CASA.test.ts -- --watchAll=false --no-color 2>output-PERF_MOMENTS_CASA-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s

sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
(cd /home/mingyi/carta-backend-dev/62130e4/carta-backend/build ; ./carta_backend /home/mingyi/carta-test-img --verbosity=5 --omp_threads=4 --port=3006 --debug_no_auth=true --no_http=true --log_performance=true &)>>Backlog-output-PERF_MOMENTS_HDF5-$now.txt
sleep 5s
npm test PERF_MOMENTS_HDF5.test.ts -- --watchAll=false --no-color 2>output-PERF_MOMENTS_HDF5-$now.txt
sleep 5s
ps -ef | grep 3006 | grep -v grep | awk '{print $2}' | xargs kill
sleep 5s

exit
