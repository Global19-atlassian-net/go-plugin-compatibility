package main

import (
	"fmt"
	"gopkg.in/yaml.v2"
	"os"
	"plugin"
)

var _ = yaml.Encoder{}

func main() {
	if len(os.Args) < 2 {
		panic("must provide plugin file name as first argument")
	}
	pluginFileName := os.Args[1]

	fmt.Printf("Loading plugin file: %s\n", pluginFileName)
	if _, err := plugin.Open(pluginFileName); err != nil {
		panic(err)
	}
}
