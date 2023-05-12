#!/bin/bash

openssl genrsa -out privatekey 2048
public=`ssh-keygen -y -f privatekey`
private=`cat privatekey | base64 | tr -d '\n'`

# echo $public
# echo $private
# cat privatekey

echo "Register this public key with DevOps...."
echo ""
echo ""
echo ""
echo $public
echo ""
echo ""
echo ""

echo "Use this encoded private key with the container...."
echo ""
echo ""
echo ""
echo $private
echo ""
echo ""
echo ""

echo "Remember that this SSH will probably only work from one host and then DevOps will reject any usage from another host."
