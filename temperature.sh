#!/bin/bash
array[0]="0°C"
array[1]="-5°C"
array[2]="0°C"
array[3]="5°C"
array[4]="10°C"
array[5]="15°C"
array[6]="20°C"
array[7]="23°C"
array[8]="25°C"
array[9]="30°C"
array[10]="35°C"

size=${#array[@]}
index=$(($RANDOM % $size))
echo "Temperature: ${array[$index]}"
