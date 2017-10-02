#!/bin/sh -e
# update minimal theme:
#   git submodule update --remote themes/minimal

if [ $# -ne 1 ]; then
	echo "[ERROR] Please pass all.inkl user ID"; exit 1
fi

webroot="/www/htdocs/$1/boddenberg.it/"

echo "[INFO] invoking hugo"
hugo

echo "[INFO] Deleting current remote web content"
ssh boddenberg.it mv "${webroot}/usage" "/${webroot}/../usage-boddenberg-it"
ssh boddenberg.it rm -rf "${webroot}*"
ssh boddenberg.it mv "/${webroot}/../usage-boddenberg-it" "${webroot}/usage"

echo "[INFO] Uploading local web content"
scp -r public/* boddenberg.it:"$webroot"

echo
echo "[INFO] done."
