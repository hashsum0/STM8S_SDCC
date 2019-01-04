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
