#!/bin/bash
# sudo apt install putty-tools
DATUM=`date +"%Y-%m-%d-%H%M"`
PASSFILE=secrets.$DATUM-pass.txt
MINISIG="PS6"
KEYTYPE="rsa"
LABEL=$DATUM-$KEYTYPE-$MINISIG
PPKFILE=$LABEL-private.ppk
PEMFILE=$LABEL-agent.pem
PYTHONFILE=secrets.print-$LABEL.py
LOGFILE=secrets.$LABEL-info.log
openssl rand -base64 33 > $PASSFILE
chmod 400 $PASSFILE
puttygen --new-passphrase $PASSFILE --strong-rsa -t $KEYTYPE -b 13337 -O private --ppk-param time=6789,memory=123456 -C "$KEYTYPE-$DATUM-$MINISIG" -o $PPKFILE
chmod 400 $PPKFILE
puttygen --old-passphrase $PASSFILE $PPKFILE -O private-openssh-new -o $PEMFILE
puttygen --old-passphrase $PASSFILE $PPKFILE -O text > $LOGFILE
puttygen --old-passphrase $PASSFILE $PPKFILE -O public >> $LOGFILE
puttygen --old-passphrase $PASSFILE $PPKFILE -O public-openssh >> $LOGFILE
puttygen --old-passphrase $PASSFILE $PPKFILE -O fingerprint >> $LOGFILE
./ssh-add-pass ./${PEMFILE} $PASSFILE
ssh-add -l
echo "#!/usr/bin/python3" > $PYTHONFILE
cat $LOGFILE | grep private_q | awk -F"=" '{print $1" = \""$2"\""}' >> $PYTHONFILE
cat $LOGFILE | grep private_p | awk -F"=" '{print $1" = \""$2"\""}' >> $PYTHONFILE
cat $LOGFILE | grep public_modulus | awk -F"=" '{print $1" = \""$2"\""}' >> $PYTHONFILE
cat << EOF >> $PYTHONFILE
print (int(private_p,16));
print ("\n");
print (int(private_q,16));
print ("\n");
print (int(public_modulus,16));
print ("\n");
print (int(private_q,16)*int(private_p,16));
EOF
chmod 500 $PYTHONFILE
echo "./${PYTHONFILE}"
