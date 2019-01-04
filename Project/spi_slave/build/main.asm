;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.8.0 #10562 (Linux)
;--------------------------------------------------------
	.module main
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _SPI_deinit
	.globl _SPI_read
	.globl _SPI_write
	.globl _SPI_init
	.globl _rx
	.globl _tx
	.globl _uart1_init
	.globl _GPIO_init
	.globl _clk_init
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
;--------------------------------------------------------
; Stack segment in internal ram 
;--------------------------------------------------------
	.area	SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area DABS (ABS)

; default segment ordering for linker
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area CONST
	.area INITIALIZER
	.area CODE

;--------------------------------------------------------
; interrupt vector 
;--------------------------------------------------------
	.area HOME
__interrupt_vect:
	int s_GSINIT ; reset
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
__sdcc_gs_init_startup:
__sdcc_init_data:
; stm8_genXINIT() start
	ldw x, #l_DATA
	jreq	00002$
00001$:
	clr (s_DATA - 1, x)
	decw x
	jrne	00001$
00002$:
	ldw	x, #l_INITIALIZER
	jreq	00004$
00003$:
	ld	a, (s_INITIALIZER - 1, x)
	ld	(s_INITIALIZED - 1, x), a
	decw	x
	jrne	00003$
00004$:
; stm8_genXINIT() end
	.area GSFINAL
	jp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
__sdcc_program_startup:
	jp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	inc/clk_init.h: 7: void clk_init(void){    
;	-----------------------------------------
;	 function clk_init
;	-----------------------------------------
_clk_init:
;	inc/clk_init.h: 8: CLK_ECKR|=CLK_ECKR_HSEEN;            
	bset	20673, #0
;	inc/clk_init.h: 9: CLK_SWCR|=CLK_SWCR_SWEN;               
	bset	20677, #1
;	inc/clk_init.h: 10: while((CLK_ECKR & CLK_ECKR_HSERDY) == 0) {} 
00101$:
	ld	a, 0x50c1
	bcp	a, #0x02
	jreq	00101$
;	inc/clk_init.h: 11: CLK_CKDIVR = 0;                    
	mov	0x50c6+0, #0x00
;	inc/clk_init.h: 12: CLK_SWR = 0xB4;                    
	mov	0x50c4+0, #0xb4
;	inc/clk_init.h: 13: while ((CLK_SWCR & CLK_SWCR_SWIF) == 0){}
00104$:
	ld	a, 0x50c5
	bcp	a, #0x08
	jreq	00104$
;	inc/clk_init.h: 14: CLK_CSSR|=CLK_CSSR_CSSEN;
	bset	20680, #0
;	inc/clk_init.h: 15: }
	ret
;	inc/gpio_init.h: 10: void GPIO_init(void)
;	-----------------------------------------
;	 function GPIO_init
;	-----------------------------------------
_GPIO_init:
;	inc/gpio_init.h: 17: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
	mov	0x5007+0, #0x00
;	inc/gpio_init.h: 18: PB_CR1 = 0xff;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
	mov	0x5008+0, #0xff
;	inc/gpio_init.h: 19: PB_CR2 = 0xff;                                                      //_______PORT_OUT
	mov	0x5009+0, #0xff
;	inc/gpio_init.h: 21: PC_DDR = 0xff;                                                        //_______1__________________0________________0_____________otkritiy stok
	mov	0x500c+0, #0xff
;	inc/gpio_init.h: 22: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
	mov	0x500d+0, #0xff
;	inc/gpio_init.h: 23: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
	mov	0x500e+0, #0x00
;	inc/gpio_init.h: 25: PD_DDR = 0xFF;   
	mov	0x5011+0, #0xff
;	inc/gpio_init.h: 26: PD_CR1 = 0xFF;  
	mov	0x5012+0, #0xff
;	inc/gpio_init.h: 27: PD_CR2 = 0x00; 
	mov	0x5013+0, #0x00
;	inc/gpio_init.h: 40: }
	ret
;	inc/uart1.h: 1: void uart1_init()
;	-----------------------------------------
;	 function uart1_init
;	-----------------------------------------
_uart1_init:
;	inc/uart1.h: 3: PD_DDR&=~(1<<6);  
	bres	20497, #6
;	inc/uart1.h: 4: PD_DDR|=(1<<5);             
	bset	20497, #5
;	inc/uart1.h: 5: UART1_CR2|=UART1_CR2_REN;
	bset	21045, #2
;	inc/uart1.h: 6: UART1_CR2|=UART1_CR2_TEN;  
	bset	21045, #3
;	inc/uart1.h: 7: UART1_BRR2 = 0x00;             
	mov	0x5233+0, #0x00
;	inc/uart1.h: 8: UART1_BRR1 = 0x48;            
	mov	0x5232+0, #0x48
;	inc/uart1.h: 9: }
	ret
;	inc/uart1.h: 10: void tx(char *str)
;	-----------------------------------------
;	 function tx
;	-----------------------------------------
_tx:
;	inc/uart1.h: 14: while (!(UART1_SR & UART1_SR_TXE)) {}       
	ldw	x, (0x03, sp)
00101$:
	ld	a, 0x5230
	jrpl	00101$
;	inc/uart1.h: 15: UART1_DR=*str; 
	ld	a, (x)
	ld	0x5231, a
;	inc/uart1.h: 16: if(*str=='\r') break;
	ld	a, (x)
	cp	a, #0x0d
	jrne	00129$
	ret
00129$:
;	inc/uart1.h: 17: *str++;
	incw	x
	jra	00101$
;	inc/uart1.h: 20: } 
	ret
;	inc/uart1.h: 21: void rx(char *str)
;	-----------------------------------------
;	 function rx
;	-----------------------------------------
_rx:
;	inc/uart1.h: 23: while (*str!='\r')
00104$:
	ldw	x, (0x03, sp)
	ld	a, (x)
	cp	a, #0x0d
	jrne	00129$
	ret
00129$:
;	inc/uart1.h: 26: while ((UART1_SR & UART1_SR_RXNE)!=0)         //Æäåì ïîÿâëåíèÿ áàéòà
00101$:
	ld	a, 0x5230
	bcp	a, #0x20
	jreq	00104$
;	inc/uart1.h: 28: *str++;
	incw	x
	ldw	(0x03, sp), x
;	inc/uart1.h: 29: *str=UART1_DR; 
	ld	a, 0x5231
	ld	(x), a
	jra	00101$
;	inc/uart1.h: 32: } 
	ret
;	inc/spi_slave.h: 1: void SPI_init() {
;	-----------------------------------------
;	 function SPI_init
;	-----------------------------------------
_SPI_init:
;	inc/spi_slave.h: 3: SPI_CR1 = SPI_CR1_SPE ;
	mov	0x5200+0, #0x40
;	inc/spi_slave.h: 4: }
	ret
;	inc/spi_slave.h: 6: void SPI_write(int data) {
;	-----------------------------------------
;	 function SPI_write
;	-----------------------------------------
_SPI_write:
;	inc/spi_slave.h: 7: SPI_DR = data;
	ld	a, (0x04, sp)
	ld	0x5204, a
;	inc/spi_slave.h: 8: while (!(SPI_SR & SPI_SR_TXE));
00101$:
	ld	a, 0x5203
	bcp	a, #0x02
	jreq	00101$
;	inc/spi_slave.h: 9: }
	ret
;	inc/spi_slave.h: 10: int SPI_read() {
;	-----------------------------------------
;	 function SPI_read
;	-----------------------------------------
_SPI_read:
;	inc/spi_slave.h: 11: while (!(SPI_SR & SPI_SR_RXNE));
00101$:
	ld	a, 0x5203
	srl	a
	jrnc	00101$
;	inc/spi_slave.h: 12: return SPI_DR;
	ld	a, 0x5204
	clrw	x
	ld	xl, a
;	inc/spi_slave.h: 13: }
	ret
;	inc/spi_slave.h: 14: void SPI_deinit() {
;	-----------------------------------------
;	 function SPI_deinit
;	-----------------------------------------
_SPI_deinit:
;	inc/spi_slave.h: 15: while (!(SPI_SR & SPI_SR_RXNE));
00101$:
	ld	a, 0x5203
	ld	xl, a
	srl	a
	jrnc	00101$
;	inc/spi_slave.h: 16: while (!(SPI_SR & SPI_SR_TXE));
	ld	a, xl
	and	a, #0x02
00104$:
	tnz	a
	jreq	00104$
;	inc/spi_slave.h: 17: while ((SPI_SR & SPI_SR_BSY));
	ld	a, xl
	and	a, #0x80
00107$:
	tnz	a
	jrne	00107$
;	inc/spi_slave.h: 18: SPI_CR1 &=~ SPI_CR1_SPE;
	bres	20992, #6
;	inc/spi_slave.h: 19: }
	ret
;	main.c: 9: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	main.c: 12: clk_init();
	call	_clk_init
;	main.c: 13: uart1_init();
	call	_uart1_init
;	main.c: 14: SPI_init();
	call	_SPI_init
;	main.c: 15: tx("start\n\r");
	push	#<___str_0
	push	#(___str_0 >> 8)
	call	_tx
	addw	sp, #2
;	main.c: 17: while (1) {
00105$:
;	main.c: 19: data=SPI_read();
	call	_SPI_read
;	main.c: 20: while (!(UART1_SR & UART1_SR_TXE)) {}
00101$:
	ld	a, 0x5230
	jrpl	00101$
;	main.c: 21: UART1_DR=data;
	ld	a, xl
	ld	0x5231, a
;	main.c: 22: SPI_write(data+1);
	incw	x
	pushw	x
	call	_SPI_write
	addw	sp, #2
	jra	00105$
;	main.c: 24: }
	ret
	.area CODE
	.area CONST
___str_0:
	.ascii "start"
	.db 0x0a
	.db 0x0d
	.db 0x00
	.area INITIALIZER
	.area CABS (ABS)
