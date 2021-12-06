#!/bin/bash

# Gernot Skottke, 30.04.2021

echo "Execute MROSM_5_mapbuilder.bash"

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Include MROSM_functions.bash
source "$MYDIR"/MROSM_functions.bash

# splitter
echo " "

# if exist remake tiles folder
rm -rf ./tiles
# make tiles folder
mkdir ./tiles

# calculate free RAM
RAMfree "$REGION"

# splitter
echo "MROSM: Start splitter "`date +%d.%m.%Y\ %H:%M:%S`" (RAM "$RAMfree"m)"
echo "MROSM: $PATHFILENAME"
#echo "       $PATHFILENAMEwin"

# Ubuntu-Linux-Subsystem (Windows 10) with Java installed in Windows use Windows-Path
if [ $JAVA = "java.exe" ]; then

	PATHFILENAMEsplitter="$PATHFILENAMEwin"

# Ubuntu-Linux-Subsystem (Windows 10) with Java installed in Ubuntu-Linux-Subsystem use POSIX-Path
# Linux
# macOS
else 

	PATHFILENAMEsplitter="$PATHFILENAME"
	
fi

# splitter.jar
$JAVA -Xmx$RAMfree"m" -jar ./$SPLITTERfolder/splitter.jar \
	--mapid=$MID \
	--output-dir=./tiles \
	"$PATHFILENAMEsplitter" \
	1> ./tmp/$SPLITTERfolder"_"$REGION"_1".log 2> ./tmp/$SPLITTERfolder"_"$REGION"_2".log

echo "MROSM: Ende  splitter "`date +%d.%m.%Y\ %H:%M:%S`

# set mkgmap tiles folder or drive
echo " "

# standard tiles folder
if [ "$obTILES" == "" ]; then

	GBASEMAPtiles="$MROSMPATH"/tiles/gbasemap

# selected tiles folder
elif ! [ "$        " == "" ]; then

	if ! [ -d "$obTILES" ]; then
	
		mkdir "$obTILES"
	
	fi
	
	GBASEMAPtiles="$obTILES"/gbasemap

fi

# if exist remake tiles folder
if [ -d "$GBASEMAPtiles" ]; then

	rm -rf "$GBASEMAPtiles"
	
fi

mkdir -p "$GBASEMAPtiles"

# Ubuntu-Linux-Subsystem (Windows 10)
if [[ "$(uname -a)" = *"Microsoft"* ]]; then

	GBASEMAPtileswin=$(echo `wslpath -w "$GBASEMAPtiles" 2> /dev/null`)

fi

echo "MROSM: temporärer Ordner für Karten-Kacheln (gbasemap tiles)"
echo "MROSM: $GBASEMAPtiles"
#echo "       $GBASEMAPtileswin"

# copy temp text-typfile
echo " "

cp ./$STYLEfolder/$TYPFILE "$GBASEMAPtiles"/tmp$TYPFILE

echo "MROSM: TYP-File $TYPFILE aus $STYLE kopiert nach "
echo "MROSM: $GBASEMAPtiles"
#echo "       $GBASEMAPtileswin"

# change placeholder fid 21011 to user defined fid
sed 's/FID=21011/FID='$FID'/' \
	"$GBASEMAPtiles"/tmp$TYPFILE > "$GBASEMAPtiles"/$TYPFILE

# delete temp text-typfile
rm -rf "$GBASEMAPtiles"/tmp$TYPFILE

echo " "
echo "MROSM: Family-ID (FID) im TYP-File geändert in "$FID

# no gmapsupp.img also at big files > 10000 MB
echo " "

if [ $chkGMAPSUPP = 0 ]; then

	GMAPSUPP=
	echo "MROSM: gmapsupp.img wird NICHT erzeugt"
	
elif [ $chkGMAPSUPP = 1 ]; then

	# 12 GB Input = ~4 GB Output
	if [ $FILESIZE -gt 12288 ]; then
	
		# Ubuntu-Linux-Subsystem (Windows 10)
		if [[ "$(uname -a)" = *"Microsoft"* ]]; then

			powershell.exe [Void][Reflection.Assembly]::LoadWithPartialName\(\"System.Windows.Forms\"\)\;\$obj=New-Object\ Windows.Forms.NotifyIcon\;\$obj.Icon\ =\ [drawing.icon]::ExtractAssociatedIcon\(\$PSHOME+\"\\powershell.exe\"\)\;\$obj.Visible\ =\ \$True\;\$obj.ShowBalloonTip\(100000,\ \"MotoRoute-OpenStreetMap\",\"Vollständige Abdeckung für $REGION größer als 4 GB. Bitte Garmin MapInstall® nehmen.\",2\)
		
		# Linux
		elif [ "$(uname -s)" == "Linux" ]; then

			notify-send --expire-time=30 MotoRoute-OpenStreetMap "Vollständige Abdeckung für $REGION größer als 4 GB. Bitte Garmin MapInstall® nehmen." 2> /dev/null
		
		# macOS
		elif [ "$(uname)" == "Darwin" ]; then

			echo "NOTIFICATION:Vollständige Abdeckung für $REGION größer als 4 GB. Bitte Garmin MapInstall® nehmen."
		fi
		echo "MROSM: Vollständige Abdeckung für EUROPE größer als 4 GB"
		echo "MROSM: Bitte Garmin MapInstall® nehmen"
	
	# all
	else

		GMAPSUPP="--gmapsupp"
		echo "MROSM: gmapsupp.img wird erzeugt"
		
	fi
	
fi

# no housenumbers at big files with less RAM
# 12 GB Input = ~4 GB Output
if [ $RAMinstalled -le 4096 ] && [ $FILESIZE -gt 12288 ]; then

	HOUSENUMBERS=
	
	echo "MROSM: "$REGION" mit Hausnummern-Index benötigt mehr als 4 GB RAM"
	echo "MROSM: Hausnummern-Index wird NICHT erzeugt"

	# Ubuntu-Linux-Subsystem (Windows 10)
	if [[ "$(uname -a)" = *"Microsoft"* ]]; then

		powershell.exe [Void][Reflection.Assembly]::LoadWithPartialName\(\"System.Windows.Forms\"\)\;\$obj=New-Object\ Windows.Forms.NotifyIcon\;\$obj.Icon\ =\ [drawing.icon]::ExtractAssociatedIcon\(\$PSHOME+\"\\powershell.exe\"\)\;\$obj.Visible\ =\ \$True\;\$obj.ShowBalloonTip\(100000,\ \"MotoRoute-OpenStreetMap\",\"$REGION mit Hausnummern-Index benötigt mehr als 4 GB RAM. Hausnummern-Index wird NICHT erzeugt.\",2\)
		
	# Linux
	elif [ "$(uname -s)" == "Linux" ]; then

		notify-send --expire-time=30 MotoRoute-OpenStreetMap "$REGION mit Hausnummern-Index benötigt mehr als 4 GB RAM. Hausnummern-Index wird NICHT erzeugt." 2> /dev/null
		
	# macOS
	elif "$(uname)" == "Darwin"; then

		echo "NOTIFICATION:$REGION mit Hausnummern-Index benötigt mehr als 4 GB RAM. Hausnummern-Index wird NICHT erzeugt."
		
	fi

# all 
else

	HOUSENUMBERS="--housenumbers"
	echo "MROSM: Hausnummern-Index wird erzeugt"
	
fi

# Ubuntu-Linux-Subsystem (Windows 10) with Java installed in Windows use Windows-Path
if [ $JAVA = "java.exe" ]; then
	GBASEMAPtilesmkgmap="$GBASEMAPtileswin"

# Ubuntu-Linux-Subsystem (Windows 10) with Java installed in Ubuntu-Linux-Subsystem use POSIX-Path
# Linux
# macOS
else 

	GBASEMAPtilesmkgmap="$GBASEMAPtiles"
	
fi

# set free RAM
RAMfree "$REGION"

# mkgmap (gbasemap)
# Alternative --generate-sea:multipolygon,extend-sea-sectors,close-gaps=6000,floodblocker 
echo " "
echo "MROSM: backe $REGION"
echo "MROSM: Start mkgmap "`date +%d.%m.%Y\ %H:%M:%S`" (RAM "$RAMfree"m)"

# check output-dir gbasemap
echo "MROSM: gbasemap=""$GBASEMAPtilesmkgmap"

# mkgmap.jar
$JAVA -Xms512m -Xmx$RAMfree"m" -jar ./$MKGMAPfolder/mkgmap.jar \
	--bounds="$obBOUNDS" \
	--precomp-sea="$obSEA" \
	--output-dir="$GBASEMAPtilesmkgmap" \
	--max-jobs \
	--style-file=./$STYLEfolder/mrosm_style/ \
	--description="MROSM "$REGION" "$REGIONdate" "$FID$CP \
	--country-name=$REGION \
	--country-abbr=$REGIONshort \
	--family-id=$FID \
	--product-id=1 \
	--product-version=$VERSIONid \
	--mapname=$MID \
	--series-name="MROSM "$REGION" "$REGIONdate" "$FID$CP \
	--family-name="MROSM-"$REGION"-"$REGIONdate"-"$FID$CP \
	--area-name=$REGIONshort \
	--$rbCP \
	--draw-priority=10 \
	--tdbfile \
	--add-pois-to-areas \
	--poi-address \
	--link-pois-to-ways \
	--add-pois-to-lines \
	$HOUSENUMBERS \
	--remove-short-arcs \
	--levels=0:24,1:22,2:21,3:19,4:18,5:16 \
	--location-autofill=is_in,nearest \
	--merge-lines \
	--index \
	--x-split-name-index \
	--net \
	--route \
	--remove-short-arcs \
	--remove-ovm-work-files \
	--gmapi \
	$GMAPSUPP \
	./tiles/*.osm.pbf \
	--keep-going \
	"$GBASEMAPtilesmkgmap"/$TYPFILE \
	1> ./tmp/$MKGMAPfolder"_"$REGION"_1".log 2> ./tmp/$MKGMAPfolder"_"$REGION"_2".log
	
echo "MROSM: Ende  mkgmap "`date +%d.%m.%Y\ %H:%M:%S`

# delete text typfile
rm -rf "$GBASEMAPtiles"/$TYPFILE

mv "$GBASEMAPtiles""/MROSM-"$REGION"-"$REGIONdate"-"$FID$CP".gmap" \
	./maps/$REGION" "$REGIONdate" "$FID$CP"/MROSM-"$REGION"-"$REGIONdate"-"$FID$CP".gmap"

echo " "
echo "MROSM: MROSM-"$REGION"-"$REGIONdate"-"$FID$CP".gmap erzeugt und kopiert nach"
echo "MROSM: "$MROSMPATH"/maps/"$REGION" "$REGIONdate" "$FID$CP

# move gmapsupp.img to maps folder
if [ -f "$GBASEMAPtiles"/gmapsupp.img ]; then

	echo " "

	# hint: mv = error. cp + rm good on NTFS
	cp "$GBASEMAPtiles"/gmapsupp.img \
		./maps/$REGION" "$REGIONdate" "$FID$CP	

	rm "$GBASEMAPtiles"/gmapsupp.img
	
	echo "MROSM: gmapsupp.img erzeugt und kopiert nach"
	echo "MROSM: "$MROSMPATH"/maps/"$REGION" "$REGIONdate" "$FID$CP

fi

# keep tiles folder
if [ $chkKEEPTILES = 1 ]; then

	mv "$GBASEMAPtiles" \
		./maps/$REGION" "$REGIONdate" "$FID$CP

	echo " " 
	echo "MROSM: temporärer Ordner für Karten-Kacheln (gbasemap tiles) verschoben nach"
	echo "MROSM: "$MROSMPATH"/maps/"$REGION" "$REGIONdate" "$FID$CP

fi 
