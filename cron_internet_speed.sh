#!/bin/bash

date >> /home/pi/speedtest.log
/home/pi/pi_tests_internet/cron_internet_speed.sh >> /home/pi/speedtest.log
echo "" >> /home/pi/speedtest.log
