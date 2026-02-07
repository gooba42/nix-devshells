using System;
using System.Threading;
using System.Device.Gpio;

namespace NanoFrameworkApp
{
    public class Program
    {
        // GPIO pin for LED (adjust for your board)
        // ESP32: GPIO pin 2
        // ESP8266: GPIO pin D4 (GPIO 2)
        // RP Pico: GPIO pin 25
        // STM32 Nucleo: varies by board
        private const int LED_PIN = 2;

        public static void Main()
        {
            Console.WriteLine("Hello from .NET nanoFramework!");
            Console.WriteLine("Starting LED blink example...");

            // Create GPIO controller
            GpioController gpio = new GpioController();

            // Open the LED pin
            gpio.OpenPin(LED_PIN, PinMode.Output);

            // Blink the LED
            while (true)
            {
                // Turn LED on
                gpio.Write(LED_PIN, PinValue.High);
                Console.WriteLine("LED ON");
                Thread.Sleep(1000);

                // Turn LED off
                gpio.Write(LED_PIN, PinValue.Low);
                Console.WriteLine("LED OFF");
                Thread.Sleep(1000);
            }
        }
    }
}
