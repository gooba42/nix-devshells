// Simple WebAssembly example for TinyGo
// Can be run with wasmtime or in a browser
package main

import (
"fmt"
)

//export add
func add(a, b int32) int32 {
	return a + b
}

//export greet
func greet(name string) string {
	return fmt.Sprintf("Hello, %s!", name)
}

func main() {
	println("TinyGo WebAssembly module loaded!")
}
