#!/bin/sh -e
# update minimal theme:
#   git submodule update --remote themes/minimal

# SANITY CHECK
if [ ! -f .deploy ]; then
	echo "[ERROR] Please provide .deploy file holding HOST, USER and DOMAIN";
	exit 1
fi

. ./.deploy # load config
webroot="/www/htdocs/$USER/$DOMAIN/"

if [ -z ${HOST+x} ] || [ -z ${USER+x} ] || [ -z ${DOMAIN+x} ]; then
	echo "[ERROR] Please provide HOST, User and Domain within .deploy file"
	exit 1
fi

# ACTUAL DEPLOYMENT
echo "[INFO] invoking hugo"
hugo

echo "[INFO] Deleting current remote web content"
ssh "$HOST" mv "${webroot}/usage" "/${webroot}/../usage-$DOMAIN"
ssh "$HOST" rm -rf "${webroot}*"
ssh "$HOST" mv "/${webroot}/../usage-$DOMAIN" "${webroot}/usage"

echo "[INFO] Uploading local web content"
scp -r public/* ${HOST}:"$webroot"

echo "[INFO] done."
