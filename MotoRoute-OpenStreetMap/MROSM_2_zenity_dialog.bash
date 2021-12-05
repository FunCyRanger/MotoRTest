#!/bin/bash

# Gernot Skottke, 04.05.2021

# Read selection from file 
# Linux: $HOME/MROSM/MROSM_settings
if [ -f "$APPSUPP/MROSM_settings" ]; then 
	
	i=1
	while read LINE
	do
		echo "$i"":""${LINE}"
		# declare input"$i"="${LINE}"
		inputx[$i]="${LINE}"
		((i+=1))
	done < "$APPSUPP/MROSM_settings"

	obPROJ=${inputx[1]}
	obFILE=${inputx[2]}
	chkUPDATE=${inputx[3]}
	chkKEEPTEMP=${inputx[4]}
	chkCUTPOLY=${inputx[5]}
	obPOLY=${inputx[6]}
  	obTILES=${inputx[7]}
	obBOUNDS=${inputx[8]}
	obSEA=${inputx[9]}
   	obSPLITTER=${inputx[10]}
	obMKGMAP=${inputx[11]}
	chkKEEPTILES=${inputx[12]}
  	chkGMAPSUPP=${inputx[13]}
 	txfFID=${inputx[14]}
	rbCP=${inputx[15]}
	obSTYLE=${inputx[16]}
	chkSETTINGS=${inputx[17]}
	
	echo "MROSM_2_zenity_dialog.bash: MROSM_settings found and read"
else
	echo "MROSM_2_zenity_dialog.bash: MROSM_settings not found"
fi

if [ "$obPROJ" == "" ]; then

	obPROJ="$HOME"
	
fi

echo "MROSM: Bitte Projekt-Ordner/Laufwerk auswählen"

obPROJ=$(zenity --file-selection \
	--title='Auswahl Projekt-Ordner/Laufwerk (MROSM)' \
	--directory --filename="$obPROJ" 2> /dev/null)

if [ "$obPROJ" == "" ]; then

	obPROJ="$HOME/MROSM"

fi

echo "MROSM: Projekt-Ordner/Laufwerk $obPROJ"
echo ""
echo "MROSM: Bitte .osm.pbf Datei auswählen"

obFILE=$(zenity --file-selection \
	--title='Auswahl .osm.pbf Datei' \
	--file-filter='*.osm.pbf' --filename="$obFILE" 2> /dev/null)

if [ "$obFILE" == "" ]; then

	zenity --warning \
		--title="MotoRoute OpenStreetMap »Kartenbäckerei«" \
		--text="ABBRUCH! Du hast leider keine .osm.pbf Datei ausgewählt." \
		--width=400 --height=50 2> /dev/null
	
	echo "MROSM: ABBRUCH! Du hast leider keine .osm.pbf Datei ausgewählt."	
	
	exit

fi

echo "MROSM: $obFILE"
echo ""

txtUPDATE="aktualisieren (.poly benötigt)"
txtKEEPTEMP="Aktualisierungen behalten"
txtCUTPOLY="aus .osm.pbf schneiden"
txtKEEPTILES="temporären tiles Ordner behalten"
txtGMAPSUPP="erzeuge gmapsupp.img (bis 4 GB FAT32)"
txtSETTINGS="Einstellungen speichern"
txtSHUTDOWN="Computer ausschalten"

if [ $chkUPDATE = 1 ]; then

	setUPDATE=True

else

	setUPDATE=False

fi

if [ $chkKEEPTEMP = 1 ]; then

	setKEEPTEMP=True

else

	setKEEPTEMP=False

fi

if [ $chkCUTPOLY = 1 ]; then

	setCUTPOLY=True

else
	setCUTPOLY=False

fi

if [ $chkKEEPTILES = 1 ]; then
	setKEEPTILES=True

else

	setKEEPTILES=False

fi

if [ $chkGMAPSUPP = 1 ]; then

	setGMAPSUPP=True

else

	setGMAPSUPP=False

fi

if [ $chkSETTINGS = 1 ]; then

	setSETTINGS=True

else

	setSETTINGS=False

fi

echo "MROSM: Bitte Optionen auswählen"

chk1=$(zenity --list --checklist \
	--text="$obFILE" \
	--column="Auswahl" \
	--column="Option" \
	$setUPDATE "$txtUPDATE" \
	$setKEEPTEMP "$txtKEEPTEMP" \
	$setCUTPOLY "$txtCUTPOLY" \
	$setKEEPTILES "$txtKEEPTILES" \
	$setGMAPSUPP "$txtGMAPSUPP" \
	$setSETTINGS "$txtSETTINGS" \
	False "$txtSHUTDOWN" \
	--title="MotoRoute OpenStreetMap »Kartenbäckerei«" \
	--width=500 --height=350 2> /dev/null)

if [[ "$chk1" == *"$txtUPDATE"* ]]; then

	chkUPDATE=1

else

	chkUPDATE=0

fi

echo "MROSM: ($chkUPDATE) $txtUPDATE"

if [[ "$chk1" == *"$txtKEEPTEMP"* ]]; then

	chkKEEPTEMP=1

else

	chkKEEPTEMP=0

fi

echo "MROSM: ($chkKEEPTEMP) $txtKEEPTEMP"

if [[ "$chk1" == *"$txtCUTPOLY"* ]]; then

	chkCUTPOLY=1

else

	chkCUTPOLY=0

fi

echo "MROSM: ($chkCUTPOLY) $txtCUTPOLY"

if [[ "$chk1" == *"$txtSPLITTER"* ]]; then

	chkSPLITTER=1

else

	chkSPLITTER=0

fi

echo "MROSM: ($chkKEEPTILES) $txtKEEPTILES"

if [[ "$chk1" == *"$txtGMAPSUPP"* ]]; then

	chkGMAPSUPP=1

else

	chkGMAPSUPP=0

fi

echo "MROSM: ($chkGMAPSUPP) $txtGMAPSUPP"

if [[ "$chk1" == *"$txtSETTINGS"* ]]; then

	chkSETTINGS=1

else

	chkSETTINGS=0

fi

echo "MROSM: ($chkSETTINGS) $txtSETTINGS"

if [[ "$chk1" == *"$txtSHUTDOWN"* ]]; then

	chkSHUTDOWN=1

else

	chkSHUTDOWN=0

fi

echo "MROSM: ($chkSHUTDOWN) $txtSHUTDOWN"
echo ""

if [ "$chkUPDATE" == "1" ] || [ "$chkCUTPOLY" == "1" ]; then

	echo "MROSM: Bitte .poly Datei auswählen"

	obPOLY=$(zenity --file-selection \
		--title="Auswahl .poly Datei" \
		--file-filter="*.poly" --filename="$obPOLY" 2> /dev/null)

	if [ "$obPOLY" == "" ]; then

		zenity --notification \
			--text="Du hast keine .poly Datei ausgewählt." 2> /dev/null
		
		echo "MROSM: Du hast keine .poly Datei ausgewählt. "
	
	else

		echo "MROSM: .poly-Datei $obPOLY"
	
	fi
	
	echo ""

fi

if [ "$chkKEEPTILES" == "1" ]; then

	echo "MROSM: Bitte temporären gbasemap tiles Ordner auswählen"
	
	obTILES=$(zenity --file-selection \
		--title="Auswahl temporärer gbasemap tiles Ordner" \
		--directory --filename="$obTILES" 2> /dev/null)
	
	if [ "$obTILES" == "" ]; then

		obTILES=$HOME"/MROSM/tiles/gbasemap"
	
	fi
	
	echo "MROSM: temporärer gbasemap tiles Ordner $obTILES"

fi

echo " "
echo "MROSM: Bitte splitter*.zip auswählen"

obSPLITTER=$(zenity --file-selection \
	--title="Auswahl splitter*.zip" \
	--file-filter='*splitter*.zip' --filename="$obSPLITTER" 2> /dev/null)

	if [ "$obSPLITTER" == "" ]; then

		zenity --notification \
			--text="Du hast splitter*.zip nicht ausgewählt." 2> /dev/null
		
		echo "MROSM: Du hast splitter*.zip nicht ausgewählt. "
	
	else

		echo "MROSM: Splitter $obSPLITTER"
	
	fi

echo " "
echo "MROSM: Bitte mkgmap*.zip auswählen"

obMKGMAP=$(zenity --file-selection \
	--title="Auswahl mkgmap*.zip" \
	--file-filter='*mkgmap*.zip' --filename="$obMKGMAP" 2> /dev/null)

	if [ "$obMKGMAP" == "" ]; then

		zenity --notification \
			--text="Du hast mkgmap*.zip nicht ausgewählt." 2> /dev/null
		
		echo "MROSM: Du hast mkgmap*.zip nicht ausgewählt. "
	
	else

		echo "MROSM: Mkgmap $obMKGMAP"
	
	fi

echo " "
echo "MROSM: Bitte bounds*.zip auswählen"

obBOUNDS=$(zenity --file-selection \
	--title="Auswahl bounds*.zip" \
	--file-filter='*bounds*.zip' --filename="$obBOUNDS" 2> /dev/null)

	if [ "$obBOUNDS" == "" ]; then

		zenity --notification \
			--text="Du hast bounds*.zip nicht ausgewählt." 2> /dev/null
		
		echo "MROSM: Du hast bounds*.zip nicht ausgewählt. "
	
	else

		echo "MROSM: Bounds $obBOUNDS"
	
	fi

echo ""
echo "MROSM: Bitte sea*.zip auswählen"

obSEA=$(zenity --file-selection \
	--title="Auswahl sea*.zip" \
	--file-filter='*sea*.zip' --filename="$obSEA" 2> /dev/null)

	if [ "$obSEA" == "" ]; then
	
		zenity --notification \
			--text="Du hast sea*.zip nicht ausgewählt." 2> /dev/null
		
		echo "MROSM: Du hast sea*.zip nicht ausgewählt. "
	
	else

		echo "MROSM: Sea $obSEA"
	
	fi

echo ""
echo "MROSM: Bitte MotoRoute style*.zip auswählen"

obSTYLE=$(zenity --file-selection \
	--title="Auswahl MotoRoute style*.zip" \
	--file-filter='*style*.zip' --filename="$obSTYLE" 2> /dev/null)

	if [ "$obSTYLE" == "" ]; then
	
		zenity --notification \
			--text="Du hast MotoRoute *style*.zip nicht ausgewählt." 2> /dev/null
		
		echo "MROSM: Du hast MotoRoute *style*.zip nicht ausgewählt. "
	
	else

		echo "MROSM: MotoRoute Style $obSTYLE"
	
	fi

echo ""
txfFID=$(zenity --entry \
	--text="Family ID (Kein Eintrag = FID wird berechnet)" \
	--title="MotoRoute OpenStreetMap »Kartenbäckerei«" \
	--cancel-label="berechnen" \
	--width=500 --height=50 2> /dev/null)

if [ "$txfFID" == "" ]; then

	echo "MROSM: Family ID wird berechnet"

else

	echo "MROSM: Family ID $txfFID"

fi

echo ""
echo "MROSM: Bitte Codepage auswählen"

txtCP1="latin1"
txtCP2="unicode"

if [ "$rbCP" == "$txtCP1" ]; then

	setCP1=True

else

	setCP1=False

fi

if [ "$rbCP" == "$txtCP2" ]; then

	setCP2=True

else

	setCP2=False

fi

rbCP=$(zenity --list --radiolist \
	--text "Standard-Codepage latin1" \
	--column "Auswahl" --column "Codepage" \
	$setCP1 "$txtCP1" \
	$setCP2 "$txtCP2" \
	--title="MotoRoute OpenStreetMap »Kartenbäckerei«" \
	--cancel-label="latin1" \
	--width=400 --height=200 2> /dev/null)

if [ "$rbCP" == "" ]; then

	rbCP=$txtCP1

fi

echo "MROSM: Codepage $rbCP"
echo ""

# Write selection as settings
MROSMsettings="$APPSUPP/MROSM_settings"

echo "$obPROJ" > "$MROSMsettings"
echo "$obFILE" >> "$MROSMsettings"
echo "$chkUPDATE" >> "$MROSMsettings"
echo "$chkKEEPTEMP" >> "$MROSMsettings"
echo "$chkCUTPOLY" >> "$MROSMsettings"
echo "$obPOLY" >> "$MROSMsettings"
echo "$obTILES" >> "$MROSMsettings"
echo "$obBOUNDS" >> "$MROSMsettings"
echo "$obSEA" >> "$MROSMsettings"

echo "$obSPLITTER" >> "$MROSMsettings"
echo "$obMKGMAP" >> "$MROSMsettings"
echo "$chkKEEPTILES" >> "$MROSMsettings"
echo "$chkGMAPSUPP" >> "$MROSMsettings"
echo "$txfFID" >> "$MROSMsettings"
echo "$rbCP" >> "$MROSMsettings"
echo "$obSTYLE" >> "$MROSMsettings"

echo "$chkSETTINGS" >> "$MROSMsettings"
