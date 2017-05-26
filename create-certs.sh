#!/usr/bin/env bash

# RootCA certs go here
rm -Rf root-cert/

# server certs go to current working directory
rm localhost.csr localhost.key localhost.crt;

set -e

mkdir root-cert/

echo ""

echo "USE SOME SIMPLE PASSWORD FOR ROOTCA, like 1234"

openssl genrsa -des3 -out root-cert/rootCA.key 2048;
openssl req -x509 -new -nodes -key root-cert/rootCA.key -sha256 -days 1024 -out root-cert/rootCA.pem;


echo ""
echo "JUST HIT ENTER BUT SET localhost AS COMMON NAME (FQDN)"
echo ""

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout localhost.key -out localhost.crt;
openssl req -new -sha256 -key localhost.key -out localhost.csr;

openssl req -new -sha256 -nodes -out localhost.csr -newkey rsa:2048 -keyout localhost.key -config <( cat localhost.csr.cnf );
openssl x509 -req -in localhost.csr -CA root-cert/rootCA.pem -CAkey root-cert/rootCA.key -CAcreateserial -out localhost.crt -days 500 -sha256 -extfile v3.ext;

echo ""
echo "BE SURE TO ADD THE .CRT TO KEYCHAIN AND SET IT AS TRUSTED"