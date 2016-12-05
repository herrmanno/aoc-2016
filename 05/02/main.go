package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"strconv"
)

const input = "wtnhxymk"
const codeLengh = 8

func main() {
	var code [codeLengh]string
	var setPos [codeLengh]bool

	i := 0
	for {
		md := md5.Sum([]byte(input + strconv.Itoa(i)))
		hash := hex.EncodeToString(md[:])
		
		if hash[0:5] == "00000" {
			pos, _ := strconv.ParseInt(string(hash[5:6]), 16, 32)
			if pos < codeLengh && !setPos[pos] {
				code[pos] = hash[6:7]
				setPos[pos] = true
				fmt.Printf("Found value %v for position %v at iteration %v with hash %v\n", code[pos], pos, i, hash)
			}
		}
		// fmt.Printf("%v\t\t%v\t\t%v\t\t%v\t\t%v\t\t\n", i, hash, pos, hash[5:6], code)

		i++

		if i % 10000 == 0 {
			done := true
			for i := 0; i < codeLengh; i++ {
				if !setPos[i] {
					done = false
				}
			}
			if done {
				break
			}
		}

	}

	fmt.Printf("Code: %s\n", code)
}