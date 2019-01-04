void SPI_init() {
    //SPI_CR2 |=SPI_CR2_RXONLY;//только прием.
    SPI_CR1 = SPI_CR1_SPE ;
}

void SPI_write(int data) {
    SPI_DR = data;
    while (!(SPI_SR & SPI_SR_TXE));
}
int SPI_read() {
    while (!(SPI_SR & SPI_SR_RXNE));
    return SPI_DR;
}
void SPI_deinit() {
        while (!(SPI_SR & SPI_SR_RXNE));
        while (!(SPI_SR & SPI_SR_TXE));
        while ((SPI_SR & SPI_SR_BSY));
        SPI_CR1 &=~ SPI_CR1_SPE;
}
