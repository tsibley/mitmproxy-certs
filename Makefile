SHELL := /bin/bash -euo pipefail

.SECONDARY:

%.crt: ~/.mitmproxy/mitmproxy-ca.pem %.key %.req %.ext
	openssl x509 -req -CA ~/.mitmproxy/mitmproxy-ca.pem -CAcreateserial -in $*.req -out $*.crt -extfile $*.ext

%.key %.req:
	openssl req -newkey rsa:4096 -keyout $*.key -nodes -out $*.req -sha256 -subj "/CN=$*"

%.ext:
	echo "subjectAltName = DNS:$*" > $*.ext
