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
;	main.c: 6: void SPI_init() {
;	-----------------------------------------
;	 function SPI_init
;	-----------------------------------------
_SPI_init:
;	main.c: 8: PC_DDR |= (1 << CS_PIN);
	bset	20492, #4
;	main.c: 9: PC_CR1 |= (1 << CS_PIN);
	bset	20493, #4
;	main.c: 10: PC_ODR |= (1 << CS_PIN);
	bset	20490, #4
;	main.c: 12: SPI_CR2 = SPI_CR2_SSM | SPI_CR2_SSI;//без этой настройки требуется подключить вывод NSS к VDD
	mov	0x5201+0, #0x03
;	main.c: 13: SPI_CR1 = SPI_CR1_MSTR | SPI_CR1_SPE | SPI_CR1_BR0;// | SPI_CR1_BR2;//??????SPI_CR1_BR(0)???????
	mov	0x5200+0, #0x4c
;	main.c: 15: }
	ret
;	main.c: 17: void SPI_write(int data) {
;	-----------------------------------------
;	 function SPI_write
;	-----------------------------------------
_SPI_write:
;	main.c: 18: SPI_DR = data;
	ld	a, (0x04, sp)
	ld	0x5204, a
;	main.c: 19: while (!(SPI_SR & SPI_SR_TXE));
00101$:
	ld	a, 0x5203
	bcp	a, #0x02
	jreq	00101$
;	main.c: 20: }
	ret
;	main.c: 21: int SPI_read() {
;	-----------------------------------------
;	 function SPI_read
;	-----------------------------------------
_SPI_read:
;	main.c: 22: SPI_write(0xFF);
	push	#0xff
	push	#0x00
	call	_SPI_write
	addw	sp, #2
;	main.c: 23: while (!(SPI_SR & SPI_SR_RXNE));
00101$:
	ld	a, 0x5203
	srl	a
	jrnc	00101$
;	main.c: 24: return SPI_DR;
	ld	a, 0x5204
	clrw	x
	ld	xl, a
;	main.c: 25: }
	ret
;	main.c: 26: void chip_select() {
;	-----------------------------------------
;	 function chip_select
;	-----------------------------------------
_chip_select:
;	main.c: 27: PC_ODR &= ~(1 << CS_PIN);
	bres	20490, #4
;	main.c: 28: }
	ret
;	main.c: 29: void chip_deselect() {
;	-----------------------------------------
;	 function chip_deselect
;	-----------------------------------------
_chip_deselect:
;	main.c: 30: while ((SPI_SR & SPI_SR_BSY));
00101$:
	ld	a, 0x5203
	jrmi	00101$
;	main.c: 31: PC_ODR |= (1 << CS_PIN);
	bset	20490, #4
;	main.c: 32: }
	ret
;	main.c: 33: void SPI_deinit() {
;	-----------------------------------------
;	 function SPI_deinit
;	-----------------------------------------
_SPI_deinit:
;	main.c: 34: while (!(SPI_SR & SPI_SR_RXNE));
00101$:
	ld	a, 0x5203
	ld	xl, a
	srl	a
	jrnc	00101$
;	main.c: 35: while (!(SPI_SR & SPI_SR_TXE));
	ld	a, xl
	and	a, #0x02
00104$:
	tnz	a
	jreq	00104$
;	main.c: 36: while ((SPI_SR & SPI_SR_BSY));
	ld	a, xl
	and	a, #0x80
00107$:
	tnz	a
	jrne	00107$
;	main.c: 37: SPI_CR1 &=~ SPI_CR1_SPE;
	bres	20992, #6
;	main.c: 38: }
	ret
;	main.c: 39: void delay(int t)
;	-----------------------------------------
;	 function delay
;	-----------------------------------------
_delay:
	sub	sp, #2
;	main.c: 42: for(i=0;i<t;i++)
	clrw	x
00107$:
	cpw	x, (0x05, sp)
	jrsge	00109$
;	main.c: 44: for(s=0;s<512;s++)
	clr	(0x02, sp)
	ld	a, #0x02
	ld	(0x01, sp), a
00105$:
	ldw	y, (0x01, sp)
	decw	y
	ldw	(0x01, sp), y
	tnzw	y
	jrne	00105$
;	main.c: 42: for(i=0;i<t;i++)
	incw	x
	jra	00107$
00109$:
;	main.c: 48: }
	addw	sp, #2
	ret
;	main.c: 50: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #16
;	main.c: 52: clk_init();
	call	_clk_init
;	main.c: 53: GPIO_init();
	call	_GPIO_init
;	main.c: 54: int data[]={'t','e','s','t','\n','\r'};
	ldw	x, sp
	incw	x
	ldw	(0x0d, sp), x
	ldw	y, #0x0074
	ldw	(x), y
	ldw	x, (0x0d, sp)
	ldw	y, #0x0065
	ldw	(0x02, x), y
	ldw	x, (0x0d, sp)
	ldw	y, #0x0073
	ldw	(0x0004, x), y
	ldw	x, (0x0d, sp)
	ldw	y, #0x0074
	ldw	(0x0006, x), y
	ldw	x, (0x0d, sp)
	ldw	y, #0x000a
	ldw	(0x0008, x), y
	ldw	x, (0x0d, sp)
	addw	x, #0x000a
	ldw	y, #0x000d
	ldw	(x), y
;	main.c: 55: PC_DDR |= (1 << CS_PIN);
	bset	20492, #4
;	main.c: 56: PC_CR1 |= (1 << CS_PIN);
	bset	20493, #4
;	main.c: 57: PC_ODR |= (1 << CS_PIN);
	bset	20490, #4
;	main.c: 59: SPI_init();
	call	_SPI_init
;	main.c: 60: PD_ODR|=(1<<0);
	ld	a, 0x500f
	or	a, #0x01
	ld	0x500f, a
;	main.c: 61: while (1) {
00103$:
;	main.c: 62: chip_select();
	call	_chip_select
;	main.c: 63: for(int i=0;i<6;i++){
	clrw	x
	ldw	(0x0f, sp), x
00106$:
	ldw	x, (0x0f, sp)
	cpw	x, #0x0006
	jrsge	00101$
;	main.c: 64: SPI_write(data[i]);
	ldw	x, (0x0f, sp)
	sllw	x
	addw	x, (0x0d, sp)
	ldw	x, (x)
	pushw	x
	call	_SPI_write
	addw	sp, #2
;	main.c: 65: delay(1);
	push	#0x01
	push	#0x00
	call	_delay
	addw	sp, #2
;	main.c: 63: for(int i=0;i<6;i++){
	ldw	x, (0x0f, sp)
	incw	x
	ldw	(0x0f, sp), x
	jra	00106$
00101$:
;	main.c: 67: chip_deselect();
	call	_chip_deselect
;	main.c: 68: delay(500);
	push	#0xf4
	push	#0x01
	call	_delay
	addw	sp, #2
;	main.c: 69: PD_ODR &=~ (1<<0);
	ld	a, 0x500f
	and	a, #0xfe
	ld	0x500f, a
	jra	00103$
;	main.c: 71: }
	addw	sp, #16
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
