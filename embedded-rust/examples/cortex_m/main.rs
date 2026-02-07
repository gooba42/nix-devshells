// ARM Cortex-M4F example: LED blink on STM32F3DISCOVERY
// Target: thumbv7em-none-eabihf
// Board: STM32F3DISCOVERY (STM32F303VC)

#![no_std]
#![no_main]

use cortex_m::asm;
use cortex_m_rt::entry;
use panic_halt as _;

// LED control register addresses for STM32F303
// These are memory-mapped peripheral addresses
// In a real project, use a HAL like `stm32f3xx-hal` to abstract this

const RCC_AHBENR: u32 = 0x4002_1014;  // RCC AHB1ENR register
const GPIOE_MODER: u32 = 0x4800_1000; // GPIO E mode register
const GPIOE_BSRR: u32 = 0x4800_1018;  // GPIO E set/reset register

#[entry]
fn main() -> ! {
    // Enable GPIOE clock (bit 21 of RCC_AHBENR)
    unsafe {
        let rcc_ahbenr = (RCC_AHBENR as *mut u32);
        *rcc_ahbenr |= 1 << 21;
    }

    // Configure PE9, PE10, PE11, PE12 as output (LEDs on STM32F3DISCOVERY)
    // Each pin needs 2 bits in MODER register: 00 = input, 01 = output
    unsafe {
        let gpioe_moder = (GPIOE_MODER as *mut u32);
        // Set bits for PE9-PE12 to 01 (output mode)
        *gpioe_moder |= 0x5500;  // 0101 0101 0000 0000
    }

    // Blink LED loop
    loop {
        // Turn on LED (set PE9)
        unsafe {
            let gpioe_bsrr = (GPIOE_BSRR as *mut u32);
            *gpioe_bsrr = 1 << 9; // Set PE9
        }

        // Delay
        delay(1_000_000);

        // Turn off LED (reset PE9)
        unsafe {
            let gpioe_bsrr = (GPIOE_BSRR as *mut u32);
            *gpioe_bsrr = 1 << (9 + 16); // Reset PE9 via upper 16 bits
        }

        // Delay
        delay(1_000_000);
    }
}

// Simple spin-loop delay (not accurate, use timer in real projects)
fn delay(count: u32) {
    for _ in 0..count {
        asm::nop();
    }
}
