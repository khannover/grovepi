#!/bin/bash

commands[0]=""
while true; do

  ### WEATHER ###
  place="braunschweig"
  off="-r 0 -g 0 -b 0"
  hot="-r 64 -g 0 -b 0"
  medium="-r 64 -g 64 -b 0"
  cold="-r 0 -g 32 -b 64"
  weather_bs=`finger o:${place}@graph.no`
  time=`echo $weather_bs | awk -F: '{print $1":"$2}' | sed 's/'$place' at//g'`
  temperature=`echo $weather_bs | awk -F: '{print $3}' | awk -F, '{print $1}'`
  tempraw=`echo $temperature | awk '{print $1}'`
  if [ $tempraw -gt 20 ]; then
    color=$hot
  elif [ $tempraw -gt 10 ]; then
    color=$medium
  else
    color=$cold
  fi
  commands[0]="/home/pi/scripts/lcd.py -t "'"Temp: '$temperature" um   $time Uhr"'"'" $color"


  ### SYSTEM INFORMATION ###
  ## SPACE ##
  length=${#commands[@]}
  spaceinfo=`df -h | grep "/dev/root"`
  freespace=`echo $spaceinfo | awk '{print $4}'`
  freespace_clean=`echo $spaceinfo | awk '{print $4}' | sed 's/[^0-9]*//g'`
  usedspace_percent=`echo $spaceinfo | awk '{print $5}'`
  usedspace_percent_clean=`echo $spaceinfo | awk '{print $5}' | sed 's/[^0-9]*//g'`
  if [ $usedspace_percent_clean -lt 10 ]; then
    color=$hot
  elif [ $usedspace_percent_clean -gt 10 -a $usedspace_percent_clean -lt 20 ]; then
    color=$medium
  else
    color=$cold
  fi
  commands[$length]="/home/pi/scripts/lcd.py -t \"Speicher: $freespace frei ($usedspace_percent genutzt)\" $color"

  ## CPU ##
  length=${#commands[@]}
  cputemp=`vcgencmd measure_temp`
  cputemp_clean=`echo $cputemp | awk -F"=" '{print $2}' | awk -F"." '{print $1}'`
  cpuclock=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`
  let cpuclock=$cpuclock/1000
  if [ $cputemp_clean -gt 60 ]; then
    color=$hot
  elif [ $cputemp_clean -gt 50 -a $cputemp_clean -lt 60 ]; then
    color=$medium
  else
    color=$cold
  fi
  commands[$length]="/home/pi/scripts/lcd.py -t \"CPU: $cputemp ($cpuclock MHz)\" $color"

  ### LAST COMMANDS ###
  #length=${#commands[@]}
  #commands[$length]="/home/pi/scripts/lcd.py -t \"\" $off"

  echo ${#commands[@]}
  ### EXECUTE ALL COMMANDS ###
  length=${#commands[@]}
  let length=$length-1
    for i in `seq 0 $length`; do
      eval ${commands[$i]}
  #    if [ $i -ne $length ];then
        sleep 10
  #    fi
    done
done
exit
