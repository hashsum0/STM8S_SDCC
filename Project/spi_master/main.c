#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/uart1.h"
#include "inc/spi_master.h"



void delay(int t)
{
	int i,s;
	for(i=0;i<t;i++)
	{
		for(s=0;s<512;s++)
		{
		}
	}
}
///*******************************************************main*/
void main(void)
{
    clk_init();
	uart1_init();
    int data='D';
    int res=0;
    SPI_init();
    while (1) {
        chip_select();
        SPI_write(data);
        res=SPI_read();
        chip_deselect();
        while (!(UART1_SR & UART1_SR_TXE)) {}
          UART1_DR=res;
        delay(50);
    }
}
