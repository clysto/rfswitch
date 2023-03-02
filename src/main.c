#include <driverlib.h>

uint8_t BITSTREAM[64];

static void __attribute__((naked, section(".crt_0042"), used)) disable_watchdog(void) {
    WDTCTL = WDTPW | WDTHOLD;
}

extern void TX_FM();

void delay_ms(unsigned int ms) {
    while (ms) {
        __delay_cycles(16000);
        ms--;
    }
}

int main(void) {
    // Disable FRAM wait cycles to allow clock operation over 8MHz
    FRAMCtl_configureWaitStateControl(FRAMCTL_ACCESS_TIME_CYCLES_1);
    // 配置 DCO 为 16 MHz
    CS_setDCOFreq(CS_DCORSEL_1, CS_DCOFSEL_4);
    // MCLK 时钟源配置为 DCO
    CS_initClockSignal(CS_MCLK, CS_DCOCLK_SELECT, CS_CLOCK_DIVIDER_1);
    // SMCLK 时钟源配置为 DCO (16MHz / 16 = 1MHz)
    CS_initClockSignal(CS_SMCLK, CS_DCOCLK_SELECT, CS_CLOCK_DIVIDER_16);
    CS_enableClockRequest(CS_MCLK);
    CS_enableClockRequest(CS_SMCLK);

    GPIO_setAsOutputPin(GPIO_PORT_P1, GPIO_PIN7);

    PMM_unlockLPM5();

    for (int i = 0; i < 128; i++) {
        BITSTREAM[i] = i;
    }

    for (;;) {
        TX_FM();
        // 50ms 间隔
        delay_ms(50);
    }

    __bis_SR_register(LPM4_bits + GIE);
    __no_operation();
    return 0;
}
