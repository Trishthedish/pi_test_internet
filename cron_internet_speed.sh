#!/bin/bash

log="/home/pi/speedtest.log"

date >> $log
./pi_tests_internet/speedtest_cli_extras/bin/speedtest-csv.sh >> $log
echo "" >> $log
