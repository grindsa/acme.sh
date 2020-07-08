#!/bin/bash
# handler for iconectiv staging
API_URL="https://authenticate-api-stg.iconectiv.com"

SPC=$1
TKVALUE=$2
ACCOUNT_KEY_PATH=$3
OPENSSL_BIN=$4

# get fingerprint
FINGERPRINT="SHA256 "$($OPENSSL_BIN rsa -in $ACCOUNT_KEY_PATH --pubout 2> /dev/null| $OPENSSL_BIN dgst -sha256 -hex | cut -d = -f 2 | tr -d ' ' | awk '{ print toupper($0) }' | sed 's/../&:/g; s/:$//')

if [ -n "$PA_USER" ] || [ -n "$PA_PASSWORD" ]; then

  # login and get token
  _token=$(curl -s -X POST -H "Content-Type: application/json" -d "{\"userId\":\"$PA_USER\", \"password\":\"$PA_PASSWORD\"}" $API_URL/api/v1/auth/login | sed -n 's|.*"accessToken":"\([^"]*\)".*|\1|p')
  _spct_response=$(curl -s -X POST -H "Content-Type: application/json" -H "Authorization: $_token" -d "{\"atc\":{\"tktype\":\"TNAuthList\", \"tkvalue\":\"$TKVALUE\", \"ca\":False, \"fingerprint\":\"$FINGERPRINT\"}}" $API_URL/api/v1/account/$SPC/token)

  # get code token and crl
  SPCT=$(echo $_spct_response | sed -n 's|.*"token":"\([^"]*\)".*|\1|p')
  CDP=$(echo $_spct_response | sed -n 's|.*"crl":"\([^"]*\)".*|\1|p')
  echo $SPCT $CDP

else
  echo "PA_USER and/or PA_PASSWORD variables are missing"
  exit 1
fi 

# echo ""
