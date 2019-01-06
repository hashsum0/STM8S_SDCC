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
	.globl _delay
	.globl _SPI_deinit
	.globl _chip_deselect
	.globl _chip_select
	.globl _SPI_read
	.globl _SPI_write
	.globl _SPI_init
	.globl _rx
	.globl _tx
	.globl _uart1_init
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
;	inc/spi_master.h: 2: void SPI_init() {
;	-----------------------------------------
;	 function SPI_init
;	-----------------------------------------
_SPI_init:
;	inc/spi_master.h: 4: PC_DDR |= (1 << CS_PIN);
	bset	20492, #4
;	inc/spi_master.h: 5: PC_CR1 |= (1 << CS_PIN);
	bset	20493, #4
;	inc/spi_master.h: 6: PC_ODR |= (1 << CS_PIN);
	bset	20490, #4
;	inc/spi_master.h: 8: SPI_CR2 = SPI_CR2_SSM | SPI_CR2_SSI;//без этой настройки требуется подключить вывод NSS к VDD
	mov	0x5201+0, #0x03
;	inc/spi_master.h: 9: SPI_CR1 = SPI_CR1_MSTR | SPI_CR1_SPE | SPI_CR1_BR0;// | SPI_CR1_BR2;//??????SPI_CR1_BR(0)???????
	mov	0x5200+0, #0x4c
;	inc/spi_master.h: 11: }
	ret
;	inc/spi_master.h: 13: void SPI_write(int data) {
;	-----------------------------------------
;	 function SPI_write
;	-----------------------------------------
_SPI_write:
;	inc/spi_master.h: 14: SPI_DR = data;
	ld	a, (0x04, sp)
	ld	0x5204, a
;	inc/spi_master.h: 15: while (!(SPI_SR & SPI_SR_TXE));
00101$:
	ld	a, 0x5203
	bcp	a, #0x02
	jreq	00101$
;	inc/spi_master.h: 16: }
	ret
;	inc/spi_master.h: 17: int SPI_read() {
;	-----------------------------------------
;	 function SPI_read
;	-----------------------------------------
_SPI_read:
;	inc/spi_master.h: 18: SPI_write(0xFF);
	push	#0xff
	push	#0x00
	call	_SPI_write
	addw	sp, #2
;	inc/spi_master.h: 19: while (!(SPI_SR & SPI_SR_RXNE));
00101$:
	ld	a, 0x5203
	srl	a
	jrnc	00101$
;	inc/spi_master.h: 20: return SPI_DR;
	ld	a, 0x5204
	clrw	x
	ld	xl, a
;	inc/spi_master.h: 21: }
	ret
;	inc/spi_master.h: 22: void chip_select() {
;	-----------------------------------------
;	 function chip_select
;	-----------------------------------------
_chip_select:
;	inc/spi_master.h: 23: PC_ODR &= ~(1 << CS_PIN);
	bres	20490, #4
;	inc/spi_master.h: 24: }
	ret
;	inc/spi_master.h: 25: void chip_deselect() {
;	-----------------------------------------
;	 function chip_deselect
;	-----------------------------------------
_chip_deselect:
;	inc/spi_master.h: 26: while ((SPI_SR & SPI_SR_BSY));
00101$:
	ld	a, 0x5203
	jrmi	00101$
;	inc/spi_master.h: 27: PC_ODR |= (1 << CS_PIN);
	bset	20490, #4
;	inc/spi_master.h: 28: }
	ret
;	inc/spi_master.h: 29: void SPI_deinit() {
;	-----------------------------------------
;	 function SPI_deinit
;	-----------------------------------------
_SPI_deinit:
;	inc/spi_master.h: 30: while (!(SPI_SR & SPI_SR_RXNE));
00101$:
	ld	a, 0x5203
	ld	xl, a
	srl	a
	jrnc	00101$
;	inc/spi_master.h: 31: while (!(SPI_SR & SPI_SR_TXE));
	ld	a, xl
	and	a, #0x02
00104$:
	tnz	a
	jreq	00104$
;	inc/spi_master.h: 32: while ((SPI_SR & SPI_SR_BSY));
	ld	a, xl
	and	a, #0x80
00107$:
	tnz	a
	jrne	00107$
;	inc/spi_master.h: 33: SPI_CR1 &=~ SPI_CR1_SPE;
	bres	20992, #6
;	inc/spi_master.h: 34: }
	ret
;	main.c: 8: void delay(int t)
;	-----------------------------------------
;	 function delay
;	-----------------------------------------
_delay:
	sub	sp, #2
;	main.c: 11: for(i=0;i<t;i++)
	clrw	x
00107$:
	cpw	x, (0x05, sp)
	jrsge	00109$
;	main.c: 13: for(s=0;s<512;s++)
	clr	(0x02, sp)
	ld	a, #0x02
	ld	(0x01, sp), a
00105$:
	ldw	y, (0x01, sp)
	decw	y
	ldw	(0x01, sp), y
	tnzw	y
	jrne	00105$
;	main.c: 11: for(i=0;i<t;i++)
	incw	x
	jra	00107$
00109$:
;	main.c: 17: }
	addw	sp, #2
	ret
;	main.c: 19: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #2
;	main.c: 21: clk_init();
	call	_clk_init
;	main.c: 22: uart1_init();
	call	_uart1_init
;	main.c: 25: SPI_init();
	call	_SPI_init
;	main.c: 26: while (1) {
00105$:
;	main.c: 27: chip_select();
	call	_chip_select
;	main.c: 29: res=SPI_read();
	call	_SPI_read
	ldw	(0x01, sp), x
;	main.c: 30: chip_deselect();
	call	_chip_deselect
;	main.c: 31: while (!(UART1_SR & UART1_SR_TXE)) {}
00101$:
	ld	a, 0x5230
	jrpl	00101$
;	main.c: 32: UART1_DR=res;
	ld	a, (0x02, sp)
	ld	0x5231, a
;	main.c: 33: delay(50);
	push	#0x32
	push	#0x00
	call	_delay
	addw	sp, #2
	jra	00105$
;	main.c: 35: }
	addw	sp, #2
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
