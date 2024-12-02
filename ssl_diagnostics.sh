#!/bin/bash

# Function to print headers
print_header() {
    echo -e "\n==============================="
    echo "$1"
    echo "===============================\n"
}

# Variables
HOSTNAME=$1
PORT=${2:-443}

if [ -z "$HOSTNAME" ]; then
    echo "Usage: $0 <hostname> [port]"
    exit 1
fi

# 1. Check OpenSSL version
print_header "OpenSSL Version"
openssl version || { echo "OpenSSL is not installed!"; exit 1; }

# 2. Test SSL/TLS connection and print the server's certificate
print_header "Server Certificate Details"
openssl s_client -connect "$HOSTNAME:$PORT" </dev/null 2>/dev/null | openssl x509 -noout -text || {
    echo "Failed to connect to $HOSTNAME:$PORT"; exit 1;
}

# 3. Check supported protocols (TLS 1.2 and 1.3)
print_header "Testing Supported Protocols"
for PROTOCOL in "-tls1_2" "-tls1_3"; do
    echo "Testing $PROTOCOL..."
    openssl s_client $PROTOCOL -connect "$HOSTNAME:$PORT" </dev/null >/dev/null 2>&1 && \
        echo "$PROTOCOL: Supported" || echo "$PROTOCOL: Not Supported"
done

# 4. List server-supported ciphers
print_header "Cipher Suite Diagnostics"
openssl s_client -connect "$HOSTNAME:$PORT" </dev/null 2>/dev/null | grep "Cipher    :" || {
    echo "Unable to retrieve cipher information."; 
}

# 5. List local supported ciphers
print_header "Local Supported Ciphers"
openssl ciphers -v

# 6. Retrieve full certificate chain and validate
print_header "Full Certificate Chain"
openssl s_client -connect "$HOSTNAME:$PORT" -showcerts </dev/null || echo "Failed to retrieve certificate chain."

# 7. Check OCSP status
print_header "OCSP Stapling Status"
openssl s_client -connect "$HOSTNAME:$PORT" -status </dev/null | grep -A 10 "OCSP Response" || echo "OCSP stapling not supported or no response."

# 8. Test for potential signature algorithm issues
print_header "Certificate Signature Algorithm"
openssl s_client -connect "$HOSTNAME:$PORT" </dev/null 2>/dev/null | openssl x509 -noout -text | grep "Signature Algorithm"

# 9. Analyze hostname with SSL Labs (if curl is installed)
if command -v curl >/dev/null 2>&1; then
    print_header "SSL Labs Analysis (External)"
    echo "You can analyze your server at: https://www.ssllabs.com/ssltest/analyze.html?d=$HOSTNAME"
else
    echo "curl not installed; skipping SSL Labs hint."
fi

echo -e "\nSSL diagnostics completed for $HOSTNAME:$PORT"
