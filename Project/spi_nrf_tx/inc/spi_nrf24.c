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
/* ========================================================================Function read status */
// Write and read one byte, defoult=STATUS.
uint8_t SPI_write_read(uint8_t i) {
    SPI_DR = i;
    check_tx();
    check_rx();
    return SPI_DR;
}
/* ========================================================================Function read register */
// Read two byte, first=STATUS second=register.
uint8_t SPI_read_reg(uint8_t reg_add) {
    chip_select();
    SPI_write_read((reg_add&31)|0x00);
    uint8_t i=SPI_write_read(0xff);
    chip_deselect();
    return i;
}
// Read some byte, first=STATUS rest=register.
uint8_t SPI_read_buf(uint8_t reg_add, uint8_t *buf, uint8_t count) {
    chip_select();
    uint8_t status = SPI_write_read((reg_add&31) | R_REGISTER);
    while (count--) {
        (*buf++) = SPI_write_read(0xFF);
    }
    chip_deselect();
    return status;
}
/* ========================================================================Function write register */
// Write two byte, first=addres second=volume.
uint8_t SPI_write_reg(uint8_t reg, uint8_t val) {
   chip_select();
  uint8_t status = SPI_write_read((reg & 31) | W_REGISTER);
  SPI_write_read(val);
   chip_deselect();
  return status;
}
/* ========================================================================Function write buf */
// Write two byte, first=addres rest=volume.
uint8_t SPI_write_buf(uint8_t reg, uint8_t *buf, uint8_t count) {
  chip_select();
  uint8_t status = SPI_write_read((reg & 31) | W_REGISTER);
  while (count--) {
    SPI_write_read(*(buf++));
  }
  chip_deselect();
  return status;
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

