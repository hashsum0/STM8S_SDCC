/* GPIO */
#define PA_ODR *(unsigned char*)0x5000
#define PA_IDR *(unsigned char*)0x5001
#define PA_DDR *(unsigned char*)0x5002
#define PA_CR1 *(unsigned char*)0x5003
#define PA_CR2 *(unsigned char*)0x5004

#define PB_ODR *(unsigned char*)0x5005
#define PB_IDR *(unsigned char*)0x5006
#define PB_DDR *(unsigned char*)0x5007
#define PB_CR1 *(unsigned char*)0x5008
#define PB_CR2 *(unsigned char*)0x5009

#define PC_ODR *(unsigned char*)0x500A
#define PC_IDR *(unsigned char*)0x500B
#define PC_DDR *(unsigned char*)0x500C
#define PC_CR1 *(unsigned char*)0x500D
#define PC_CR2 *(unsigned char*)0x500E

#define PD_ODR *(unsigned char*)0x500F
#define PD_IDR *(unsigned char*)0x5010
#define PD_DDR *(unsigned char*)0x5011
#define PD_CR1 *(unsigned char*)0x5012
#define PD_CR2 *(unsigned char*)0x5013

#define PE_ODR *(unsigned char*)0x5014
#define PE_IDR *(unsigned char*)0x5015
#define PE_DDR *(unsigned char*)0x5016
#define PE_CR1 *(unsigned char*)0x5017
#define PE_CR2 *(unsigned char*)0x5018

#define PF_ODR *(unsigned char*)0x5019
#define PF_IDR *(unsigned char*)0x501A
#define PF_DDR *(unsigned char*)0x501B
#define PF_CR1 *(unsigned char*)0x501C
#define PF_CR2 *(unsigned char*)0x501D

/* CLOCK */
#define CLK_ICKR	*(unsigned char*)0x50C0
#define CLK_ECKR	*(unsigned char*)0x50C1
#define CLK_CMSR	*(unsigned char*)0x50C3
#define CLK_SWR		*(unsigned char*)0x50C4
#define CLK_SWCR	*(unsigned char*)0x50C5
#define CLK_CKDIVR	*(unsigned char*)0x50C6
#define CLK_PCKENR1	*(unsigned char*)0x50C7
#define CLK_CSSR 	*(unsigned char*)0x50C8
#define CLK_CCOR	*(unsigned char*)0x50C9
#define CLK_PCKENR2	*(unsigned char*)0x50CA
#define CLK_HSITRIMR	*(unsigned char*)0x50CC
#define CLK_SWIMCCR	*(unsigned char*)0x50CD

/* ------------------- USART -------------------*/
#define UART1_SR *(unsigned char*)0x5230
#define UART1_DR *(unsigned char*)0x5231
#define UART1_BRR1 *(unsigned char*)0x5232
#define UART1_BRR2 *(unsigned char*)0x5233
#define UART1_CR1 *(unsigned char*)0x5234
#define UART1_CR2 *(unsigned char*)0x5235
#define UART1_CR3 *(unsigned char*)0x5236
#define UART1_CR4 *(unsigned char*)0x5237
#define UART1_CR5 *(unsigned char*)0x5238
#define UART1_GTR *(unsigned char*)0x5239
#define UART1_PSCR *(unsigned char*)0x523A

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

/* ------------------- interrupts ------------------- */
#define EXTI_CR1	*(unsigned char*)0x50A0
#define EXTI_CR2	*(unsigned char*)0x50A1
#define INTERRUPT_HANDLER(fn, num)		void fn() __interrupt(num)
#define INTERRUPT_DEFINITION(fn, num)	extern void fn() __interrupt(num)

// Reset status register
#define RST_SR		*(unsigned char*)0x50B3

#define TIM2_CR1 *(unsigned char*)0x5300
#define TIM2_IER *(unsigned char*)0x5303
#define TIM2_SR1 *(unsigned char*)0x5304
#define TIM2_SR2 *(unsigned char*)0x5305
#define TIM2_EGR *(unsigned char*)0x5306
#define TIM2_CCMR1 *(unsigned char*)0x5307
#define TIM2_CCMR2 *(unsigned char*)0x5308
#define TIM2_CCMR3 *(unsigned char*)0x5309
#define TIM2_CCER1 *(unsigned char*)0x530A
#define TIM2_CCER2 *(unsigned char*)0x530B
#define TIM2_CNTRH *(unsigned char*)0x530C
#define TIM2_CNTRL *(unsigned char*)0x530D
#define TIM2_PSCR *(unsigned char*)0x530E
#define TIM2_ARRH *(unsigned char*)0x530F
#define TIM2_ARRL *(unsigned char*)0x5310
#define TIM2_CCR1H *(unsigned char*)0x5311
#define TIM2_CCR1L *(unsigned char*)0x5312
#define TIM2_CCR2H *(unsigned char*)0x5313
#define TIM2_CCR2L *(unsigned char*)0x5314
#define TIM2_CCR3H *(unsigned char*)0x5315
#define TIM2_CCR3L *(unsigned char*)0x5316

//TIM_IER bits 
//#define TIM_IER_BIE (1 << 7)
#define TIM_IER_TIE (1 << 6)
#define TIM_IER_COMIE (1 << 5)
#define TIM_IER_CC4IE (1 << 4)
#define TIM_IER_CC3IE (1 << 3)
#define TIM_IER_CC2IE (1 << 2)
#define TIM_IER_CC1IE (1 << 1)
#define TIM_IER_UIE (1 << 0)

// TIM_CR1 bits 
#define TIM_CR1_APRE (1 << 7)
//#define TIM_CR1_CMSH (1 << 6)
//#define TIM_CR1_CMSL (1 << 5)
//#define TIM_CR1_DIR (1 << 4)
#define TIM_CR1_OPM  (1 << 3)
#define TIM_CR1_URS  (1 << 2)
#define TIM_CR1_UDIS (1 << 1)
#define TIM_CR1_CEN  (1 << 0)

// TIM_SR1 bits 
//#define TIM_SR1_BIF (1 << 7)
#define TIM_SR1_TIF   (1 << 6)
#define TIM_SR1_COMIF (1 << 5)
#define TIM_SR1_CC4IF (1 << 4)
#define TIM_SR1_CC3IF (1 << 3)
#define TIM_SR1_CC2IF (1 << 2)
#define TIM_SR1_CC1IF (1 << 1)
#define TIM_SR1_UIF   (1 << 0)
/* ------------------- TIMERS ------------------- 
#define TIM1_CR1 *(unsigned char*)0x52B0
#define TIM1_CR2 *(unsigned char*)0x52B1
#define TIM1_SMCR *(unsigned char*)0x52B2
#define TIM1_ETR *(unsigned char*)0x52B3
#define TIM1_DER *(unsigned char*)0x52B4
#define TIM1_IER *(unsigned char*)0x52B5
#define TIM1_SR1 *(unsigned char*)0x52B6
#define TIM1_SR2 *(unsigned char*)0x52B7
#define TIM1_EGR *(unsigned char*)0x52B8
#define TIM1_CCMR1 *(unsigned char*)0x52B9
#define TIM1_CCMR2 *(unsigned char*)0x52BA
#define TIM1_CCMR3 *(unsigned char*)0x52BB
#define TIM1_CCMR4 *(unsigned char*)0x52BC
#define TIM1_CCER1 *(unsigned char*)0x52BD
#define TIM1_CCER2 *(unsigned char*)0x52BE
#define TIM1_CNTRH *(unsigned char*)0x52BF
#define TIM1_CNTRL *(unsigned char*)0x52C0
#define TIM1_PSCRH *(unsigned char*)0x52C1
#define TIM1_PSCRL *(unsigned char*)0x52C2
#define TIM1_ARRH *(unsigned char*)0x52C3
#define TIM1_ARRL *(unsigned char*)0x52C4
#define TIM1_RCR *(unsigned char*)0x52C5
#define TIM1_CCR1H *(unsigned char*)0x52C6
#define TIM1_CCR1L *(unsigned char*)0x52C7
#define TIM1_CCR2H *(unsigned char*)0x52C8
#define TIM1_CCR2L *(unsigned char*)0x52C9
#define TIM1_CCR3H *(unsigned char*)0x52CA
#define TIM1_CCR3L *(unsigned char*)0x52CB
#define TIM1_CCR4H *(unsigned char*)0x52CC
#define TIM1_CCR4L *(unsigned char*)0x52CD
#define TIM1_BKR *(unsigned char*)0x52CE
#define TIM1_DTR *(unsigned char*)0x52CF
#define TIM1_OISR *(unsigned char*)0x52D0
#define TIM1_DCR1 *(unsigned char*)0x52D1
#define TIM1_DCR2 *(unsigned char*)0x52D2
#define TIM1_DMA1R *(unsigned char*)0x52D3

// TIM_IER bits 
#define TIM_IER_BIE (1 << 7)
#define TIM_IER_TIE (1 << 6)
#define TIM_IER_COMIE (1 << 5)
#define TIM_IER_CC4IE (1 << 4)
#define TIM_IER_CC3IE (1 << 3)
#define TIM_IER_CC2IE (1 << 2)
#define TIM_IER_CC1IE (1 << 1)
#define TIM_IER_UIE (1 << 0)

// TIM_CR1 bits 
#define TIM_CR1_APRE (1 << 7)
#define TIM_CR1_CMSH (1 << 6)
#define TIM_CR1_CMSL (1 << 5)
#define TIM_CR1_DIR (1 << 4)
#define TIM_CR1_OPM (1 << 3)
#define TIM_CR1_URS (1 << 2)
#define TIM_CR1_UDIS (1 << 1)
#define TIM_CR1_CEN (1 << 0)

// TIM_SR1 bits 
#define TIM_SR1_BIF (1 << 7)
#define TIM_SR1_TIF (1 << 6)
#define TIM_SR1_COMIF (1 << 5)
#define TIM_SR1_CC4IF (1 << 4)
#define TIM_SR1_CC3IF (1 << 3)
#define TIM_SR1_CC2IF (1 << 2)
#define TIM_SR1_CC1IF (1 << 1)
#define TIM_SR1_UIF (1 << 0)*/
