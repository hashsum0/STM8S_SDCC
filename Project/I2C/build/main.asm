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
	.globl _i2c_read_byte
	.globl _i2c_write_byte
	.globl _i2c_init
	.globl _GPIO_init
	.globl _clk_init_HSI
	.globl _clk_init_HSE
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
;	inc/clk_init.h: 7: void clk_init_HSE(void){    
;	-----------------------------------------
;	 function clk_init_HSE
;	-----------------------------------------
_clk_init_HSE:
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
;	inc/clk_init.h: 16: }
	ret
;	inc/clk_init.h: 18: void clk_init_HSI()
;	-----------------------------------------
;	 function clk_init_HSI
;	-----------------------------------------
_clk_init_HSI:
;	inc/clk_init.h: 20: CLK_ICKR = 0; // Сбрасываем регистр внутреннего тактирования
	mov	0x50c0+0, #0x00
;	inc/clk_init.h: 21: CLK_ICKR|=(1<<0); // Включаем внутренний генератор HSI
	bset	20672, #0
;	inc/clk_init.h: 22: CLK_ECKR = 0; // Отключаем внешний генератор
	mov	0x50c1+0, #0x00
;	inc/clk_init.h: 23: while ((CLK_ICKR&(1<<1))== 0); // Ждём стабилизации внутреннего генератора
00101$:
	ld	a, 0x50c0
	bcp	a, #0x02
	jreq	00101$
;	inc/clk_init.h: 24: CLK_CKDIVR = 0; // Устанавливаем максимальную частоту
	mov	0x50c6+0, #0x00
;	inc/clk_init.h: 25: CLK_CCOR = 0; // Выключаем CCO.
	mov	0x50c9+0, #0x00
;	inc/clk_init.h: 26: CLK_HSITRIMR = 0; // Turn off any HSIU trimming.
	mov	0x50cc+0, #0x00
;	inc/clk_init.h: 27: CLK_SWIMCCR = 0; // Set SWIM to run at clock / 2.
	mov	0x50cd+0, #0x00
;	inc/clk_init.h: 28: CLK_SWR = 0xe1; // Используем HSI в качестве источника тактиров
	mov	0x50c4+0, #0xe1
;	inc/clk_init.h: 29: CLK_SWCR = 0; // Сброс флага переключения генераторов
	mov	0x50c5+0, #0x00
;	inc/clk_init.h: 30: CLK_SWCR= CLK_SWCR_SWEN; // Включаем переключение на HSI
	mov	0x50c5+0, #0x02
;	inc/clk_init.h: 31: while ((CLK_SWCR&(1<<0)) != 0); // Пауза, пока произойдёт переключение(CLK_SWCR_SWBSY != 0)
00104$:
	ld	a, 0x50c5
	srl	a
	jrc	00104$
;	inc/clk_init.h: 33: }
	ret
;	inc/gpio_init.h: 1: void GPIO_init(void)
;	-----------------------------------------
;	 function GPIO_init
;	-----------------------------------------
_GPIO_init:
;	inc/gpio_init.h: 4: PA_DDR = 0xFF;                                                        //_______PORT_IN
	mov	0x5002+0, #0xff
;	inc/gpio_init.h: 5: PA_CR1 = 0xFF;                                                       //_______DDR________________CR1______________CR2___________FUNCTION  
	mov	0x5003+0, #0xff
;	inc/gpio_init.h: 6: PA_CR2 = 0x00;                                                      //_______0__________________0________________0_____________bez podtiyzhki,bez prerbIvanii 
	mov	0x5004+0, #0x00
;	inc/gpio_init.h: 8: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
	mov	0x5007+0, #0x00
;	inc/gpio_init.h: 9: PB_CR1 = 0xff;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
	mov	0x5008+0, #0xff
;	inc/gpio_init.h: 10: PB_CR2 = 0x00;                                                      //_______PORT_OUT
	mov	0x5009+0, #0x00
;	inc/gpio_init.h: 12: PC_DDR = 0xFF;                                                        //_______1__________________0________________0_____________otkritiy stok
	mov	0x500c+0, #0xff
;	inc/gpio_init.h: 13: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
	mov	0x500d+0, #0xff
;	inc/gpio_init.h: 14: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
	mov	0x500e+0, #0x00
;	inc/gpio_init.h: 16: PD_DDR = 0xFF;   
	mov	0x5011+0, #0xff
;	inc/gpio_init.h: 17: PD_CR1 = 0xFF;  
	mov	0x5012+0, #0xff
;	inc/gpio_init.h: 18: PD_CR2 = 0x00; 
	mov	0x5013+0, #0x00
;	inc/gpio_init.h: 20: PE_DDR = 0xFF;   
	mov	0x5016+0, #0xff
;	inc/gpio_init.h: 21: PE_CR1 = 0xFF;  
	mov	0x5017+0, #0xff
;	inc/gpio_init.h: 22: PE_CR2 = 0x00; 
	mov	0x5018+0, #0x00
;	inc/gpio_init.h: 24: PF_DDR = 0xFF;   
	mov	0x501b+0, #0xff
;	inc/gpio_init.h: 25: PF_CR1 = 0xFF;  
	mov	0x501c+0, #0xff
;	inc/gpio_init.h: 26: PF_CR2 = 0x00; 
	mov	0x501d+0, #0x00
;	inc/gpio_init.h: 31: }
	ret
;	inc/i2c.h: 56: void i2c_init() {
;	-----------------------------------------
;	 function i2c_init
;	-----------------------------------------
_i2c_init:
;	inc/i2c.h: 57: I2C_FREQR |= (1 << 1);
	bset	21010, #1
;	inc/i2c.h: 58: I2C_CCRL = 0x0A; // 100kHz
	mov	0x521b+0, #0x0a
;	inc/i2c.h: 59: I2C_OARH |= (1 << 7); // 7-bit addressing
	bset	21012, #7
;	inc/i2c.h: 60: I2C_CR1 |= I2C_CR1_PE;
	bset	21008, #0
;	inc/i2c.h: 61: }
	ret
;	inc/i2c.h: 63: void i2c_write_byte(unsigned int addr_dev, unsigned int addr_mem, unsigned int data){
;	-----------------------------------------
;	 function i2c_write_byte
;	-----------------------------------------
_i2c_write_byte:
;	inc/i2c.h: 66: while ((I2C_SR3 & I2C_SR3_BUSY)); 
00101$:
	ld	a, 0x5219
	bcp	a, #0x02
	jrne	00101$
;	inc/i2c.h: 67: I2C_CR2 |= I2C_CR2_START;
	bset	21009, #0
;	inc/i2c.h: 68: while (!(I2C_SR1 & I2C_SR1_SB));   
00104$:
	ld	a, 0x5217
	srl	a
	jrnc	00104$
;	inc/i2c.h: 69: d=I2C_SR3;
	ldw	x, #0x5219
	ld	a, (x)
;	inc/i2c.h: 71: I2C_DR = addr_dev;                    
	ld	a, (0x04, sp)
	ld	0x5216, a
;	inc/i2c.h: 72: while (!(I2C_SR1 & I2C_SR1_ADDR));
00107$:
	ld	a, 0x5217
	bcp	a, #0x02
	jreq	00107$
;	inc/i2c.h: 73: d=I2C_SR3;
	ldw	x, #0x5219
	ld	a, (x)
;	inc/i2c.h: 74: I2C_CR2 |= (1 << I2C_CR2_ACK);
	bset	21009, #4
;	inc/i2c.h: 76: while (!(I2C_SR1 & I2C_SR1_TXE));
00110$:
	ld	a, 0x5217
	tnz	a
	jrpl	00110$
;	inc/i2c.h: 77: I2C_DR = addr_mem;
	ld	a, (0x06, sp)
	ld	0x5216, a
;	inc/i2c.h: 79: while (!(I2C_SR1 & I2C_SR1_TXE));
00113$:
	ld	a, 0x5217
	tnz	a
	jrpl	00113$
;	inc/i2c.h: 80: I2C_DR = data;
	ld	a, (0x08, sp)
	ld	0x5216, a
;	inc/i2c.h: 82: while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
00117$:
;	inc/i2c.h: 68: while (!(I2C_SR1 & I2C_SR1_SB));   
	ld	a, 0x5217
;	inc/i2c.h: 82: while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
	tnz	a
	jrmi	00119$
	bcp	a, #0x04
	jreq	00117$
00119$:
;	inc/i2c.h: 83: I2C_CR2 |= I2C_CR2_STOP;       
	bset	21009, #1
;	inc/i2c.h: 84: while (I2C_SR3 & I2C_SR3_MSL);
00120$:
	ld	a, 0x5219
	srl	a
	jrc	00120$
;	inc/i2c.h: 85: }
	ret
;	inc/i2c.h: 87: int i2c_read_byte(unsigned int addr_dev,unsigned int addr_mem){
;	-----------------------------------------
;	 function i2c_read_byte
;	-----------------------------------------
_i2c_read_byte:
;	inc/i2c.h: 90: while ((I2C_SR3 & I2C_SR3_BUSY));
00101$:
	ld	a, 0x5219
	bcp	a, #0x02
	jrne	00101$
;	inc/i2c.h: 91: I2C_CR2 |= I2C_CR2_START;
	bset	21009, #0
;	inc/i2c.h: 92: while (!(I2C_SR1 & I2C_SR1_SB));  
00104$:
	ld	a, 0x5217
	srl	a
	jrnc	00104$
;	inc/i2c.h: 93: d=I2C_SR3;
	ldw	x, #0x5219
	ld	a, (x)
;	inc/i2c.h: 95: I2C_DR = addr_dev;                    
	ld	a, (0x04, sp)
	ld	yl, a
	ldw	x, #0x5216
	ld	a, yl
	ld	(x), a
;	inc/i2c.h: 96: while (!(I2C_SR1 & I2C_SR1_ADDR));
00107$:
	ld	a, 0x5217
	bcp	a, #0x02
	jreq	00107$
;	inc/i2c.h: 97: d=I2C_SR3;
	ldw	x, #0x5219
	ld	a, (x)
;	inc/i2c.h: 99: while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
00111$:
;	inc/i2c.h: 92: while (!(I2C_SR1 & I2C_SR1_SB));  
	ld	a, 0x5217
;	inc/i2c.h: 99: while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
	tnz	a
	jrmi	00113$
	bcp	a, #0x04
	jreq	00111$
00113$:
;	inc/i2c.h: 100: I2C_DR = addr_mem;              
	ld	a, (0x06, sp)
	ld	0x5216, a
;	inc/i2c.h: 102: I2C_CR2 |=I2C_CR2_ACK;
	bset	21009, #2
;	inc/i2c.h: 103: I2C_CR2 |= I2C_CR2_START;
	bset	21009, #0
;	inc/i2c.h: 105: while (!(I2C_SR1 & I2C_SR1_SB));   
00114$:
	ld	a, 0x5217
	srl	a
	jrnc	00114$
;	inc/i2c.h: 106: d=I2C_SR3;
	ldw	x, #0x5219
	ld	a, (x)
;	inc/i2c.h: 107: I2C_DR = addr_dev+1;                    
	ld	a, yl
	inc	a
	ld	0x5216, a
;	inc/i2c.h: 108: while (!(I2C_SR1 & I2C_SR1_ADDR));
00117$:
	ld	a, 0x5217
	bcp	a, #0x02
	jreq	00117$
;	inc/i2c.h: 109: d=I2C_SR3;
	ldw	x, #0x5219
	ld	a, (x)
;	inc/i2c.h: 111: while (!(I2C_SR1 & I2C_SR1_RXNE));
00120$:
	ld	a, 0x5217
	bcp	a, #0x40
	jreq	00120$
;	inc/i2c.h: 112: d=I2C_DR;
	ld	a, 0x5216
	clrw	x
	ld	xl, a
;	inc/i2c.h: 113: I2C_CR2 &= ~I2C_CR2_ACK;
	bres	21009, #2
;	inc/i2c.h: 115: while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
00124$:
;	inc/i2c.h: 92: while (!(I2C_SR1 & I2C_SR1_SB));  
	ld	a, 0x5217
;	inc/i2c.h: 115: while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
	tnz	a
	jrmi	00126$
	bcp	a, #0x04
	jreq	00124$
00126$:
;	inc/i2c.h: 116: I2C_CR2 |= I2C_CR2_STOP;       
	bset	21009, #1
;	inc/i2c.h: 117: while (I2C_SR3 & I2C_SR3_MSL);
00127$:
	ld	a, 0x5219
	srl	a
	jrc	00127$
;	inc/i2c.h: 119: return d;
;	inc/i2c.h: 120: }
	ret
;	main.c: 7: void main(void){
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	main.c: 9: clk_init_HSI(); //16MHz
	call	_clk_init_HSI
;	main.c: 10: i2c_init();
	call	_i2c_init
;	main.c: 12: PC_DDR = 0xFF;                                                    
	mov	0x500c+0, #0xff
;	main.c: 13: PC_CR1 = 0xFF;                                                      
	mov	0x500d+0, #0xff
;	main.c: 14: PC_CR2 = 0x00;
	mov	0x500e+0, #0x00
;	main.c: 15: while(1){
00108$:
;	main.c: 16: i2c_write_byte(0xA0, 0x01, 0x0C);
	push	#0x0c
	push	#0x00
	push	#0x01
	push	#0x00
	push	#0xa0
	push	#0x00
	call	_i2c_write_byte
	addw	sp, #6
;	main.c: 18: while(t--);
	ldw	x, #0x61a8
00101$:
	ldw	y, x
	decw	x
	tnzw	y
	jrne	00101$
;	main.c: 19: data=i2c_read_byte(0xA0,0x01);
	push	#0x01
	push	#0x00
	push	#0xa0
	push	#0x00
	call	_i2c_read_byte
	addw	sp, #4
	ld	a, xl
;	main.c: 20: PC_ODR =0;
	mov	0x500a+0, #0x00
;	main.c: 21: PC_ODR =data;
	ld	0x500a, a
;	main.c: 23: while(t--);
	ldw	x, #0x61a8
00104$:
	ldw	y, x
	decw	x
	tnzw	y
	jreq	00108$
	jra	00104$
;	main.c: 27: }
	ret
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
