//#include <stdint.h>
#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/uart1.h"
#include "inc/spi_nrf24.h"
void delay(uint8_t t)
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
    uint8_t i=0;
    uint8_t reg_data=0,status=0;
    uint8_t reg_buf[]={0x00,0x00,0x00,0x00,0x00};
    uint8_t remote_addr[] = {0xe7, 0xe7, 0xe7, 0xe7, 0xe7};
    Init_HSE();
    SPI_init();
    uart1_init();
    PB_DDR&=~(1<<7);
    PB_CR1|=(1<<7);
    PB_CR2&=~(1<<7);
    while (1) {
        if(!(PB_IDR&(1<<7))){
            delay(10);
            SPI_write_buf(RX_ADDR_P0, &remote_addr[0], 5);

            reg_data=SPI_read_buf(RX_ADDR_P0, &reg_buf[0], 5);
            //SPI_write_reg(CONFIG, 0x08);
            //reg_data=SPI_read_reg(CONFIG);

            while (!(UART1_SR & UART1_SR_TXE)) {}
            UART1_DR=reg_data;
            for(i=0;i<5;i++){
                while (!(UART1_SR & UART1_SR_TXE)) {}
                UART1_DR=reg_buf[i];
            }
            while(!(PB_IDR&(1<<7)));
        }
    }
}
