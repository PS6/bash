#!/bin/bash
# sudo apt install putty-tools
DATUM=`date +"%Y-%m-%d-%H%M"`
PASSFILE=$DATUM-pass.txt
MINISIG="PS6"
KEYTYPE="rsa"
LABEL=$DATUM-$KEYTYPE-$MINISIG
PPKFILE=$LABEL-private.ppk
PEMFILE=$LABEL-agent.pem
LOGFILE=$LABEL-info.log
openssl rand -base64 33 > $PASSFILE
chmod 400 $PASSFILE
puttygen --new-passphrase $PASSFILE --strong-rsa -t $KEYTYPE -b 2048 -O private --ppk-param time=2048,memory=65536 -C "$KEYTYPE-$DATUM-$MINISIG" -o $PPKFILE
chmod 400 $PPKFILE
puttygen --old-passphrase $PASSFILE $PPKFILE -O private-openssh-new -o $PEMFILE
puttygen --old-passphrase $PASSFILE $PPKFILE -O text > $LOGFILE
puttygen --old-passphrase $PASSFILE $PPKFILE -O public >> $LOGFILE
puttygen --old-passphrase $PASSFILE $PPKFILE -O public-openssh >> $LOGFILE
puttygen --old-passphrase $PASSFILE $PPKFILE -O fingerprint >> $LOGFILE
./ssh-add-pass ./${PEMFILE} $PASSFILE
ssh-add -l
