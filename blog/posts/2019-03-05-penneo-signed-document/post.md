---
title: A closer look at documents signed with Penneo
comments: true
---

[Penneo][penneo] is a digital signature platform that relies on government
backed EIDs. That would be [NemID][nemid] in Denmark, [BankID][bankidse] in
Sweden, and [BankID][bankidno] in Norway. A document signed with Penneo contains
all the proof required to establish the validity of the signature.

**Note:** If can try the following yourself if you have access to bash on Linux
shell (or just use this [docker image][toolkit]).

## What is a Penneo signature?

Theoretically speaking, a digital signature is the value obtained from from encrypting the hash of the document:

```
digital signature = [ hash of document ] 🔑
```

However, we need to be able to answer the following questions when signed documents are concerned:

- Which document was signed?
- Who was the signer or signers?
- Is the signature valid i.e. does the signer actually sign the document?
- Is the signature still valid? (Long Term Validation or LTV) 

Just by looking at the digital signature, we can't answer any of the questions
which is why we need to keep the actual value of the signature inside a
container. This container will keep all the proof related to the signature i.e.
data that was signed, signer info, certificates to establish trust, time stamps
for long term validation and so on.

**In Penneo lingo, it is this container that is referred to as the "Penneo
Signature" instead of the actual value of the signature. The actual signature is
called the `signature value` inside the container.**

From now on when we say **Penneo Signature**, it means the container that
contains everything related to the signature.

We'll explore Penneo signatures in detail in the following sections but before
that we'll take a high level view and start with the document itself:

## What's included in the signed document?

Let's start by exploring the signed document and find the signature (i.e. the
container that contains all the details).

You can use `pdfdetach` command (part of [Poppler][poppler] utils) to extract the attachments:

 
``` bash
$ pdfdetach -saveall signed.pdf
```

Now you can see everything that was included in the document:

```
$ ls
audit.txt  penneo.json 3fc266fd847e707c.xml signed.pdf
```

### 1. Audit file

The audit file is a Penneo log of the events that happened with the document. Here is how it looks:

```
 ========================= ================== ============== ===================================================== 
  Time                      Name               IP             Activity                                             
 ========================= ================== ============== ===================================================== 
  2019-03-05 18:10:02 UTC   John Doe           xxx.xxx.xx.x   The document was created                             
  2019-03-05 18:10:04 UTC   John Doe           xxx.xxx.xx.x   A signing link was activated for "Ahmad Nazir Raja"  
  2019-03-05 18:10:10 UTC   Ahmad Nazir Raja   xxx.xxx.xx.x   The document was viewed by the signer                
  2019-03-05 18:11:06 UTC   Ahmad Nazir Raja   xxx.xxx.xx.x   The signer signed the document as Signer             
  2019-03-05 18:11:06 UTC   Penneo system      xxx.xxx.xx.x   The document signing process was completed           
 ========================= ================== ============== ===================================================== 
```

### 2. Index file: penneo.json

The `penneo.json` contains the list of all the signatures that sign the document. Here is how it looks:

```
{
  "documentKey": "SPNEM-B22SH-H0TOS-MCLVZ-E3YLB-MMJEL",
  "signatures": [
    {
      "signatureLines": [
        {
          "role": "Signer",
          "onBehalfOf": "Acme Inc"
        }
      ],
      "signerSerial": "PID:9208-2002-2-821442331526",
      "signTime": "2019-03-05T18:11:05Z",
      "signerName": "Ahmad Nazir Raja",
      "validations": [],
      "dataFile": "3fc266fd847e707c.xml",
      "type": "nemid",
      "ip": "xxx.xxx.xx.x"
    }
  ],
  "version": "1.2"
}
```

The `dataFile` points to the Penneo Signature i.e. the container that has all
signature related details.

### 3. Data File / Penneo Signature

One document can have one or more signers. For every signer, multiple signatures
are stored in the data file. In our example, only one signer has signed the
document. The `penneo.json` tells us that the relevant data is contained in
`3fc266fd847e707c.xml`. This file contains the Penneo Signature.

See the xml file:

```
$ xmllint --format 3fc266fd847e707c.xml
```

## Analyzing the Penneo Signature

The Penneo Signature is the container of all the relevant data needed to
establish that the signer signs the document. It is basically an
[xmldsig][xmldsig] document extended to [xades][xades] (more on this later). 
Broadly, the following information is contained:

1. **Sign Properties:** Data that is signed i.e. document digests, etc
2. **Signature Value:** This is the actual signature generated by signing the data with the signer's private key
3. **Certificates:** Signer certificate and related certificates to establish chain of trust
3. **Time stamps:** This is needed for long term validation

### Signer Certificate and establishing trust

Though the order of the certificates isn't promised, they are usually present in
the following order:

1. Intermediate certificate
2. Root certificate
3. Signer Certificate

The root and the intermediate certificates are required to establish validity of
the signer certificate. If you trust any one of them, then it means that the
signer certificate can also be trusted.

In our examples all the certificates are [x509][x509] and the can be parsed as follows:

#### Extracting certificates from the Penneo Signature

We can use [xmlstarlet][xmlstarlet] (not actively maintained but still quite
useful) to extract the signatures:

```
function extract-certificate () {
    local file=$1
    local index=$2
    xmlstarlet \
        sel \
        -N openoces='http://www.openoces.org/2006/07/signature#' \
        -N ds='http://www.w3.org/2000/09/xmldsig#' \
        -t \
        -v \
        "//openoces:signature/ds:Signature/ds:KeyInfo/ds:X509Data[${index}]/ds:X509Certificate/text()" \
        $file
}
```

To extract the signer certificate: 

```
extract-certificate 3fc266fd847e707c.xml 3
```

#### Parsing the signer certificate

This just gives us the base 64 encoded certificate. In order to read the
information inside the x509 certificate, base 64 decode it and using openssl:

```
extract-certificate 3fc266fd847e707c.xml 1 | \
    base64 --decode | \
    openssl x509 -noout -text -inform DER -in /dev/stdin
```

You can read the name of the signer as follows (by appending to the command above):

```
extract-certificate 3fc266fd847e707c.xml 3 | \
    base64 --decode | \
    openssl x509 -noout -text -inform DER -in /dev/stdin | \
    grep Subject -A1
```

<!-- #### How to validate the signatures? -->

<!-- Stay tuned, I am working on it -->

## So where is the document level signature?

Up until now we have looked at the attachments in the pdf. But the original pdf
to be signed has also been appended with visual information along with the
document level signature. Let's see how many times the pdf has been
appended to:

```
$ strings signed.pdf | grep -E '^..EOF' | wc -l
3
```

This means that apart from the original PDF, two more versions were appended. 

1. Version 1: Original PDF (after removing malicious content)
2. Version 2: This contains the document key (also visible on the right side of every page)
3. Version 3: This is where the document signature resides

Maybe in another post, I'll talk about how to extract the document level signature and analyze it.

## Other things worth mentioning...

### Penneo Signatures are Long Term Validated

On inspecting the signature file, we can see that the signature is basically an
[xmldsig][xmldsig] document which is extended to [xades][xades]. The elements of
[xades][xades] are needed to support long term validation (LTV). This means that
proof of the signature validity at the time of signing is embedded in the
document so that the signer can't deny the validity of the of signature at a
later point (in case the signing certificate gets revoked). This property is
called non-repudiation and is needed to support long term validation.

### What about CMS and CADES?
Penneo also supports [cms][cms] instead of xmldsig, and similarly [cades][cades]
instead of xades. It depends on the EID which types of signatures are embedded
in the data file.


Here are the formats that Penneo receives from different EIDs and how Penneo stores them:

```
|                | Originally Received | Stored by Penneo (LTV) |
|----------------|---------------------|------------------------|
| Denmark Nem ID | XMLDSIG             | XADES                  |
| Sweden Bank ID | XML                 | XADES                  |
| Norway Bank ID | CMS                 | CADES                  |
```


## Conclusion

Documents signed with Penneo contain all the proof about the signature. The
elements are used by the Penneo validator to validate everything. In this post,
we looked at the different elements included and how to extract data from them.

So how would you use the elements and validate that everything checks out
yourself? That will have to wait for another post.


[bankidno]: https://www.bankid.no/en/
[bankidse]: https://www.bankid.com/en/
[cades]: https://tools.ietf.org/html/rfc5126.html
[cms]: https://tools.ietf.org/html/rfc5652
[nemid]: https://www.nemid.nu/dk-en/
[penneo]: https://penneo.com
[poppler]: https://en.wikipedia.org/wiki/Poppler_(software)
[toolkit]: https://cloud.docker.com/u/ahmadnazir/repository/docker/ahmadnazir/penneo-signature-toolkit
[x509]: https://en.wikipedia.org/wiki/X.509
[xades]: https://www.w3.org/TR/XAdES/
[xmldsig]: https://www.w3.org/TR/xmldsig-core1/
[xmlstarlet]: https://en.wikipedia.org/wiki/XMLStarlet
