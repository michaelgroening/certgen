#!/bin/bash
# Script for deploying certificat Container
# Please check all Variables for sane values describing your Setup

cp ca/ca.pem files/ca.pem

openssl genrsa -out files/client_key.pem 4096
openssl req -subj '/CN=client' -new -key files/client_key.pem -out files/client.csr
echo extendedKeyUsage = clientAuth > files/extfile_client.cnf
openssl x509 -req -days 365 -sha256 -in files/client.csr -CA ca/ca.pem -CAkey ca/ca-key.pem -CAcreateserial -out files/client_cert.pem -extfile files/extfile_client.cnf

printf "subjectAltName = DNS:<PUT_DNS_NAME_HERE>\n" > files/extfile_services.cnf
printf "extendedKeyUsage = clientAuth,serverAuth" >> files/extfile_services.cnf
openssl genrsa -out files/server_key.pem 4096
openssl req -subj '/CN=server' -new -key files/server_key.pem -out files/server.csr
openssl x509 -req -days 365 -sha256 -in files/server.csr -CA ca/ca.pem -CAkey ca/ca-key.pem -CAcreateserial -out files/server_cert.pem -extfile files/extfile_services.cnf
