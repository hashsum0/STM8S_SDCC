;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.5 #9426 (Linux)
;--------------------------------------------------------
	.module main
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _delay
	.globl _out7seg
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
	ret
;	inc/7sig.h: 23: void out7seg(volatile int t,volatile int q)
;	-----------------------------------------
;	 function out7seg
;	-----------------------------------------
_out7seg:
	sub	sp, #25
;	inc/7sig.h: 27: unsigned int x[10]={num0, num1, num2, num3, num4, num5, num6, num7, num8, num9};
	ldw	x, sp
	incw	x
	ldw	(0x18, sp), x
	ldw	x, (0x18, sp)
	ldw	y, #0x00be
	ldw	(x), y
	ldw	x, (0x18, sp)
	incw	x
	incw	x
	ldw	y, #0x000c
	ldw	(x), y
	ldw	x, (0x18, sp)
	ldw	y, #0x0076
	ldw	(0x0004, x), y
	ldw	x, (0x18, sp)
	ldw	y, #0x006e
	ldw	(0x0006, x), y
	ldw	x, (0x18, sp)
	ldw	y, #0x00cc
	ldw	(0x0008, x), y
	ldw	x, (0x18, sp)
	ldw	y, #0x00ea
	ldw	(0x000a, x), y
	ldw	x, (0x18, sp)
	ldw	y, #0x00fa
	ldw	(0x000c, x), y
	ldw	x, (0x18, sp)
	ldw	y, #0x000e
	ldw	(0x000e, x), y
	ldw	x, (0x18, sp)
	ldw	y, #0x00fe
	ldw	(0x0010, x), y
	ldw	x, (0x18, sp)
	ldw	y, #0x00ee
	ldw	(0x0012, x), y
;	inc/7sig.h: 33: SEGPORT=0xff;
	mov	0x500a+0, #0xff
;	inc/7sig.h: 34: NSEGPORT|=(1<<3)|(1<<1)|(1<<2);
	ldw	x, #0x500f
	ld	a, (x)
	or	a, #0x0e
	ld	(x), a
;	inc/7sig.h: 35: nseg(q);
	ldw	x, (0x1e, sp)
	jrne	00102$
	ldw	x, #0x500f
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
00102$:
	ldw	x, (0x1e, sp)
	cpw	x, #0x0001
	jrne	00104$
	ldw	x, #0x500f
	ld	a, (x)
	and	a, #0xfd
	ld	(x), a
00104$:
	ldw	x, (0x1e, sp)
	cpw	x, #0x0002
	jrne	00106$
	ldw	x, #0x500f
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
00106$:
;	inc/7sig.h: 36: if(q==0) SEGPORT&=~(x[t%1000/100]);
	ldw	x, (0x1e, sp)
	jrne	00108$
	ldw	x, #0x500a
	ld	a, (x)
	ld	(0x17, sp), a
	push	#0xe8
	push	#0x03
	ldw	x, (0x1e, sp)
	pushw	x
	call	__modsint
	addw	sp, #4
	push	#0x64
	push	#0x00
	pushw	x
	call	__divsint
	addw	sp, #4
	sllw	x
	addw	x, (0x18, sp)
	ldw	x, (x)
	ld	a, xl
	cpl	a
	and	a, (0x17, sp)
	ldw	x, #0x500a
	ld	(x), a
00108$:
;	inc/7sig.h: 37: if(q==1) SEGPORT&=~(x[t%100/10]);
	ldw	x, (0x1e, sp)
	cpw	x, #0x0001
	jrne	00110$
	ldw	x, #0x500a
	ld	a, (x)
	ld	(0x16, sp), a
	push	#0x64
	push	#0x00
	ldw	x, (0x1e, sp)
	pushw	x
	call	__modsint
	addw	sp, #4
	push	#0x0a
	push	#0x00
	pushw	x
	call	__divsint
	addw	sp, #4
	sllw	x
	addw	x, (0x18, sp)
	ldw	x, (x)
	ld	a, xl
	cpl	a
	and	a, (0x16, sp)
	ldw	x, #0x500a
	ld	(x), a
00110$:
;	inc/7sig.h: 38: if(q==2) SEGPORT&=~(x[t%10]);
	ldw	x, (0x1e, sp)
	cpw	x, #0x0002
	jrne	00113$
	ldw	x, #0x500a
	ld	a, (x)
	ld	(0x15, sp), a
	push	#0x0a
	push	#0x00
	ldw	x, (0x1e, sp)
	pushw	x
	call	__modsint
	addw	sp, #4
	sllw	x
	addw	x, (0x18, sp)
	ldw	x, (x)
	ld	a, xl
	cpl	a
	and	a, (0x15, sp)
	ldw	x, #0x500a
	ld	(x), a
00113$:
	addw	sp, #25
	ret
;	main.c: 46: void delay(int t)
;	-----------------------------------------
;	 function delay
;	-----------------------------------------
_delay:
	sub	sp, #2
;	main.c: 49: for(i=0;i<t;i++)
	clrw	y
00107$:
	exgw	x, y
	cpw	x, (0x05, sp)
	exgw	x, y
	jrsge	00109$
;	main.c: 51: for(s=0;s<1512;s++)
	ldw	x, #0x05e8
	ldw	(0x01, sp), x
00105$:
	ldw	x, (0x01, sp)
	decw	x
	ldw	(0x01, sp), x
	tnzw	x
	jrne	00105$
;	main.c: 49: for(i=0;i<t;i++)
	incw	y
	jra	00107$
00109$:
	addw	sp, #2
	ret
;	main.c: 59: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #70
;	main.c: 61: int f=0,d=0,w=0,q=0,fl1=0,fl2=0,fl3=0,fl4=0,fl5=0,fl6=0,fl7=0;
	clrw	x
	ldw	(0x11, sp), x
	clrw	x
	ldw	(0x13, sp), x
	clrw	x
	ldw	(0x0f, sp), x
	clrw	x
	ldw	(0x0d, sp), x
	clrw	x
	ldw	(0x0b, sp), x
	clrw	x
	ldw	(0x1f, sp), x
	clrw	x
	ldw	(0x1d, sp), x
	clrw	x
	ldw	(0x1b, sp), x
	clrw	x
	ldw	(0x19, sp), x
;	main.c: 62: unsigned int os[3]={0,0,0};
	ldw	x, sp
	addw	x, #5
	ldw	(0x25, sp), x
	ldw	x, (0x25, sp)
	clr	(0x1, x)
	clr	(x)
	ldw	x, (0x25, sp)
	incw	x
	incw	x
	clr	(0x1, x)
	clr	(x)
	ldw	x, (0x25, sp)
	addw	x, #0x0004
	clr	(0x1, x)
	clr	(x)
;	main.c: 63: long b=0;
	clrw	x
	ldw	(0x03, sp), x
	ldw	(0x01, sp), x
;	main.c: 64: clk_init();
	call	_clk_init
;	main.c: 66: GPIO_init();
	call	_GPIO_init
;	main.c: 70: d=0;
	clrw	x
	ldw	(0x17, sp), x
;	main.c: 73: while(1)
00163$:
;	main.c: 77: if((b&(1<<5))!=0&&fl1==0)
	ld	a, (0x04, sp)
	and	a, #0x20
	ld	(0x2a, sp), a
	clrw	x
	ldw	(0x28, sp), x
	clr	(0x27, sp)
	ldw	x, (0x29, sp)
	jrne	00315$
	ldw	x, (0x27, sp)
	jreq	00113$
00315$:
	ldw	x, (0x0f, sp)
	jrne	00113$
;	main.c: 79: w=(PB_IDR&((1<<0)|(1<<1)));
	ldw	x, #0x5006
	ld	a, (x)
	and	a, #0x03
	clrw	x
	ld	xl, a
	ldw	(0x15, sp), x
;	main.c: 80: if(w==0&&q==2&&f<998) f=f+1;
	ldw	x, (0x15, sp)
	jrne	00102$
	ldw	x, (0x13, sp)
	cpw	x, #0x0002
	jrne	00102$
	ldw	x, (0x11, sp)
	cpw	x, #0x03e6
	jrsge	00102$
	ldw	x, (0x11, sp)
	incw	x
	ldw	(0x11, sp), x
00102$:
;	main.c: 81: if(w==0&&q==1&&f>0) f=f-1;
	ldw	x, (0x15, sp)
	jrne	00106$
	ldw	x, (0x13, sp)
	cpw	x, #0x0001
	jrne	00106$
	ldw	x, (0x11, sp)
	cpw	x, #0x0000
	jrsle	00106$
	ldw	x, (0x11, sp)
	decw	x
	ldw	(0x11, sp), x
00106$:
;	main.c: 82: q=w;
	ldw	y, (0x15, sp)
	ldw	(0x13, sp), y
;	main.c: 84: fl1=1;
	ldw	x, #0x0001
	ldw	(0x0f, sp), x
	jra	00114$
00113$:
;	main.c: 86: else if((b&(1<<5))==0&&fl1==1)fl1=0;
	ldw	x, (0x29, sp)
	jrne	00114$
	ldw	x, (0x27, sp)
	jrne	00114$
	ldw	x, (0x0f, sp)
	cpw	x, #0x0001
	jrne	00114$
	clrw	x
	ldw	(0x0f, sp), x
00114$:
;	main.c: 88: if((b&(1<<6))!=0&&fl2==0)
	ld	a, (0x04, sp)
	and	a, #0x40
	ld	(0x32, sp), a
	clrw	x
	ldw	(0x30, sp), x
	clr	(0x2f, sp)
	ldw	x, (0x31, sp)
	jrne	00332$
	ldw	x, (0x2f, sp)
	jreq	00122$
00332$:
	ldw	x, (0x0d, sp)
	jrne	00122$
;	main.c: 90: out7seg(f,d);
	ldw	x, (0x17, sp)
	pushw	x
	ldw	x, (0x13, sp)
	pushw	x
	call	_out7seg
	addw	sp, #4
;	main.c: 91: if((d++)>2)d=0;
	ldw	y, (0x17, sp)
	ldw	x, (0x17, sp)
	incw	x
	ldw	(0x17, sp), x
	cpw	y, #0x0002
	jrsle	00117$
	clrw	x
	ldw	(0x17, sp), x
00117$:
;	main.c: 92: fl2=1;
	ldw	x, #0x0001
	ldw	(0x0d, sp), x
	jra	00123$
00122$:
;	main.c: 94: else if((b&(1<<6))==0&&fl2==1)fl2=0;
	ldw	x, (0x31, sp)
	jrne	00123$
	ldw	x, (0x2f, sp)
	jrne	00123$
	ldw	x, (0x0d, sp)
	cpw	x, #0x0001
	jrne	00123$
	clrw	x
	ldw	(0x0d, sp), x
00123$:
;	main.c: 96: if((b&((1<<13)|(1<<14)|(1<<15)))!=0&&fl3==0)PD_ODR^=(1<<0),fl3=1;
	clr	(0x2e, sp)
	ld	a, (0x03, sp)
	and	a, #0xe0
	ld	(0x2d, sp), a
	ldw	y, (0x01, sp)
	ldw	(0x2b, sp), y
	ldw	x, (0x2d, sp)
	jrne	00340$
	ldw	x, (0x2b, sp)
	jreq	00129$
00340$:
	ldw	x, (0x0b, sp)
	jrne	00129$
	bcpl	0x500f, #0
	ldw	x, #0x0001
	ldw	(0x0b, sp), x
	jra	00130$
00129$:
;	main.c: 97: else if((b&((1<<13)|(1<<14)|(1<<15)))==0&&fl3==1)fl3=0;
	ldw	x, (0x2d, sp)
	jrne	00130$
	ldw	x, (0x2b, sp)
	jrne	00130$
	ldw	x, (0x0b, sp)
	cpw	x, #0x0001
	jrne	00130$
	clrw	x
	ldw	(0x0b, sp), x
00130$:
;	main.c: 99: if((b&(1<<14))!=0&&fl4==0)PD_ODR^=(1<<4),fl4=1;
	clr	(0x42, sp)
	ld	a, (0x03, sp)
	and	a, #0x40
	ld	(0x41, sp), a
	clrw	x
	ldw	(0x3f, sp), x
	ldw	x, (0x41, sp)
	jrne	00347$
	ldw	x, (0x3f, sp)
	jreq	00136$
00347$:
	ldw	x, (0x1f, sp)
	jrne	00136$
	ldw	x, #0x500f
	ld	a, (x)
	xor	a, #0x10
	ld	(x), a
	ldw	x, #0x0001
	ldw	(0x1f, sp), x
	jra	00137$
00136$:
;	main.c: 100: else if((b&(1<<14))==0&&fl4==1)fl4=0;
	ldw	x, (0x41, sp)
	jrne	00137$
	ldw	x, (0x3f, sp)
	jrne	00137$
	ldw	x, (0x1f, sp)
	cpw	x, #0x0001
	jrne	00137$
	clrw	x
	ldw	(0x1f, sp), x
00137$:
;	main.c: 102: if((b&(1<<13))!=0&&fl5==0)PD_ODR^=(1<<5),fl5=1;
	clr	(0x36, sp)
	ld	a, (0x03, sp)
	and	a, #0x20
	ld	(0x35, sp), a
	clrw	x
	ldw	(0x33, sp), x
	ldw	x, (0x35, sp)
	jrne	00354$
	ldw	x, (0x33, sp)
	jreq	00143$
00354$:
	ldw	x, (0x1d, sp)
	jrne	00143$
	bcpl	0x500f, #5
	ldw	x, #0x0001
	ldw	(0x1d, sp), x
	jra	00144$
00143$:
;	main.c: 103: else if((b&(1<<13))==0&&fl5==1)fl5=0;
	ldw	x, (0x35, sp)
	jrne	00144$
	ldw	x, (0x33, sp)
	jrne	00144$
	ldw	x, (0x1d, sp)
	cpw	x, #0x0001
	jrne	00144$
	clrw	x
	ldw	(0x1d, sp), x
00144$:
;	main.c: 105: if((b&(1<<12))!=0&&fl6==0)PD_ODR^=(1<<6),fl6=1;
	clr	(0x3a, sp)
	ld	a, (0x03, sp)
	and	a, #0x10
	ld	(0x39, sp), a
	clrw	x
	ldw	(0x37, sp), x
	ldw	x, (0x39, sp)
	jrne	00361$
	ldw	x, (0x37, sp)
	jreq	00150$
00361$:
	ldw	x, (0x1b, sp)
	jrne	00150$
	ldw	x, #0x500f
	ld	a, (x)
	xor	a, #0x40
	ld	(x), a
	ldw	x, #0x0001
	ldw	(0x1b, sp), x
	jra	00151$
00150$:
;	main.c: 106: else if((b&(1<<12))==0&&fl6==1)fl6=0;
	ldw	x, (0x39, sp)
	jrne	00151$
	ldw	x, (0x37, sp)
	jrne	00151$
	ldw	x, (0x1b, sp)
	cpw	x, #0x0001
	jrne	00151$
	clrw	x
	ldw	(0x1b, sp), x
00151$:
;	main.c: 108: if((b&(1<<11))!=0&&fl7==0)PD_ODR^=(1<<7),fl7=1;
	clr	(0x3e, sp)
	ld	a, (0x03, sp)
	and	a, #0x08
	ld	(0x3d, sp), a
	clrw	x
	ldw	y, (0x3d, sp)
	jrne	00368$
	tnzw	x
	jreq	00157$
00368$:
	ldw	y, (0x19, sp)
	jrne	00157$
	ldw	x, #0x500f
	ld	a, (x)
	xor	a, #0x80
	ld	(x), a
	ldw	x, #0x0001
	ldw	(0x19, sp), x
	jra	00158$
00157$:
;	main.c: 109: else if((b&(1<<11))==0&&fl7==1)fl7=0;
	ldw	y, (0x3d, sp)
	jrne	00158$
	tnzw	x
	jrne	00158$
	ldw	x, (0x19, sp)
	cpw	x, #0x0001
	jrne	00158$
	clrw	x
	ldw	(0x19, sp), x
00158$:
;	main.c: 111: if((b++)==65535)b=0;
	ldw	y, (0x03, sp)
	ldw	(0x23, sp), y
	ldw	y, (0x01, sp)
	ldw	x, (0x03, sp)
	addw	x, #0x0001
	ldw	(0x45, sp), x
	ld	a, (0x02, sp)
	adc	a, #0x00
	ld	xl, a
	ld	a, (0x01, sp)
	adc	a, #0x00
	ld	xh, a
	ldw	(0x01, sp), x
	ldw	x, (0x45, sp)
	ldw	(0x03, sp), x
	ldw	x, (0x23, sp)
	cpw	x, #0xffff
	jrne	00376$
	cpw	y, #0x0000
	jreq	00377$
00376$:
	jp	00163$
00377$:
	clrw	x
	ldw	(0x03, sp), x
	ldw	(0x01, sp), x
	jp	00163$
	addw	sp, #70
	ret
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
