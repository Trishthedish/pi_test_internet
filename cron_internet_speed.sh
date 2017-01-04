#!/bin/bash

date >> /home/pi/speedtest.log
./speedtest_cli_extras/bin/speedtest-csv.sh >> /home/pi/speedtest.log
echo "" >> /home/pi/speedtest.log
