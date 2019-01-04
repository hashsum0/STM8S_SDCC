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
	.globl _i2c_read_arr
	.globl _i2c_read
	.globl _i2c_write_addr
	.globl _i2c_write
	.globl _i2c_stop
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
;	inc/i2c.h: 4: void i2c_init() {
;	-----------------------------------------
;	 function i2c_init
;	-----------------------------------------
_i2c_init:
;	inc/i2c.h: 5: I2C_FREQR = (1 << I2C_FREQR_FREQ1);
	mov	0x5212+0, #0x02
;	inc/i2c.h: 6: I2C_CCRL = 0x0A; // 100kHz
	mov	0x521b+0, #0x0a
;	inc/i2c.h: 7: I2C_OARH = (1 << I2C_OARH_ADDMODE); // 7-bit addressing
	mov	0x5214+0, #0x80
;	inc/i2c.h: 8: I2C_CR1 = (1 << I2C_CR1_PE);
	mov	0x5210+0, #0x01
;	inc/i2c.h: 9: }
	ret
;	inc/i2c.h: 11: void i2c_start() {
;	-----------------------------------------
;	 function i2c_start
;	-----------------------------------------
_i2c_start:
;	inc/i2c.h: 12: I2C_CR2 |= (1 << I2C_CR2_START);
	bset	21009, #0
;	inc/i2c.h: 13: while (!(I2C_SR1 & (1 << I2C_SR1_SB)));
00101$:
	ld	a, 0x5217
	srl	a
	jrnc	00101$
;	inc/i2c.h: 14: }
	ret
;	inc/i2c.h: 16: void i2c_stop() {
;	-----------------------------------------
;	 function i2c_stop
;	-----------------------------------------
_i2c_stop:
;	inc/i2c.h: 17: I2C_CR2 |= (1 << I2C_CR2_STOP);
	bset	21009, #1
;	inc/i2c.h: 18: while (I2C_SR3 & (1 << I2C_SR3_MSL));
00101$:
	ld	a, 0x5219
	srl	a
	jrc	00101$
;	inc/i2c.h: 19: }
	ret
;	inc/i2c.h: 21: void i2c_write(uint8_t data) {
;	-----------------------------------------
;	 function i2c_write
;	-----------------------------------------
_i2c_write:
;	inc/i2c.h: 22: I2C_DR = data;
	ldw	x, #0x5216
	ld	a, (0x03, sp)
	ld	(x), a
;	inc/i2c.h: 23: while (!(I2C_SR1 & (1 << I2C_SR1_TXE)));
00101$:
	ld	a, 0x5217
	tnz	a
	jrpl	00101$
;	inc/i2c.h: 24: }
	ret
;	inc/i2c.h: 26: void i2c_write_addr(uint8_t addr) {
;	-----------------------------------------
;	 function i2c_write_addr
;	-----------------------------------------
_i2c_write_addr:
;	inc/i2c.h: 27: I2C_DR = addr;
	ldw	x, #0x5216
	ld	a, (0x03, sp)
	ld	(x), a
;	inc/i2c.h: 28: while (!(I2C_SR1 & (1 << I2C_SR1_ADDR)));
00101$:
	ld	a, 0x5217
	bcp	a, #0x02
	jreq	00101$
;	inc/i2c.h: 29: (void) I2C_SR3; // check BUS_BUSY
	ldw	x, #0x5219
	ld	a, (x)
;	inc/i2c.h: 30: I2C_CR2 |= (1 << I2C_CR2_ACK);
	bset	21009, #2
;	inc/i2c.h: 31: }
	ret
;	inc/i2c.h: 33: uint8_t i2c_read() {
;	-----------------------------------------
;	 function i2c_read
;	-----------------------------------------
_i2c_read:
;	inc/i2c.h: 34: I2C_CR2 &= ~(1 << I2C_CR2_ACK);
	bres	21009, #2
;	inc/i2c.h: 35: i2c_stop();
	call	_i2c_stop
;	inc/i2c.h: 36: while (!(I2C_SR1 & (1 << I2C_SR1_RXNE)));
00101$:
	ld	a, 0x5217
	bcp	a, #0x40
	jreq	00101$
;	inc/i2c.h: 37: return I2C_DR;
	ld	a, 0x5216
;	inc/i2c.h: 38: }
	ret
;	inc/i2c.h: 40: void i2c_read_arr(uint8_t *buf, int len) {
;	-----------------------------------------
;	 function i2c_read_arr
;	-----------------------------------------
_i2c_read_arr:
	sub	sp, #2
;	inc/i2c.h: 41: while (len-- > 1) {
	ldw	x, (0x05, sp)
	ldw	y, (0x07, sp)
00104$:
	ldw	(0x01, sp), y
	decw	y
	pushw	x
	ldw	x, (0x03, sp)
	cpw	x, #0x0001
	popw	x
	jrsle	00106$
;	inc/i2c.h: 42: I2C_CR2 |= (1 << I2C_CR2_ACK);
	bset	21009, #2
;	inc/i2c.h: 43: while (!(I2C_SR1 & (1 << I2C_SR1_RXNE)));
00101$:
	ld	a, 0x5217
	bcp	a, #0x40
	jreq	00101$
;	inc/i2c.h: 44: *(buf++) = I2C_DR;
	ld	a, 0x5216
	ld	(x), a
	incw	x
	jra	00104$
00106$:
;	inc/i2c.h: 46: *buf = i2c_read();
	pushw	x
	call	_i2c_read
	popw	x
	ld	(x), a
;	inc/i2c.h: 47: }
	addw	sp, #2
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
;	main.c: 22: i2c_init();
	call	_i2c_init
;	main.c: 24: while(1){
00111$:
;	main.c: 25: i2c_start();    
	call	_i2c_start
;	main.c: 26: i2c_write_addr(0xA0);
	push	#0xa0
	call	_i2c_write_addr
	pop	a
;	main.c: 28: i2c_write(0x01);
	push	#0x01
	call	_i2c_write
	pop	a
;	main.c: 30: i2c_write(0x99);
	push	#0x99
	call	_i2c_write
	pop	a
;	main.c: 31: i2c_stop();
	call	_i2c_stop
;	main.c: 33: while(t--);
	ldw	x, #0x1388
00107$:
	ldw	y, x
	decw	x
	tnzw	y
	jreq	00111$
	jra	00107$
;	main.c: 38: }
	ret
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
