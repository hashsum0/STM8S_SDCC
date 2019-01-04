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
	.globl _test
	.globl _rx
	.globl _tx
	.globl _uart1_init
	.globl _GPIO_init
	.globl _clk_init
	.globl _q
	.globl _x
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_x::
	.ds 2
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
;	inc/gpio_init.h: 16: PD_DDR = 0x3F;   
	mov	0x5011+0, #0x3f
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
;	inc/uart1.h: 2: void uart1_init()
;	-----------------------------------------
;	 function uart1_init
;	-----------------------------------------
_uart1_init:
;	inc/uart1.h: 4: PD_DDR&=~(1<<6);  
	ldw	x, #0x5011
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
;	inc/uart1.h: 5: PD_DDR|=(1<<5);    
	ldw	x, #0x5011
	ld	a, (x)
	or	a, #0x20
	ld	(x), a
;	inc/uart1.h: 6: PD_CR1&=~(1<<6);  
	ldw	x, #0x5012
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
;	inc/uart1.h: 7: PD_CR2&=~(1<<6);         
	ldw	x, #0x5013
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
;	inc/uart1.h: 8: UART1_CR2|=UART1_CR2_REN;
	ldw	x, #0x5235
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
;	inc/uart1.h: 9: UART1_CR2|=UART1_CR2_TEN;  
	ldw	x, #0x5235
	ld	a, (x)
	or	a, #0x08
	ld	(x), a
;	inc/uart1.h: 10: UART1_BRR2 = 0x00;             
	mov	0x5233+0, #0x00
;	inc/uart1.h: 11: UART1_BRR1 = 0x48;            
	mov	0x5232+0, #0x48
	ret
;	inc/uart1.h: 13: void tx(char *str)
;	-----------------------------------------
;	 function tx
;	-----------------------------------------
_tx:
;	inc/uart1.h: 17: while (!(UART1_SR & UART1_SR_TXE)) {}       
	ldw	x, (0x03, sp)
00101$:
	ldw	y, #0x5230
	ld	a, (y)
	tnz	a
	jrpl	00101$
;	inc/uart1.h: 18: UART1_DR=*str; 
	ld	a, (x)
	ldw	y, #0x5231
	ld	(y), a
;	inc/uart1.h: 19: if(*str=='\r') break;
	ld	a, (x)
	cp	a, #0x0d
	jrne	00126$
	ret
00126$:
;	inc/uart1.h: 20: *str++;
	incw	x
	jra	00101$
	ret
;	inc/uart1.h: 24: void rx(char *str)
;	-----------------------------------------
;	 function rx
;	-----------------------------------------
_rx:
;	inc/uart1.h: 26: char r=0;
	clr	a
;	inc/uart1.h: 27: while (r!='\r')
	ldw	y, (0x03, sp)
00104$:
	cp	a, #0x0d
	jrne	00127$
	ret
00127$:
;	inc/uart1.h: 29: UART1_SR&=~(1<<5); 
	ldw	x, #0x5230
	ld	a, (x)
	and	a, #0xdf
	ld	(x), a
;	inc/uart1.h: 30: while ((UART1_SR & UART1_SR_RXNE)==0)         //Æäåì ïîÿâëåíèÿ áàéòà
00101$:
	ldw	x, #0x5230
	ld	a, (x)
	bcp	a, #0x20
	jrne	00103$
;	inc/uart1.h: 33: __asm__("nop\n");
	nop
	jra	00101$
00103$:
;	inc/uart1.h: 35: r=UART1_DR; 
	ldw	x, #0x5231
	ld	a, (x)
;	inc/uart1.h: 37: *str++=r;
	ld	(y), a
	incw	y
	jra	00104$
	ret
;	inc/uart1.h: 41: void test()
;	-----------------------------------------
;	 function test
;	-----------------------------------------
_test:
;	inc/uart1.h: 44: if(x==0)PC_ODR=2;
	ldw	x, _x+0
	jrne	00102$
	mov	0x500a+0, #0x02
00102$:
;	inc/uart1.h: 45: if(x==1)PC_ODR=4;
	ldw	x, _x+0
	cpw	x, #0x0001
	jrne	00104$
	mov	0x500a+0, #0x04
00104$:
;	inc/uart1.h: 46: if(x==2)PC_ODR=8;
	ldw	x, _x+0
	cpw	x, #0x0002
	jrne	00106$
	mov	0x500a+0, #0x08
00106$:
;	inc/uart1.h: 47: x++;
	ldw	x, _x+0
	incw	x
;	inc/uart1.h: 48: if(x>2) x=0;
	ldw	_x+0, x
	cpw	x, #0x0002
	jrsgt	00134$
	ret
00134$:
	clrw	x
	ldw	_x+0, x
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
;	inc/7sig.h: 14: PC_ODR=0xff;
	mov	0x500a+0, #0xff
;	inc/7sig.h: 15: PD_ODR|=(1<<3)|(1<<1)|(1<<2);
	ldw	x, #0x500f
	ld	a, (x)
	or	a, #0x0e
	ld	(x), a
;	inc/7sig.h: 17: if(q==0) num=(t%1000/100),PD_ODR&=~(1<<1);
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
	and	a, #0xfd
	ld	(x), a
00102$:
;	inc/7sig.h: 18: if(q==1) num=(t%100/10),PD_ODR&=~(1<<2);
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
	and	a, #0xfb
	ld	(x), a
00104$:
;	inc/7sig.h: 19: if(q==2) num=(t%10),PD_ODR&=~(1<<3);
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
	and	a, #0xf7
	ld	(x), a
00106$:
;	inc/7sig.h: 20: q++;
	ldw	x, _q+0
	incw	x
;	inc/7sig.h: 21: if(q>2) q=0;
	ldw	_q+0, x
	cpw	x, #0x0002
	jrsle	00108$
	clrw	x
	ldw	_q+0, x
00108$:
;	inc/7sig.h: 22: switch (num)
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
;	inc/7sig.h: 24: case 0:   
00109$:
;	inc/7sig.h: 25: segA,segB,segC,segD,segE,segF;
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
	and	a, #0xef
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0x7f
	ld	(x), a
;	inc/7sig.h: 26: break;
	jp	00121$
;	inc/7sig.h: 27: case 1:   
00110$:
;	inc/7sig.h: 28: segB,segC;
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xf7
	ld	(x), a
;	inc/7sig.h: 29: break;
	jp	00121$
;	inc/7sig.h: 30: case 2:   
00111$:
;	inc/7sig.h: 31: segA,segB,segG,segD,segE;
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
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
;	inc/7sig.h: 32: break;
	jp	00121$
;	inc/7sig.h: 33: case 3:   
00112$:
;	inc/7sig.h: 34: segA,segB,segC,segD,segG;
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
;	inc/7sig.h: 35: break;
	jp	00121$
;	inc/7sig.h: 36: case 4:   
00113$:
;	inc/7sig.h: 37: segF,segB,segG,segC;
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
;	inc/7sig.h: 38: break;
	jp	00121$
;	inc/7sig.h: 39: case 5:   
00114$:
;	inc/7sig.h: 40: segA,segC,segD,segF,segG;
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
;	inc/7sig.h: 41: break;
	jp	00121$
;	inc/7sig.h: 42: case 6:   
00115$:
;	inc/7sig.h: 43: segA,segC,segD,segE,segF,segG;
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
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xef
	ld	(x), a
	bres	0x500a, #7
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
;	inc/7sig.h: 44: break;
	jra	00121$
;	inc/7sig.h: 45: case 7:   
00116$:
;	inc/7sig.h: 46: segA,segB,segC;
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
;	inc/7sig.h: 47: break;
	jra	00121$
;	inc/7sig.h: 48: case 8:   
00117$:
;	inc/7sig.h: 49: segA,segB,segC,segD,segE,segF,segG;
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
	and	a, #0xef
	ld	(x), a
	bres	0x500a, #7
	ldw	x, #0x500a
	ld	a, (x)
	and	a, #0xbf
	ld	(x), a
;	inc/7sig.h: 50: break;
	jra	00121$
;	inc/7sig.h: 51: case 9:   
00118$:
;	inc/7sig.h: 52: segA,segB,segC,segD,segF,segG;
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
;	inc/7sig.h: 56: }
00121$:
	addw	sp, #2
	ret
;	main.c: 7: void delay(int t)
;	-----------------------------------------
;	 function delay
;	-----------------------------------------
_delay:
	sub	sp, #2
;	main.c: 10: for(i=0;i<t;i++)
	clrw	x
00107$:
	cpw	x, (0x05, sp)
	jrsge	00109$
;	main.c: 12: for(s=0;s<1512;s++)
	ldw	y, #0x05e8
	ldw	(0x01, sp), y
00105$:
	ldw	y, (0x01, sp)
	decw	y
	ldw	(0x01, sp), y
	tnzw	y
	jrne	00105$
;	main.c: 10: for(i=0;i<t;i++)
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
	sub	sp, #8
;	main.c: 21: int z=0,q=0,w=0,cont=0;
	clrw	x
	ldw	(0x07, sp), x
	clrw	x
	ldw	(0x05, sp), x
	clrw	x
	ldw	(0x01, sp), x
;	main.c: 22: clk_init();
	call	_clk_init
;	main.c: 23: GPIO_init();
	call	_GPIO_init
;	main.c: 25: while(1)
00118$:
;	main.c: 27: if(cont==48)
	ldw	x, (0x01, sp)
	cpw	x, #0x0030
	jrne	00110$
;	main.c: 29: w=(PD_IDR&((1<<7)|(1<<6)));
	ldw	x, #0x5010
	ld	a, (x)
	and	a, #0xc0
	clrw	x
	ld	xl, a
;	main.c: 30: if(w==192&&q==64&&z<500) z++;
	ldw	(0x03, sp), x
	cpw	x, #0x00c0
	jrne	00170$
	ld	a, #0x01
	.byte 0x21
00170$:
	clr	a
00171$:
	tnz	a
	jreq	00102$
	ldw	x, (0x05, sp)
	cpw	x, #0x0040
	jrne	00102$
	ldw	x, (0x07, sp)
	cpw	x, #0x01f4
	jrsge	00102$
	ldw	x, (0x07, sp)
	incw	x
	ldw	(0x07, sp), x
00102$:
;	main.c: 31: if(w==192&&q==128&&z>0) z--;
	tnz	a
	jreq	00106$
	ldw	x, (0x05, sp)
	cpw	x, #0x0080
	jrne	00106$
	ldw	x, (0x07, sp)
	cpw	x, #0x0000
	jrsle	00106$
	ldw	x, (0x07, sp)
	decw	x
	ldw	(0x07, sp), x
00106$:
;	main.c: 32: q=w;
	ldw	y, (0x03, sp)
	ldw	(0x05, sp), y
;	main.c: 33: w=0;
00110$:
;	main.c: 35: if(cont<=48)cont++;
	ldw	x, (0x01, sp)
	cpw	x, #0x0030
	jrsgt	00112$
	ldw	x, (0x01, sp)
	incw	x
	ldw	(0x01, sp), x
00112$:
;	main.c: 36: if(cont>48)cont=0;
	ldw	x, (0x01, sp)
	cpw	x, #0x0030
	jrsle	00114$
	clrw	x
	ldw	(0x01, sp), x
00114$:
;	main.c: 37: if(cont==48)out7seg(z);
	ldw	x, (0x01, sp)
	cpw	x, #0x0030
	jrne	00118$
	ldw	x, (0x07, sp)
	pushw	x
	call	_out7seg
	addw	sp, #2
	jra	00118$
	addw	sp, #8
	ret
	.area CODE
	.area INITIALIZER
__xinit__x:
	.dw #0x0000
__xinit__q:
	.dw #0x0000
	.area CABS (ABS)
