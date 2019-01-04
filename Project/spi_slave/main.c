#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
#include "inc/uart1.h"
#include "inc/spi_slave.h"


///*******************************************************main*/
void main(void)
{
    int data=0;
    clk_init();
    uart1_init();
    SPI_init();
    tx("start\n\r");
 
    while (1) {
        
        data=SPI_read();
        while (!(UART1_SR & UART1_SR_TXE)) {}
          UART1_DR=data;
          SPI_write(data+1);
    }
}
