// Arduino Blink Example for TinyGo
package main

import (
"machine"
"time"
)

func main() {
	// Use Arduino pin 13 (built-in LED on most Arduino boards)
	led := machine.D13
	led.Configure(machine.PinConfig{Mode: machine.PinOutput})

	println("Blinking LED on Arduino pin 13...")

	for {
		led.High()
		time.Sleep(500 * time.Millisecond)

		led.Low()
		time.Sleep(500 * time.Millisecond)
	}
}
