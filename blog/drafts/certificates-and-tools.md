
# Reading the contents of a certificate

So you have a certificate file.. what do you do with it?

## Maybe it is a .pem file?

Does it have ASCII characters with the following delims:

```
-----BEGIN CERTIFICATE-----
..
..
-----END CERTIFICATE-----
```

it is `pem` format. Open it with:

```
openssl x509 -in $FILE -text -noout
openssl x509 -in ssl.crt -text -noout
```

### What is .pem format?

Base 64 encoded x509 certificate which has delimiters around the encoded data.

## It might still be an x509 certificate but with different encoding?

Try this:


```
openssl x509 -in $FILE -text -noout -inform DER
```

### What is a DER encoding?

DER (Distinguished Encoding Rules) is a way to encode data. It uses ASN.1
standard which determines how the information is represented. It doesn't
restrict how the data is encoded which is where DER comes into play. DER is one
of encoding quite common in certificates.

Common extensions are: `.der`, `.crt`, `.cert`.

### How do I check if two files contain the same certificate?

Compare the fingerprints! Fingerprint is the hash of the data which means if the
data changes, the fingerprint also changes.

Considering that one of the certificate has .pem format and the other one uses
DER encoding, then the following two command should produce the same output:

```
openssl x509 -in cert-a.pem -fingerprint -noout
openssl x509 -in cert-b.pem -fingerprint -noout -inform DER
```

## Extract the public key from the certificate

```
openssl x509 -pubkey -noout -in cert.pem > pubkey.pem
```

# Storing certificates and keys

Keystores! If you don't intend to store private keys in the store, then it makes
more sense to called it a trust store instead of a key store. When working with
Java, the `keytool` command can be used to manipulate java key stores.

## How do I list the certificates in a keystore?

```
KEYSTORE=keystore.jks
keytool -list -keystore $KEYSTORE
```

## Extracting a certificate

```
CERT_NAME=alias_of_certificate
keytool -exportcert -keystore $KEYSTORE -alias $CERT_NAME > certificate.crt
```

https://www.cryptologie.net/article/260/asn1-vs-der-vs-pem-vs-x509-vs-pkcs7-vs/


# How to get the https certificate for a website?

```
openssl s_client -connect registry.penneo.com:443 < /dev/null 2>/dev/null \
    | openssl x509 -in /dev/stdin -noout -text
```

## Misc

ssh-keygen -f public.key -e -m pem > public.pem 
