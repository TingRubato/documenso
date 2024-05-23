#!/bin/bash

# Variables for the files
key_file="key.pem"
cert_file="cert.pem"
p12_file="signmetoday.p12"
output_file="p12_info.txt"

# Define the passphrase
p12_passphrase="passphrase?ShutUpAndTakeMyMoney!"

# Generate RSA private key and self-signed certificate
echo "Generating RSA key and self-signed certificate..."
openssl req -x509 -newkey rsa:4096 -keyout $key_file -out $cert_file -days 365 -nodes -subj "/C=US/ST=MO/L=STL/O=Organization/CN=www.signme.today"

# Create a PKCS#12 file from the certificate and key
echo "Creating PKCS#12 (.p12) file..."
openssl pkcs12 -export -in $cert_file -inkey $key_file -out $p12_file -password pass:$p12_passphrase

# Generate Base64-encoded contents of the PKCS#12 file
echo "Encoding PKCS#12 file contents in Base64..."
base64_contents=$(base64 $p12_file)

# Write the required information to the output file
echo "Writing necessary information to the output file..."
cat <<EOF > $output_file
Passphrase: $p12_passphrase
PKCS#12 File Path: $p12_file
Base64-Encoded Contents:
$base64_contents
EOF

echo "Process completed successfully. Check '$output_file' for details."
