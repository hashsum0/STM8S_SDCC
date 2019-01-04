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
	.globl _rx
	.globl _tx
	.globl _uart1_init
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
;	inc/clk_init.h: 7: void Init_HSE(){    
;	-----------------------------------------
;	 function Init_HSE
;	-----------------------------------------
_Init_HSE:
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
;	inc/clk_init.h: 15: CLK_CCOR=0; // CLK_CCOR|=(1<<2)|(1<<0);
	mov	0x50c9+0, #0x00
;	inc/clk_init.h: 16: }
	ret
;	inc/clk_init.h: 18: void Init_HSI()
;	-----------------------------------------
;	 function Init_HSI
;	-----------------------------------------
_Init_HSI:
;	inc/clk_init.h: 20: CLK_ICKR = 0; // Сбрасываем регистр внутреннего тактирования
	mov	0x50c0+0, #0x00
;	inc/clk_init.h: 21: CLK_ICKR|=(1<<0); // Включаем внутренний генератор HSI
	bset	20672, #0
;	inc/clk_init.h: 22: CLK_ECKR = 0; // Отключаем внешний генератор
	mov	0x50c1+0, #0x00
;	inc/clk_init.h: 23: while ((CLK_ICKR&(1<<1))== 0); // Ждём стабилизации внутреннего генератора
00101$:
	ld	a, 0x50c0
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
	ld	a, 0x50c5
	srl	a
	jrc	00104$
;	inc/clk_init.h: 33: }
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
;	inc/gpio_init.h: 32: PB_CR1 = 0xff;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
	mov	0x5008+0, #0xff
;	inc/gpio_init.h: 33: PB_CR2 = 0x00;                                                      //_______PORT_OUT
	mov	0x5009+0, #0x00
;	inc/gpio_init.h: 35: PC_DDR = 0xff;                                                        //_______1__________________0________________0_____________otkritiy stok
	mov	0x500c+0, #0xff
;	inc/gpio_init.h: 36: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
	mov	0x500d+0, #0xff
;	inc/gpio_init.h: 37: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
	mov	0x500e+0, #0x00
;	inc/gpio_init.h: 39: PD_DDR = 0xFF;   
	mov	0x5011+0, #0xff
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
;	inc/uart1.h: 1: void uart1_init()
;	-----------------------------------------
;	 function uart1_init
;	-----------------------------------------
_uart1_init:
;	inc/uart1.h: 3: PD_DDR&=~(1<<6);  
	bres	20497, #6
;	inc/uart1.h: 4: PD_DDR|=(1<<5);             
	bset	20497, #5
;	inc/uart1.h: 5: UART1_CR2|=UART1_CR2_REN;
	bset	21045, #2
;	inc/uart1.h: 6: UART1_CR2|=UART1_CR2_TEN;  
	bset	21045, #3
;	inc/uart1.h: 7: UART1_BRR2 = 0x00;             
	mov	0x5233+0, #0x00
;	inc/uart1.h: 8: UART1_BRR1 = 0x48;            
	mov	0x5232+0, #0x48
;	inc/uart1.h: 9: }
	ret
;	inc/uart1.h: 10: void tx(char *str)
;	-----------------------------------------
;	 function tx
;	-----------------------------------------
_tx:
;	inc/uart1.h: 14: while (!(UART1_SR & UART1_SR_TXE)) {}       
	ldw	x, (0x03, sp)
00101$:
	ld	a, 0x5230
	jrpl	00101$
;	inc/uart1.h: 15: UART1_DR=*str; 
	ld	a, (x)
	ld	0x5231, a
;	inc/uart1.h: 16: if(*str=='\r') break;
	ld	a, (x)
	cp	a, #0x0d
	jrne	00129$
	ret
00129$:
;	inc/uart1.h: 17: *str++;
	incw	x
	jra	00101$
;	inc/uart1.h: 20: } 
	ret
;	inc/uart1.h: 21: void rx(char *str)
;	-----------------------------------------
;	 function rx
;	-----------------------------------------
_rx:
;	inc/uart1.h: 23: while (*str!='\r')
00104$:
	ldw	x, (0x03, sp)
	ld	a, (x)
	cp	a, #0x0d
	jrne	00129$
	ret
00129$:
;	inc/uart1.h: 26: while ((UART1_SR & UART1_SR_RXNE)!=0)         //Æäåì ïîÿâëåíèÿ áàéòà
00101$:
	ld	a, 0x5230
	bcp	a, #0x20
	jreq	00104$
;	inc/uart1.h: 28: *str++;
	incw	x
	ldw	(0x03, sp), x
;	inc/uart1.h: 29: *str=UART1_DR; 
	ld	a, 0x5231
	ld	(x), a
	jra	00101$
;	inc/uart1.h: 32: } 
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
;	main.c: 11: for(s=0;s<512;s++)
	clr	(0x02, sp)
	ld	a, #0x02
	ld	(0x01, sp), a
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
;	main.c: 15: }
	addw	sp, #2
	ret
;	main.c: 17: void main(void){
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	main.c: 19: Init_HSE();
	call	_Init_HSE
;	main.c: 21: gpio_init();
	call	_gpio_init
;	main.c: 22: uart1_init();
	call	_uart1_init
;	main.c: 23: while(1){
00102$:
;	main.c: 24: tx("test\n\r");
	push	#<___str_0
	push	#(___str_0 >> 8)
	call	_tx
	addw	sp, #2
;	main.c: 25: delay(2000);
	push	#0xd0
	push	#0x07
	call	_delay
	addw	sp, #2
	jra	00102$
;	main.c: 28: }
	ret
	.area CODE
	.area CONST
___str_0:
	.ascii "test"
	.db 0x0a
	.db 0x0d
	.db 0x00
	.area INITIALIZER
	.area CABS (ABS)
