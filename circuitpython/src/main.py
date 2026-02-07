"""
CircuitPython example for Raspberry Pi Pico
Blink the built-in LED
"""

import board
import digitalio
import time

# Initialize the onboard LED
led = digitalio.DigitalInOut(board.LED)
led.direction = digitalio.Direction.OUTPUT

# Blink loop
while True:
    led.value = True
    time.sleep(0.5)
    led.value = False
    time.sleep(0.5)
