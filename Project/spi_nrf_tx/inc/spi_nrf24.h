#ifndef __SPI_NRF24_H
#define __SPI_NRF24_H

#define CS_PIN      (1<<3)
#define CSN_PIN     (1<<4)
#define IRQ_PIN     (1<<2)

void SPI_init();
void check_tx(void);
void check_rx(void);
void SPI_write(unsigned char data);
int SPI_read_status();
void chip_select(void);
void chip_deselect(void);
void SPI_deinit(void);
#endif /*__SPI_NRF24_H*/
