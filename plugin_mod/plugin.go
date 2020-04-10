package main

import (
	"fmt"

	"gopkg.in/yaml.v2"
)

var e = yaml.Encoder{}

func init() { fmt.Printf("Type: %T\n", e) }

func main() {}
