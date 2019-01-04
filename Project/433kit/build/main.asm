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
	.globl _EXTI
	.globl _TIM2_update
	.globl _GPIO_init
	.globl _clk_init
	.globl _timer
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_timer::
	.ds 1
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
	int 0x000000 ; trap
	int 0x000000 ; int0
	int 0x000000 ; int1
	int 0x000000 ; int2
	int 0x000000 ; int3
	int _EXTI ; int4
	int 0x000000 ; int5
	int 0x000000 ; int6
	int 0x000000 ; int7
	int 0x000000 ; int8
	int 0x000000 ; int9
	int 0x000000 ; int10
	int 0x000000 ; int11
	int 0x000000 ; int12
	int _TIM2_update ; int13
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
;	inc/gpio_init.h: 40: }
	ret
;	main.c: 7: INTERRUPT_HANDLER(TIM2_update,TIM2_OVR_UIF_IRQ)
;	-----------------------------------------
;	 function TIM2_update
;	-----------------------------------------
_TIM2_update:
;	main.c: 9: timer=1;
	mov	_timer+0, #0x01
;	main.c: 10: TIM2_SR1&=~TIM_SR1_UIF;
	bres	21252, #0
;	main.c: 11: }
	iret
;	main.c: 13: INTERRUPT_HANDLER(EXTI,4)         
;	-----------------------------------------
;	 function EXTI
;	-----------------------------------------
_EXTI:
;	main.c: 15: TIM2_CR1 |= TIM_CR1_CEN;
	bset	21248, #0
;	main.c: 16: }
	iret
;	main.c: 18: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #5
;	main.c: 20: unsigned char resiver=0;
	clr	(0x03, sp)
;	main.c: 21: unsigned char i=0;
	clr	(0x05, sp)
;	main.c: 23: unsigned char startrx=0;
	clr	(0x04, sp)
;	main.c: 24: clk_init();
	call	_clk_init
;	main.c: 25: GPIO_init();
	call	_GPIO_init
;	main.c: 26: TIM2_PSCR = 8;
	mov	0x530e+0, #0x08
;	main.c: 27: TIM2_ARRH = 0x00;
	mov	0x530f+0, #0x00
;	main.c: 28: TIM2_ARRL = 0xff;//880uS
	mov	0x5310+0, #0xff
;	main.c: 29: TIM2_CR1 |= TIM_CR1_OPM; 
	bset	21248, #3
;	main.c: 30: TIM2_IER |= TIM_IER_UIE;
	ld	a, 0x5303
	or	a, #0x01
	ld	0x5303, a
;	main.c: 31: EXTI_CR1=4;//00: Падающий фронт и низкий уровень/01: только передний край/10: только падающая кромка/11: Восходящий и опускающийся край
	mov	0x50a0+0, #0x04
;	main.c: 32: __asm__("rim\n");
	rim
;	main.c: 33: PD_ODR=0x00;
	mov	0x500f+0, #0x00
;	main.c: 36: while(!(timer)){
00101$:
	tnz	_timer+0
	jrne	00103$
;	main.c: 37: PD_ODR^=(1<<7),t=0;
	bcpl	20495, #7
	jra	00101$
00103$:
;	main.c: 41: timer=0;
	clr	_timer+0
;	main.c: 42: TIM2_ARRH = 0x00;
	mov	0x530f+0, #0x00
;	main.c: 44: if(PB_IDR&(1<<7) && !startrx)
	ld	a, 0x5006
	and	a, #0x80
	ld	(0x02, sp), a
	jreq	00112$
	tnz	(0x04, sp)
	jrne	00112$
;	main.c: 45: startrx=1,
	ld	a, #0x01
	ld	(0x04, sp), a
;	main.c: 46: TIM2_ARRL = 0xaf;
	mov	0x5310+0, #0xaf
	jra	00113$
00112$:
;	main.c: 48: resiver|=(1<<i),
	ld	a, (0x05, sp)
	ld	xh, a
	ld	a, (0x03, sp)
	ld	(0x01, sp), a
;	main.c: 49: i++;
	ld	a, (0x05, sp)
	inc	a
	ld	xl, a
;	main.c: 48: resiver|=(1<<i),
	ld	a, #0x01
	push	a
	ld	a, xh
	tnz	a
	jreq	00202$
00201$:
	sll	(1, sp)
	dec	a
	jrne	00201$
00202$:
	pop	a
;	main.c: 47: else if(PB_IDR&(1<<7) && startrx)
	tnz	(0x02, sp)
	jreq	00108$
	tnz	(0x04, sp)
	jreq	00108$
;	main.c: 48: resiver|=(1<<i),
	or	a, (0x01, sp)
	ld	(0x03, sp), a
;	main.c: 49: i++;
	exg	a, xl
	ld	(0x05, sp), a
	exg	a, xl
	jra	00113$
00108$:
;	main.c: 50: else if(!(PB_IDR&(1<<7)) && startrx)
	tnz	(0x02, sp)
	jrne	00113$
	tnz	(0x04, sp)
	jreq	00113$
;	main.c: 51: resiver&=~(1<<i),
	cpl	a
	and	a, (0x01, sp)
	ld	(0x03, sp), a
;	main.c: 52: i++;
	exg	a, xl
	ld	(0x05, sp), a
	exg	a, xl
00113$:
;	main.c: 54: if(i>=8){
	ld	a, (0x05, sp)
	cp	a, #0x08
	jrc	00101$
;	main.c: 55: i=0;
	clr	(0x05, sp)
;	main.c: 56: startrx=0;
	clr	(0x04, sp)
;	main.c: 57: TIM2_ARRL = 0xff;
	mov	0x5310+0, #0xff
;	main.c: 58: if(resiver=='D')
	ld	a, (0x03, sp)
	cp	a, #0x44
	jrne	00124$
;	main.c: 59: PD_ODR=0x01;
	mov	0x500f+0, #0x01
	jp	00101$
00124$:
;	main.c: 60: else if(resiver=='A')
	ld	a, (0x03, sp)
	cp	a, #0x41
	jrne	00121$
;	main.c: 61: PD_ODR=0x10;
	mov	0x500f+0, #0x10
	jp	00101$
00121$:
;	main.c: 62: else if(resiver=='B')
	ld	a, (0x03, sp)
	cp	a, #0x42
	jrne	00118$
;	main.c: 63: PD_ODR=0x04;
	mov	0x500f+0, #0x04
	jp	00101$
00118$:
;	main.c: 64: else if(resiver=='C')
	ld	a, (0x03, sp)
	cp	a, #0x43
	jreq	00219$
	jp	00101$
00219$:
;	main.c: 65: PD_ODR=0x08;
	mov	0x500f+0, #0x08
;	main.c: 68: }
	jp	00101$
	.area CODE
	.area CONST
	.area INITIALIZER
__xinit__timer:
	.db #0x00	; 0
	.area CABS (ABS)
