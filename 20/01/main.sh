#!/bin/bash

ip=0

for line in $(sort -g input.txt) ; do
    IFS="-" read -r low high <<<$line;
    IFS=" " read -r low high <<<$low;
    
    if (( $low <= $ip )); then
        if (( $high >= $ip )); then
            ip=$(($high + 1));
        fi
    fi

done

echo "The lowest possible IP-Adress is: $ip";