#!/bin/bash

ips=4294967296

declare -a stack;
sp=0

for line in $(sort -g input.txt) ; do
    IFS="-" read -r low high <<<$line;
    IFS=" " read -r low high <<<$low;
    
    if(($sp == 0)); then
        stack[sp]=$low
        ((sp++))
        stack[sp]=$high      
    fi

    if((stack[sp]+1 < low)); then
        ((sp++))
        stack[sp]=$low
        ((sp++))
        stack[sp]=$high        

    elif((stack[sp]+1 < high)); then
        stack[sp]=$high        
    fi

done

while [ $sp -ge 0 ]
do
    diff=$((1 + stack[sp] - stack[sp-1]))
    ips=$((ips-diff))
    sp=$((sp-2))
done

echo "There are $ips valid ips";