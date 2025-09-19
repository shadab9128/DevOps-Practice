#!/usr/bin/env bash

SRVPORT=${PORT:-4499}
RSPFILE=response

rm -f "$RSPFILE"
mkfifo "$RSPFILE"

get_api() {
    # Read the first line of the HTTP request (e.g. "GET / HTTP/1.1")
    read line
    echo "$line"
}

handleRequest() {
    get_api
    mod=$(fortune)

    cat <<EOF > "$RSPFILE"
HTTP/1.1 200 OK
Content-Type: text/html

<pre>$(cowsay "$mod")</pre>
EOF
}

prerequisites() {
    command -v cowsay >/dev/null 2>&1 &&
    command -v fortune >/dev/null 2>&1 &&
    command -v nc >/dev/null 2>&1 || { 
        echo "Install prerequisites (fortune, cowsay, netcat)."
        exit 1
    }
}

main() {
    prerequisites
    echo "Wisdom served on port=$SRVPORT..."

    while true; do
        if nc -h 2>&1 | grep -q "OpenBSD"; then
            # Debian/Ubuntu (netcat-openbsd)
            cat "$RSPFILE" | nc -lN "$SRVPORT" | handleRequest
        else
            # macOS / BSD netcat
            cat "$RSPFILE" | nc -l -p "$SRVPORT" | handleRequest
        fi
        sleep 0.01
    done
}

main
