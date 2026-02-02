#!/usr/bin/env bash
# Run this once to create a release keystore and key.properties for Play Store signing.
# From project root:  cd android && ./setup-release-signing.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

KEYSTORE_FILE="upload-keystore.jks"
KEY_PROPERTIES="key.properties"

if [[ -f "$KEY_PROPERTIES" && -f "$KEYSTORE_FILE" ]]; then
  echo "✓ key.properties and $KEYSTORE_FILE already exist. You're set for release signing."
  exit 0
fi

if [[ ! -f "$KEYSTORE_FILE" ]]; then
  echo "Creating release keystore: $KEYSTORE_FILE"
  echo "You will be prompted for a store password, key password, and certificate details."
  echo ""
  keytool -genkey -v -keystore "$KEYSTORE_FILE" -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
  echo ""
  echo "✓ Keystore created. Remember the passwords you entered."
else
  echo "✓ Keystore already exists: $KEYSTORE_FILE"
fi

if [[ ! -f "$KEY_PROPERTIES" ]]; then
  cp key.properties.example "$KEY_PROPERTIES"
  echo "✓ Created $KEY_PROPERTIES from key.properties.example"
  echo ""
  echo "IMPORTANT: Edit $KEY_PROPERTIES and set:"
  echo "  - storePassword = the keystore password you just chose"
  echo "  - keyPassword   = the key password you just chose"
  echo ""
  echo "Then run from project root:  flutter build appbundle"
else
  echo "✓ $KEY_PROPERTIES already exists"
fi
