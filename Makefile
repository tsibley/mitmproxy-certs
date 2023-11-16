SHELL := /bin/bash -euo pipefail

.SECONDARY:

# These certs can be used with:
#
#   socat openssl-listen:5443,bind=localhost,verify=0,cert=/home/tom/.mitmproxy/manual-certs/localhost.pem,fork tcp4-connect:localhost:5000

~/.mitmproxy/mitmproxy-ca.pem:
	:

%.pem: %.crt %.key
	touch $*.pem
	chmod og= $*.pem
	cat $*.crt $*.key > $*.pem

%.crt: ~/.mitmproxy/mitmproxy-ca.pem %.key %.req %.ext
	openssl x509 -req -CA ~/.mitmproxy/mitmproxy-ca.pem -CAcreateserial -in $*.req -out $*.crt -extfile $*.ext

%.key %.req:
	openssl req -newkey rsa:4096 -keyout $*.key -nodes -out $*.req -sha256 -subj "/CN=$*"

%.ext:
	echo "subjectAltName = DNS:$*" > $*.ext
