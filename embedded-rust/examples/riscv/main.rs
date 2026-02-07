// RISC-V example: Simple LED blink
// Target: riscv32imac-unknown-none-elf
// Compatible with: CH32V003, CH32V103, and other RISC-V microcontrollers

#![no_std]
#![no_main]

use core::arch::asm;

// Example for WCH CH32V003 (RISC-V CPU)
// GPIO port C register addresses (adjust for your board)
const GPIOC_BASE: u32 = 0x4001_1000;
const GPIO_CFGLR: u32 = 0x00; // Low byte configuration register
const GPIO_BSHR: u32 = 0x10;  // Bit set/reset register
const GPIO_BCR: u32 = 0x14;   // Bit clear register

#[no_mangle]
pub fn _start() -> ! {
    // Configure PC7 as output (generic example)
    // Bit mode: 01 = output
    unsafe {
        let gpio_ptr = (GPIOC_BASE + GPIO_CFGLR) as *mut u32;
        let val = core::ptr::read_volatile(gpio_ptr);
        core::ptr::write_volatile(gpio_ptr, val | (0b0001 << 28));
    }

    loop {
        // Set PC7 (output high)
        unsafe {
            let gpio_ptr = (GPIOC_BASE + GPIO_BSHR) as *mut u32;
            core::ptr::write_volatile(gpio_ptr, 1 << 7);
        }

        delay(500_000);

        // Clear PC7 (output low)
        unsafe {
            let gpio_ptr = (GPIOC_BASE + GPIO_BCR) as *mut u32;
            core::ptr::write_volatile(gpio_ptr, 1 << 7);
        }

        delay(500_000);
    }
}

// Simple delay loop
fn delay(count: u32) {
    for _ in 0..count {
        unsafe {
            asm!("nop");
        }
    }
}

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    loop {
        unsafe {
            asm!("wfi"); // Wait for interrupt
        }
    }
}
