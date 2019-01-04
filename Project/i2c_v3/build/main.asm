;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.9 #10207 (Linux)
;--------------------------------------------------------
	.module main
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _i2c_stop
	.globl _i2c_read
	.globl _i2c_write_data
	.globl _i2c_write_addr_mem
	.globl _i2c_write_addr_dev
	.globl _i2c_start
	.globl _i2c_init
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
;	inc/i2c.h: 29: void i2c_init() {
;	-----------------------------------------
;	 function i2c_init
;	-----------------------------------------
_i2c_init:
;	inc/i2c.h: 31: cli(I2C_CR1,I2C_CR1_PE);
	bres	21008, #0
;	inc/i2c.h: 32: I2C_FREQR = F_MASTER;
	mov	0x5212+0, #0x10
;	inc/i2c.h: 38: I2C_CCRH = I2C_CCRH_16MHZ_STD_100;     // 0x00 
	mov	0x521c+0, #0x00
;	inc/i2c.h: 39: I2C_CCRL = I2C_CCRL_16MHZ_STD_100;     // 0x50
	mov	0x521b+0, #0x50
;	inc/i2c.h: 45: I2C_TRISER = I2C_TRISER_16MHZ_STD_100; // 0x11
	mov	0x521d+0, #0x0b
;	inc/i2c.h: 46: set(I2C_OARH,I2C_OARH_ADDCONF);          //Must always be written as 1 
	bset	21012, #6
;	inc/i2c.h: 47: cli(I2C_OARH,I2C_OARH_ADDMODE);         // 7-bit slave address
	bres	21012, #7
;	inc/i2c.h: 48: set(I2C_CR1,I2C_CR1_PE);
	bset	21008, #0
;	inc/i2c.h: 50: }
	ret
;	inc/i2c.h: 52: void i2c_start() {
;	-----------------------------------------
;	 function i2c_start
;	-----------------------------------------
_i2c_start:
;	inc/i2c.h: 53: set(I2C_CR2,I2C_CR2_ACK);
	bset	21009, #2
;	inc/i2c.h: 54: while(check(I2C_SR3, I2C_SR3_BUSY));
00101$:
	ld	a, 0x5219
	bcp	a, #0x02
	jrne	00101$
;	inc/i2c.h: 55: set(I2C_CR2,I2C_CR2_START);
	bset	21009, #0
;	inc/i2c.h: 56: while(!check(I2C_SR1, I2C_SR1_SB));
00104$:
	ld	a, 0x5217
	srl	a
	jrnc	00104$
;	inc/i2c.h: 58: }
	ret
;	inc/i2c.h: 60: void i2c_write_addr_dev(unsigned char d_addr) {
;	-----------------------------------------
;	 function i2c_write_addr_dev
;	-----------------------------------------
_i2c_write_addr_dev:
;	inc/i2c.h: 62: I2C_DR = d_addr;
	ldw	x, #0x5216
	ld	a, (0x03, sp)
	ld	(x), a
;	inc/i2c.h: 63: while (!check(I2C_SR1, I2C_SR1_ADDR));
00101$:
	ld	a, 0x5217
	bcp	a, #0x02
	jreq	00101$
;	inc/i2c.h: 64: I2C_SR3;
	ldw	x, #0x5219
	ld	a, (x)
;	inc/i2c.h: 65: }
	ret
;	inc/i2c.h: 67: void i2c_write_addr_mem(unsigned char m_addr) {
;	-----------------------------------------
;	 function i2c_write_addr_mem
;	-----------------------------------------
_i2c_write_addr_mem:
;	inc/i2c.h: 69: I2C_DR = m_addr;
	ldw	x, #0x5216
	ld	a, (0x03, sp)
	ld	(x), a
;	inc/i2c.h: 70: while (!check(I2C_SR1, I2C_SR1_TXE));
00101$:
	ld	a, 0x5217
	tnz	a
	jrpl	00101$
;	inc/i2c.h: 71: I2C_SR3;
	ldw	x, #0x5219
	ld	a, (x)
;	inc/i2c.h: 72: }
	ret
;	inc/i2c.h: 74: void i2c_write_data(unsigned char data) {
;	-----------------------------------------
;	 function i2c_write_data
;	-----------------------------------------
_i2c_write_data:
;	inc/i2c.h: 76: I2C_DR = data;
	ldw	x, #0x5216
	ld	a, (0x03, sp)
	ld	(x), a
;	inc/i2c.h: 77: while (!check(I2C_SR1, I2C_SR1_TXE));
00101$:
	ld	a, 0x5217
	tnz	a
	jrpl	00101$
;	inc/i2c.h: 78: I2C_SR3;
	ldw	x, #0x5219
	ld	a, (x)
;	inc/i2c.h: 79: }
	ret
;	inc/i2c.h: 81: unsigned char i2c_read(unsigned char addr) {
;	-----------------------------------------
;	 function i2c_read
;	-----------------------------------------
_i2c_read:
;	inc/i2c.h: 83: set(I2C_CR2,I2C_CR2_START);
	bset	21009, #0
;	inc/i2c.h: 84: while(!check(I2C_SR1, I2C_SR1_SB));
00101$:
	ld	a, 0x5217
	srl	a
	jrnc	00101$
;	inc/i2c.h: 87: I2C_DR = addr+1;
	ld	a, (0x03, sp)
	inc	a
	ld	0x5216, a
;	inc/i2c.h: 88: while (!check(I2C_SR1,I2C_SR1_ADDR));
00104$:
	ld	a, 0x5217
	bcp	a, #0x02
	jreq	00104$
;	inc/i2c.h: 89: I2C_SR3;
	ldw	x, #0x5219
	ld	a, (x)
;	inc/i2c.h: 91: cli(I2C_CR2,I2C_CR2_ACK);
	bres	21009, #2
;	inc/i2c.h: 92: set(I2C_CR2,I2C_CR2_STOP);
	bset	21009, #1
;	inc/i2c.h: 94: while (!check(I2C_SR1,I2C_SR1_RXNE));
00107$:
	ld	a, 0x5217
	bcp	a, #0x40
	jreq	00107$
;	inc/i2c.h: 95: return I2C_DR;
	ld	a, 0x5216
;	inc/i2c.h: 96: }
	ret
;	inc/i2c.h: 98: void i2c_stop() {
;	-----------------------------------------
;	 function i2c_stop
;	-----------------------------------------
_i2c_stop:
;	inc/i2c.h: 99: set(I2C_CR2,I2C_CR2_STOP);
	bset	21009, #1
;	inc/i2c.h: 100: while (check(I2C_SR3,I2C_SR3_MSL));
00101$:
	ld	a, 0x5219
	srl	a
	jrc	00101$
;	inc/i2c.h: 101: }
	ret
;	main.c: 7: void main(void){
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	main.c: 9: CLK_ICKR = 0; // Сбрасываем регистр внутреннего тактирования
	mov	0x50c0+0, #0x00
;	main.c: 10: CLK_ICKR|=(1<<0); // Включаем внутренний генератор HSI
	bset	20672, #0
;	main.c: 11: CLK_ECKR = 0; // Отключаем внешний генератор
	mov	0x50c1+0, #0x00
;	main.c: 12: while ((CLK_ICKR&(1<<1))== 0); // Ждём стабилизации внутреннего генератора
00101$:
	ld	a, 0x50c0
	bcp	a, #0x02
	jreq	00101$
;	main.c: 13: CLK_CKDIVR = 0; // Устанавливаем максимальную частоту
	mov	0x50c6+0, #0x00
;	main.c: 14: CLK_CCOR = 0; // Выключаем CCO.
	mov	0x50c9+0, #0x00
;	main.c: 15: CLK_HSITRIMR = 0; // Turn off any HSIU trimming.
	mov	0x50cc+0, #0x00
;	main.c: 16: CLK_SWIMCCR = 0; // Set SWIM to run at clock / 2.
	mov	0x50cd+0, #0x00
;	main.c: 17: CLK_SWR = 0xe1; // Используем HSI в качестве источника тактиров
	mov	0x50c4+0, #0xe1
;	main.c: 18: CLK_SWCR = 0; // Сброс флага переключения генераторов
	mov	0x50c5+0, #0x00
;	main.c: 19: CLK_SWCR = (1<<1); // Включаем переключение на HSI
	mov	0x50c5+0, #0x02
;	main.c: 20: while ((CLK_SWCR&(1<<0)) != 0); // Пауза, пока произойдёт переключение(CLK_SWCR_SWBSY != 0)
00104$:
	ld	a, 0x50c5
	srl	a
	jrc	00104$
;	main.c: 21: PC_DDR=0xFF;
	mov	0x500c+0, #0xff
;	main.c: 22: PC_CR1=0xFF;
	mov	0x500d+0, #0xff
;	main.c: 23: PC_ODR=0x00;
	mov	0x500a+0, #0x00
;	main.c: 24: i2c_init();
	call	_i2c_init
;	main.c: 26: while(1){
00111$:
;	main.c: 27: i2c_start();    
	call	_i2c_start
;	main.c: 28: i2c_write_addr_dev(0xA0);
	push	#0xa0
	call	_i2c_write_addr_dev
	pop	a
;	main.c: 29: i2c_write_addr_mem(0x01);
	push	#0x01
	call	_i2c_write_addr_mem
	pop	a
;	main.c: 30: i2c_write_data(0xcc);
	push	#0xcc
	call	_i2c_write_data
	pop	a
;	main.c: 31: i2c_stop();
	call	_i2c_stop
;	main.c: 33: while(t--);
	ldw	x, #0x1388
00107$:
	ldw	y, x
	decw	x
	tnzw	y
	jrne	00107$
;	main.c: 34: i2c_start();
	call	_i2c_start
;	main.c: 35: i2c_write_addr_dev(0xA0);
	push	#0xa0
	call	_i2c_write_addr_dev
	pop	a
;	main.c: 36: i2c_write_addr_mem(0x01);
	push	#0x01
	call	_i2c_write_addr_mem
	pop	a
;	main.c: 37: data=i2c_read(0xA0);
	push	#0xa0
	call	_i2c_read
	addw	sp, #1
	exg	a, xl
	clr	a
	exg	a, xl
;	main.c: 38: PC_ODR=data;
	ld	0x500a, a
	jra	00111$
;	main.c: 42: }
	ret
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
