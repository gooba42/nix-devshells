import os
import sys
import time

# CRITICAL: Set BLINKA_FT232H BEFORE importing board/digitalio
# This prevents pyftdi from trying to enumerate USB devices on import
os.environ["BLINKA_FT232H"] = "1"

# Try to import Blinka libraries; gracefully handle missing FT232H device
try:
    import digitalio
    import board
except ValueError as e:
    # This happens when pyftdi/libusb tries to enumerate devices
    # but no FT232H is connected or USB permissions are missing
    print(f"ERROR: Could not import CircuitPython Blinka libraries: {e}")
    print("")
    print("This usually means:")
    print("  1. No FT232H device is connected to USB, OR")
    print("  2. udev rules are not installed (see README.md), OR")
    print("  3. Your user is not in the 'plugdev' group")
    print("")
    print("The development environment is installed correctly.")
    print("Connect an FT232H breakout and try again.")
    sys.exit(1)


# Use C0 for GPIO example; adjust as needed for your hardware
PIN = board.C0


def main() -> None:
    """
    Toggle GPIO pin C0 every 500ms.
    
    Requires an FT232H breakout connected via USB.
    """
    try:
        led = digitalio.DigitalInOut(PIN)
        led.direction = digitalio.Direction.OUTPUT
    except (ValueError, OSError) as e:
        print(f"ERROR: Could not initialize GPIO on {PIN}: {e}")
        print("Make sure FT232H is connected and udev rules are installed.")
        return

    print(f"Blinking GPIO on {PIN}...")
    try:
        while True:
            led.value = True
            time.sleep(0.5)
            led.value = False
            time.sleep(0.5)
    except KeyboardInterrupt:
        print("\nGPIO toggle stopped.")
    except Exception as e:
        print(f"Error toggling GPIO: {e}")


if __name__ == "__main__":
    main()
