;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.4 #9794 (Linux)
;--------------------------------------------------------
	.module main
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _delay
	.globl _ADC_read0
	.globl _ADC_INIT
	.globl __delay_ms
	.globl _GPIO_init
	.globl _clk_init_HSI
	.globl _clk_init_HSE
	.globl _LCD_enable
	.globl _LCD_command
	.globl _LCD_putc
	.globl _LCD_puts
	.globl _LCD_init
	.globl _shiftL
	.globl _shiftR
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
	int s_GSINIT ;reset
	int 0x0000 ;trap
	int 0x0000 ;int0
	int 0x0000 ;int1
	int 0x0000 ;int2
	int 0x0000 ;int3
	int 0x0000 ;int4
	int 0x0000 ;int5
	int 0x0000 ;int6
	int 0x0000 ;int7
	int 0x0000 ;int8
	int 0x0000 ;int9
	int 0x0000 ;int10
	int 0x0000 ;int11
	int 0x0000 ;int12
	int 0x0000 ;int13
	int 0x0000 ;int14
	int 0x0000 ;int15
	int 0x0000 ;int16
	int 0x0000 ;int17
	int 0x0000 ;int18
	int 0x0000 ;int19
	int 0x0000 ;int20
	int 0x0000 ;int21
	int 0x0000 ;int22
	int 0x0000 ;int23
	int 0x0000 ;int24
	int 0x0000 ;int25
	int 0x0000 ;int26
	int 0x0000 ;int27
	int 0x0000 ;int28
	int 0x0000 ;int29
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
	bset	0x50c1, #0
;	inc/clk_init.h: 9: CLK_SWCR|=CLK_SWCR_SWEN;               
	ldw	x, #0x50c5
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
;	inc/clk_init.h: 10: while((CLK_ECKR & CLK_ECKR_HSERDY) == 0) {} 
00101$:
	ldw	x, #0x50c1
	ld	a, (x)
	bcp	a, #0x02
	jreq	00101$
;	inc/clk_init.h: 11: CLK_CKDIVR = 0;                    
	mov	0x50c6+0, #0x00
;	inc/clk_init.h: 12: CLK_SWR = 0xB4;                    
	mov	0x50c4+0, #0xb4
;	inc/clk_init.h: 13: while ((CLK_SWCR & CLK_SWCR_SWIF) == 0){}
00104$:
	ldw	x, #0x50c5
	ld	a, (x)
	bcp	a, #0x08
	jreq	00104$
;	inc/clk_init.h: 14: CLK_CSSR|=CLK_CSSR_CSSEN;
	bset	0x50c8, #0
;	inc/clk_init.h: 15: CLK_CCOR|=(1<<2)|(1<<0);
	ldw	x, #0x50c9
	ld	a, (x)
	or	a, #0x05
	ld	(x), a
	ret
;	inc/clk_init.h: 18: void clk_init_HSI()
;	-----------------------------------------
;	 function clk_init_HSI
;	-----------------------------------------
_clk_init_HSI:
;	inc/clk_init.h: 20: CLK_ICKR = 0; // Сбрасываем регистр внутреннего тактирования
	mov	0x50c0+0, #0x00
;	inc/clk_init.h: 21: CLK_ICKR|=(1<<0); // Включаем внутренний генератор HSI
	bset	0x50c0, #0
;	inc/clk_init.h: 22: CLK_ECKR = 0; // Отключаем внешний генератор
	mov	0x50c1+0, #0x00
;	inc/clk_init.h: 23: while ((CLK_ICKR&(1<<1))== 0); // Ждём стабилизации внутреннего генератора
00101$:
	ldw	x, #0x50c0
	ld	a, (x)
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
	ldw	x, #0x50c5
	ld	a, (x)
	srl	a
	jrc	00104$
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
;	inc/gpio_init.h: 10: PB_CR2 = 0xff;                                                      //_______PORT_OUT
	mov	0x5009+0, #0xff
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
	ret
;	inc/LCDv2.h: 26: void _delay_ms(int t)
;	-----------------------------------------
;	 function _delay_ms
;	-----------------------------------------
__delay_ms:
	sub	sp, #2
;	inc/LCDv2.h: 29: for(i=0;i<t;i++)
	clrw	x
00107$:
	cpw	x, (0x05, sp)
	jrsge	00109$
;	inc/LCDv2.h: 31: for(s=0;s<1512;s++)
	ldw	y, #0x05e8
	ldw	(0x01, sp), y
00105$:
	ldw	y, (0x01, sp)
	decw	y
	ldw	(0x01, sp), y
	tnzw	y
	jrne	00105$
;	inc/LCDv2.h: 29: for(i=0;i<t;i++)
	incw	x
	jra	00107$
00109$:
	addw	sp, #2
	ret
;	inc/LCDv2.h: 37: void LCD_enable(void)
;	-----------------------------------------
;	 function LCD_enable
;	-----------------------------------------
_LCD_enable:
;	inc/LCDv2.h: 39: lcden0; /* Clear bit P2.4 */
	ldw	x, #0x500f
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
;	inc/LCDv2.h: 40: _delay_ms(min);
	push	#0x05
	push	#0x00
	call	__delay_ms
	addw	sp, #2
;	inc/LCDv2.h: 41: lcden1; /* Set bit P2.4 */
	ldw	x, #0x500f
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
	ret
;	inc/LCDv2.h: 44: void LCD_command(unsigned char command)
;	-----------------------------------------
;	 function LCD_command
;	-----------------------------------------
_LCD_command:
	sub	sp, #2
;	inc/LCDv2.h: 46: lcdrs0; /* Clear bit P2.5 */
	ldw	x, #0x500f
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
;	inc/LCDv2.h: 47: PORTData = (PORTData & 0x0f)|(command & 0xf0);
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0x0f
	ld	(0x02, sp), a
	ld	a, (0x05, sp)
	and	a, #0xf0
	or	a, (0x02, sp)
	ldw	x, #0x500a
	ld	(x), a
;	inc/LCDv2.h: 48: LCD_enable();
	call	_LCD_enable
;	inc/LCDv2.h: 49: PORTData = (PORTData & 0x0f)|((command | 0xf0)<<4);
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0x0f
	ld	(0x01, sp), a
	ld	a, (0x05, sp)
	or	a, #0xf0
	swap	a
	and	a, #0xf0
	or	a, (0x01, sp)
	ldw	x, #0x500a
	ld	(x), a
;	inc/LCDv2.h: 50: LCD_enable();
	call	_LCD_enable
;	inc/LCDv2.h: 51: _delay_ms(min);
	push	#0x05
	push	#0x00
	call	__delay_ms
	addw	sp, #4
	ret
;	inc/LCDv2.h: 54: char LCD_putc(char tc){//??????? ?????? ????????. ???????
;	-----------------------------------------
;	 function LCD_putc
;	-----------------------------------------
_LCD_putc:
	sub	sp, #2
;	inc/LCDv2.h: 55: switch (tc){
	ld	a, (0x05, sp)
	cp	a, #0xa8
	jrnc	00174$
	jp	00167$
00174$:
	ld	a, (0x05, sp)
	sub	a, #0xa8
	clrw	x
	ld	xl, a
	sllw	x
	ldw	x, (#00175$, x)
	jp	(x)
00175$:
	.dw	#00107$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00140$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00167$
	.dw	#00101$
	.dw	#00102$
	.dw	#00103$
	.dw	#00104$
	.dw	#00105$
	.dw	#00106$
	.dw	#00108$
	.dw	#00109$
	.dw	#00110$
	.dw	#00111$
	.dw	#00112$
	.dw	#00113$
	.dw	#00114$
	.dw	#00115$
	.dw	#00116$
	.dw	#00117$
	.dw	#00118$
	.dw	#00119$
	.dw	#00120$
	.dw	#00121$
	.dw	#00122$
	.dw	#00123$
	.dw	#00124$
	.dw	#00125$
	.dw	#00126$
	.dw	#00127$
	.dw	#00129$
	.dw	#00130$
	.dw	#00128$
	.dw	#00131$
	.dw	#00132$
	.dw	#00133$
	.dw	#00134$
	.dw	#00135$
	.dw	#00136$
	.dw	#00137$
	.dw	#00138$
	.dw	#00139$
	.dw	#00141$
	.dw	#00142$
	.dw	#00143$
	.dw	#00144$
	.dw	#00145$
	.dw	#00146$
	.dw	#00147$
	.dw	#00148$
	.dw	#00149$
	.dw	#00150$
	.dw	#00151$
	.dw	#00152$
	.dw	#00153$
	.dw	#00154$
	.dw	#00155$
	.dw	#00156$
	.dw	#00157$
	.dw	#00158$
	.dw	#00159$
	.dw	#00160$
	.dw	#00161$
	.dw	#00162$
	.dw	#00163$
	.dw	#00164$
	.dw	#00165$
	.dw	#00166$
;	inc/LCDv2.h: 56: case '�': tc=0x41; break;  
00101$:
	ld	a, #0x41
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 57: case '�': tc=0xA0; break;
00102$:
	ld	a, #0xa0
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 58: case '�': tc=0x42; break;
00103$:
	ld	a, #0x42
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 59: case '�': tc=0xA1; break;
00104$:
	ld	a, #0xa1
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 60: case '�': tc=0xE0; break;
00105$:
	ld	a, #0xe0
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 61: case '�': tc=0x45; break;
00106$:
	ld	a, #0x45
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 62: case '�': tc=0xA2; break;
00107$:
	ld	a, #0xa2
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 63: case '�': tc=0xA3; break;
00108$:
	ld	a, #0xa3
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 64: case '�': tc=0xA4; break;
00109$:
	ld	a, #0xa4
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 65: case '�': tc=0xA5; break;
00110$:
	ld	a, #0xa5
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 66: case '�': tc=0xA6; break;
00111$:
	ld	a, #0xa6
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 67: case '�': tc=0x4B; break;
00112$:
	ld	a, #0x4b
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 68: case '�': tc=0xA7; break;
00113$:
	ld	a, #0xa7
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 69: case '�': tc=0x4D; break;
00114$:
	ld	a, #0x4d
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 70: case '�': tc=0x48; break;
00115$:
	ld	a, #0x48
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 71: case '�': tc=0x4F; break;
00116$:
	ld	a, #0x4f
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 72: case '�': tc=0xA8; break;
00117$:
	ld	a, #0xa8
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 73: case '�': tc=0x50; break;
00118$:
	ld	a, #0x50
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 74: case '�': tc=0x43; break;
00119$:
	ld	a, #0x43
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 75: case '�': tc=0x54; break;
00120$:
	ld	a, #0x54
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 76: case '�': tc=0xA9; break;
00121$:
	ld	a, #0xa9
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 77: case '�': tc=0xAA; break;
00122$:
	ld	a, #0xaa
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 78: case '�': tc=0x58; break;
00123$:
	ld	a, #0x58
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 79: case '�': tc=0xE1; break;
00124$:
	ld	a, #0xe1
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 80: case '�': tc=0xAB; break;
00125$:
	ld	a, #0xab
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 81: case '�': tc=0xAC; break;
00126$:
	ld	a, #0xac
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 82: case '�': tc=0xE2; break;
00127$:
	ld	a, #0xe2
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 83: case '�': tc=0xC4; break;
00128$:
	ld	a, #0xc4
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 84: case '�': tc=0xAD; break;
00129$:
	ld	a, #0xad
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 85: case '�': tc=0xAE; break;
00130$:
	ld	a, #0xae
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 86: case '�': tc=0xAF; break;
00131$:
	ld	a, #0xaf
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 87: case '�': tc=0xB0; break;
00132$:
	ld	a, #0xb0
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 88: case '�': tc=0xB1; break;
00133$:
	ld	a, #0xb1
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 89: case '�': tc=0x61; break;
00134$:
	ld	a, #0x61
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 90: case '�': tc=0xB2; break;
00135$:
	ld	a, #0xb2
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 91: case '�': tc=0xB3; break;
00136$:
	ld	a, #0xb3
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 92: case '�': tc=0xB4; break;
00137$:
	ld	a, #0xb4
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 93: case '�': tc=0xE3; break;
00138$:
	ld	a, #0xe3
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 94: case '�': tc=0x65; break;
00139$:
	ld	a, #0x65
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 95: case '�': tc=0xB5; break;
00140$:
	ld	a, #0xb5
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 96: case '�': tc=0xB6; break;
00141$:
	ld	a, #0xb6
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 97: case '�': tc=0xB7; break;
00142$:
	ld	a, #0xb7
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 98: case '�': tc=0xB8; break;
00143$:
	ld	a, #0xb8
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 99: case '�': tc=0xB9; break;
00144$:
	ld	a, #0xb9
	ld	(0x05, sp), a
	jp	00167$
;	inc/LCDv2.h: 100: case '�': tc=0xBA; break;
00145$:
	ld	a, #0xba
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 101: case '�': tc=0xBB; break;
00146$:
	ld	a, #0xbb
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 102: case '�': tc=0xBC; break;
00147$:
	ld	a, #0xbc
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 103: case '�': tc=0xBD; break;
00148$:
	ld	a, #0xbd
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 104: case '�': tc=0x6F; break;
00149$:
	ld	a, #0x6f
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 105: case '�': tc=0xBE; break;
00150$:
	ld	a, #0xbe
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 106: case '�': tc=0x70; break;
00151$:
	ld	a, #0x70
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 107: case '�': tc=0x63; break;
00152$:
	ld	a, #0x63
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 108: case '�': tc=0xBF; break;
00153$:
	ld	a, #0xbf
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 109: case '�': tc=0x79; break;
00154$:
	ld	a, #0x79
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 110: case '�': tc=0xE4; break;
00155$:
	ld	a, #0xe4
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 111: case '�': tc=0x78; break;
00156$:
	ld	a, #0x78
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 112: case '�': tc=0xE5; break;
00157$:
	ld	a, #0xe5
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 113: case '�': tc=0xC0; break;
00158$:
	ld	a, #0xc0
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 114: case '�': tc=0xC1; break;
00159$:
	ld	a, #0xc1
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 115: case '�': tc=0xE6; break;
00160$:
	ld	a, #0xe6
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 116: case '�': tc=0xC2; break;
00161$:
	ld	a, #0xc2
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 117: case '�': tc=0xC3; break;
00162$:
	ld	a, #0xc3
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 118: case '�': tc=0xC4; break;
00163$:
	ld	a, #0xc4
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 119: case '�': tc=0xC5; break;
00164$:
	ld	a, #0xc5
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 120: case '�': tc=0xC6; break;
00165$:
	ld	a, #0xc6
	ld	(0x05, sp), a
	jra	00167$
;	inc/LCDv2.h: 121: case '�': tc=0xC7; break;
00166$:
	ld	a, #0xc7
	ld	(0x05, sp), a
;	inc/LCDv2.h: 122: }
00167$:
;	inc/LCDv2.h: 123: lcdrs1;
	ldw	x, #0x500f
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
;	inc/LCDv2.h: 124: PORTData = (PORTData & 0x0f)|(tc & 0xf0);
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0x0f
	ld	(0x02, sp), a
	ld	a, (0x05, sp)
	and	a, #0xf0
	or	a, (0x02, sp)
	ldw	x, #0x500a
	ld	(x), a
;	inc/LCDv2.h: 125: LCD_enable();
	call	_LCD_enable
;	inc/LCDv2.h: 126: PORTData = (PORTData & 0x0f)|((tc | 0xf0)<<4);
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0x0f
	ld	(0x01, sp), a
	ld	a, (0x05, sp)
	or	a, #0xf0
	swap	a
	and	a, #0xf0
	or	a, (0x01, sp)
	ldw	x, #0x500a
	ld	(x), a
;	inc/LCDv2.h: 127: LCD_enable();
	call	_LCD_enable
;	inc/LCDv2.h: 128: return 0;
	clr	a
	addw	sp, #2
	ret
;	inc/LCDv2.h: 131: void LCD_puts(int x,int y,unsigned char *lcd_string)
;	-----------------------------------------
;	 function LCD_puts
;	-----------------------------------------
_LCD_puts:
	sub	sp, #3
;	inc/LCDv2.h: 133: if(x==0 && y==1)LCD_command(0x80);
	ldw	x, (0x08, sp)
	cpw	x, #0x0001
	jrne	00171$
	ld	a, #0x01
	ld	(0x03, sp), a
	jra	00172$
00171$:
	clr	(0x03, sp)
00172$:
	ldw	x, (0x06, sp)
	jrne	00102$
	tnz	(0x03, sp)
	jreq	00102$
	push	#0x80
	call	_LCD_command
	pop	a
00102$:
;	inc/LCDv2.h: 134: if(x==0 && y==2)LCD_command(0xC0);
	ldw	x, (0x08, sp)
	cpw	x, #0x0002
	jrne	00176$
	ld	a, #0x01
	ld	(0x02, sp), a
	jra	00177$
00176$:
	clr	(0x02, sp)
00177$:
	ldw	x, (0x06, sp)
	jrne	00105$
	tnz	(0x02, sp)
	jreq	00105$
	push	#0xc0
	call	_LCD_command
	pop	a
00105$:
;	inc/LCDv2.h: 135: if(x!=0 && y==1)LCD_command(128+x);
	ld	a, (0x07, sp)
	ld	(0x01, sp), a
	ldw	x, (0x06, sp)
	jreq	00108$
	tnz	(0x03, sp)
	jreq	00108$
	ld	a, (0x01, sp)
	add	a, #0x80
	push	a
	call	_LCD_command
	pop	a
00108$:
;	inc/LCDv2.h: 136: if(x!=0 && y==2)LCD_command(192+x);
	ldw	x, (0x06, sp)
	jreq	00111$
	tnz	(0x02, sp)
	jreq	00111$
	ld	a, (0x01, sp)
	add	a, #0xc0
	push	a
	call	_LCD_command
	pop	a
00111$:
;	inc/LCDv2.h: 137: if(y!=2 && y!=1)return;
	tnz	(0x02, sp)
	jrne	00132$
	tnz	(0x03, sp)
;	inc/LCDv2.h: 138: while (*lcd_string) 
	jreq	00119$
00132$:
	ldw	x, (0x0a, sp)
00116$:
	ld	a, (x)
	tnz	a
	jreq	00119$
;	inc/LCDv2.h: 140: LCD_putc(*lcd_string++);
	incw	x
	pushw	x
	push	a
	call	_LCD_putc
	pop	a
	popw	x
	jra	00116$
00119$:
	addw	sp, #3
	ret
;	inc/LCDv2.h: 144: void LCD_init(void)
;	-----------------------------------------
;	 function LCD_init
;	-----------------------------------------
_LCD_init:
;	inc/LCDv2.h: 146: lcden1;
	ldw	x, #0x500f
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	inc/LCDv2.h: 147: lcdrs0;   
	ldw	x, #0x500f
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
;	inc/LCDv2.h: 148: LCD_command(0x33);
	push	#0x33
	call	_LCD_command
	pop	a
;	inc/LCDv2.h: 149: LCD_command(0x32);
	push	#0x32
	call	_LCD_command
	pop	a
;	inc/LCDv2.h: 150: LCD_command(0x28);
	push	#0x28
	call	_LCD_command
	pop	a
;	inc/LCDv2.h: 151: LCD_command(0x0C);
	push	#0x0c
	call	_LCD_command
	pop	a
;	inc/LCDv2.h: 152: LCD_command(0x06);
	push	#0x06
	call	_LCD_command
	pop	a
;	inc/LCDv2.h: 153: LCD_command(0x01); /* Clear */
	push	#0x01
	call	_LCD_command
	pop	a
;	inc/LCDv2.h: 154: _delay_ms(min);
	push	#0x05
	push	#0x00
	call	__delay_ms
	addw	sp, #2
	ret
;	inc/LCDv2.h: 156: void shiftL(char i)
;	-----------------------------------------
;	 function shiftL
;	-----------------------------------------
_shiftL:
	sub	sp, #2
;	inc/LCDv2.h: 159: for(t=0;t<i;t++)
	clrw	x
00103$:
	ld	a, (0x05, sp)
	ld	(0x02, sp), a
	clr	(0x01, sp)
	cpw	x, (0x01, sp)
	jrsge	00105$
;	inc/LCDv2.h: 161: LCD_command(0x1C);
	pushw	x
	push	#0x1c
	call	_LCD_command
	pop	a
	popw	x
;	inc/LCDv2.h: 162: _delay_ms(150);
	pushw	x
	push	#0x96
	push	#0x00
	call	__delay_ms
	addw	sp, #2
	popw	x
;	inc/LCDv2.h: 159: for(t=0;t<i;t++)
	incw	x
	jra	00103$
00105$:
	addw	sp, #2
	ret
;	inc/LCDv2.h: 165: void shiftR(char i)
;	-----------------------------------------
;	 function shiftR
;	-----------------------------------------
_shiftR:
	sub	sp, #2
;	inc/LCDv2.h: 168: for(t=0;t<i;t++)
	clrw	x
00103$:
	ld	a, (0x05, sp)
	ld	(0x02, sp), a
	clr	(0x01, sp)
	cpw	x, (0x01, sp)
	jrsge	00105$
;	inc/LCDv2.h: 170: LCD_command(0x18);
	pushw	x
	push	#0x18
	call	_LCD_command
	pop	a
	popw	x
;	inc/LCDv2.h: 171: _delay_ms(150);
	pushw	x
	push	#0x96
	push	#0x00
	call	__delay_ms
	addw	sp, #2
	popw	x
;	inc/LCDv2.h: 168: for(t=0;t<i;t++)
	incw	x
	jra	00103$
00105$:
	addw	sp, #2
	ret
;	inc/ADC.h: 52: void ADC_INIT(void){
;	-----------------------------------------
;	 function ADC_INIT
;	-----------------------------------------
_ADC_INIT:
;	inc/ADC.h: 54: ADC_CR2_ALIGN_LEFT;    //Выравнивание по левому краю
	ldw	x, #0x5402
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
;	inc/ADC.h: 55: ADC_CR1_ADON_ON;       //Первый запуск ADC
	bset	0x5401, #0
	ret
;	inc/ADC.h: 57: int ADC_read0(void){
;	-----------------------------------------
;	 function ADC_read0
;	-----------------------------------------
_ADC_read0:
	sub	sp, #4
;	inc/ADC.h: 59: ADC_CSR_CLEAN;
	ldw	x, #0x5400
	ld	a, (x)
	and	a, #0xf0
	ld	(x), a
;	inc/ADC.h: 60: ADC_CSR_CH0;           //Выбераем канал
	ldw	x, #0x5400
	ld	a, (x)
	and	a, #0xf0
	ld	(x), a
;	inc/ADC.h: 61: ADC_CR1_SPSEL8;        //Делитель на 18            
	ldw	x, #0x5401
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
;	inc/ADC.h: 62: ADC_TDRL_DIS(0);       //Отключаем тригер Шмидта
	bset	0x5407, #0
;	inc/ADC.h: 63: ADC_CR1_ADON_ON;
	ldw	x, #0x5401
	ld	a, (x)
	or	a, #0x01
	ld	(x), a
;	inc/ADC.h: 64: for(t=0;t<64;t++){
	ldw	x, #0x0040
00104$:
;	inc/ADC.h: 65: __asm__("nop\n");
	nop
	decw	x
;	inc/ADC.h: 64: for(t=0;t<64;t++){
	ldw	(0x03, sp), x
	ldw	y, x
	jrne	00104$
;	inc/ADC.h: 67: data=ADC_DRH<<2;
	ldw	x, #0x5404
	ld	a, (x)
	clrw	x
	ld	xl, a
	sllw	x
	sllw	x
	ldw	(0x01, sp), x
;	inc/ADC.h: 68: data=data+ADC_DRL;
	ldw	x, #0x5405
	ld	a, (x)
	clrw	x
	ld	xl, a
	addw	x, (0x01, sp)
;	inc/ADC.h: 69: data=data>>1;
	sraw	x
;	inc/ADC.h: 70: return data;
	addw	sp, #4
	ret
;	main.c: 6: void delay(int t)
;	-----------------------------------------
;	 function delay
;	-----------------------------------------
_delay:
	sub	sp, #2
;	main.c: 9: for(i=0;i<t;i++)
	clrw	x
00107$:
	cpw	x, (0x05, sp)
	jrsge	00109$
;	main.c: 11: for(s=0;s<1512;s++)
	ldw	y, #0x05e8
	ldw	(0x01, sp), y
00105$:
	ldw	y, (0x01, sp)
	decw	y
	ldw	(0x01, sp), y
	tnzw	y
	jrne	00105$
;	main.c: 9: for(i=0;i<t;i++)
	incw	x
	jra	00107$
00109$:
	addw	sp, #2
	ret
;	main.c: 18: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #23
;	main.c: 21: float volt=0.0, volt_old=0.0, k=0.1;// vold=0, vcontl=0,vconth=0;
	clrw	x
	ldw	(0x03, sp), x
	ldw	(0x01, sp), x
;	main.c: 22: int vadc=0,v=0,cadc=0,count=0;
	clrw	x
	ldw	(0x05, sp), x
;	main.c: 23: clk_init_HSI();
	call	_clk_init_HSI
;	main.c: 24: GPIO_init();
	call	_GPIO_init
;	main.c: 25: LCD_init();
	call	_LCD_init
;	main.c: 26: ADC_INIT();
	call	_ADC_INIT
;	main.c: 28: while(1)
00104$:
;	main.c: 30: vadc=ADC_read0();
	call	_ADC_read0
;	main.c: 32: volt=(k*vadc)+(1-k)*volt_old;
	pushw	x
	call	___sint2fs
	addw	sp, #2
	pushw	x
	pushw	y
	push	#0xcd
	push	#0xcc
	push	#0xcc
	push	#0x3d
	call	___fsmul
	addw	sp, #8
	ldw	(0x14, sp), x
	ldw	(0x12, sp), y
	ldw	x, (0x03, sp)
	pushw	x
	ldw	x, (0x03, sp)
	pushw	x
	push	#0x66
	push	#0x66
	push	#0x66
	push	#0x3f
	call	___fsmul
	addw	sp, #8
	pushw	x
	pushw	y
	ldw	x, (0x18, sp)
	pushw	x
	ldw	x, (0x18, sp)
	pushw	x
	call	___fsadd
	addw	sp, #8
;	main.c: 33: volt_old=volt;
	ldw	(0x03, sp), x
	ldw	(0x01, sp), y
;	main.c: 35: v=volt*0.0097*6*10;
	pushw	x
	pushw	y
	push	#0xf4
	push	#0xfd
	push	#0x14
	push	#0x3f
	call	___fsmul
	addw	sp, #8
	pushw	x
	pushw	y
	call	___fs2sint
	addw	sp, #4
	ldw	(0x07, sp), x
;	main.c: 36: volts[0]=(v%1000/100)+48;
	ldw	x, sp
	addw	x, #9
	ldw	(0x0e, sp), x
	push	#0xe8
	push	#0x03
	ldw	x, (0x09, sp)
	pushw	x
	call	__modsint
	addw	sp, #4
	push	#0x64
	push	#0x00
	pushw	x
	call	__divsint
	addw	sp, #4
	ld	a, xl
	add	a, #0x30
	ldw	x, (0x0e, sp)
	ld	(x), a
;	main.c: 37: volts[1]=(v%100/10)+48;
	ldw	x, (0x0e, sp)
	incw	x
	ldw	(0x16, sp), x
	push	#0x64
	push	#0x00
	ldw	x, (0x09, sp)
	pushw	x
	call	__modsint
	addw	sp, #4
	push	#0x0a
	push	#0x00
	pushw	x
	call	__divsint
	addw	sp, #4
	ld	a, xl
	add	a, #0x30
	ldw	x, (0x16, sp)
	ld	(x), a
;	main.c: 38: volts[2]='.';
	ldw	x, (0x0e, sp)
	incw	x
	incw	x
	ld	a, #0x2e
	ld	(x), a
;	main.c: 39: volts[3]=(v%10)+48;
	ldw	x, (0x0e, sp)
	addw	x, #0x0003
	ldw	(0x10, sp), x
	push	#0x0a
	push	#0x00
	ldw	x, (0x09, sp)
	pushw	x
	call	__modsint
	addw	sp, #4
	ld	a, xl
	add	a, #0x30
	ldw	x, (0x10, sp)
	ld	(x), a
;	main.c: 40: volts[4]=0;
	ldw	x, (0x0e, sp)
	addw	x, #0x0004
	clr	(x)
;	main.c: 42: if(count>=50){
	ldw	x, (0x05, sp)
	cpw	x, #0x0032
	jrslt	00102$
;	main.c: 43: count=0;
	clrw	x
	ldw	(0x05, sp), x
;	main.c: 44: LCD_puts(0,1,"U=");
	ldw	x, #___str_0+0
	pushw	x
	push	#0x01
	push	#0x00
	clrw	x
	pushw	x
	call	_LCD_puts
	addw	sp, #6
;	main.c: 45: LCD_puts(3,1,volts);
	ldw	x, (0x0e, sp)
	pushw	x
	push	#0x01
	push	#0x00
	push	#0x03
	push	#0x00
	call	_LCD_puts
	addw	sp, #6
00102$:
;	main.c: 47: count++;	
	ldw	x, (0x05, sp)
	incw	x
	ldw	(0x05, sp), x
	jp	00104$
	addw	sp, #23
	ret
	.area CODE
___str_0:
	.ascii "U="
	.db 0x00
	.area INITIALIZER
	.area CABS (ABS)
