// STM32F3DISCOVERY-specific example with stm32f3xx-hal
// This is a more practical example showing how to use a real HAL
// Target: thumbv7em-none-eabihf

#![no_std]
#![no_main]

use cortex_m_rt::entry;
use panic_halt as _;

// Uncomment when using stm32f3xx-hal:
// use stm32f3xx_hal::{
//     pac,
//     prelude::*,
//     gpio::GpioExt,
//     rcc::RccExt,
// };

#[entry]
fn main() -> ! {
    // With stm32f3xx-hal, the code would look like:
    //
    // let dp = pac::Peripherals::take().unwrap();
    // let mut flash = dp.FLASH.constrain();
    // let rcc = dp.RCC.constrain();
    // let clocks = rcc.cfgr.freeze(&mut flash.acr);
    // let mut gpioe = dp.GPIOE.split(&mut rcc.ahbenr);
    //
    // let mut led = gpioe.pe9
    //     .into_push_pull_output(&mut gpioe.moder, &mut gpioe.otyper);
    //
    // loop {
    //     led.set_high().ok();
    //     cortex_m::asm::delay(8_000_000);
    //     led.set_low().ok();
    //     cortex_m::asm::delay(8_000_000);
    // }

    // For now, we'll just spin
    loop {
        cortex_m::asm::nop();
    }
}

// Alternative: Manually control registers (without HAL)
/*
#[entry]
fn main() -> ! {
    // Configure clock and GPIO
    // (See cortex_m/main.rs for manual register access)
    loop {}
}
*/
