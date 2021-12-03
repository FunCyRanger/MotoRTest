#!/bin/bash

# Gernot Skottke, 07.04.2019

# variables
MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# include MROSM_functions.bash
source "$MYDIR/MROSM_functions.bash"

# keep temp files
if [ $chkKEEPTEMP = 1 ]; then

	KEEPTEMP="--keep-tempfiles"
	
else
	KEEPTEMP=
	
	if [ -d ./osmupdate ]; then

		rm -rf ./osmupdate
	
	fi

fi

# cut .poly from .osm.pbf
if [ $chkCUTPOLY = 1 ]; then

	if ! [ "$obPOLY" = "" ]; then

		REGIONpoly="$(basename "${obPOLY%%.*}")"		
		
		echo " "
		echo "MROSM: $REGIONpoly.osm.pbf wird aus $FILENAME geschnitten"
		echo "MROSM: Start osmconvert "`date +%d.%m.%Y\ %H:%M:%S`	

		#osmconvert
		"$bashpath"osmconvert \
			"$PATHFILENAME" \
			-B="$obPOLY" \
			-o="$PATHNAME/$REGIONpoly.osm.pbf"
			1> ./tmp/osmconvert_$REGIONpoly.log 2> ./tmp/osmconvert_$REGIONpoly.err.log
		
		echo "MROSM: Ende  osmconvert "`date +%d.%m.%Y\ %H:%M:%S`	

		# set new variables
		PATHFILENAME="$PATHNAME/$REGIONpoly.osm.pbf"
		
		# Ubuntu-Linux-Subsystem (Windows 10)
		if [[ "$(uname -a)" = *"Microsoft"* ]]; then

			PATHFILENAMEwin=$(echo `wslpath -w "$PATHFILENAME" 2> /dev/null`)

		fi
		
		FILENAME="$REGIONpoly.osm.pbf"
		REGION="$REGIONpoly"
		
		if [ -f "$PATHFILENAME" ]; then

			echo "MROSM: $PATHFILENAME erzeugt"
			#echo "       $PATHFILENAMEwin"

		fi

	fi

fi

# update .osm.pbf
if [ $chkUPDATE = 1 ]; then

	if ! [ "$obPOLY" = "" ]; then

		REGIONpoly="$(basename "${obPOLY%%.*}")"

	fi

	echo " "
	echo "MROSM: Region $REGIONpoly wird in $FILENAME aktualisiert"
	echo "MROSM: Start osmupdate "`date +%d.%m.%Y\ %H:%M:%S`		

	# osmupdate
	echo " "
	
	# UPPER case in lower case
	REGION=`echo "$REGION" | tr '[:upper:]' '[:lower:]'`
	
	if [ -f "$obPOLY" ] || [ "$REGION" == "planet" ]; then
		
		# no poly file for planet
		if [ "$REGION" == "planet" ]; then

			POLY=""
		
		else

			POLY="-B=$obPOLY"
		
		fi
		
		# to make osmupdate find osmconvert and wget in macOS package
		cd "$MYDIR"
		
		osmupdate --verbose $KEEPTEMP --day \
			-t="$MROSMPATH/osmupdate/temp" \
			"$POLY" \
			"$PATHFILENAME" \
			"$PATHNAME"/"$REGION-new.osm.pbf"
			1> "$MROSMPATH"/tmp/osmupdate_$FILENAME.log 2> "$MROSMPATH"/tmp/osmupdate_$FILENAME.err.log
		
		cd "$MROSMPATH"
		# from here on path is ./ again
		
		echo " "
		echo "MROSM: Ende  osmupdate: "`date +%d.%m.%Y\ %H:%M:%S`

		# rename
		if [ -f "$PATHNAME/$REGION-new.osm.pbf" ]; then

			rm -rf "$PATHFILENAME"
			mv "$PATHNAME/$REGION-new.osm.pbf" "$PATHFILENAME"
	
		# up-to-date
		else

			echo "MROSM: $PATHFILENAME bereits aktuell"
			#echo "       $PATHFILENAMEwin"
		fi
	
	else

		echo "MROSM: .poly fehlt - $PATHFILENAME wird NICHT aktualisiert"
		#echo "       $PATHFILENAMEwin"
	fi
fi