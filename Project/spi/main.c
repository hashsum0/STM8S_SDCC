#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
#define CS_PIN      4

void SPI_init() {
    /* Initialize CS pin */
    PC_DDR |= (1 << CS_PIN);
    PC_CR1 |= (1 << CS_PIN);
    PC_ODR |= (1 << CS_PIN);
    /* Initialize SPI master at 500kHz  */
    SPI_CR2 = SPI_CR2_SSM | SPI_CR2_SSI;//без этой настройки требуется подключить вывод NSS к VDD
    SPI_CR1 = SPI_CR1_MSTR | SPI_CR1_SPE | SPI_CR1_BR0;// | SPI_CR1_BR2;//??????SPI_CR1_BR(0)???????
    //SPI_CR1 |=SPI_CR1_LSBFIRST;
}

void SPI_write(int data) {
    SPI_DR = data;
    while (!(SPI_SR & SPI_SR_TXE));
}
int SPI_read() {
    SPI_write(0xFF);
    while (!(SPI_SR & SPI_SR_RXNE));
    return SPI_DR;
}
void chip_select() {
    PC_ODR &= ~(1 << CS_PIN);
}
void chip_deselect() {
    while ((SPI_SR & SPI_SR_BSY));
    PC_ODR |= (1 << CS_PIN);
}
void SPI_deinit() {
        while (!(SPI_SR & SPI_SR_RXNE));
        while (!(SPI_SR & SPI_SR_TXE));
        while ((SPI_SR & SPI_SR_BSY));
        SPI_CR1 &=~ SPI_CR1_SPE;
}
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
	GPIO_init();
    int data[]={'t','e','s','t','\n','\r'};
    PC_DDR |= (1 << CS_PIN);
    PC_CR1 |= (1 << CS_PIN);
    PC_ODR |= (1 << CS_PIN);
    
    SPI_init();
    PD_ODR|=(1<<0);
    while (1) {
        chip_select();
        for(int i=0;i<6;i++){
            SPI_write(data[i]);
            delay(1);
        }
        chip_deselect();
        delay(500);
        PD_ODR &=~ (1<<0);
    }
}
