# Embedded Rust Microcontroller Template

A Nix flake-based development environment for Rust embedded systems targeting ARM Cortex-M, RISC-V, AVR, and other microcontroller architectures. This template follows the [Rust Embedded Book](https://docs.rust-embedded.org/book/) and provides everything needed to build, test, and flash bare-metal Rust applications.

## Features

- **Multi-architecture support**: ARM Cortex-M0/M3/M4/M7, RISC-V, AVR, and more
- **Integrated toolchain**: Rust with embedded targets, ARM/RISC-V/AVR GCC, OpenOCD, probe-rs
- **Debugging tools**: GDB, LLDB, probe-rs, OpenOCD for hardware debugging
- **Flashing utilities**: probe-rs, cargo-flash, esptool for multiple board types
- **Example projects**: STM32F3DISCOVERY, generic Cortex-M, RISC-V, STM32 HAL examples
- **Reproducible environment**: Nix ensures consistent toolchains across systems
- **Development shells**: Configured with all necessary packages and helper scripts

## Supported Architectures

| Architecture | Rust Target | GCC Toolchain | Example Board | Status |
|---|---|---|---|---|
| ARM Cortex-M0 | `thumbv6m-none-eabi` | arm-none-eabi-gcc | BBC micro:bit | ✅ |
| ARM Cortex-M3 | `thumbv7m-none-eabi` | arm-none-eabi-gcc | STM32L1xx | ✅ |
| ARM Cortex-M4 | `thumbv7em-none-eabihf` | arm-none-eabi-gcc | STM32F3, STM32F4 | ✅ |
| ARM Cortex-M7 | `thumbv7em-none-eabihf` | arm-none-eabi-gcc | STM32F7, STM32H7 | ✅ |
| RISC-V (32-bit) | `riscv32imac-unknown-none-elf` | riscv-none-embed-gcc | CH32V003, GD32VF | ✅ |
| AVR | `avr-unknown-gnu-eabihf` | avr-libc | Arduino, ATmega | ⚠️ |

## Quick Start

### 1. Initialize a New Project

Using the Nix template:

```bash
nix flake init -t '/path/to/nix#embedded-rust'
cd embedded-rust-app
```

Or clone the template manually:

```bash
git clone https://github.com/yourusername/nix-templates
cd nix-templates/flakes/embedded-rust

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Rust packaging docs](https://nixos.org/manual/nixpkgs/stable/#rust) for more details.

#### Option B: Using OpenOCD + GDB

```bash
# Terminal 1: Start OpenOCD
openocd -f openocd.cfg

# Terminal 2: Connect with GDB
arm-none-eabi-gdb target/thumbv7em-none-eabihf/release/myapp
(gdb) target remote localhost:3333
(gdb) load
(gdb) continue
```

#### Option C: Using cargo-flash

```bash
cargo install cargo-flash
cargo flash --chip stm32f303xc --release
```

## Project Structure

```
embedded-rust/
├── flake.nix              # Nix flake with devShell and packages
├── Cargo.toml             # Workspace and package configuration
├── .envrc                 # direnv integration
├── src/
│   ├── lib.rs             # Library code (HAL abstractions, utilities)
│   └── main.rs            # Application entry point
├── examples/
│   ├── cortex_m/          # ARM Cortex-M LED blink example
│   ├── riscv/             # RISC-V LED blink example
│   └── stm32/             # STM32F3DISCOVERY HAL example
├── openocd.cfg            # OpenOCD configuration (customize for your board)
└── README.md              # This file
```

## Development Workflow

### Typical Development Loop

1. **Modify code** in `src/main.rs` or `src/lib.rs`
2. **Build** for your target:

   ```bash
   cargo build --release --target thumbv7em-none-eabihf
   ```

3. **Check** without building:

   ```bash
   cargo check --target thumbv7em-none-eabihf
   ```

4. **Flash** to device:

   ```bash
   probe-rs run --chip stm32f303xc --release
   ```

5. **Debug** with GDB or via semihosting

### Using Helper Scripts

The flake provides convenient build/flash helpers:

```bash
# Build for Cortex-M4
nix run .#build-cortex-m release thumbv7em-none-eabihf

# Flash with probe-rs
nix run .#flash-cortex-m stm32f303xc release

# Start OpenOCD + GDB
nix run .#flash-openocd target/thumbv7em-none-eabihf/release/myapp openocd.cfg
```

## Common Tasks

### Check Available Targets

```bash
rustup target list | grep installed
```

### Inspecting Generated Binaries

```bash
# List symbols and sections
arm-none-eabi-objdump -d target/thumbv7em-none-eabihf/release/myapp | less

# Check binary size
arm-none-eabi-size target/thumbv7em-none-eabihf/release/myapp

# Convert to hex for flashing
arm-none-eabi-objcopy -O ihex target/thumbv7em-none-eabihf/release/myapp firmware.hex
```

### Using Semihosting for Debugging

Enable semihosting in your project:

```bash
# In Cargo.toml
[features]
semihosting = ["panic-semihosting"]

# Build with semihosting
cargo build --release --target thumbv7em-none-eabihf --features semihosting
```

Then in `main.rs`:

```rust
use cortex_m_semihosting::println;

#[entry]
fn main() -> ! {
    println!("Hello, embedded world!");
    loop {}
}
```

### Serial Console / UART Monitoring

Connect to your board's UART:

```bash
# Using minicom
minicom -D /dev/ttyUSB0 -b 115200

# Using screen
screen /dev/ttyUSB0 115200

# Quit screen: Ctrl-A, then X
```

## HAL and Peripheral Access

### Using embedded-hal Traits

The `embedded-hal` crate provides abstract traits for common peripherals:

```rust
use embedded_hal::prelude::*;
use embedded_hal::digital::v2::OutputPin;

fn blink<LED: OutputPin>(led: &mut LED) {
    led.set_high().ok();
    delay();
    led.set_low().ok();
}
```

### Device-Specific HALs

For popular boards, use official HALs:

- **STM32**: [stm32f3xx-hal](https://docs.rs/stm32f3xx-hal/)
- **STM32H7**: [stm32h7xx-hal](https://docs.rs/stm32h7xx-hal/)
- **RP2040** (Raspberry Pi Pico): [rp2040-hal](https://docs.rs/rp2040-hal/)
- **nRF52**: [nrf52-hal](https://docs.rs/nrf52-hal/)
- **ESP32**: [esp-hal](https://docs.rs/esp-hal/)

Example with stm32f3xx-hal:

```rust
use stm32f3xx_hal::{
    pac,
    prelude::*,
    gpio::GpioExt,
};

#[entry]
fn main() -> ! {
    let dp = pac::Peripherals::take().unwrap();
    let mut rcc = dp.RCC.constrain();
    let mut gpioe = dp.GPIOE.split(&mut rcc.ahbenr);

    let mut led = gpioe.pe9.into_push_pull_output(&mut gpioe.moder, &mut gpioe.otyper);

    loop {
        led.set_high().ok();
        cortex_m::asm::delay(8_000_000);
        led.set_low().ok();
        cortex_m::asm::delay(8_000_000);
    }
}
```

## Memory and Linking

Embedded Rust requires careful memory management:

### memory.x

Create a `memory.x` file in your project root to define RAM/FLASH layout:

```
/* STM32F303VC */
MEMORY
{
  FLASH : ORIGIN = 0x08000000, LENGTH = 256K
  RAM : ORIGIN = 0x20000000, LENGTH = 40K
}
```

The `cortex-m-rt` crate will automatically use this during linking.

### .cargo/config.toml

Configure Cargo for your target:

```toml
[build]
target = "thumbv7em-none-eabihf"

[target.thumbv7em-none-eabihf]
runner = "arm-none-eabi-gdb -q -x openocd.gdb"
rustflags = [
    "-C", "link-arg=-Tlink.x",
    "-C", "link-arg=-nostartfiles",
]
```

## Debugging

### With probe-rs

```bash
cargo embed --chip stm32f303xc --release
```

### With OpenOCD + GDB

1. Create `openocd.cfg`:

```
# ST-Link connection
interface stlink
transport select hla_swd

# STM32F303 chip
source [find target/stm32f3x.cfg]
```

1. Start OpenOCD:

```bash
openocd -f openocd.cfg
```

1. In another terminal, debug:

```bash
arm-none-eabi-gdb target/thumbv7em-none-eabihf/release/myapp
(gdb) target remote localhost:3333
(gdb) load
(gdb) break main
(gdb) continue
(gdb) step
(gdb) print my_variable
(gdb) info registers
```

### Common GDB Commands

```
target remote localhost:3333   # Connect to OpenOCD
load                           # Load program into flash
run                           # Run program
break <location>              # Set breakpoint
continue (or c)               # Continue execution
step (or s)                   # Step into
next (or n)                   # Step over
finish                        # Run until return
backtrace (or bt)             # Print call stack
print <variable>              # Print variable value
info registers                # Show register values
monitor reset halt            # Reset board
disconnect                    # Disconnect and keep OpenOCD running
quit                          # Exit GDB
```

## Troubleshooting

### "error: linker `cc` not found"

The ARM toolchain is not available. Ensure you're in the Nix shell:

```bash
nix develop
```

### "error: could not compile `cortex-m`"

Your Rust target is not installed. Install it:

```bash
rustup target add thumbv7em-none-eabihf
```

### Probe not detected by probe-rs

Check connections and permissions:

```bash
probe-rs list    # Should show your probe
lsusb             # Check USB devices
# May need: sudo usermod -a -G plugdev $USER
```

### OpenOCD connection refused

OpenOCD isn't running. Start it in another terminal:

```bash
openocd -f openocd.cfg
```

### Binary too large for flash

Optimize your build:

```toml
[profile.release]
opt-level = "z"     # Optimize for size
lto = true          # Link-time optimization
codegen-units = 1   # Better optimization at cost of build time
strip = true        # Strip symbols
```

### Slow compilation times

Use incremental compilation (but it may use more disk space):

```bash
export CARGO_INCREMENTAL=1
cargo build --release --target thumbv7em-none-eabihf
```

## Resources

- [Rust Embedded Book](https://docs.rust-embedded.org/book/) - Essential resource for embedded Rust
- [Cortex-M Devices](https://docs.rs/cortex-m/) - Low-level ARM Cortex-M support
- [embedded-hal](https://docs.rs/embedded-hal/) - Hardware abstraction traits
- [STM32F3 Discovery Book](https://docs.rust-embedded.org/discovery/) - STM32F3DISCOVERY specific guide
- [probe-rs Documentation](https://probe.rs/) - Probe-rs flashing and debugging
- [probe-rs User Guide](https://probe.rs/guide/) - Detailed usage guide

## Nix Flake Commands

List available apps and packages:

```bash
nix flake show .
```

Build your project using Nix:

```bash
nix build .
```

Run a helper script:

```bash
nix run .#build-cortex-m
nix run .#flash-openocd
```

## Contributing

To extend this template:

1. Add new examples to `examples/<arch>/main.rs`
2. Update `Cargo.toml` with new dependencies
3. Modify `flake.nix` to add new packages or apps
4. Test with: `nix develop && cargo build --release --target thumbv7em-none-eabihf`

## License

This template is provided as-is. Check license files in dependent crates for their respective licenses.

## Notes

- The examples use `no_std` and `no_main` attributes for bare-metal embedded Rust
- Always verify your board's memory layout in `memory.x` before flashing
- Use `cortex-m::asm::delay()` for simple delays; implement timers for precise timing
- Prefer HAL crates over direct memory-mapped register access for clarity and safety
