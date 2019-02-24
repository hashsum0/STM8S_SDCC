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
	.globl _send_byte
	.globl _tx_stop_bit
	.globl _tx_start_bit
	.globl _tx_cli_bit
	.globl _tx_set_bit
	.globl _tim_wait
	.globl _TIM2_update
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
	int 0x000000 ; int4
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
;	inc/clk_init.h: 15: }
	ret
;	inc/gpio_init.h: 10: void GPIO_init(void)
;	-----------------------------------------
;	 function GPIO_init
;	-----------------------------------------
_GPIO_init:
;	inc/gpio_init.h: 17: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
	mov	0x5007+0, #0x00
;	inc/gpio_init.h: 18: PB_CR1 = 0x00;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
	mov	0x5008+0, #0x00
;	inc/gpio_init.h: 19: PB_CR2 = 0x00;                                                      //_______PORT_OUT
	mov	0x5009+0, #0x00
;	inc/gpio_init.h: 21: PC_DDR = 0x00;                                                        //_______1__________________0________________0_____________otkritiy stok
	mov	0x500c+0, #0x00
;	inc/gpio_init.h: 22: PC_CR1 = 0x00;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
	mov	0x500d+0, #0x00
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
;	main.c: 9: INTERRUPT_HANDLER(TIM2_update,TIM2_OVR_UIF_IRQ)
;	-----------------------------------------
;	 function TIM2_update
;	-----------------------------------------
_TIM2_update:
;	main.c: 11: TIM2_SR1 &= ~TIM_SR1_UIF;
	bres	21252, #0
;	main.c: 12: }
	iret
;	main.c: 13: void tim_wait(unsigned char reg_h, unsigned char reg_l)
;	-----------------------------------------
;	 function tim_wait
;	-----------------------------------------
_tim_wait:
;	main.c: 15: TIM2_ARRH = reg_h;
	ldw	x, #0x530f
	ld	a, (0x03, sp)
	ld	(x), a
;	main.c: 16: TIM2_ARRL = reg_l;
	ldw	x, #0x5310
	ld	a, (0x04, sp)
	ld	(x), a
;	main.c: 17: TIM2_CR1 |= TIM_CR1_CEN;
	ld	a, 0x5300
	or	a, #0x01
	ld	0x5300, a
;	main.c: 18: __asm__("wfi\n");
	wfi
;	main.c: 19: }
	ret
;	main.c: 20: void tx_set_bit()
;	-----------------------------------------
;	 function tx_set_bit
;	-----------------------------------------
_tx_set_bit:
;	main.c: 22: out_set_bit;
	bset	20495, #5
;	main.c: 23: tim_wait(0x00,0x40);//0x00,0x0f
	push	#0x40
	push	#0x00
	call	_tim_wait
	addw	sp, #2
;	main.c: 24: out_cli_bit;
	bres	20495, #5
;	main.c: 25: tim_wait(0x00,0x20);//0x00,0x08
	push	#0x20
	push	#0x00
	call	_tim_wait
	addw	sp, #2
;	main.c: 26: }
	ret
;	main.c: 27: void tx_cli_bit()
;	-----------------------------------------
;	 function tx_cli_bit
;	-----------------------------------------
_tx_cli_bit:
;	main.c: 29: out_set_bit;
	bset	20495, #5
;	main.c: 30: tim_wait(0x00,0x20);//0x00,0x08
	push	#0x20
	push	#0x00
	call	_tim_wait
	addw	sp, #2
;	main.c: 31: out_cli_bit;
	bres	20495, #5
;	main.c: 32: tim_wait(0x00,0x20);//0x00,0x08
	push	#0x20
	push	#0x00
	call	_tim_wait
	addw	sp, #2
;	main.c: 33: }
	ret
;	main.c: 34: void tx_start_bit()
;	-----------------------------------------
;	 function tx_start_bit
;	-----------------------------------------
_tx_start_bit:
;	main.c: 36: out_set_bit;
	bset	20495, #5
;	main.c: 37: tim_wait(0x00,0x80);//0x00,0x47
	push	#0x80
	push	#0x00
	call	_tim_wait
	addw	sp, #2
;	main.c: 38: out_cli_bit;
	bres	20495, #5
;	main.c: 39: tim_wait(0x00,0x20);//0x00,0x08
	push	#0x20
	push	#0x00
	call	_tim_wait
	addw	sp, #2
;	main.c: 40: }
	ret
;	main.c: 41: void tx_stop_bit()
;	-----------------------------------------
;	 function tx_stop_bit
;	-----------------------------------------
_tx_stop_bit:
;	main.c: 43: out_cli_bit;
	bres	20495, #5
;	main.c: 44: tim_wait(0x00,0x80);
	push	#0x80
	push	#0x00
	call	_tim_wait
	addw	sp, #2
;	main.c: 45: }
	ret
;	main.c: 46: void send_byte(unsigned char data)
;	-----------------------------------------
;	 function send_byte
;	-----------------------------------------
_send_byte:
	sub	sp, #4
;	main.c: 49: tx_start_bit();
	call	_tx_start_bit
;	main.c: 50: for(i=0;i<=7;i++)
	clrw	x
	ldw	(0x03, sp), x
00105$:
;	main.c: 52: if(data&(1<<i))tx_set_bit();
	clrw	x
	incw	x
	ld	a, (0x04, sp)
	jreq	00126$
00125$:
	sllw	x
	dec	a
	jrne	00125$
00126$:
	ld	a, (0x07, sp)
	ld	(0x02, sp), a
	clr	(0x01, sp)
	ld	a, xl
	and	a, (0x02, sp)
	rlwa	x
	and	a, (0x01, sp)
	ld	xh, a
	tnzw	x
	jreq	00102$
	call	_tx_set_bit
	jra	00106$
00102$:
;	main.c: 53: else tx_cli_bit();
	call	_tx_cli_bit
00106$:
;	main.c: 50: for(i=0;i<=7;i++)
	ldw	x, (0x03, sp)
	incw	x
	ldw	(0x03, sp), x
	cpw	x, #0x0007
	jrsle	00105$
;	main.c: 55: tx_stop_bit();
	call	_tx_stop_bit
;	main.c: 56: }
	addw	sp, #4
	ret
;	main.c: 57: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	main.c: 59: clk_init();
	call	_clk_init
;	main.c: 60: GPIO_init();
	call	_GPIO_init
;	main.c: 61: TIM2_PSCR = 10;
	mov	0x530e+0, #0x0a
;	main.c: 62: TIM2_CR1|=TIM_CR1_OPM; 
	bset	21248, #3
;	main.c: 63: TIM2_IER |= TIM_IER_UIE;
	bset	21251, #0
;	main.c: 65: while(1)
00110$:
;	main.c: 67: if(!(PC_IDR&(1<<3))){
	ld	a, 0x500b
	bcp	a, #0x08
	jrne	00102$
;	main.c: 68: send_byte('A');
	push	#0x41
	call	_send_byte
	pop	a
00102$:
;	main.c: 70: if(!(PC_IDR&(1<<4))){
	ld	a, 0x500b
	bcp	a, #0x10
	jrne	00104$
;	main.c: 71: send_byte('B');
	push	#0x42
	call	_send_byte
	pop	a
00104$:
;	main.c: 73: if(!(PC_IDR&(1<<5))){
	ld	a, 0x500b
	bcp	a, #0x20
	jrne	00106$
;	main.c: 74: send_byte('C');
	push	#0x43
	call	_send_byte
	pop	a
00106$:
;	main.c: 76: if(!(PC_IDR&(1<<6))){
	ld	a, 0x500b
	bcp	a, #0x40
	jrne	00110$
;	main.c: 77: send_byte('D');
	push	#0x44
	call	_send_byte
	pop	a
	jra	00110$
;	main.c: 81: }
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
