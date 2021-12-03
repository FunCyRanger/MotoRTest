#!/bin/bash

# Gernot Skottke, 05.05.2021

MyUnzip()
{
	# function [ZipFile Unix $1] [ZipFile Windows $2]

	# Ubuntu-Linux-Subsystem (Windows 10)
	if [[ "$(uname -a)" = *"Microsoft"* ]]; then

		tar.exe -xf "$2" -C ./ 
		
		# title
		echo -e '\033]2;'$bashTITLE'\007'
	
	# Linux
	# macOS
	else

		unzip -q -o "$1" -d ./
	
	fi

	echo "MROSM: $(basename $1 .zip) entpackt"
}



GtoJDN() 
{
# input [ ${REGIONdate:8:2} | day ] [ ${REGIONdate:5:2} | month ] [ ${REGIONdate:0:4} year ]
# https://blog.sleeplessbeastie.eu/2013/05/17/how-to-convert-date-to-julian-day-number-using-shell-script/
# gtojdn
# convert Gregorian calendar date to Julian Day Number
#
# parameters:
# day
# month
# year
# 
# example:
# gtojdn 15 5 2013
#
# notes:
# algorithm is simplified 
# as it will return 2456428 instead of 2456427.5
if [ $2 -le 2 ]; then

	y=$(($3 - 1))
    m=$(($2 + 12))
	
else

	y=$3
    m=$2

fi

d=$1
x=$(echo "2 - $y / 100 + $y / 400" | bc)
x=$(echo "($x + 365.25 * ($y + 4716))/1" | bc) 
x=$(echo "($x + 30.6001 * ($m + 1))/1" | bc)
JD=$(echo "($x + $d - 1524.5 + 0.5)/1" | bc) # added 0.5

return $JD                                           
}



FILESIZE()
{
# input [ $PATHFILENAME ]
# calculate size of .osm.pbf file (MB)
FILESIZE=$(($(wc -c < "$1") / 1024 / 1024))

return $FILESIZE
}



RAMinstalled()
{
# calculate installed RAM

# Ubuntu-Linux-Subsystem (Windows 10)
# Linux  
if [ "$(uname -s)" == "Linux" ]; then

	INSTALLED=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)

# macOS
elif [ "$(uname)" == "Darwin" ]; then

	INSTALLED=$(expr $(sysctl -n hw.memsize) / 1024 )

fi

let RAMinstalled=($INSTALLED / 1024)
return $RAMinstalled
}



RAMfree()
{
# calculate free RAM

# Ubuntu-Linux-Subsystem (Windows 10)
# Linux     
if [ "$(uname -s)" == "Linux" ]; then

	INSTALLED=$(awk '/MemTotal:/ { print $2 }' /proc/meminfo)
	FREE=$(awk '/MemFree:/ { print $2 }' /proc/meminfo)
	INACTIVE=$(awk '/Inactive:/ { print $2 }' /proc/meminfo)
	AVAILABLE=$(awk '/MemAvailable:/ { print $2 }' /proc/meminfo)
	
	if [ $FILESIZE -gt 10000 ]; then
	
		let RAMfree=($INSTALLED / 1024)
	
	else
	
		let RAMfree=$FREE+$INACTIVE
		let RAMfree=($RAMfree / 1024) 
	
	fi
	
# macOS
elif [ "$(uname)" == "Darwin" ]; then

	INSTALLED=$(expr $(sysctl -n hw.memsize) / 1024 / 1024)
	FREE="$(( $(vm_stat | grep free | awk '{ print $3 }' | sed 's/\.//')*4096/1048576 ))"
	INACTIVE="$(( $(vm_stat | grep inactive | awk '{ print $3 }' | sed 's/\.//')*4096/1048576 ))"
	
	# file larger than 10.000 MB (10 GB) and RAM installed up to 8 GB 
	if [ $FILESIZE -gt 10000 ] && [ $INSTALLED -le 8192 ]; then
	
		let RAMfree=$INSTALLED 
	
	else
		
		let RAMfree=$FREE+$INACTIVE 
	
	fi	

fi

return $RAMfree
}