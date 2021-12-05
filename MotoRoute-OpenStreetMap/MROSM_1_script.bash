#!/bin/bash

# Gernot Skottke, 05.05.2021

export TERM=${TERM:-dumb}
export PATH=.:$PATH

# dir-variables
# MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# MYDIRwin=$(echo `wslpath -w "$MYDIR" 2> /dev/null`)
# MROSMDIR="$HOME"
MROSMDIR="$PWD"

# variables
OSMUPDATE=0.4.5
OSMCONVERT=0.8.11
OSMFILTER=1.4.6
WGET=1.20.1
PASHUA=0.11
TITLE="MotoRoute OpenStreetMap »Kartenbäckerei« • macOS, Ubuntu-Linux & Windows 10"
bashTITLE="MotoRoute OpenStreetMap »Kartenbäckerei«"
subTITLE="Garmin Karte für BaseCamp und Navi aus OpenStreetMap-Geodaten erzeugen"
PROGRAMMER="Gernot Skottke • scotti@motoroute.de"
VERSIONnumber="2.1"
VERSIONid="107"
VERSIONdate="2021-05-14"
TYPFILE="mrosm.txt"
PREPROCESSOR="uk.me.parabola.mkgmap.reader.osm.boundary.BoundaryPreprocessor"

# MROSM_settings
# Ubuntu-Linux-Subsystem (Windows 10)
if [ "$(uname -a)" = *"Microsoft"* ]
	then

	#remember $HOME/MROSM is 	
	#C:\Users\scotti\AppData\Local\Packages\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\LocalState\rootfs\home\scotti\MROSM

	# title
	echo -e '\033]2;'$bashTITLE'\007'
		
	ME="$(whoami)"
	
	if [ $ME == "root" ]
		then
	
		echo "MROSM: User root wird im Linux-Subsystem nicht unterstützt. Bitte Linux-Subsystem richtig konfigurieren."
		
		powershell.exe [Void][Reflection.Assembly]::LoadWithPartialName\(\"System.Windows.Forms\"\)\;\$obj=New-Object\ Windows.Forms.NotifyIcon\;\$obj.Icon\ =\ [drawing.icon]::ExtractAssociatedIcon\(\$PSHOME+\"\\powershell.exe\"\)\;\$obj.Visible\ =\ \$True\;\$obj.ShowBalloonTip\(100000,\ \"MotoRoute-OpenStreetMap\",\"User root wird im Linux-Subsystem nicht unterstützt. Bitte Linux-Subsystem richtig konfigurieren.\",3\)
		
		# title
		echo -e '\033]2;'$bashTITLE'\007'
		
		read -n1 -s
		exit
	
	fi
	
	APPSUPPwin="$(cmd.exe /c "<nul set /p=%USERPROFILE%" 2>/dev/null)"
	APPSUPP=$(wslpath "$APPSUPPwin")
	
	wgetdotbar=bar

# Linux: $MROSMDIR = $HOME/MROSM
elif [ "$(uname -s)" == "Linux" ]
	then

	APPSUPP="$MROSMDIR"
	
	wgetdotbar=bar

	#title
	echo -e '\033]2;'$bashTITLE'\007'

# macOS: ~/Library/Application\ Support/MROSM
elif [ "$(uname)" == "Darwin" ]
	then

	APPSUPP=~/Library/Application\ Support/MROSM
	
	wgetdotbar=dot

# not supported OS
else

	echo "MROSM: Unerwartetes Betriebssytem - Not supported"
	
	read -n1 -s
	exit
fi

# mask 
echo " "
echo $TITLE
echo " "
echo $subTITLE
echo " "
echo "Version "$VERSIONnumber"."$VERSIONid" • "$VERSIONdate" • "$PROGRAMMER
echo " "

if [ "$(uname)" == "Darwin" ]; then

	echo "Implementierte Versionen"
	echo " • osmupdate-"$OSMUPDATE" • osmconvert-"$OSMCONVERT" • osmfilter-"$OSMFILTER
	echo " • wget-"$WGET
	echo " • pashua-"$PASHUA

fi

echo " "
echo "Daten von OpenStreetMap.org • Da kannst auch Du mitmachen!"
echo "Veröffentlicht unter ODbL • http://opendatacommons.org/licenses/odbl"
echo "Map created with mkgmap • http://mkgmap.org.uk"
echo " "
echo "Präsentiert von MotoRoute.de • Mit uns findest Du den richtigen Weg"
echo " "
echo " "

# restart after shutdown
# macOS
if [ "$(uname)" == "Darwin" ]; then

	if [ -f "$APPSUPP"/MROSM_shutdown ]; then
	
		REGIONbaked=$(head -n 1 "$APPSUPP"/MROSM_shutdown)
		
		rm -rf "$APPSUPP"/MROSM_shutdown
		
		echo "ALERT:MotoRoute OpenStreetMap|Deine $REGIONbaked Karte ist fertig"
		echo "QUITAPP"
		exit
	
	fi

fi

# Ubuntu-Linux-Subsystem (Windows 10) 
if [[ "$(uname -a)" = *"Microsoft"* ]]; then

	# do nothing 
	sleep 1

# Linux 
# macOS
elif [ "$(uname -s)" == "Linux" ] || [ "$(uname)" == "Darwin" ]; then

	# copy default settings (MROSM_settings_default)
	if ! [ -f "$APPSUPP"/MROSM_settings ]; then

		if ! [ -d "$APPSUPP" ]; then

			mkdir "$APPSUPP"
			
		fi
		
		cp "$MYDIR"/MROSM_settings_default "$APPSUPP"/MROSM_settings
		echo "No settings file found, default sttings copied"
	else
		echo "Settings found"
	fi

fi

# include MROSM_functions.bash
source "$MYDIR"/MROSM_functions.bash

# Ubuntu-Linux-Subsystem (Windows 10)
if [[ "$(uname -a)" = *"Microsoft"* ]]; then

	#Windows-GUI by HTA file
	echo "Voraussetzungen:"
	echo " • Installiertes Ubuntu Linux-Subsystem"
	echo " • User (nicht root) muss im Linux-Subsystem angelegt sein"
	echo " • 1. Unbedingt ausführen!"
	echo "   - sudo apt update"
	echo " • 2. 64-Bit Java:"
	echo "   - entweder in Windows: https://java.com/de/download/manual.jsp"
    echo "   - oder im Linux-Subsystem (empfohlen): sudo apt install default-jre"
	echo " • 3. osmctools (osmupdate, osmconvert, osmfilter):"
	echo "   - sudo apt install osmctools"
	echo " • optional Linux-Subsystem aktualisieren und aufräumen:"
	echo "   - sudo apt upgrade && sudo apt autoremove && sudo apt autoclean"
	echo " "
	echo "Linux Subsystem wird gestartet . . ."
	echo " "

# Linux
elif [ "$(uname -s)" == "Linux" ]; then

	echo "Voraussetzungen:"
	echo " • 64-Bit Java:"
    echo "   - sudo apt install default-jre"
	echo " • osmupdate, osmconvert, osmfilter:"
	echo "   - sudo apt install osmctools"
	echo " "
	
	source "$MYDIR"/MROSM_2_zenity_dialog.bash

# include MROSM_pashua_mask.bash
# pashua mask macOS
elif [ "$(uname)" == "Darwin" ]; then

	source "$MYDIR"/MROSM_2_pashua_mask.bash
	echo "REFRESH"

fi

# include MROSM_preparation.bash
source "$MYDIR"/MROSM_3_preparation.bash

# include MROSM_mapbuilder.bash
source "$MYDIR"/MROSM_5_mapbuilder.bash

# Ubuntu-Linux-Subsystem (Windows 10)
if [[ "$(uname -a)" = *"Microsoft"* ]]; then

	# include MROSM_win_install.bash
	source "$MYDIR"/MROSM_6_win_install.bash
	
	# generate Install.bat and Uninstall.bat
	Install
	Uninstall
	
fi

# include MROSM_cleanup.bash
source "$MYDIR"/MROSM_7_cleanup.bash

# Ubuntu-Linux-Subsystem (Windows 10)
if [[ "$(uname -a)" = *"Microsoft"* ]]; then

	powershell.exe [Void][Reflection.Assembly]::LoadWithPartialName\(\"System.Windows.Forms\"\)\;\$obj=New-Object\ Windows.Forms.NotifyIcon\;\$obj.Icon\ =\ [drawing.icon]::ExtractAssociatedIcon\(\$PSHOME+\"\\powershell.exe\"\)\;\$obj.Visible\ =\ \$True\;\$obj.ShowBalloonTip\(100000,\ \"MotoRoute-OpenStreetMap\",\"Deine $REGION Karte ist fertig\",0\)

	# title
	echo -e '\033]2;'$bashTITLE'\007'

# Linux
elif [ "$(uname -s)" == "Linux" ]; then

	notify-send --expire-time=30 MotoRoute-OpenStreetMap "Deine $REGION Karte ist fertig" 2> /dev/null

	# title
	echo -e '\033]2;'$bashTITLE'\007'

# macOS
elif [ "$(uname)" == "Darwin" ]; then

	# open maps folder
	open ./maps/$REGION" "$REGIONdate" "$FID$CP
	echo "NOTIFICATION:Deine $REGION Karte ist fertig"

fi

# copyright
echo " "
echo "MROSM: Daten von OpenStreetMap"
echo "MROSM: http://www.openstreetmap.org"
echo "MROSM: Veröffentlicht unter ODbL"
echo "MROSM: http://opendatacommons.org/licenses/odbl"
echo "MROSM: Map created with mkgmap"

echo " "
echo "MROSM: Deine "$REGION" Karte ist fertig"
echo "MROSM: Präsentiert von MotoRoute - http://motoroute.de"
echo "MROSM: Mit uns findest Du den richtigen Weg"

# Ubuntu-Linux-Subsystem (Windows 10)
if [[ "$(uname -a)" = *"Microsoft"* ]]; then

	# empty %temp%\MROSM
	if [ -d "$MYDIR" ]; then 

		rm -rf "$MYDIR" 2> /dev/null 
	
	fi
	
fi

# shutdown
if [ "$chkSHUTDOWN" == "1" ]; then

	echo " "

	# Ubuntu-Linux-Subsystem (Windows 10)
	if [[ "$(uname -a)" = *"Microsoft"* ]]; then

		shutdown.exe /s /t 120 /d u:4:2 /c "Dein Computer wird in wenigen Minuten heruntergefahren. Herunterfahren abbrechen mit   shutdown /a"
		
		echo -n "MROSM: Herunterfahren abbrechen? (J/j/Y/y/N/n)"
		
		read answer
		
		if [ "$answer" != "${answer#[JjYy]}" ]; then
			shutdown.exe /a
			
			echo "MROSM: Herunterfahren wurde abgebrochen"
			
		else
			echo "MROSM: Dein System wird in wenigen Minuten heruntergefahren"
			
		fi

	#Linux
	elif [ "$(uname -s)" == "Linux" ]; then
	
		#systemctl poweroff
		shutdown -h -t 120
		
		shutdown=$(zenity --question \
			--title="MotoRoute OpenStreetMap »Kartenbäckerei«" \
       		--text="Dein System wird in wenigen Minuten heruntergefahren" \
			--ok-label="Ok" \
       		--cancel-label="abbrechen" \
			--width=500 --height=50 2> /dev/null)
			
		if [ "$shutdown" == "" ]; then

			shutdown -c
			echo "MROSM: Herunterfahren wurde abgebrochen"
			
		else

			echo "MROSM: Dein System wird in wenigen Sekunden heruntergefahren"
			
		fi

		# title
		echo -e '\033]2;'$bashTITLE'\007'

	# macOS
	elif [ "$(uname)" == "Darwin" ]; then

		# write shutdown to remember
		## macOS: ~/Library/Application\ Support/MROSM/MROSM_shutdown
		echo "$REGION" > "$APPSUPP"/MROSM_shutdown

		# user working then dialog | user NOT working then error
    	osascript -e 'tell app "loginwindow" to «event aevtrsdn»' 2> ./logs/MROSM_shutdown

    	# on error shutdown
    	if [ -f ./logs/MROSM_shutdown ]; then

    	    rm -rf ./logs/MROSM_shutdown
    		osascript -e 'tell app "System Events" to shut down'

		fi

	fi
	
fi
	
read -n1 -s
exit
