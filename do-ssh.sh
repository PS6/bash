#!/bin/bash
SHORT=`openssl rand -base64 3 | sed -e s'#/##'g -e s'/+//'g -e 's/.*/\L&/g'`
SHORTER=`echo $SHORT | sed -e 's/.*\(...\)$/\1/'`
#SHORTER=`openssl rand -base64 3 | sed -e s'#/##'g -e s'/+//'g -e 's/.*/\L&/g' -e 's/.*\(...\)$/\1/'`
echo $SHORT $SHORTER
COUNTER=0
for i in `terraform show | grep ssh_ip_a | awk '{print $3}' | sed -e 's/"//g'`
do
let COUNTER=COUNTER+1
echo -e "Host csr-$SHORTER-$COUNTER\n    Hostname $i\n    User admin\n    KexAlgorithms +diffie-hellman-group14-sha1" >> ~/.ssh/config
echo -e "csr-$SHORTER-$COUNTER ansible_host=$i ansible_connection=network_cli ansible_network_os=ios" >> hosts.txt
echo "$i csr-$SHORTER-$COUNTER"
done
