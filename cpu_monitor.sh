#!/bin/bash

while true; do
    clear
    
    echo "$(date) — CPU Monitor"
    echo "==============================================="
    
    pid=$(ps aux | sed '1d' | sort -k3 -nr | head -1 | awk '{print $2}')
    
    ps aux | head -1
    ps aux | grep -w $pid | grep -v grep   

    echo ""
    echo "=== /proc/$pid ==="
   
    name=$(cat /proc/$pid/comm 2>/dev/null)
    echo -e "— name: ${name:-[unknown]}\n"

    cmd=$(cat /proc/$pid/cmdline 2>/dev/null | tr '\0' ' ')
    echo -e "— cmdline: ${cmd:-[unknown]}\n"

    status=$(grep -E '^(State|VmRSS|Threads):' /proc/$pid/status 2>/dev/null)
    if [ -z "$status" ]; then
        echo -e "— status: [unknown]\n"
    else
        echo "— status:"
        echo -e "$status\n"
    fi

    mem=$(grep -E '^(VmSize|VmRSS|VmData|VmSwap):' /proc/$pid/status 2>/dev/null)
    if [ -z "$mem" ]; then
        echo -e "— memory: [unknown]\n"
    else
        echo "— memory:"
        echo -e "$mem\n"
    fi

    io=$(grep -E '^(read_bytes|write_bytes):' /proc/$pid/io 2>/dev/null)
    if [ -z "$io" ]; then
        echo -e "— io: [unknown]\n"
    else
        echo "— io:"
        echo -e "$io\n"
    fi

    if [ -d "/proc/$pid/fd" ]; then
        fds=$(ls "/proc/$pid/fd" 2>/dev/null | wc -l)
        echo -e "— fds: $fds\n"
    else
        echo -e "— fds: [unknown]\n"
    fi

    sleep 5
done
