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
	.globl _ADC_ch_1
	.globl _ADC_ch_0
	.globl _gpio_init
	.globl _Init_HSI
	.globl _Init_HSE
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
;	inc/clk_init.h: 7: void Init_HSE(){    
;	-----------------------------------------
;	 function Init_HSE
;	-----------------------------------------
_Init_HSE:
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
;	inc/clk_init.h: 15: CLK_CCOR=0; // CLK_CCOR|=(1<<2)|(1<<0);
	mov	0x50c9+0, #0x00
	ret
;	inc/clk_init.h: 18: void Init_HSI()
;	-----------------------------------------
;	 function Init_HSI
;	-----------------------------------------
_Init_HSI:
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
;	inc/gpio_init.h: 24: void gpio_init(void)
;	-----------------------------------------
;	 function gpio_init
;	-----------------------------------------
_gpio_init:
;	inc/gpio_init.h: 27: PA_DDR = 0xFF;                                                        //_______PORT_IN
	mov	0x5002+0, #0xff
;	inc/gpio_init.h: 28: PA_CR1 = 0xFF;                                                       //_______DDR________________CR1______________CR2___________FUNCTION  
	mov	0x5003+0, #0xff
;	inc/gpio_init.h: 29: PA_CR2 = 0x00;                                                      //_______0__________________0________________0_____________bez podtiyzhki,bez prerbIvanii 
	mov	0x5004+0, #0x00
;	inc/gpio_init.h: 31: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
	mov	0x5007+0, #0x00
;	inc/gpio_init.h: 32: PB_CR1 = 0x00;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
	mov	0x5008+0, #0x00
;	inc/gpio_init.h: 33: PB_CR2 = 0x00;                                                      //_______PORT_OUT
	mov	0x5009+0, #0x00
;	inc/gpio_init.h: 35: PC_DDR = 0xFF;                                                        //_______1__________________0________________0_____________otkritiy stok
	mov	0x500c+0, #0xff
;	inc/gpio_init.h: 36: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
	mov	0x500d+0, #0xff
;	inc/gpio_init.h: 37: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
	mov	0x500e+0, #0x00
;	inc/gpio_init.h: 39: PD_DDR = 0x00;   
	mov	0x5011+0, #0x00
;	inc/gpio_init.h: 40: PD_CR1 = 0x00;  
	mov	0x5012+0, #0x00
;	inc/gpio_init.h: 41: PD_CR2 = 0x00; 
	mov	0x5013+0, #0x00
;	inc/gpio_init.h: 43: PE_DDR = 0xFF;   
	mov	0x5016+0, #0xff
;	inc/gpio_init.h: 44: PE_CR1 = 0xFF;  
	mov	0x5017+0, #0xff
;	inc/gpio_init.h: 45: PE_CR2 = 0x00; 
	mov	0x5018+0, #0x00
;	inc/gpio_init.h: 47: PF_DDR = 0xFF;   
	mov	0x501b+0, #0xff
;	inc/gpio_init.h: 48: PF_CR1 = 0xFF;  
	mov	0x501c+0, #0xff
;	inc/gpio_init.h: 49: PF_CR2 = 0x00; 
	mov	0x501d+0, #0x00
	ret
;	inc/ADC.h: 51: int ADC_ch_0(void){
;	-----------------------------------------
;	 function ADC_ch_0
;	-----------------------------------------
_ADC_ch_0:
;	inc/ADC.h: 53: ADC_CSR_CH2;           //Выбераем канал
	ldw	x, #0x5400
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
;	inc/ADC.h: 57: ADC_CR1_ADON_ON;       //Первый запуск ADC
	bset	0x5401, #0
;	inc/ADC.h: 62: data=ADC_DRH;
	ldw	x, #0x5404
	ld	a, (x)
	clrw	x
	ld	xl, a
;	inc/ADC.h: 64: return data;
	ret
;	inc/ADC.h: 66: int ADC_ch_1(void){
;	-----------------------------------------
;	 function ADC_ch_1
;	-----------------------------------------
_ADC_ch_1:
;	inc/ADC.h: 68: ADC_CSR_CH3;           //Выбераем канал
	ldw	x, #0x5400
	ld	a, (x)
	or	a, #0x03
	ld	(x), a
;	inc/ADC.h: 72: ADC_CR1_ADON_ON;       //Первый запуск ADC
	bset	0x5401, #0
;	inc/ADC.h: 77: data=ADC_DRH;
	ldw	x, #0x5404
	ld	a, (x)
	clrw	x
	ld	xl, a
;	inc/ADC.h: 79: return data;
	ret
;	main.c: 5: void delay(int t)
;	-----------------------------------------
;	 function delay
;	-----------------------------------------
_delay:
	sub	sp, #2
;	main.c: 8: for(i=0;i<t;i++)
	clrw	x
00107$:
	cpw	x, (0x05, sp)
	jrsge	00109$
;	main.c: 10: for(s=0;s<1512;s++)
	ldw	y, #0x05e8
	ldw	(0x01, sp), y
00105$:
	ldw	y, (0x01, sp)
	decw	y
	ldw	(0x01, sp), y
	tnzw	y
	jrne	00105$
;	main.c: 8: for(i=0;i<t;i++)
	incw	x
	jra	00107$
00109$:
	addw	sp, #2
	ret
;	main.c: 16: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	main.c: 19: Init_HSE();
	call	_Init_HSE
;	main.c: 20: gpio_init();
	call	_gpio_init
;	main.c: 22: ADC_CR1_SPSEL8;  //Делитель на 18            
	ldw	x, #0x5401
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
;	main.c: 23: ADC_TDRL_DIS(5);       //Отключаем тригер Шмидта
	ldw	x, #0x5407
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	main.c: 24: ADC_TDRL_DIS(6);       //Отключаем тригер Шмидта
	ldw	x, #0x5407
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
;	main.c: 25: ADC_CR2_ALIGN_LEFT;    //Выравнивание по левому краю
	ldw	x, #0x5402
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
;	main.c: 26: ADC_CR1_ADON_ON;       //Первый запуск ADC
	bset	0x5401, #0
;	main.c: 28: while(1)
00108$:
;	main.c: 31: ADC_CSR&=~((1<<3)|(1<<2)|(1<<1)|(1<<0));
	ldw	x, #0x5400
	ld	a, (x)
	and	a, #0xf0
	ld	(x), a
;	main.c: 32: ADC_CSR_CH5;           //Выбераем канал
	ldw	x, #0x5400
	ld	a, (x)
	or	a, #0x05
	ld	(x), a
;	main.c: 33: ADC_CR1_ADON_ON;       //запуск ADC
	bset	0x5401, #0
;	main.c: 34: while(!(ADC_CSR&(1<<7))) //ждем окончания преобразования
00101$:
;	main.c: 31: ADC_CSR&=~((1<<3)|(1<<2)|(1<<1)|(1<<0));
	ldw	x, #0x5400
	ld	a, (x)
;	main.c: 34: while(!(ADC_CSR&(1<<7))) //ждем окончания преобразования
	tnz	a
	jrmi	00103$
;	main.c: 36: __asm__("nop\n");
	nop
	jra	00101$
00103$:
;	main.c: 38: s=ADC_DRH; //первым читается значемый регистр в данном случае ADC_DRH
	ldw	x, #0x5404
	push	a
	ld	a, (x)
	ld	xl, a
	pop	a
	rlwa	x
	clr	a
	rrwa	x
;	main.c: 40: ADC_CSR&=~(1<<7); //очищаем флаг окончания преобразования
	and	a, #0x7f
	ldw	y, #0x5400
	ld	(y), a
;	main.c: 41: PC_ODR=s; 
	ld	a, xl
	ldw	x, #0x500a
	ld	(x), a
;	main.c: 42: delay(100);
	push	#0x64
	push	#0x00
	call	_delay
	addw	sp, #2
;	main.c: 45: ADC_CSR&=~((1<<3)|(1<<2)|(1<<1)|(1<<0));
	ldw	x, #0x5400
	ld	a, (x)
	and	a, #0xf0
	ld	(x), a
;	main.c: 46: ADC_CSR_CH6;           //Выбераем канал
	ldw	x, #0x5400
	ld	a, (x)
	or	a, #0x06
	ld	(x), a
;	main.c: 47: ADC_CR1_ADON_ON;       //запуск ADC
	bset	0x5401, #0
;	main.c: 48: while(!(ADC_CSR&(1<<7)))
00104$:
;	main.c: 31: ADC_CSR&=~((1<<3)|(1<<2)|(1<<1)|(1<<0));
	ldw	x, #0x5400
	ld	a, (x)
;	main.c: 48: while(!(ADC_CSR&(1<<7)))
	tnz	a
	jrmi	00106$
;	main.c: 50: __asm__("nop\n");
	nop
	jra	00104$
00106$:
;	main.c: 52: s=ADC_DRH;
	ldw	x, #0x5404
	push	a
	ld	a, (x)
	ld	xl, a
	pop	a
	rlwa	x
	clr	a
	rrwa	x
;	main.c: 54: ADC_CSR&=~(1<<7);
	and	a, #0x7f
	ldw	y, #0x5400
	ld	(y), a
;	main.c: 55: PC_ODR=s; 
	ld	a, xl
	ldw	x, #0x500a
	ld	(x), a
;	main.c: 56: delay(100); 
	push	#0x64
	push	#0x00
	call	_delay
	addw	sp, #2
;	main.c: 57: s=i=0;
	jra	00108$
	ret
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
