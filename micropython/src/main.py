# MicroPython Blink Example
import time
from machine import Pin

# Configure LED pin
# ESP32: GPIO2, ESP8266: GPIO2, Pico: GP25, PyBoard: LED1
led = Pin(2, Pin.OUT)  

print("MicroPython blink example")
print("LED will blink every 0.5 seconds")

while True:
    led.on()
    time.sleep(0.5)
    led.off()
    time.sleep(0.5)
