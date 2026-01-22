if [ -z "$1" ]; then
    echo "ERROR: No secret provided"
    exit 1
fi

eyaml encrypt --pkcs7-public-key=./puppet-master/keys/public_key.pkcs7.pem \
    --string "$1"
