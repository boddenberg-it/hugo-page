#!/bin/sh -e
# update minimal theme:
#   git submodule update --remote themes/minimal

if [ ! -f .deploy ]; then
	echo "[ERROR] Please provide .deploy file holding USER and DOMAIN"; exit 1
	exit 1
fi

# load config
. ./.deploy
webroot="/www/htdocs/$USER/$DOMAIN/"

echo "[INFO] invoking hugo"
hugo

echo "[INFO] Deleting current remote web content"
ssh boddenberg.it mv "${webroot}/usage" "/${webroot}/../usage-$DOMAIN"
ssh boddenberg.it rm -rf "${webroot}*"
ssh boddenberg.it mv "/${webroot}/../usage-$DOMAIN" "${webroot}/usage"

echo "[INFO] Uploading local web content"
scp -r public/* boddenberg.it:"$webroot"

echo "[INFO] done."
