;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.0 #9615 (Linux)
;--------------------------------------------------------
	.module main
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _delay
	.globl _out7seg
	.globl _ADC_read
	.globl _ADC_INIT
	.globl _GPIO_init
	.globl _Init_HSI
	.globl _Init_HSE
	.globl _q
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_q::
	.ds 2
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
;	inc/gpio_init.h: 4: void GPIO_init(void)
;	-----------------------------------------
;	 function GPIO_init
;	-----------------------------------------
_GPIO_init:
;	inc/gpio_init.h: 7: PA_DDR = 0xFF;                                                        //_______PORT_IN
	mov	0x5002+0, #0xff
;	inc/gpio_init.h: 8: PA_CR1 = 0xFF;                                                       //_______DDR________________CR1______________CR2___________FUNCTION  
	mov	0x5003+0, #0xff
;	inc/gpio_init.h: 9: PA_CR2 = 0x00;                                                      //_______0__________________0________________0_____________bez podtiyzhki,bez prerbIvanii 
	mov	0x5004+0, #0x00
;	inc/gpio_init.h: 11: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
	mov	0x5007+0, #0x00
;	inc/gpio_init.h: 12: PB_CR1 = 0x00;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
	mov	0x5008+0, #0x00
;	inc/gpio_init.h: 13: PB_CR2 = 0x00;                                                      //_______PORT_OUT
	mov	0x5009+0, #0x00
;	inc/gpio_init.h: 15: PC_DDR = 0xFF;                                                        //_______1__________________0________________0_____________otkritiy stok
	mov	0x500c+0, #0xff
;	inc/gpio_init.h: 16: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
	mov	0x500d+0, #0xff
;	inc/gpio_init.h: 17: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
	mov	0x500e+0, #0x00
;	inc/gpio_init.h: 19: PD_DDR = 0x3F;   
	mov	0x5011+0, #0x3f
;	inc/gpio_init.h: 20: PD_CR1 = 0xFF;  
	mov	0x5012+0, #0xff
;	inc/gpio_init.h: 21: PD_CR2 = 0x00; 
	mov	0x5013+0, #0x00
;	inc/gpio_init.h: 23: PE_DDR = 0x01;   
	mov	0x5016+0, #0x01
;	inc/gpio_init.h: 24: PE_CR1 = 0x01;  
	mov	0x5017+0, #0x01
;	inc/gpio_init.h: 25: PE_CR2 = 0x00; 
	mov	0x5018+0, #0x00
;	inc/gpio_init.h: 27: PF_DDR = 0xFF;   
	mov	0x501b+0, #0xff
;	inc/gpio_init.h: 28: PF_CR1 = 0xFF;  
	mov	0x501c+0, #0xff
;	inc/gpio_init.h: 29: PF_CR2 = 0x00; 
	mov	0x501d+0, #0x00
;	inc/gpio_init.h: 31: PG_DDR = 0xFF;   
	mov	0x5020+0, #0xff
;	inc/gpio_init.h: 32: PG_CR1 = 0xFF;  
	mov	0x5021+0, #0xff
;	inc/gpio_init.h: 33: PG_CR2 = 0x00; 
	mov	0x5022+0, #0x00
	ret
;	inc/ADC.h: 51: void ADC_INIT(void){
;	-----------------------------------------
;	 function ADC_INIT
;	-----------------------------------------
_ADC_INIT:
;	inc/ADC.h: 52: ADC_CSR_CH9;           //Выбераем канал
	ldw	x, #0x5400
	ld	a, (x)
	or	a, #0x09
	ld	(x), a
;	inc/ADC.h: 53: ADC_CR1_SPSEL8;  //Делитель на 18            
	ldw	x, #0x5401
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
;	inc/ADC.h: 54: ADC_TDRL_DIS(0);       //Отключаем тригер Шмидта
	bset	0x5407, #0
;	inc/ADC.h: 55: ADC_CR2_ALIGN_LEFT;    //Выравнивание по левому краю
	ldw	x, #0x5402
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
;	inc/ADC.h: 56: ADC_CR1_ADON_ON;       //Первый запуск ADC
	bset	0x5401, #0
	ret
;	inc/ADC.h: 58: int ADC_read(void){
;	-----------------------------------------
;	 function ADC_read
;	-----------------------------------------
_ADC_read:
	sub	sp, #4
;	inc/ADC.h: 60: ADC_CR1_ADON_ON;
	ldw	x, #0x5401
	ld	a, (x)
	or	a, #0x01
	ld	(x), a
;	inc/ADC.h: 61: for(t=0;t<64;t++){
	ldw	x, #0x0040
00104$:
;	inc/ADC.h: 62: __asm__("nop\n");
	nop
	decw	x
	ldw	(0x03, sp), x
	ldw	x, (0x03, sp)
;	inc/ADC.h: 61: for(t=0;t<64;t++){
	ldw	y, (0x03, sp)
	jrne	00104$
;	inc/ADC.h: 64: data=ADC_DRH<<2;
	ldw	x, #0x5404
	ld	a, (x)
	clrw	x
	ld	xl, a
	sllw	x
	sllw	x
	ldw	(0x01, sp), x
;	inc/ADC.h: 65: data=data+ADC_DRL;
	ldw	x, #0x5405
	ld	a, (x)
	clrw	x
	ld	xl, a
	addw	x, (0x01, sp)
;	inc/ADC.h: 66: data=data>>1;
	sraw	x
;	inc/ADC.h: 67: return data;
	addw	sp, #4
	ret
;	inc/7sig.h: 11: void out7seg(volatile int t)
;	-----------------------------------------
;	 function out7seg
;	-----------------------------------------
_out7seg:
	sub	sp, #2
;	inc/7sig.h: 13: int num=0;
	clrw	x
	ldw	(0x01, sp), x
;	inc/7sig.h: 14: PC_ODR=0x00;
	mov	0x500a+0, #0x00
;	inc/7sig.h: 15: PG_ODR=0x00;
	mov	0x501e+0, #0x00
;	inc/7sig.h: 16: PD_ODR&=~((1<<4) |(1<<3)|(1<<2));
	ldw	x, #0x500f
	ld	a, (x)
	and	a, #0xe3
	ld	(x), a
;	inc/7sig.h: 20: if(q==0) num=(t%1000/100),PD_ODR|=(1<<2);
	ldw	x, _q+0
	jrne	00102$
	push	#0xe8
	push	#0x03
	ldw	x, (0x07, sp)
	pushw	x
	call	__modsint
	addw	sp, #4
	push	#0x64
	push	#0x00
	pushw	x
	call	__divsint
	addw	sp, #4
	ldw	(0x01, sp), x
	ldw	x, #0x500f
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
00102$:
;	inc/7sig.h: 21: if(q==1) num=(t%100/10),PD_ODR|=(1<<3);
	ldw	x, _q+0
	cpw	x, #0x0001
	jrne	00104$
	push	#0x64
	push	#0x00
	ldw	x, (0x07, sp)
	pushw	x
	call	__modsint
	addw	sp, #4
	push	#0x0a
	push	#0x00
	pushw	x
	call	__divsint
	addw	sp, #4
	ldw	(0x01, sp), x
	ldw	x, #0x500f
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
00104$:
;	inc/7sig.h: 22: if(q==2) num=(t%10),PD_ODR|=(1<<4);
	ldw	x, _q+0
	cpw	x, #0x0002
	jrne	00106$
	push	#0x0a
	push	#0x00
	ldw	x, (0x07, sp)
	pushw	x
	call	__modsint
	addw	sp, #4
	ldw	(0x01, sp), x
	ldw	x, #0x500f
	ld	a, (x)
	or	a, #0x10
	ld	(x), a
00106$:
;	inc/7sig.h: 23: q++;
	ldw	x, _q+0
	incw	x
;	inc/7sig.h: 24: if(q>2) q=0;
	ldw	_q+0, x
	cpw	x, #0x0002
	jrsle	00108$
	clrw	x
	ldw	_q+0, x
00108$:
;	inc/7sig.h: 25: switch (num)
	tnz	(0x01, sp)
	jrpl	00155$
	jp	00121$
00155$:
	ldw	x, (0x01, sp)
	cpw	x, #0x0009
	jrsle	00156$
	jp	00121$
00156$:
	ldw	x, (0x01, sp)
	sllw	x
	ldw	x, (#00157$, x)
	jp	(x)
00157$:
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
;	inc/7sig.h: 27: case 0:   
00109$:
;	inc/7sig.h: 28: segA,segB,segC,segD,segE,segF;
	ldw	x, #0x501e
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
	bset	0x501e, #0
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x80
	ld	(x), a
;	inc/7sig.h: 29: break;
	jp	00121$
;	inc/7sig.h: 30: case 1:   
00110$:
;	inc/7sig.h: 31: segB,segC;
	bset	0x501e, #0
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	inc/7sig.h: 32: break;
	jp	00121$
;	inc/7sig.h: 33: case 2:   
00111$:
;	inc/7sig.h: 34: segA,segB,segG,segD,segE;
	ldw	x, #0x501e
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
	bset	0x501e, #0
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
;	inc/7sig.h: 35: break;
	jp	00121$
;	inc/7sig.h: 36: case 3:   
00112$:
;	inc/7sig.h: 37: segA,segB,segC,segD,segG;
	ldw	x, #0x501e
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
	bset	0x501e, #0
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
;	inc/7sig.h: 38: break;
	jp	00121$
;	inc/7sig.h: 39: case 4:   
00113$:
;	inc/7sig.h: 40: segF,segB,segG,segC;
	bset	0x500a, #7
	bset	0x501e, #0
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	inc/7sig.h: 41: break;
	jp	00121$
;	inc/7sig.h: 42: case 5:   
00114$:
;	inc/7sig.h: 43: segA,segC,segD,segF,segG;
	ldw	x, #0x501e
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
	bset	0x500a, #7
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
;	inc/7sig.h: 44: break;
	jp	00121$
;	inc/7sig.h: 45: case 6:   
00115$:
;	inc/7sig.h: 46: segA,segC,segD,segE,segF,segG;
	ldw	x, #0x501e
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
	bset	0x500a, #7
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
;	inc/7sig.h: 47: break;
	jra	00121$
;	inc/7sig.h: 48: case 7:   
00116$:
;	inc/7sig.h: 49: segA,segB,segC;
	ldw	x, #0x501e
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
	bset	0x501e, #0
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	inc/7sig.h: 50: break;
	jra	00121$
;	inc/7sig.h: 51: case 8:   
00117$:
;	inc/7sig.h: 52: segA,segB,segC,segD,segE,segF,segG;
	ldw	x, #0x501e
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
	bset	0x501e, #0
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
	bset	0x500a, #7
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
;	inc/7sig.h: 53: break;
	jra	00121$
;	inc/7sig.h: 54: case 9:   
00118$:
;	inc/7sig.h: 55: segA,segB,segC,segD,segF,segG;
	ldw	x, #0x501e
	ld	a, (x)
	or	a, #0x02
	ld	(x), a
	bset	0x501e, #0
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
	bset	0x500a, #7
	ldw	x, #0x500a
	ld	a, (x)
	or	a, #0x40
	ld	(x), a
;	inc/7sig.h: 59: }
00121$:
	addw	sp, #2
	ret
;	main.c: 9: void delay(int t)
;	-----------------------------------------
;	 function delay
;	-----------------------------------------
_delay:
	sub	sp, #2
;	main.c: 12: for(i=0;i<t;i++)
	clrw	x
00107$:
	cpw	x, (0x05, sp)
	jrsge	00109$
;	main.c: 14: for(s=0;s<32;s++)
	ldw	y, #0x0020
	ldw	(0x01, sp), y
00105$:
	ldw	y, (0x01, sp)
	decw	y
	ldw	(0x01, sp), y
	tnzw	y
	jrne	00105$
;	main.c: 12: for(i=0;i<t;i++)
	incw	x
	jra	00107$
00109$:
	addw	sp, #2
	ret
;	main.c: 20: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #34
;	main.c: 24: int vzd=5,Kvzd=18,count=0,w=0,q=0;
	clrw	x
	ldw	(0x17, sp), x
	clrw	x
	ldw	(0x13, sp), x
;	main.c: 25: int ustavka=280;								
	ldw	x, #0x0118
	ldw	(0x11, sp), x
;	main.c: 26: int lcd=0;								
	clrw	x
	ldw	(0x0b, sp), x
;	main.c: 29: float result=0.0,oldresult=0.0,k=0.2,Nresult=0.0;							
	clrw	x
	ldw	(0x03, sp), x
	ldw	(0x01, sp), x
;	main.c: 32: Init_HSI();
	call	_Init_HSI
;	main.c: 33: GPIO_init();
	call	_GPIO_init
;	main.c: 34: ADC_INIT();
	call	_ADC_INIT
;	main.c: 37: while(1)
00126$:
;	main.c: 39: PC_ODR=0x00;
	mov	0x500a+0, #0x00
;	main.c: 40: PG_ODR=0x00;
	mov	0x501e+0, #0x00
;	main.c: 41: PD_ODR&=~((1<<4) |(1<<3)|(1<<2));
	ldw	x, #0x500f
	ld	a, (x)
	and	a, #0xe3
	ld	(x), a
;	main.c: 42: delay(32);
	push	#0x20
	push	#0x00
	call	_delay
	addw	sp, #2
;	main.c: 43: adc_data=ADC_read();						
	call	_ADC_read
;	main.c: 44: result=(k*adc_data)+(1-k)*oldresult;
	pushw	x
	call	___sint2fs
	addw	sp, #2
	pushw	x
	pushw	y
	push	#0xcd
	push	#0xcc
	push	#0x4c
	push	#0x3e
	call	___fsmul
	addw	sp, #8
	ldw	(0x1d, sp), x
	ldw	(0x1b, sp), y
	ldw	x, (0x03, sp)
	pushw	x
	ldw	x, (0x03, sp)
	pushw	x
	push	#0xcd
	push	#0xcc
	push	#0x4c
	push	#0x3f
	call	___fsmul
	addw	sp, #8
	pushw	x
	pushw	y
	ldw	x, (0x21, sp)
	pushw	x
	ldw	x, (0x21, sp)
	pushw	x
	call	___fsadd
	addw	sp, #8
	ldw	(0x07, sp), x
	ldw	(0x05, sp), y
;	main.c: 45: oldresult=result;
	ldw	y, (0x07, sp)
	ldw	(0x03, sp), y
	ldw	y, (0x05, sp)
	ldw	(0x01, sp), y
;	main.c: 46: Nresult=result+((ustavka>>1)-23);
	ldw	x, (0x11, sp)
	sraw	x
	subw	x, #0x0017
	pushw	x
	call	___sint2fs
	addw	sp, #2
	pushw	x
	pushw	y
	ldw	x, (0x0b, sp)
	pushw	x
	ldw	x, (0x0b, sp)
	pushw	x
	call	___fsadd
	addw	sp, #8
	ldw	(0x0f, sp), x
	ldw	(0x0d, sp), y
;	main.c: 47: vzd=(ustavka-Nresult)*4+16;
	ldw	x, (0x11, sp)
	pushw	x
	call	___sint2fs
	addw	sp, #2
	ldw	(0x21, sp), x
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x25, sp)
	pushw	x
	pushw	y
	call	___fssub
	addw	sp, #8
	pushw	x
	pushw	y
	clrw	x
	pushw	x
	push	#0x80
	push	#0x40
	call	___fsmul
	addw	sp, #8
	push	#0x00
	push	#0x00
	push	#0x80
	push	#0x41
	pushw	x
	pushw	y
	call	___fsadd
	addw	sp, #8
	pushw	x
	pushw	y
	call	___fs2sint
	addw	sp, #4
	ldw	(0x19, sp), x
;	main.c: 48: if(vzd>100)vzd=100;
	ldw	x, (0x19, sp)
	cpw	x, #0x0064
	jrsle	00102$
	ldw	x, #0x0064
	ldw	(0x19, sp), x
00102$:
;	main.c: 49: if(vzd<4)vzd=4;
	ldw	x, (0x19, sp)
	cpw	x, #0x0004
	jrsge	00104$
	ldw	x, #0x0004
	ldw	(0x19, sp), x
00104$:
;	main.c: 50: if(count<=0)count=24,lcd=Nresult; 
	ldw	x, (0x17, sp)
	cpw	x, #0x0000
	jrsgt	00106$
	ldw	x, #0x0018
	ldw	(0x17, sp), x
	ldw	x, (0x0f, sp)
	pushw	x
	ldw	x, (0x0f, sp)
	pushw	x
	call	___fs2sint
	addw	sp, #4
	ldw	(0x0b, sp), x
00106$:
;	main.c: 53: bit_h(PE_ODR,0);
	ldw	x, #0x5014
	ld	a, (x)
	or	a, #0x01
	ld	(x), a
;	main.c: 54: for(period=0;period<100;period++)
	clrw	x
	ldw	(0x09, sp), x
00128$:
;	main.c: 56: if(period==vzd)bit_l(PE_ODR,0);
	ldw	x, (0x09, sp)
	cpw	x, (0x19, sp)
	jrne	00108$
	ldw	x, #0x5014
	ld	a, (x)
	and	a, #0xfe
	ld	(x), a
00108$:
;	main.c: 57: if(period==20||period==60||period==100||period==140||period==180||period==220)out7seg(lcd);
	ldw	x, (0x09, sp)
	cpw	x, #0x0014
	jreq	00109$
	ldw	x, (0x09, sp)
	cpw	x, #0x003c
	jreq	00109$
	ldw	x, (0x09, sp)
	cpw	x, #0x0064
	jreq	00109$
	ldw	x, (0x09, sp)
	cpw	x, #0x008c
	jreq	00109$
	ldw	x, (0x09, sp)
	cpw	x, #0x00b4
	jreq	00109$
	ldw	x, (0x09, sp)
	cpw	x, #0x00dc
	jrne	00110$
00109$:
	ldw	x, (0x0b, sp)
	pushw	x
	call	_out7seg
	addw	sp, #2
00110$:
;	main.c: 58: delay(2);
	push	#0x02
	push	#0x00
	call	_delay
	addw	sp, #2
;	main.c: 59: w=(PD_IDR&((1<<7)|(1<<6)));
	ldw	x, #0x5010
	ld	a, (x)
	and	a, #0xc0
	clrw	x
	ld	xl, a
	ldw	(0x15, sp), x
;	main.c: 60: if(w==0&&q==64&&ustavka<500) ustavka=ustavka+5,count=400,lcd=ustavka;
	ldw	x, (0x15, sp)
	jrne	00117$
	ldw	x, (0x13, sp)
	cpw	x, #0x0040
	jrne	00117$
	ldw	x, (0x11, sp)
	cpw	x, #0x01f4
	jrsge	00117$
	ldw	x, (0x11, sp)
	addw	x, #0x0005
	ldw	(0x11, sp), x
	ldw	x, #0x0190
	ldw	(0x17, sp), x
	ldw	y, (0x11, sp)
	ldw	(0x0b, sp), y
00117$:
;	main.c: 61: if(w==0&&q==128&&ustavka>200) ustavka=ustavka-5,count=400,lcd=ustavka;
	ldw	x, (0x15, sp)
	jrne	00121$
	ldw	x, (0x13, sp)
	cpw	x, #0x0080
	jrne	00121$
	ldw	x, (0x11, sp)
	cpw	x, #0x00c8
	jrsle	00121$
	ldw	x, (0x11, sp)
	subw	x, #0x0005
	ldw	(0x11, sp), x
	ldw	x, #0x0190
	ldw	(0x17, sp), x
	ldw	y, (0x11, sp)
	ldw	(0x0b, sp), y
00121$:
;	main.c: 62: q=w;
	ldw	y, (0x15, sp)
	ldw	(0x13, sp), y
;	main.c: 54: for(period=0;period<100;period++)
	ldw	x, (0x09, sp)
	incw	x
	ldw	(0x09, sp), x
	ldw	x, (0x09, sp)
	cpw	x, #0x0064
	jrsge	00239$
	jp	00128$
00239$:
;	main.c: 64: bit_l(PE_ODR,0);
	bres	0x5014, #0
;	main.c: 65: count--;
	ldw	x, (0x17, sp)
	decw	x
	ldw	(0x17, sp), x
	jp	00126$
	addw	sp, #34
	ret
	.area CODE
	.area INITIALIZER
__xinit__q:
	.dw #0x0000
	.area CABS (ABS)
