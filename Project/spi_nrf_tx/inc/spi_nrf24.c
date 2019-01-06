#include "stm8s.h"
#include "spi_nrf24.h"
/* ================================================================================Init SPI STM8 */
void SPI_init() {
    PC_DDR &=~ IRQ_PIN;
    PC_DDR |= CS_PIN | CSN_PIN;
    PC_CR1 |= CS_PIN | CSN_PIN | IRQ_PIN;
    PC_ODR |= CSN_PIN;
    SPI_CR2 = SPI_CR2_SSM | SPI_CR2_SSI;
    SPI_CR1 = SPI_CR1_MSTR | SPI_CR1_SPE | SPI_CR1_BR0 | SPI_CR1_BR1;
}
/* ===============================================================================Check SPI flags */
void check_tx(void){
     while (!(SPI_SR & SPI_SR_TXE));
}
void check_rx(void){
     while (!(SPI_SR & SPI_SR_RXNE));
}
/* ========================================================================Function read and write */
void SPI_write(unsigned char data) {
    SPI_DR = data;
    check_tx();
}
int SPI_read_status() {
    SPI_write(0xFF);
    check_rx();
    return SPI_DR;
}
/* ====================================================================================Control CSN */
void chip_select() {
    PC_ODR &= ~CSN_PIN ;
}
void chip_deselect() {
    while ((SPI_SR & SPI_SR_BSY));
    PC_ODR |= CSN_PIN ;
}
/* ================================================================================Deinit SPI STM8 */
void SPI_deinit() {
        while (!(SPI_SR & SPI_SR_RXNE));
        while (!(SPI_SR & SPI_SR_TXE));
        while ((SPI_SR & SPI_SR_BSY));
        SPI_CR1 &=~ SPI_CR1_SPE;
}

