#!/bin/bash
set -e

KEYS_DIR="./puppet-master/keys"

if [ -f "$KEYS_DIR/private_key.pkcs7.pem" ] || [ -f "$KEYS_DIR/public_key.pkcs7.pem" ]; then
    echo "ERROR: Keys already exist in $KEYS_DIR"
    exit 1
fi

mkdir -p "$KEYS_DIR"

echo "Generating eyaml key pair..."
eyaml createkeys \
    --pkcs7-private-key=$KEYS_DIR/private_key.pkcs7.pem \
    --pkcs7-public-key=$KEYS_DIR/public_key.pkcs7.pem

chmod 600 "$KEYS_DIR/private_key.pkcs7.pem"
chmod 644 "$KEYS_DIR/public_key.pkcs7.pem"

echo "Keys generated successfully!"
