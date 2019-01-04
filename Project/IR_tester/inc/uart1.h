#ifndef UART1_H
#define UART1_H

/* USART_CR1 bits */
#define UART1_CR1_R8 (1 << 7)
#define UART1_CR1_T8 (1 << 6)
#define UART1_CR1_UARTD (1 << 5)
#define UART1_CR1_M (1 << 4)
#define UART1_CR1_WAKE (1 << 3)
#define UART1_CR1_PCEN (1 << 2)
#define UART1_CR1_PS (1 << 1)
#define UART1_CR1_PIEN (1 << 0)

/* USART_CR2 bits */
#define UART1_CR2_TIEN (1 << 7)
#define UART1_CR2_TCIEN (1 << 6)
#define UART1_CR2_RIEN (1 << 5)
#define UART1_CR2_ILIEN (1 << 4)
#define UART1_CR2_TEN (1 << 3)
#define UART1_CR2_REN (1 << 2)
#define UART1_CR2_RWU (1 << 1)
#define UART1_CR2_SBK (1 << 0)

/* USART_CR3 bits */
#define UART1_CR3_LINEN (1 << 6)
#define UART1_CR3_STOP2 (1 << 5)
#define UART1_CR3_STOP1 (1 << 4)
#define UART1_CR3_CLKEN (1 << 3)
#define UART1_CR3_CPOL (1 << 2)
#define UART1_CR3_CPHA (1 << 1)
#define UART1_CR3_LBCL (1 << 0)

/* USART_SR bits */
#define UART1_SR_TXE (1 << 7)
#define UART1_SR_TC (1 << 6)
#define UART1_SR_RXNE (1 << 5)
#define UART1_SR_IDLE (1 << 4)
#define UART1_SR_OR (1 << 3)
#define UART1_SR_NF (1 << 2)
#define UART1_SR_FE (1 << 1)
#define UART1_SR_PE (1 << 0)

void uart1_init();

void tx(char *str);

void rx(char *str);

#endif /* UART1_H */
