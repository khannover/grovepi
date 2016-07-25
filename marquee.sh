#!/bin/bash

LENGTH=16
TEXT="$1"
r=$2
g=$3
b=$4

position=0
let length=${#TEXT}

./lcd.py -t "${TEXT:0:16}" -r $r -g $g -b $b
sleep 1
./lcd.py -t "${TEXT:0:16}" -r 0 -g 0 -b 0
sleep 1
./lcd.py -t "${TEXT:0:16}" -r $r -g $g -b $b
sleep 1
./lcd.py -t "${TEXT:0:16}" -r 0 -g 0 -b 0
sleep 1
./lcd.py -t "${TEXT:0:16}" -r $r -g $g -b $b
sleep 1

for i in `seq 0 5 $length`; do
        let position=$position+5
        echo $position
#       let r=$RANDOM%16
#       let g=$RANDOM%16
#       let b=$RANDOM%16
        ./lcd.py -t "${TEXT:$position:16}" -r $r -g $g -b $b
        sleep 1
done

./lcd.py -t "" -r 0 -g 0 -b 0
