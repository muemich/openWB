#!/bin/bash

#########################################################
#
# liest aus Wechselrichter Kostal Plenticore Register
# zu PV-Statistik und berechnet PV-Leistung, Speicherleistung
# unter Beachtung angeschlossener Batterie falls vorhanden
#
# 2019 Michael Ortenstein
# This file is part of openWB
# 
# 01.09.2021	skl	Python3 , Anpassung auf neue .py
#########################################################

# Aufruf der Leseroutine mit den IP WR 1 und ggf. WR 2 und WR3
# WR3 kann auch eine Liste an einanderfolgenden IP haben 


OPENWBBASEDIR=$(cd "$(dirname "$0")/../../" && pwd)
RAMDISKDIR="${OPENWBBASEDIR}/ramdisk"
DMOD="PV"
Battery=0

if [[ $speichermodul == "speicher_kostalplenticore" ]]; then
	Battery=1
fi

if [ $DMOD == "MAIN" ]; then
	MYLOGFILE="${RAMDISKDIR}/openWB.log"
else
	MYLOGFILE="${RAMDISKDIR}/nurpv.log"
fi

bash "$OPENWBBASEDIR/packages/legacy_run.sh" "wr_plenticore.read_kostalplenticore" "${kostalplenticoreip}" "${kostalplenticoreip2}" "${Battery}" "${kostalplenticoreip3}" >>"${MYLOGFILE}" 2>&1
ret=$?

openwbDebugLog ${DMOD} 2 "RET: ${ret}"
# Rückgabe des Wertes Gesamt-PV-Leistung
pvwatt=$(<"$RAMDISKDIR/pvwatt")
echo "$pvwatt"
