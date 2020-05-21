#!/bin/bash
array[0]="Sunny"
array[1]="Cloudy"
array[2]="Partialy Cloudy"
array[3]="Rainy"
array[4]="Stormy"
array[5]="Snowy"
array[6]="Windy"
array[7]="Patchy Rain"
array[8]="Light Rain"
array[9]="Moderate Rain"
array[10]="Overcast"



size=${#array[@]}
index=$(($RANDOM % $size))
echo "Forecast: ${array[$index]}"
