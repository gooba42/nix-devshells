package main

import (
"machine"
"time"
)

func main() {
	// Configure LED pin
	led := machine.LED
	led.Configure(machine.PinConfig{Mode: machine.PinOutput})

	// Blink forever
	for {
		led.High()
		time.Sleep(time.Second / 2)

		led.Low()
		time.Sleep(time.Second / 2)
	}
}
