eyaml decrypt \
    --string "$1" \
    --pkcs7-private-key=./puppet-master/keys/private_key.pkcs7.pem \
    --pkcs7-public-key=./puppet-master/keys/public_key.pkcs7.pem
