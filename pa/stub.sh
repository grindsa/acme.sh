#!/bin/bash
# this is a stub handler for debugging purposes

SPC=$1
TKVALUE=$2
ACCOUNT_KEY_PATH=$3
OPENSSL_BIN=$4

FINGERPRINT="SHA256 "$($OPENSSL_BIN rsa -in $ACCOUNT_KEY_PATH --pubout 2>/dev/null| $OPENSSL_BIN dgst -sha256 -hex | cut -d = -f 2 | tr -d ' ' | awk '{ print toupper($0) }' | sed 's/../&:/g; s/:$//')

# echo $FINGERPRINT

echo "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsIng1dSI6Imh0dHBzOi8vYXV0aGVudGljYXRlLWFwaS1zdGcuaWNvbmVjdGl2LmNvbS9kb3dubG9hZC92MS9jZXJ0aWZpY2F0ZS9jZXJ0aWZpY2F0ZUlkXzI5NjUuY3J0In0.eyJleHAiOjE2MjM1NjIzNDcsImp0aSI6IjgzODhiZWI1LWMyMzYtNDlhYS05NWQ2LTk5NjM4NDFhODFhYyIsImF0YyI6eyJ0a3R5cGUiOiJUTkF1dGhMaXN0IiwidGt2YWx1ZSI6Ik1BaWdCaFlFTmpVeU9RPT0iLCJjYSI6ZmFsc2UsImZpbmdlcnByaW50IjoiU0hBMjU2IGRiOmRjOjJmOjE4OjViOjliOjQzOjY1OmYwOjA1OmIyOmQyOmY2OmNkOmI4OmE1OmI3OjZhOjYyOmE2OjVmOjQwOmVhOjAzOjlhOjg5OmM2OjQxOjU4OmRlOjRlOmY4In19.Wlcl2zPXOGWWzNNYCkmIPegxboJANuLEbOoOVX4SQS6HzoX8CNNdBUxj6BnUPu2T6Ml3h23zYoWaZ1lIPfPldA https://stub-pa.bar.local/crl"
