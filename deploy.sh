#!/bin/sh -e

if [ $# -ne 1 ]; then
	echo "[ERROR] Please pass all.inkl user ID"; exit 1
fi

webroot="/www/htdocs/$1/boddenberg.it/"
echo "[INFO] Deleting current remote web content"
ssh boddenberg.it rm -rf "${webroot}*"
echo "[INFO] Uploading local web content"
scp -r public/* boddenberg.it:"$webroot"
echo
echo "[INFO] done."
