#!/bin/bash

function extract-signature () {
    local index=$1
    xmlstarlet \
        sel \
        -N openoces='http://www.openoces.org/2006/07/signature#' \
        -N ds='http://www.w3.org/2000/09/xmldsig#' \
        -t \
        -v \
        "//openoces:signature/ds:Signature/ds:KeyInfo/ds:X509Data[${index}]/ds:X509Certificate/text()" \
        /dev/stdin
}

function decode() {
    base64 --decode $1
}

function set-certificate () {
    local index=$1
    local value=$2
    xmlstarlet \
        ed \
        -P \
        -N openoces='http://www.openoces.org/2006/07/signature#' \
        -N ds='http://www.w3.org/2000/09/xmldsig#' \
        --update \
        "//openoces:signature/ds:Signature/ds:KeyInfo/ds:X509Data[${index}]/ds:X509Certificate" \
        --value \
        ${value} \
        /dev/stdin
}

function -fix-certificate-order () {

    local file=/tmp/`random`
    cat /dev/stdin > ${file}

    local intermediate_cert=$(cat ${file} | extract-signature 1)
    local root_cert=$(cat ${file} | extract-signature 2)
    local signer_cert=$(cat ${file} | extract-signature 3)

    cat ${file} | \
        set-certificate 1 ${signer_cert} | \
        set-certificate 2 ${intermediate_cert} | \
        set-certificate 3 ${root_cert}

    rm ${file}
}

function x509-der () {
    openssl x509 -in /dev/stdin -inform DER -noout -text
}

function der-to-pem () {
    openssl x509 -inform der -in /dev/stdin -out /dev/stdout
}

function random () {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -1
}

function verify-chain () {
    local file=/tmp/`random`
    local root=/tmp/`random`
    local inter=/tmp/`random`
    local signer=/tmp/`random`-signer-cert.der

    cat /dev/stdin > ${file}

    cat ${file} | extract-signature 1 | decode | der-to-pem > ${inter}
    cat ${file} | extract-signature 2 | decode | der-to-pem > ${root}
    cat ${file} | extract-signature 3 | decode | der-to-pem > ${signer}

    openssl verify -CAfile ${root} -untrusted ${inter} ${signer}

    rm ${file}
    rm ${inter}
    rm ${root}
    rm ${signer}
}

function verify-signature-value () {
    xmlsec1 \
	      --verify \
        --trusted-der root.der \
        --trusted-der intermediate.der \
        /dev/stdin
}

function validate () {
    # verify chain
    # verify signature value
    echo 'Not implemented'
}
