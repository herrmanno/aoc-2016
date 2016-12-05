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
	code := ""
	i := 0
	for len(code) < codeLengh {
		md := md5.Sum([]byte(input + strconv.Itoa(i)))
		hash := hex.EncodeToString(md[:])
		if hash[0:5] == "00000" {
			code += string(hash[5])
		}
		// fmt.Printf("%v\t\t%v\t\t%v\t\t\n", i, hash, code)

		i++
	}

	fmt.Printf("%v", code)
}
