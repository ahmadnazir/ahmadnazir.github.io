---
title: Trust a self-signed certificate in Debian
---

## Generate a self-signed certificate

Generate a self-signed certificate in PEM format

```
DOMAIN=anr.dev.penneo.com
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $DOMAIN.key -out $DOMAIN.crt
```

## Trusting the certificate

For making the OS trust the certificate, the requirements for Debian are:

- The certificate should be in PEM format
- The certificate should be placed in the certificates directory i.e. /etc/ssl/certs
- The name of the symlink to the certificate is the hash of the certificate needs a `.0` appended to it. Why we do that? No idea.. let me know when you find out

or in bash lingo:

```
CERTS=/etc/ssl/certs
sudo cp $DOMAIN.crt $CERTS/
cd $CERTS
HASH=`openssl x509 -noout -hash -in $DOMAIN.crt`.0
sudo ln -s $DOMAIN.crt $HASH
```

Source: [Trusting self-signed certificates in redhat][redhat]

<!-- How is chrome and firefox affected? -->

<!-- ## Add the key and certificate to the nginx confiruation -->

## What is PEM format?

PEM is a container format for storing certificates. [There are a number of ways to store certificates][diff-formats] and here is a quick reference for some extensions that I have bumped into:

- **.pem** : Base64 encoded form of DER
- **.der** : Encoding data that uses the ASN.1 standard
- **.crt** : It could be .pem or .der. The extension just means that it is a certificate
- **.key** : A .pem or .der file that contains just the private key


[diff-formats]: http://serverfault.com/a/9717/286083
[redhat]: http://serverfault.com/a/730234/286083
