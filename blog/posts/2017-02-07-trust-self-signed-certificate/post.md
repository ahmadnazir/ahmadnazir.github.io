---
title: Trust a self signed certificate in Debian
changelog: "2017-08-01 Note about establishing trust in the browser"
---

## Generate a self-signed certificate

Generate a self-signed certificate in PEM format

```
DOMAIN=dev.penneo.com
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $DOMAIN.key -out $DOMAIN.crt
```

For a certificate that gets accepted by Chrome 68+, see the [self signed certificate generator][generator] by [Jesus Otero Gomez][jesus].


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

You can check the details for the newly generated certificate as follows:

```
openssl x509 -in $DOMAIN.crt -text -noout
```

<!-- How is chrome and firefox affected? -->

<!-- ## Add the key and certificate to the nginx confiruation -->

## FAQ

### Does this mean that the browsers also trust the certificate?

Some applications rely on the OS level trusted certificates. Browsers have a
different way to established trust. For Chrome, you have to add the `rootCA`
certificate instead of the self signed certificate. Check out [Jesus's self
signed certificate generator][jesus] to generate the `rootCA.pem`. Once you have
that, it needs to be imported in Chrome:

```
Chrome Settings
  > Show advanced settings
  > HTTPS/SSL
  > Manage Certificates
  > Import certificate
```

### What is PEM format?

PEM is a container format for storing
certificates. [There are a number of ways to store certificates][diff-formats]
and here is a quick reference for some extensions that I have bumped into:

- **.pem** : Base64 encoded form of DER
- **.der** : Encoding data that uses the ASN.1 standard
- **.crt** : It could be .pem or .der. The extension just means that it is a certificate
- **.key** : A .pem or .der file that contains just the private key


[diff-formats]: http://serverfault.com/a/9717/286083
[redhat]: http://serverfault.com/a/730234/286083
[generator]: https://github.com/jesusoterogomez/self-signed-ssl-generator
[jesus]: https://www.jesusoterogomez.com/
