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
	.globl _flag
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_flag::
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
;	main.c: 15: INTERRUPT_HANDLER(TIM2_update,TIM2_OVR_UIF_IRQ){
;	-----------------------------------------
;	 function TIM2_update
;	-----------------------------------------
_TIM2_update:
;	main.c: 16: SetBit(flag,tim_end);
	bset	_flag+0, #1
;	main.c: 17: TIM2_SR1&=~TIM_SR1_UIF;
	bres	21252, #0
;	main.c: 18: }
	iret
;	main.c: 20: INTERRUPT_HANDLER(EXTI,4){
;	-----------------------------------------
;	 function EXTI
;	-----------------------------------------
_EXTI:
;	main.c: 21: SetBit(flag,ext_intrrpt);
	bset	_flag+0, #0
;	main.c: 22: }
	iret
;	main.c: 24: void main(void){
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #2
;	main.c: 25: unsigned char resiver=0;
	clr	a
	ld	xl, a
;	main.c: 26: unsigned char i=0;
	clr	a
	ld	xh, a
;	main.c: 27: clk_init();
	pushw	x
	call	_clk_init
	call	_GPIO_init
	popw	x
;	main.c: 29: TIM2_PSCR = 8;
	mov	0x530e+0, #0x08
;	main.c: 30: TIM2_CR1 |= TIM_CR1_OPM; 
	bset	21248, #3
;	main.c: 31: TIM2_IER |= TIM_IER_UIE;
	ld	a, 0x5303
	or	a, #0x01
	ld	0x5303, a
;	main.c: 32: EXTI_CR1=4;//00: Падающий фронт и низкий уровень/01: только передний край/10: только падающая кромка/11: Восходящий и опускающийся край
	mov	0x50a0+0, #0x04
;	main.c: 33: __asm__("rim\n");
	rim
;	main.c: 34: PD_ODR=0x00;
	mov	0x500f+0, #0x00
;	main.c: 37: while(!(GetBit(flag,startbit))){//wait startbit
00112$:
	btjf	_flag+0, #4, 00257$
	jra	00130$
00257$:
;	main.c: 38: if(GetBit(flag,ext_intrrpt)){
	btjt	_flag+0, #0, 00259$
	jra	00105$
00259$:
;	main.c: 39: if(!(GetBit(flag,tim_count))){
	btjf	_flag+0, #2, 00261$
	jra	00102$
00261$:
;	main.c: 40: TIM2_ARRH = 0x01;
	mov	0x530f+0, #0x01
;	main.c: 41: TIM2_ARRL = 0xdf;  
	mov	0x5310+0, #0xdf
;	main.c: 42: TIM2_CR1 |= TIM_CR1_CEN;
	bset	21248, #0
;	main.c: 43: SetBit(flag,tim_count);
	bset	_flag+0, #2
;	main.c: 44: ClearBit(flag,ext_intrrpt);            
	bres	_flag+0, #0
	jra	00105$
00102$:
;	main.c: 46: SetBit(flag,err_tim_count);
	bset	_flag+0, #3
;	main.c: 47: ClearBit(flag,ext_intrrpt);
	bres	_flag+0, #0
00105$:
;	main.c: 50: if(GetBit(flag,tim_end)){
	btjt	_flag+0, #1, 00263$
	jra	00112$
00263$:
;	main.c: 51: if(!(GetBit(flag,err_tim_count)) && PB_IDR&(1<<7)){
	btjf	_flag+0, #3, 00265$
	jra	00107$
00265$:
	ld	a, 0x5006
	jrpl	00107$
;	main.c: 52: ClearBit(flag,tim_count);
	bres	_flag+0, #2
;	main.c: 53: ClearBit(flag,tim_end);
	bres	_flag+0, #1
;	main.c: 54: SetBit(flag,startbit);
	bset	_flag+0, #4
	jra	00112$
00107$:
;	main.c: 56: ClearBit(flag,tim_end);
	bres	_flag+0, #1
;	main.c: 57: ClearBit(flag,err_tim_count);
	bres	_flag+0, #3
;	main.c: 58: ClearBit(flag,tim_count); 
	bres	_flag+0, #2
	jra	00112$
;	main.c: 63: while(i<8){//wait startbit
00130$:
	ld	a, xh
	cp	a, #0x08
	clr	a
	rlc	a
	jrne	00267$
	jp	00132$
00267$:
;	main.c: 64: if(GetBit(flag,ext_intrrpt)){
	btjt	_flag+0, #0, 00269$
	jra	00119$
00269$:
;	main.c: 65: if(!(GetBit(flag,tim_count))){
	btjf	_flag+0, #2, 00271$
	jra	00116$
00271$:
;	main.c: 66: TIM2_ARRH = 0x00;
	mov	0x530f+0, #0x00
;	main.c: 67: TIM2_ARRL = 0xaf;  
	mov	0x5310+0, #0xaf
;	main.c: 68: TIM2_CR1 |= TIM_CR1_CEN;
	bset	21248, #0
;	main.c: 69: SetBit(flag,tim_count);
	bset	_flag+0, #2
;	main.c: 70: ClearBit(flag,ext_intrrpt);            
	bres	_flag+0, #0
	jra	00119$
00116$:
;	main.c: 72: SetBit(flag,err_tim_count);
	bset	_flag+0, #3
;	main.c: 73: ClearBit(flag,ext_intrrpt);
	bres	_flag+0, #0
00119$:
;	main.c: 76: if(GetBit(flag,tim_end)){
	btjt	_flag+0, #1, 00273$
	jra	00130$
00273$:
;	main.c: 77: if(!(GetBit(flag,err_tim_count)) && PB_IDR&(1<<7)){
	btjf	_flag+0, #3, 00275$
	jra	00125$
00275$:
	ld	a, 0x5006
	jrpl	00125$
;	main.c: 78: resiver|=(1<<i),
	ld	a, xh
	push	a
	ld	a, #0x01
	ld	(0x03, sp), a
	pop	a
	tnz	a
	jreq	00278$
00277$:
	sll	(0x02, sp)
	dec	a
	jrne	00277$
00278$:
	ld	a, xl
	or	a, (0x02, sp)
	ld	xl, a
;	main.c: 79: i++;
	addw	x, #256
;	main.c: 80: ClearBit(flag,tim_count);
	bres	_flag+0, #2
;	main.c: 81: ClearBit(flag,tim_end);
	bres	_flag+0, #1
	jra	00130$
00125$:
;	main.c: 82: }else if(!(GetBit(flag,err_tim_count)) && !(PB_IDR&(1<<7))){
	ld	a, _flag+0
	and	a, #0x08
;	main.c: 53: ClearBit(flag,tim_end);
	push	a
	ld	a, _flag+0
	and	a, #0xfd
	ld	(0x02, sp), a
	pop	a
;	main.c: 82: }else if(!(GetBit(flag,err_tim_count)) && !(PB_IDR&(1<<7))){
	tnz	a
	jrne	00121$
	ld	a, 0x5006
	jrmi	00121$
;	main.c: 83: resiver&=~(1<<i),
	ldw	y, x
	ld	a, #0x01
	push	a
	ld	a, yh
	tnz	a
	jreq	00282$
00281$:
	sll	(1, sp)
	dec	a
	jrne	00281$
00282$:
	pop	a
	cpl	a
	pushw	x
	and	a, (2, sp)
	popw	x
	ld	xl, a
;	main.c: 84: i++;
	addw	x, #256
;	main.c: 85: ClearBit(flag,tim_end);
	ld	a, (0x01, sp)
	ld	_flag+0, a
;	main.c: 86: ClearBit(flag,tim_count);
	bres	_flag+0, #2
	jp	00130$
00121$:
;	main.c: 88: ClearBit(flag,tim_end);
	ld	a, (0x01, sp)
	ld	_flag+0, a
;	main.c: 89: ClearBit(flag,err_tim_count);
	bres	_flag+0, #3
;	main.c: 90: ClearBit(flag,tim_count); 
	bres	_flag+0, #2
	jp	00130$
00132$:
;	main.c: 94: __asm__("sim\n");
	sim
;	main.c: 95: if(i>=8){
	tnz	a
	jrne	00145$
;	main.c: 96: i=0;
	clr	a
	ld	xh, a
;	main.c: 97: ClearBit(flag,startbit);
	bres	_flag+0, #4
;	main.c: 98: if(resiver=='D'){
	ld	a, xl
	cp	a, #0x44
	jrne	00142$
;	main.c: 99: PD_ODR=0x01;
	mov	0x500f+0, #0x01
	jra	00145$
00142$:
;	main.c: 100: }else if(resiver=='A'){
	ld	a, xl
	cp	a, #0x41
	jrne	00139$
;	main.c: 101: PD_ODR=0x10;
	mov	0x500f+0, #0x10
	jra	00145$
00139$:
;	main.c: 102: }else if(resiver=='B'){
	ld	a, xl
	cp	a, #0x42
	jrne	00136$
;	main.c: 103: PD_ODR=0x04;
	mov	0x500f+0, #0x04
	jra	00145$
00136$:
;	main.c: 104: }else if(resiver=='C'){
	ld	a, xl
	cp	a, #0x43
	jrne	00145$
;	main.c: 105: PD_ODR=0x08;
	mov	0x500f+0, #0x08
00145$:
;	main.c: 108: __asm__("rim\n");
	rim
;	main.c: 110: }
	jp	00112$
	.area CODE
	.area CONST
	.area INITIALIZER
__xinit__flag:
	.db #0x00	; 0
	.area CABS (ABS)
