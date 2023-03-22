#!/bin/bash
USER=test.user
PASSWORD="abc123"
PSWD=`openssl passwd -6 $PASSWORD`
# it is much more secure to do the openssl step on another machine an only copy the string
echo $PSWD
sudo useradd -m -s /bin/bash $USER -p ${PSWD}
