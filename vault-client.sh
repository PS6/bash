#!/bin/bash
#
# created by PS6 https://github.com/PS6/bash/vault-client.sh
# 
DGST="-sha256"
KEY0=`echo $0 | openssl dgst $DGST -hmac $1 -binary | openssl base64 -A | sed -e 's/[\/+=]//g'`
KEY1=`echo $2 | openssl dgst $DGST -hmac $KEY0 -binary | openssl base64 -A | sed -e 's/[\/+=]//g'`
KEY2=`cat $0 | openssl dgst $DGST -hmac $KEY1 -binary | openssl base64 -A | sed -e 's/[\/+=]//g'`
KEY3=`cat ~/.ssh/authorized_keys | grep "cicAbc= ssh-key-for-cloud" | openssl dgst $DGST -hmac $KEY2 -binary | openssl base64 -A | sed -e 's/[\/+=]//g'`
read -s password
echo -n $password | openssl dgst $DGST -hmac $KEY3 -binary | openssl enc -base64 -A | sed -e 's/[\/+=]//g' | tail -c 31
