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
	.globl _out7seg
	.globl _ADC_read
	.globl _ADC_INIT
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
;	inc/clk_init.h: 7: void clk_init(void){    
;	-----------------------------------------
;	 function clk_init
;	-----------------------------------------
_clk_init:
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
	ret
;	inc/gpio_init.h: 2: void GPIO_init(void)
;	-----------------------------------------
;	 function GPIO_init
;	-----------------------------------------
_GPIO_init:
;	inc/gpio_init.h: 5: PA_DDR = 0xFF;                                                        //_______PORT_IN
	mov	0x5002+0, #0xff
;	inc/gpio_init.h: 6: PA_CR1 = 0xFF;                                                       //_______DDR________________CR1______________CR2___________FUNCTION  
	mov	0x5003+0, #0xff
;	inc/gpio_init.h: 7: PA_CR2 = 0x00;                                                      //_______0__________________0________________0_____________bez podtiyzhki,bez prerbIvanii 
	mov	0x5004+0, #0x00
;	inc/gpio_init.h: 9: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
	mov	0x5007+0, #0x00
;	inc/gpio_init.h: 10: PB_CR1 = 0x00;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
	mov	0x5008+0, #0x00
;	inc/gpio_init.h: 11: PB_CR2 = 0x00;                                                      //_______PORT_OUT
	mov	0x5009+0, #0x00
;	inc/gpio_init.h: 13: PC_DDR = 0xFF;                                                        //_______1__________________0________________0_____________otkritiy stok
	mov	0x500c+0, #0xff
;	inc/gpio_init.h: 14: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
	mov	0x500d+0, #0xff
;	inc/gpio_init.h: 15: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
	mov	0x500e+0, #0x00
;	inc/gpio_init.h: 17: PD_DDR = 0x3F;   
	mov	0x5011+0, #0x3f
;	inc/gpio_init.h: 18: PD_CR1 = 0xFF;  
	mov	0x5012+0, #0xff
;	inc/gpio_init.h: 19: PD_CR2 = 0x00; 
	mov	0x5013+0, #0x00
;	inc/gpio_init.h: 21: PE_DDR = 0xFF;   
	mov	0x5016+0, #0xff
;	inc/gpio_init.h: 22: PE_CR1 = 0xFF;  
	mov	0x5017+0, #0xff
;	inc/gpio_init.h: 23: PE_CR2 = 0x00; 
	mov	0x5018+0, #0x00
;	inc/gpio_init.h: 25: PF_DDR = 0xFF;   
	mov	0x501b+0, #0xff
;	inc/gpio_init.h: 26: PF_CR1 = 0xFF;  
	mov	0x501c+0, #0xff
;	inc/gpio_init.h: 27: PF_CR2 = 0x00; 
	mov	0x501d+0, #0x00
;	inc/gpio_init.h: 29: PG_DDR = 0xFF;   
	mov	0x5020+0, #0xff
;	inc/gpio_init.h: 30: PG_CR1 = 0xFF;  
	mov	0x5021+0, #0xff
;	inc/gpio_init.h: 31: PG_CR2 = 0x00; 
	mov	0x5022+0, #0x00
	ret
;	inc/ADC.h: 51: void ADC_INIT(void){
;	-----------------------------------------
;	 function ADC_INIT
;	-----------------------------------------
_ADC_INIT:
;	inc/ADC.h: 52: ADC_CSR_CH0;           //Выбераем канал
	ldw	x, #0x5400
	ld	a, (x)
	and	a, #0xf0
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
;	inc/ADC.h: 61: for(t=0;t<64;t++){
	ldw	(0x03, sp), x
	ldw	y, x
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
;	inc/ADC.h: 67: return data;
	addw	sp, #4
	ret
;	inc/7sig.h: 11: void out7seg(volatile int t,volatile int q)
;	-----------------------------------------
;	 function out7seg
;	-----------------------------------------
_out7seg:
	sub	sp, #2
;	inc/7sig.h: 13: int num=0;
	clrw	x
	ldw	(0x01, sp), x
;	inc/7sig.h: 14: PC_ODR=0xff;
	mov	0x500a+0, #0xff
;	inc/7sig.h: 15: PE_ODR|=(1<<0)|(1<<1)|(1<<2);
	ldw	x, #0x5014
	ld	a, (x)
	or	a, #0x07
	ld	(x), a
;	inc/7sig.h: 17: if(q==0) num=(t%1000/100),PD_ODR&=~(1<<1);
	ldw	x, (0x07, sp)
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
	and	a, #0xfd
	ld	(x), a
00102$:
;	inc/7sig.h: 18: if(q==1) num=(t%100/10),PD_ODR&=~(1<<2);
	ldw	x, (0x07, sp)
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
	and	a, #0xfb
	ld	(x), a
00104$:
;	inc/7sig.h: 19: if(q==2) num=(t%10),PD_ODR&=~(1<<0);
	ldw	x, (0x07, sp)
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
	and	a, #0xfe
	ld	(x), a
00106$:
;	inc/7sig.h: 20: switch (num)
	tnz	(0x01, sp)
	jrpl	00148$
	jp	00119$
00148$:
	ldw	x, (0x01, sp)
	cpw	x, #0x0009
	jrsle	00149$
	jp	00119$
00149$:
	ldw	x, (0x01, sp)
	sllw	x
	ldw	x, (#00150$, x)
	jp	(x)
00150$:
	.dw	#00107$
	.dw	#00108$
	.dw	#00109$
	.dw	#00110$
	.dw	#00111$
	.dw	#00112$
	.dw	#00113$
	.dw	#00114$
	.dw	#00115$
	.dw	#00116$
;	inc/7sig.h: 22: case 0:   
00107$:
;	inc/7sig.h: 23: segA,segB,segC,segD,segE,segF;
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
	ldw	x, #0x501e
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0x7f
	ld	(x), a
;	inc/7sig.h: 24: break;
	jp	00119$
;	inc/7sig.h: 25: case 1:   
00108$:
;	inc/7sig.h: 26: segB,segC;
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
;	inc/7sig.h: 27: break;
	jp	00119$
;	inc/7sig.h: 28: case 2:   
00109$:
;	inc/7sig.h: 29: segA,segB,segG,segD,segE;
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
	ldw	x, #0x501e
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	inc/7sig.h: 30: break;
	jp	00119$
;	inc/7sig.h: 31: case 3:   
00110$:
;	inc/7sig.h: 32: segA,segB,segC,segD,segG;
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
;	inc/7sig.h: 33: break;
	jp	00119$
;	inc/7sig.h: 34: case 4:   
00111$:
;	inc/7sig.h: 35: segF,segB,segG,segC;
	bres	0x500a, #7
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
;	inc/7sig.h: 36: break;
	jp	00119$
;	inc/7sig.h: 37: case 5:   
00112$:
;	inc/7sig.h: 38: segA,segC,segD,segF,segG;
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
	bres	0x500a, #7
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
;	inc/7sig.h: 39: break;
	jp	00119$
;	inc/7sig.h: 40: case 6:   
00113$:
;	inc/7sig.h: 41: segA,segC,segD,segE,segF,segG;
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
	ldw	x, #0x501e
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
	bres	0x500a, #7
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
;	inc/7sig.h: 42: break;
	jra	00119$
;	inc/7sig.h: 43: case 7:   
00114$:
;	inc/7sig.h: 44: segA,segB,segC;
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
;	inc/7sig.h: 45: break;
	jra	00119$
;	inc/7sig.h: 46: case 8:   
00115$:
;	inc/7sig.h: 47: segA,segB,segC,segD,segE,segF,segG;
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
	ldw	x, #0x501e
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
	bres	0x500a, #7
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
;	inc/7sig.h: 48: break;
	jra	00119$
;	inc/7sig.h: 49: case 9:   
00116$:
;	inc/7sig.h: 50: segA,segB,segC,segD,segF,segG;
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
	bres	0x500a, #7
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
;	inc/7sig.h: 54: }
00119$:
	addw	sp, #2
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
;	main.c: 13: for(s=0;s<1512;s++)
	ldw	y, #0x05e8
	ldw	(0x01, sp), y
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
	addw	sp, #2
	ret
;	main.c: 20: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	main.c: 24: clk_init();
	call	_clk_init
;	main.c: 25: GPIO_init();
	call	_GPIO_init
;	main.c: 28: while(1)
00102$:
;	main.c: 30: bit1(PD_ODR,2);
	ldw	x, #0x500f
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
;	main.c: 31: delay(100);
	push	#0x64
	push	#0x00
	call	_delay
	addw	sp, #2
;	main.c: 32: bit0(PD_ODR,2);
	ldw	x, #0x500f
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
;	main.c: 33: delay(100);
	push	#0x64
	push	#0x00
	call	_delay
	addw	sp, #2
	jra	00102$
	ret
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
