#!/bin/bash

ssh-keygen -t rsa #-b 4096
public=`cat ~/.ssh/id_rsa.pub`
private=`cat ~/.ssh/id_rsa | base64 | tr -d '\n'`

echo "Register this public key with DevOps...."
echo ""
echo ""
echo ""
echo $public
echo ""
echo ""
echo ""

echo "Use this enoded private key with the container...."
echo ""
echo ""
echo ""
echo $private
echo ""
echo ""
echo ""

echo "Remember that this SSH will probably only work from one host and then DevOps will reject any usage from another host."
