#!/bin/bash

# Gernot Skottke, 02.05.2020

echo "Execute MROSM_7_cleanup.bash"

# cleanup
if [ -d ./tmp ]; then

	if [ -f ./msg.vbs ]; then rm -rf ./msg.vbs; fi
	if [ -f ./tmp/java.log ]; then rm -rf ./tmp/java.log; fi
	if [ -f ./tmp/osmctools.log ]; then rm -rf ./tmp/osmctools.log; fi
	if [ -f ./tmp/tarexe.log ]; then rm -rf ./tmp/tarexe.log; fi
		
	find ./tmp -name '*txt' -delete
	find ./tmp/ -type f -size 0 -print0 | xargs -0 rm

	if [ -d "$GBASEMAPtiles" ]; then rm -rf "$GBASEMAPtiles"; fi
	
	if [ -d ./tiles ]; then rm -rf ./tiles; fi
	if [ -d ./logs ]; then rm -rf ./logs; fi
	
	if [ -d ./splitter* ]; then rm -rf ./splitter*; fi
	if [ -d ./mkgmap* ]; then rm -rf ./mkgmap*; fi
	if [ -d ./style* ]; then rm -rf ./style*; fi
	
	# delete saved settings
	if [ $chkSETTINGS = 0 ]; then
	
		if [ -f "$APPSUPP"/MROSM_settings ]; then rm -rf "$APPSUPP"/MROSM_settings; fi
	
	fi

	mv ./tmp ./logs

	echo " "
	echo "MROSM: Temporäre Dateien gelöscht"

fi
