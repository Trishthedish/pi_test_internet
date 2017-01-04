# Notes

1. Not sure what will happen but I'm modifiing my previously created cron job from:
```bash
#!/bin/bash
date >> /home/pi/speedtest.log
/usr/local/bin/speedtest --simple >> /home/pi/speedtest.log
```
to
```bash
#!/bin/bash
date >> /home/pi/speedtest.log
/home/pi/speedtest-ifttt.sh >> /home/pi/speedtest.log
echo "" >> /home/pi/speedtest.log
```
