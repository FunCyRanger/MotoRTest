#!/bin/bash

# Gernot Skottke, 05.05.2021

# Include MROSM_functions.bash
source "$MYDIR"/MROSM_functions.bash

# calculate installed RAM
RAMinstalled

# path to osmctools and wget
# macOS
if [ "$(uname)" == "Darwin" ]; then
	
	# use inside app-package
	bashpath="$MYDIR/"

else

	# use as command
	bashpath=""
			
fi

# read selection from file 	
## macOS: ~/Library/Application\ Support/MROSM/MROSM_settings 
## Linux: $HOME/MROSM/MROSM_settings
if [ -f "$APPSUPP"/MROSM_settings ]; then 

	i=1
	while read -u2 -r LINE
	do
	
		# Ubuntu-Linux-Subsystem (Windows 10)
		if [[ "$(uname -a)" = *"Microsoft"* ]]; then
		
			LINE=$(echo "$LINE" | sed -e 's/\r//g')
			
			# echo $i" vorher:"${LINE}
			if [[ "${LINE:1:1}" = ":" ]]; then
				declare "inputwin$i=${LINE}"                      # win-path
				# convert windows path to wsl-path 
				wslLINEr=$(echo `wslpath "${LINE}" 2> /dev/null`) # wsl-path with \r
				wslLINE=$(echo $wslLINEr | sed -e 's/\r//g')      # wsl-path without \r
				
				# Not supported wsl.pathes
				if [ "$wslLINE" == "" ]; then 
				
					echo "MROSM: ABBRUCH! Ausgewählter Pfad $LINE wird im Linux-Subsystem nicht unterstützt."
						
					powershell.exe [Void][Reflection.Assembly]::LoadWithPartialName\(\"System.Windows.Forms\"\)\;\$obj=New-Object\ Windows.Forms.NotifyIcon\;\$obj.Icon\ =\ [drawing.icon]::ExtractAssociatedIcon\(\$PSHOME+\"\\powershell.exe\"\)\;\$obj.Visible\ =\ \$True\;\$obj.ShowBalloonTip\(100000,\ \"MotoRoute-OpenStreetMap\",\"ABBRUCH! Ausgewählter Pfad $LINE wird im Linux-Subsystem nicht unterstützt.\",3\)
					
					# title
					echo -e '\033]2;'$bashTITLE'\007'

					read -n1 -s
					exit
						
				fi
				
				declare "input$i=${wslLINE}" # wsl-path
				# echo $i" nachher:"${wslLINE}
			
			else
				declare "input$i=${LINE}"
				# echo $i":"${LINE}
				
			fi

		# macOS
		# Linux
		else

			# echo $i":"${LINE}
			declare "input$i=${LINE}"
		fi
		
		((i+=1))
		
	done 2< "$APPSUPP"/MROSM_settings

	obPROJ=$input1
	#obPROJwin=$inputwin1
	
	obFILE=$input2
	obFILEwin=$inputwin2
	
	chkUPDATE=$input3
	chkKEEPTEMP=$input4
	chkCUTPOLY=$input5
	
	obPOLY=$input6
	#obPOLYwin=$inputwin6
	
   	obTILES=$input7
	#obTILESwin=$inputwin7
	
	obBOUNDS=$input8
	obBOUNDSwin=$inputwin8
	
	obSEA=$input9
	obSEAwin=$inputwin9

   	obSPLITTER=$input10
	obSPLITTERwin=$inputwin10
   	
	obMKGMAP=$input11
	obMKGMAPwin=$inputwin11
   	
   	chkKEEPTILES=$input12
   	chkGMAPSUPP=$input13
   	
   	txfFID=$input14
   	rbCP=$input15
	
	obSTYLE=$input16
	obSTYLEwin=$inputwin16

	chkSETTINGS=$input17
	
	# Ubuntu-Linux-Subsystem (Windows 10)
	if [[ "$(uname -a)" = *"Microsoft"* ]]; then 

		chkSHUTDOWN=$input18

	fi
		
	PATHFILENAME=$obFILE # .osm.pbf input-file
	PATHFILENAMEwin=$obFILEwin # .osm.pbf input-file win
	
	PATHNAME=$(dirname "$obFILE") # pathname of .osm.pbf input-file
	#PATHNAMEwin=$(echo `wslpath -w "$PATHNAME" 2> /dev/null`)
	FILENAME=$(basename "$obFILE") # basename of .osm.pbf input-file

else

	echo "MROSM: "$APPSUPP"/MROSM_settings nicht vorhanden"
	
	# title
	if [ "$(uname -s)" == "Linux" ]; then

		echo -e '\033]2;'$bashTITLE'\007'

	fi
	
	read -n1 -s
	exit
	
fi

# MROSM project-folder
if [ -d "$obPROJ" ]; then

	# selected MROSM project-folder exist
	if [ "$(basename "$obPROJ")" == "MROSM" ]; then

		MROSMPATH="$obPROJ"
		#MROSMPATHwin=$(echo `wslpath -w "$MROSMPATH" 2> /dev/null`)
		
		echo "MROSM: $obPROJ vorhanden"
		#echo "       $obPROJwin"

	# selected MROSM project-folder exist in subfolder
	elif [ -d "$obPROJ/MROSM" ]; then

		MROSMPATH="$obPROJ/MROSM"
		#MROSMPATHwin=$(echo `wslpath -w "$MROSMPATH" 2> /dev/null`)
		
		echo "MROSM: $MROSMPATH vorhanden"
		#echo "       $MROSMPATHwin"
	
	# selected MROSM project-folder not exist in subfolder
	else 

		MROSMPATH="$obPROJ/MROSM"
		#MROSMPATHwin=$(echo `wslpath -w "$MROSMPATH" 2> /dev/null`)
		
		mkdir "$MROSMPATH"
		
		echo "MROSM: $MROSMPATH angelegt"
		#echo "       $MROSMPATHwin"
	fi
			
else
	
		# MROSM project-folder not exist

		MROSMPATH="$obPROJ"
		#MROSMPATHwin=$(echo `wslpath -w "$MROSMPATH" 2> /dev/null`)
		
		mkdir "$MROSMPATH"
		
		echo "MROSM: $MROSMPATH angelegt" 
		#echo "       $MROSMPATHwin"
		
fi

cd "$MROSMPATH"
# from here on path is ./

# MROSM temp-folder
if [ -d ./tmp ]; then

	#MROSMTEMPwin=$(echo `wslpath -w "$MROSMPATH/tmp" 2> /dev/null`)
	
	echo "MROSM: $MROSMPATH/tmp gelöscht"
	
	rm -rf ./tmp

fi

mkdir ./tmp
	
#MROSMTEMPwin=$(echo `wslpath -w "$MROSMPATH/tmp" 2> /dev/null`)
	
echo "MROSM: $MROSMPATH/tmp angelegt"
#echo "       $MROSMTEMPwin"

# check java
# macOS
if [ "$(uname -s)" == "Darwin" ]; then

	# check JDK
	which javac > ./tmp/java.log 2>&1

# Ubuntu-Linux-Subsystem (Windows 10)
# Linux
else

	which java > ./tmp/java.log 2>&1

fi

logJAVA=$(head -n 1 ./tmp/java.log)
if [ "$logJAVA" == "" ]; then

	# Ubuntu-Linux-Subsystem (Windows 10)
	if [[ "$(uname -a)" = *"Microsoft"* ]]; then

		which java.exe > ./tmp/java.log 2>&1
		logJAVAEXE=$(head -n 1 ./tmp/java.log)
		
		# without any installed Java
		if [ "$logJAVAEXE" == "" ]; then

			echo "MROSM: Bitte installiere zuerst Java"
			echo "MROSM: entweder im Ubuntu-Linux-Subsystem: sudo apt install default-jre"
			echo "MROSM: oder Windows als 64-Bit-Version"
			echo "msgbox \"ABBRUCH! Bitte installiere zuerst Java\" & vbCrLf & \"entweder im Ubuntu-Linux-Subsystem:\" & vbCrLf & \"sudo apt install default-jre\" & vbCrLf & \"oder Windows als 64-Bit-Version\", vbExclamation, \"MotoRoute-OpenStreetMap\"" > ./tmp/msg.vbs			
			cscript.exe //nologo ./tmp/msg.vbs
			rm -rf ./tmp/msg.vbs
			
			# title
			echo -e '\033]2;'$bashTITLE'\007'

			read -n1 -s
			exit
		
		# with installed Java in Windows	
		else
			JAVA="java.exe"
		
		fi
		
	# Linux
	elif [ "$(uname -s)" == "Linux" ]; then

		zenity --warning \
			--title="MotoRoute OpenStreetMap »Kartenbäckerei«" \
			--text="ABBRUCH! Bitte installiere zuerst Java:\n\nsudo apt install default-jre" \
			--width=400 --height=50 2> /dev/null
	
		echo "MROSM: ABBRUCH! Bitte installiere zuerst Java: sudo apt install default-jre"	
		
		# title
		echo -e '\033]2;'$bashTITLE'\007'
		
		read -n1 -s
		exit
		
	# macOS
	elif [ "$(uname -s)" == "Darwin" ]; then

		echo "ALERT:MotoRoute-OpenStreetMap|Bitte installiere zuerst Java-Development-Kit (JDK)!"
		echo "QUITAPP"
		
		read -n1 -s
		exit
		
	fi

# Ubuntu-Linux-Subsystem (Windows 10) with installed Java in Ubuntu-Linux-Subsystem	
# Linux
# macOS
else

	JAVA="java"
	
fi

# java version
$JAVA -version 2> ./tmp/javaversion.log
logJAVA=$(head -n 1 ./tmp/javaversion.log)
JAVAPATH=$(echo `which "$JAVA"`)
#JAVAPATHwin=$(echo `wslpath -w "$JAVAPATH" 2> /dev/null`)

# echo "MROSM: $JAVAPATH"
echo "MROSM: $logJAVA"

# Ubuntu-Linux-Subsystem (Windows 10)
# use tar.exe (for unzip, because no unzip installed in Ubuntu-Linux-Subsystem (Windows 10)
if [[ "$(uname -a)" = *"Microsoft"* ]]; then

	which tar.exe > ./tmp/tarexe.log 2>&1
	logTAREXE=$(head -n 1 ./tmp/tarexe.log)
	
	if [ "$logTAREXE" == "" ]; then
			
		echo "msgbox \"ABBRUCH! tar.exe nicht gefunden! Bitte Windows aktualisieren!\", vbExclamation, \"MotoRoute-OpenStreetMap\"" > ./msg.vbs
		cscript.exe //nologo ./msg.vbs
		rm -rf ./msg.vbs
			
		# title
		echo -e '\033]2;'$bashTITLE'\007'
		
		read -n1 -s
		exit
		
	fi

fi

# check osmctools (update or cut or generate bounds)
# Ubuntu-Linux-Subsystem (Windows 10)
# Linux
if [[ "$(uname -a)" = *"Microsoft"* ]] || [ "$(uname -s)" == "Linux" ]; then

	if [ $chkUPDATE = 1 ] || [ $chkCUTPOLY = 1 ]; then

		which osmconvert >> ./tmp/osmctools.log 2>&1
		which osmfilter >> ./tmp/osmctools.log 2>&1
		which osmupdate > ./tmp/osmctools.log 2>&1
		logOSMCTOOLS=$(head -n 1 ./tmp/osmctools.log)

		if [ "$logOSMCTOOLS" == "" ]; then
			
			echo "MROSM: ABBRUCH! Bitte installiere zuerst osmctools: sudo apt install osmctools"
			
			# Ubuntu-Linux-Subsystem (Windows 10)
			if [[ "$(uname -a)" = *"Microsoft"* ]]; then
			
				echo "msgbox \"ABBRUCH! Bitte installiere zuerst osmctools: sudo apt install osmctools\", vbExclamation, \"MotoRoute-OpenStreetMap\"" > ./msg.vbs
				cscript.exe //nologo ./msg.vbs
				rm -rf ./msg.vbs
			
			# Linux
			elif [ "$(uname -s)" == "Linux" ]; then

				zenity --warning \
					--title="MotoRoute OpenStreetMap »Kartenbäckerei«" \
					--text="ABBRUCH! Bitte installiere zuerst osmctools:\n\nsudo apt install osmctools" \
					--width=400 --height=50 2> /dev/null
			
			fi
			
			# title
			echo -e '\033]2;'$bashTITLE'\007'
			
			read -n1 -s
			exit
			
		else
			
			echo "MROSM: osmctools sind installiert"

		fi
		
	fi

fi

# filename without extension
FILENAMEnoext="${FILENAME%%.*}"
REGION=${FILENAMEnoext%-*}

# Include MROSM_update.bash
source "$MYDIR/MROSM_4_update.bash"
	
# split region in substrings (rheinland-pfalz in $1:rheinland, $2:pfalz)
IFS="-"
set - $REGION
REGIONlength=${#REGION}

if [ "${#2}" -eq 0 ]; then

	if [ "${REGIONlength}" -gt 2 ]; then

		REGIONshort=${REGION:0:3} # bayern = bay
		
	else
		REGIONshort=$REGION 
	
	fi

else

	REGIONshort=${1:0:1}${2:0:1} # rheinland-pfalz = rp

fi

# mkgmap uses only up to 50 chars. space for $REGION only 27 chars.
echo " "

if [ "${REGIONlength}" -gt 25 ]; then

	REGION=${REGION:0:25}

fi

IFS=" "
# lower case in UPPER case
REGION=`echo "$REGION" | tr '[:lower:]' '[:upper:]'`
REGIONshort=`echo "$REGIONshort" | tr '[:lower:]' '[:upper:]'`

echo "MROSM: zu backende Region $REGION ($REGIONshort)"

# timestamp of .osm.pbf file
STARTdate=$(date "+%Y-%m-%d")
STARTyear=$(date "+%Y")
STARTymd=$(date "+%Y%m%d")

REGIONdate=$("$bashpath"osmconvert "$PATHFILENAME" --out-timestamp)

if [ "${REGIONdate:1:7}" == "invalid" ]; then

	REGIONdate=$STARTdate

else

	REGIONdate=${REGIONdate:0:10}

fi

# calculate size of .osm.pbf file (MB)
FILESIZE "$PATHFILENAME"
echo "MROSM: $FILENAME $REGIONdate ($FILESIZE MB)"

# set family id
if ! [ "$txfFID" == "" ]; then

	if [ $txfFID -gt 65535 ]; then
	
		echo "MROSM: Family-ID $txfFID zu hoch - korrigiere ..."
		txfFID=""
	
	else

		FID=$txfFID
	
	fi	
	
fi	

# if not given, set family id from gregorian date to julian day number 
if [ "$txfFID" == "" ]; then

	GtoJDN ${REGIONdate:8:2} ${REGIONdate:5:2} ${REGIONdate:0:4} 
	typeset -i num
	num=$(($RANDOM % 9+1))
	MJD=${JD: -3}
	
	if [ "${MJD:0:1}" == "0" ]; then

		MJD="5""${JD: -2}"
	
	fi
	
	FID=$MJD$num

fi

echo "MROSM: Family-ID $FID"

# set map-id
if [ ${#FID} -lt 4 ]; then

	MID=$(expr 1000 + $FID)"0001"

elif [ ${#FID} -gt 4 ]; then

	MID=${FID:0:4}"0001"

else
	MID=$FID"0001"
fi
echo "MROSM: Map-ID $MID"

# mark unicode codepage
if [ "$rbCP" == "unicode" ]; then

	CP="U"

fi

# MROSM maps-folder
echo " "
MROSMMAPS="$MROSMPATH/maps"
#MROSMMAPSwin=$(echo `wslpath -w "$MROSMPATH/maps" 2> /dev/null`)

if [ -d ./maps ]; then

	echo "MROSM: $MROSMPATH/maps vorhanden"
	#echo "       $MROSMMAPSwin"

else

	mkdir ./maps
	echo "MROSM: $MROSMPATH/maps angelegt"
	#echo "       $MROSMMAPSwin"

fi

# MROSM region-folder
MROSMREGION="$MROSMPATH/maps/$REGION $REGIONdate $FID$CP"
#MROSMREGIONwin=$(echo `wslpath -w "$MROSMPATH/maps/$REGION $REGIONdate $FID$CP" 2> /dev/null`)

if [ -d "$MROSMREGION" ]; then

	rm -rf "$MROSMREGION"

fi

mkdir ./maps/$REGION" "$REGIONdate" "$FID$CP

echo "MROSM: $MROSMPATH/maps/$REGION $REGIONdate $FID$CP angelegt"
#echo "       $MROSMREGIONwin"

# unzip splitter 
MyUnzip "$obSPLITTER" "$obSPLITTERwin"
find ./ -maxdepth 1 -iname "splitter-*" > ./tmp/splitter.txt
SPLITTERfolder="$(sed -n '1p' ./tmp/splitter.txt)"
SPLITTERfolder=${SPLITTERfolder//\.\/\//}
echo "MROSM: Inhalt $SPLITTERfolder"

# unzip mkgmap 
MyUnzip "$obMKGMAP" "$obMKGMAPwin"
find ./ -maxdepth 1 -iname "mkgmap-*" > ./tmp/mkgmap.txt
MKGMAPfolder="$(sed -n '1p' ./tmp/mkgmap.txt)"
MKGMAPfolder=${MKGMAPfolder//\.\/\//}
echo "MROSM: Inhalt $MKGMAPfolder"

# unzip style
MyUnzip "$obSTYLE" "$obSTYLEwin"
find ./ -maxdepth 1 -iname "style-*" > ./tmp/style.txt
STYLEfolder="$(sed -n '1p' ./tmp/style.txt)"
STYLEfolder=${STYLEfolder//\.\/\//}
echo "MROSM: Inhalt $STYLEfolder"