import os
import sys
import time

# CRITICAL: Set BLINKA_FT232H BEFORE importing busio/board
# This prevents pyftdi from trying to enumerate USB devices on import
os.environ["BLINKA_FT232H"] = "1"

# Try to import Blinka libraries; gracefully handle missing FT232H device
try:
    import busio
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


def main() -> None:
    """
    Scan the I2C bus for connected devices.
    
    Requires an FT232H breakout connected via USB.
    """
    try:
        i2c = busio.I2C(board.SCL, board.SDA)
    except (ValueError, OSError) as e:
        print(f"ERROR: Could not initialize I2C interface: {e}")
        print("Make sure FT232H is connected and udev rules are installed.")
        return

    # Wait for I2C to be ready
    while not i2c.try_lock():
        time.sleep(0.01)
    try:
        addrs = i2c.scan()
        if not addrs:
            print("No I2C devices found on bus")
        else:
            print("Found I2C addresses:", [hex(a) for a in addrs])
    except Exception as e:
        print(f"Error scanning I2C bus: {e}")
    finally:
        i2c.unlock()


if __name__ == "__main__":
    main()
