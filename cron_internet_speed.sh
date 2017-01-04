#!/bin/bash

date >> /home/pi/speedtest.log
/home/pi/speedtest-ifttt.sh >> /home/pi/speedtest.log
echo "" >> /home/pi/speedtest.log
