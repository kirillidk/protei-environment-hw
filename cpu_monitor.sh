#!/bin/bash

while true; do
    clear
    
    echo "$(date) - CPU Monitor"
    echo "===================="
    
    pid=$(ps aux | sed '1d' | sort -k3 -nr | head -1 | awk '{print $2}')
    
    ps aux | head -1
    ps aux | grep -w $pid | grep -v grep   

    echo ""
    echo "=== /proc/$pid ==="
   
    name=$(cat /proc/$pid/comm 2>/dev/null)
    echo "— name: ${name:-[unknown]}"
    echo ""

    cmd=$(cat /proc/$pid/cmdline 2>/dev/null | tr '\0' ' ')
    echo "— cmdline: ${cmd:-[unknown]}"
    echo ""

    status=$(grep -E '^(State|VmRSS|Threads):' /proc/$pid/status 2>/dev/null)
    if [ -z "$status" ]; then
        echo "— status: [unknown]"
    else
        echo "— status:"
        echo "$status"
    fi
    echo ""

    mem=$(grep -E '^(VmSize|VmRSS|VmData|VmSwap):' /proc/$pid/status 2>/dev/null)
    if [ -z "$mem" ]; then
        echo "— memory: [unknown]"
    else
        echo "— memory:"
        echo "$mem"
    fi
    echo ""

    io=$(grep -E '^(read_bytes|write_bytes):' /proc/$pid/io 2>/dev/null)
    if [ -z "$io" ]; then
        echo "— io: [unknown]"
    else
        echo "— io:"
        echo "$io"
    fi
    echo ""

    if [ -d "/proc/$pid/fd" ]; then
        fds=$(ls "/proc/$pid/fd" 2>/dev/null | wc -l)
        echo "— fds: $fds"
    else
        echo "— fds: [unknown]"
    fi
    echo ""

    sleep 5
done
