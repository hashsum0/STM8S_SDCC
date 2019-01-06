#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/uart1.h"
#include "inc/spi_nrf24.h"
void delay(int t)
{
    int i,s;
    for(i=0;i<t;i++){
        for(s=0;s<255;s++){
        }
    }
}

///*******************************************************main*/
void main(void)
{
    int i=0;
    Init_HSE();
    SPI_init();
    uart1_init();
    
    while (1) {
        delay(10);
        chip_select();
        SPI_read_status();
        chip_deselect();
        while (!(UART1_SR & UART1_SR_TXE)) {}
        UART1_DR=i+48;
    }
}
