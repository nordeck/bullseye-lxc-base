#!/bin/bash

# ------------------------------------------------------------------------------
# HOST_CUSTOM_CA.SH
# ------------------------------------------------------------------------------
set -e
source $INSTALLER/000-source

# ------------------------------------------------------------------------------
# ENVIRONMENT
# ------------------------------------------------------------------------------
MACH="nordeck-host"
cd $MACHINES/$MACH

# ------------------------------------------------------------------------------
# INIT
# ------------------------------------------------------------------------------
[[ "$DONT_RUN_HOST_CUSTOM_CA" = true ]] && exit

echo
echo "---------------------- HOST CUSTOM CA ---------------------"

# ------------------------------------------------------------------------------
# PACKAGES
# ------------------------------------------------------------------------------
export DEBIAN_FRONTEND=noninteractive

# added packages
apt-get $APT_PROXY -y install openssl

# ------------------------------------------------------------------------------
# CA CERTIFICATE & KEY
# ------------------------------------------------------------------------------
# the CA key and the CA certificate
if [[ ! -d "/root/nordeck-certs" ]]; then
    mkdir /root/nordeck-certs
    chmod 700 /root/nordeck-certs
fi

if [[ ! -f "/root/nordeck-certs/nordeck-CA.pem" ]]; then
    cd /root/nordeck-certs
    rm -f nordeck-CA.key

    openssl req -nodes -new -x509 -days 10950 \
        -keyout nordeck-CA.key -out nordeck-CA.pem \
        -subj "/O=nordeck/OU=CA/CN=nordeck-bullseye $DATE-$RANDOM"
fi
