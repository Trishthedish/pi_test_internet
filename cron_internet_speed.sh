#!/bin/bash

date >> /home/pi/speedtest.log
/home/pi/cron_internet_speed.sh >> /home/pi/speedtest.log
echo "" >> /home/pi/speedtest.log
