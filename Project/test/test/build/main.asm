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
	.globl _out7seg
	.globl _ADC_read
	.globl _ADC_INIT
	.globl _gpio_init
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
;	inc/gpio_init.h: 39: PD_DDR = 0x3F;   
	mov	0x5011+0, #0x3f
;	inc/gpio_init.h: 40: PD_CR1 = 0xFF;  
	mov	0x5012+0, #0xff
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
;	inc/gpio_init.h: 54: }
	ret
;	inc/ADC.h: 51: void ADC_INIT(void){
;	-----------------------------------------
;	 function ADC_INIT
;	-----------------------------------------
_ADC_INIT:
;	inc/ADC.h: 52: ADC_CSR_CH0;           //Выбераем канал
	ld	a, 0x5400
	and	a, #0xf0
	ld	0x5400, a
;	inc/ADC.h: 53: ADC_CR1_SPSEL8;  //Делитель на 18            
	bset	21505, #6
;	inc/ADC.h: 54: ADC_TDRL_DIS(0);       //Отключаем тригер Шмидта
	bset	21511, #0
;	inc/ADC.h: 55: ADC_CR2_ALIGN_LEFT;    //Выравнивание по левому краю
	bres	21506, #3
;	inc/ADC.h: 56: ADC_CR1_ADON_ON;       //Первый запуск ADC
	bset	21505, #0
;	inc/ADC.h: 57: }
	ret
;	inc/ADC.h: 58: int ADC_read(void){
;	-----------------------------------------
;	 function ADC_read
;	-----------------------------------------
_ADC_read:
;	inc/ADC.h: 60: ADC_CR1_ADON_ON;
	ld	a, 0x5401
	or	a, #0x01
	ld	0x5401, a
;	inc/ADC.h: 61: for(t=0;t<64;t++){
	ldw	y, #0x0040
00104$:
;	inc/ADC.h: 62: __asm__("nop\n");
	nop
	ldw	x, y
	decw	x
	ldw	y, x
;	inc/ADC.h: 61: for(t=0;t<64;t++){
	tnzw	x
	jrne	00104$
;	inc/ADC.h: 64: data=ADC_DRH;
	ld	a, 0x5404
	clrw	x
	ld	xl, a
;	inc/ADC.h: 65: return data;
;	inc/ADC.h: 66: }
	ret
;	inc/7sig.h: 11: void out7seg(volatile int t,volatile int q)
;	-----------------------------------------
;	 function out7seg
;	-----------------------------------------
_out7seg:
;	inc/7sig.h: 13: int num=0;
	clrw	x
;	inc/7sig.h: 14: PC_ODR=0xff;
	mov	0x500a+0, #0xff
;	inc/7sig.h: 15: PD_ODR|=(1<<3)|(1<<1)|(1<<2);
	ld	a, 0x500f
	or	a, #0x0e
	ld	0x500f, a
;	inc/7sig.h: 17: if(q==0) num=(t%1000/100),PD_ODR&=~(1<<1);
	ldw	y, (0x05, sp)
	jrne	00102$
	push	#0xe8
	push	#0x03
	ldw	x, (0x05, sp)
	pushw	x
	call	__modsint
	addw	sp, #4
	push	#0x64
	push	#0x00
	pushw	x
	call	__divsint
	addw	sp, #4
	ld	a, 0x500f
	and	a, #0xfd
	ld	0x500f, a
00102$:
;	inc/7sig.h: 18: if(q==1) num=(t%100/10),PD_ODR&=~(1<<2);
	pushw	x
	ldw	x, (0x07, sp)
	decw	x
	popw	x
	jrne	00104$
	push	#0x64
	push	#0x00
	ldw	x, (0x05, sp)
	pushw	x
	call	__modsint
	addw	sp, #4
	push	#0x0a
	push	#0x00
	pushw	x
	call	__divsint
	addw	sp, #4
	ld	a, 0x500f
	and	a, #0xfb
	ld	0x500f, a
00104$:
;	inc/7sig.h: 19: if(q==2) num=(t%10),PD_ODR&=~(1<<3);
	pushw	x
	ldw	x, (0x07, sp)
	cpw	x, #0x0002
	popw	x
	jrne	00106$
	push	#0x0a
	push	#0x00
	ldw	x, (0x05, sp)
	pushw	x
	call	__modsint
	addw	sp, #4
	ld	a, 0x500f
	and	a, #0xf7
	ld	0x500f, a
00106$:
;	inc/7sig.h: 20: switch (num)
	tnzw	x
	jrpl	00153$
	ret
00153$:
	cpw	x, #0x0009
	jrsle	00154$
	ret
00154$:
	sllw	x
	ldw	x, (#00155$, x)
	jp	(x)
00155$:
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
	bres	20490, #1
	bres	20490, #2
	bres	20490, #3
	bres	20490, #5
	bres	20490, #4
	bres	20490, #7
;	inc/7sig.h: 24: break;
	ret
;	inc/7sig.h: 25: case 1:   
00108$:
;	inc/7sig.h: 26: segB,segC;
	bres	20490, #2
	bres	20490, #3
;	inc/7sig.h: 27: break;
	ret
;	inc/7sig.h: 28: case 2:   
00109$:
;	inc/7sig.h: 29: segA,segB,segG,segD,segE;
	bres	20490, #1
	bres	20490, #2
	bres	20490, #6
	bres	20490, #5
	bres	20490, #4
;	inc/7sig.h: 30: break;
	ret
;	inc/7sig.h: 31: case 3:   
00110$:
;	inc/7sig.h: 32: segA,segB,segC,segD,segG;
	bres	20490, #1
	bres	20490, #2
	bres	20490, #3
	bres	20490, #5
	bres	20490, #6
;	inc/7sig.h: 33: break;
	ret
;	inc/7sig.h: 34: case 4:   
00111$:
;	inc/7sig.h: 35: segF,segB,segG,segC;
	bres	20490, #7
	bres	20490, #2
	bres	20490, #6
	bres	20490, #3
;	inc/7sig.h: 36: break;
	ret
;	inc/7sig.h: 37: case 5:   
00112$:
;	inc/7sig.h: 38: segA,segC,segD,segF,segG;
	bres	20490, #1
	bres	20490, #3
	bres	20490, #5
	bres	20490, #7
	bres	20490, #6
;	inc/7sig.h: 39: break;
	ret
;	inc/7sig.h: 40: case 6:   
00113$:
;	inc/7sig.h: 41: segA,segC,segD,segE,segF,segG;
	bres	20490, #1
	bres	20490, #3
	bres	20490, #5
	bres	20490, #4
	bres	20490, #7
	bres	20490, #6
;	inc/7sig.h: 42: break;
	ret
;	inc/7sig.h: 43: case 7:   
00114$:
;	inc/7sig.h: 44: segA,segB,segC;
	bres	20490, #1
	bres	20490, #2
	bres	20490, #3
;	inc/7sig.h: 45: break;
	ret
;	inc/7sig.h: 46: case 8:   
00115$:
;	inc/7sig.h: 47: segA,segB,segC,segD,segE,segF,segG;
	bres	20490, #1
	bres	20490, #2
	bres	20490, #3
	bres	20490, #5
	bres	20490, #4
	bres	20490, #7
	bres	20490, #6
;	inc/7sig.h: 48: break;
	ret
;	inc/7sig.h: 49: case 9:   
00116$:
;	inc/7sig.h: 50: segA,segB,segC,segD,segF,segG;
	bres	20490, #1
	bres	20490, #2
	bres	20490, #3
	bres	20490, #5
	bres	20490, #7
	bres	20490, #6
;	inc/7sig.h: 54: }
;	inc/7sig.h: 56: }
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
;	main.c: 13: __asm__("nop\n");
	nop
	ldw	y, (0x01, sp)
	decw	y
	ldw	(0x01, sp), y
;	main.c: 11: for(s=0;s<1512;s++)
	tnzw	y
	jrne	00105$
;	main.c: 9: for(i=0;i<t;i++)
	incw	x
	jra	00107$
00109$:
;	main.c: 16: }
	addw	sp, #2
	ret
;	main.c: 18: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #18
;	main.c: 20: int f=150,w=0,s=0,t=0,q=0,counter=0,ironON=200,ironOFF=55,format_data=0,oldadc=0,adc_data=0;
	ldw	x, #0x0096
	ldw	(0x0b, sp), x
	clrw	x
	ldw	(0x0d, sp), x
	clrw	x
	ldw	(0x11, sp), x
	clrw	x
	ldw	(0x0f, sp), x
	ldw	x, #0x00c8
	ldw	(0x09, sp), x
	ldw	x, #0x0037
	ldw	(0x07, sp), x
	clrw	x
	ldw	(0x05, sp), x
	clrw	x
	ldw	(0x01, sp), x
;	main.c: 21: clk_init();
	call	_clk_init
;	main.c: 22: gpio_init();
	call	_gpio_init
;	main.c: 23: ADC_INIT();
	call	_ADC_INIT
;	main.c: 24: while(1)
00136$:
;	main.c: 26: if(counter<=32) counter++;
	ldw	x, (0x0f, sp)
	cpw	x, #0x0020
	jrsgt	00102$
	ldw	x, (0x0f, sp)
	incw	x
	ldw	(0x0f, sp), x
00102$:
;	main.c: 27: if(counter>32) counter=0;
	ldw	x, (0x0f, sp)
	cpw	x, #0x0020
	jrsle	00104$
	clrw	x
	ldw	(0x0f, sp), x
00104$:
;	main.c: 28: if((counter&(1<<2))!=0)
	ld	a, (0x10, sp)
	bcp	a, #0x04
	jreq	00118$
;	main.c: 30: out7seg(format_data,t);
	ldw	x, (0x0d, sp)
	pushw	x
	ldw	x, (0x07, sp)
	pushw	x
	call	_out7seg
	addw	sp, #4
;	main.c: 31: w=(PD_IDR&((1<<7)|(1<<6)));
	ld	a, 0x5010
	and	a, #0xc0
	clrw	x
	ld	xl, a
	ldw	(0x03, sp), x
;	main.c: 32: if(w==128&&q==192&&f<500)   f=f+1;
	ldw	x, (0x11, sp)
	cpw	x, #0x00c0
	jrne	00249$
	ld	a, #0x01
	.byte 0x21
00249$:
	clr	a
00250$:
	ldw	x, (0x03, sp)
	cpw	x, #0x0080
	jrne	00106$
	tnz	a
	jreq	00106$
	ldw	x, (0x0b, sp)
	cpw	x, #0x01f4
	jrsge	00106$
	ldw	x, (0x0b, sp)
	incw	x
	ldw	(0x0b, sp), x
00106$:
;	main.c: 33: if(w==64&&q==192&&f>0)    f=f-1;
	ldw	x, (0x03, sp)
	cpw	x, #0x0040
	jrne	00110$
	tnz	a
	jreq	00110$
	ldw	x, (0x0b, sp)
	cpw	x, #0x0000
	jrsle	00110$
	ldw	x, (0x0b, sp)
	decw	x
	ldw	(0x0b, sp), x
00110$:
;	main.c: 34: q=w;
	ldw	y, (0x03, sp)
	ldw	(0x11, sp), y
;	main.c: 36: if(t<=2)t++;
	ldw	x, (0x0d, sp)
	cpw	x, #0x0002
	jrsgt	00114$
	ldw	x, (0x0d, sp)
	incw	x
	ldw	(0x0d, sp), x
00114$:
;	main.c: 37: if(t>2)t=0;
	ldw	x, (0x0d, sp)
	cpw	x, #0x0002
	jrsle	00118$
	clrw	x
	ldw	(0x0d, sp), x
00118$:
;	main.c: 40: if(counter==8||counter==16||counter==24)
	ldw	x, (0x0f, sp)
	cpw	x, #0x0008
	jreq	00131$
	ldw	x, (0x0f, sp)
	cpw	x, #0x0010
	jreq	00131$
	ldw	x, (0x0f, sp)
	cpw	x, #0x0018
	jreq	00271$
	jp	00136$
00271$:
00131$:
;	main.c: 43: if(ironON!=0)
	ldw	x, (0x09, sp)
	jreq	00120$
;	main.c: 45: PD_ODR|=(1<<0);
	ld	a, 0x500f
	or	a, #0x01
	ld	0x500f, a
;	main.c: 46: --ironON;
	ldw	x, (0x09, sp)
	decw	x
	ldw	(0x09, sp), x
00120$:
;	main.c: 49: if(ironON==0&&ironOFF!=0)
	ldw	x, (0x09, sp)
	jrne	00122$
	ldw	x, (0x07, sp)
	jreq	00122$
;	main.c: 51: PD_ODR&=~(1<<0);
	ld	a, 0x500f
	and	a, #0xfe
	ld	0x500f, a
;	main.c: 52: --ironOFF;
	ldw	x, (0x07, sp)
	decw	x
	ldw	(0x07, sp), x
00122$:
;	main.c: 55: if(ironON==0&&ironOFF==0)
	ldw	x, (0x09, sp)
	jreq	00275$
	jp	00136$
00275$:
	ldw	x, (0x07, sp)
	jreq	00276$
	jp	00136$
00276$:
;	main.c: 57: adc_data=ADC_read();
	call	_ADC_read
;	main.c: 58: adc_data=adc_data+oldadc;
	addw	x, (0x01, sp)
;	main.c: 59: adc_data=adc_data>>1;
	sraw	x
;	main.c: 60: format_data=adc_data;
	ldw	(0x05, sp), x
;	main.c: 61: oldadc=adc_data;
	ldw	(0x01, sp), x
;	main.c: 63: ironON=f-format_data;
	negw	x
	addw	x, (0x0b, sp)
;	main.c: 64: if(ironON>120)ironON=120;
	ldw	(0x09, sp), x
	cpw	x, #0x0078
	jrsle	00125$
	ldw	x, #0x0078
	ldw	(0x09, sp), x
00125$:
;	main.c: 65: if(ironON<0)ironON=0;
	tnz	(0x09, sp)
	jrpl	00127$
	clrw	x
	ldw	(0x09, sp), x
00127$:
;	main.c: 66: ironOFF=128-ironON;
	ldw	x, #0x0080
	subw	x, (0x09, sp)
	ldw	(0x07, sp), x
;	main.c: 71: }
	jp	00136$
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
