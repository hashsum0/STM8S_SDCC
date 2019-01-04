;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.9 #10207 (Linux)
;--------------------------------------------------------
	.module main
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _EXTI_PORTC_IRQHandler
	.globl _TIM2_OVR_UIF
	.globl _delay
	.globl _DelayUs
	.globl _resive_ir
	.globl _DelayMs
	.globl _IR_dec_init
	.globl _GPIO_init
	.globl _clk_init_HSI
	.globl _clk_init_HSE
	.globl _i
	.globl _flag
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_resive_ir_oldcode_1_20:
	.ds 2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_flag::
	.ds 2
_i::
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
	int s_GSINIT ; reset
	int 0x0000 ; trap
	int 0x0000 ; int0
	int 0x0000 ; int1
	int 0x0000 ; int2
	int 0x0000 ; int3
	int 0x0000 ; int4
	int _EXTI_PORTC_IRQHandler ; int5
	int 0x0000 ; int6
	int 0x0000 ; int7
	int 0x0000 ; int8
	int 0x0000 ; int9
	int 0x0000 ; int10
	int 0x0000 ; int11
	int 0x0000 ; int12
	int _TIM2_OVR_UIF ; int13
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
;	inc/IR_decoder.h: 39: static int oldcode = 0;
	clrw	x
	ldw	_resive_ir_oldcode_1_20+0, x
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
;	inc/clk_init.h: 7: void clk_init_HSE(void){    
;	-----------------------------------------
;	 function clk_init_HSE
;	-----------------------------------------
_clk_init_HSE:
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
;	inc/clk_init.h: 16: }
	ret
;	inc/clk_init.h: 18: void clk_init_HSI()
;	-----------------------------------------
;	 function clk_init_HSI
;	-----------------------------------------
_clk_init_HSI:
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
;	inc/gpio_init.h: 10: PB_CR2 = 0x00;                                                      //_______PORT_OUT
	mov	0x5009+0, #0x00
;	inc/gpio_init.h: 12: PC_DDR = 0x00;                                                        //_______1__________________0________________0_____________otkritiy stok
	mov	0x500c+0, #0x00
;	inc/gpio_init.h: 13: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
	mov	0x500d+0, #0xff
;	inc/gpio_init.h: 14: PC_CR2 = 0xFF;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
	mov	0x500e+0, #0xff
;	inc/gpio_init.h: 16: PD_DDR = 0xFF;   
	mov	0x5011+0, #0xff
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
;	inc/gpio_init.h: 31: }
	ret
;	inc/IR_decoder.h: 9: void IR_dec_init()
;	-----------------------------------------
;	 function IR_dec_init
;	-----------------------------------------
_IR_dec_init:
;	inc/IR_decoder.h: 11: PB_DDR&=~(1<<7);
	bres	20487, #7
;	inc/IR_decoder.h: 12: }
	ret
;	inc/IR_decoder.h: 13: void DelayMs(int t)
;	-----------------------------------------
;	 function DelayMs
;	-----------------------------------------
_DelayMs:
	sub	sp, #2
;	inc/IR_decoder.h: 16: for(i=0;i<t;i++)
	clrw	x
00107$:
	cpw	x, (0x05, sp)
	jrsge	00109$
;	inc/IR_decoder.h: 18: for(s=0;s<5;s++)
	ldw	y, #0x0005
	ldw	(0x01, sp), y
00105$:
	ldw	y, (0x01, sp)
	decw	y
	ldw	(0x01, sp), y
	tnzw	y
	jrne	00105$
;	inc/IR_decoder.h: 16: for(i=0;i<t;i++)
	incw	x
	jra	00107$
00109$:
;	inc/IR_decoder.h: 22: }
	addw	sp, #2
	ret
;	inc/IR_decoder.h: 23: static char delta_t(void){
;	-----------------------------------------
;	 function delta_t
;	-----------------------------------------
_delta_t:
	sub	sp, #2
;	inc/IR_decoder.h: 26: while(is_0());  // ���� ��������� 1 � �����
00101$:
	ld	a, 0x5006
	tnz	a
	jrpl	00101$
	ld	a, #0x0a
	ld	(0x02, sp), a
00108$:
;	inc/IR_decoder.h: 27: for( ; i; i--){              // ���� �� ����������!!!
	tnz	(0x02, sp)
	jreq	00106$
;	inc/IR_decoder.h: 28: DelayMs(100);         // ��������� �� 100 ���
	push	#0x64
	push	#0x00
	call	_DelayMs
	addw	sp, #2
;	inc/IR_decoder.h: 30: if(is_0()) break;       // ���������� ����� ��� 0 �� �����
	ld	a, 0x5006
	tnz	a
	jrpl	00106$
;	inc/IR_decoder.h: 27: for( ; i; i--){              // ���� �� ����������!!!
	dec	(0x02, sp)
	jra	00108$
00106$:
;	inc/IR_decoder.h: 32: return END_100us - i;        // ���������� ��������
	ld	a, (0x02, sp)
	ld	(0x01, sp), a
	ld	a, #0x0a
	sub	a, (0x01, sp)
;	inc/IR_decoder.h: 33: }
	addw	sp, #2
	ret
;	inc/IR_decoder.h: 35: int resive_ir(void){
;	-----------------------------------------
;	 function resive_ir
;	-----------------------------------------
_resive_ir:
	sub	sp, #3
;	inc/IR_decoder.h: 36: int code = 0;
	clrw	x
;	inc/IR_decoder.h: 40: PD_ODR &= ~(1<<0);
	bres	20495, #0
;	inc/IR_decoder.h: 41: while(is_1());// ������������� � ������� ��������
00101$:
	ld	a, 0x5006
	tnz	a
	jrmi	00101$
;	inc/IR_decoder.h: 43: for(i = MAX_BIT_CNT; i; i--){
	ld	a, #0x24
	ld	(0x03, sp), a
00112$:
;	inc/IR_decoder.h: 44: code =code<< 1;                  // ������� ��������� ����� ����
	sllw	x
;	inc/IR_decoder.h: 45: delta = delta_t();  // �������� ������������ 1 � �����
	pushw	x
	call	_delta_t
	popw	x
	clrw	y
	ld	yl, a
	ldw	(0x01, sp), y
;	inc/IR_decoder.h: 46: if((delta >= END_100us)) break;                   // ���� ������� ����� - ����� ������            
	pushw	x
	ldw	x, (0x03, sp)
	cpw	x, #0x000a
	popw	x
	jrsge	00108$
;	inc/IR_decoder.h: 47: if(delta > LOG0_100us) code |= 1;             // ���� ����� 1 - ������� � ��� 1      
	pushw	x
	ldw	x, (0x03, sp)
	cpw	x, #0x0001
	popw	x
	jrsle	00113$
	srlw	x
	scf
	rlcw	x
00113$:
;	inc/IR_decoder.h: 43: for(i = MAX_BIT_CNT; i; i--){
	ld	a, (0x03, sp)
	dec	a
	ld	(0x03, sp), a
	tnz	a
	jrne	00112$
00108$:
;	inc/IR_decoder.h: 49: if((code > 0) && (code < 5)) return oldcode;      
	cpw	x, #0x0000
	jrsle	00110$
	cpw	x, #0x0005
	jrsge	00110$
	ldw	x, _resive_ir_oldcode_1_20+0
	jra	00114$
00110$:
;	inc/IR_decoder.h: 50: oldcode = code;      
	ldw	_resive_ir_oldcode_1_20+0, x
;	inc/IR_decoder.h: 51: return code;                       // ����������, ��� ����������
00114$:
;	inc/IR_decoder.h: 52: } 
	addw	sp, #3
	ret
;	main.c: 11: void DelayUs(unsigned int msec)
;	-----------------------------------------
;	 function DelayUs
;	-----------------------------------------
_DelayUs:
;	main.c: 14: for(x=0; x<=msec;x++);
	clrw	x
00103$:
	incw	x
	cpw	x, (0x03, sp)
	jrule	00103$
;	main.c: 15: }
	ret
;	main.c: 17: void delay(int sec)
;	-----------------------------------------
;	 function delay
;	-----------------------------------------
_delay:
;	main.c: 20: for(t=0;t<=sec;t++)
	clrw	x
00103$:
	cpw	x, (0x03, sp)
	jrsle	00116$
	ret
00116$:
;	main.c: 22: DelayMs(25000);
	pushw	x
	push	#0xa8
	push	#0x61
	call	_DelayMs
	addw	sp, #2
	push	#0xa8
	push	#0x61
	call	_DelayMs
	addw	sp, #2
	popw	x
;	main.c: 20: for(t=0;t<=sec;t++)
	incw	x
	jra	00103$
;	main.c: 25: }
	ret
;	main.c: 27: INTERRUPT_HANDLER( TIM2_OVR_UIF, 13)           //обработчик прерывания по переполнению таймера 
;	-----------------------------------------
;	 function TIM2_OVR_UIF
;	-----------------------------------------
_TIM2_OVR_UIF:
;	main.c: 29: if(flag==1) UPR_PIN_ON;                      
	ldw	x, _flag+0
	decw	x
	jrne	00102$
	bset	20495, #2
00102$:
;	main.c: 30: TIM2_SR1&=~(1<<0);
	bres	21252, #0
;	main.c: 31: DelayUs(200);
	push	#0xc8
	push	#0x00
	call	_DelayUs
	addw	sp, #2
;	main.c: 32: UPR_PIN_OFF; 
	bres	20495, #2
;	main.c: 33: }
	iret
;	main.c: 35: INTERRUPT_HANDLER( EXTI_PORTC_IRQHandler, 5) //обработчик прерывания датчика перехода нуля
;	-----------------------------------------
;	 function EXTI_PORTC_IRQHandler
;	-----------------------------------------
_EXTI_PORTC_IRQHandler:
;	main.c: 38: TIM2_ARRH=i;           
	ld	a, _i+1
	ld	0x530f, a
;	main.c: 39: TIM2_ARRL=0x00; 
	mov	0x5310+0, #0x00
;	main.c: 40: TIM2_CR1|=(1<<0);                       //CEN-запускаем таймер
	bset	21248, #0
;	main.c: 41: }
	iret
;	main.c: 44: int main( void )
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	main.c: 48: clk_init_HSE();                                   //инициируем все что нужно
	call	_clk_init_HSE
;	main.c: 49: __asm__("sim");
	sim
;	main.c: 50: GPIO_init();
	call	_GPIO_init
;	main.c: 52: EXTI_CR1|=(1<<4); //PCIS=01
	bset	20640, #4
;	main.c: 54: TIM2_PSCR=0x01;
	mov	0x530e+0, #0x01
;	main.c: 55: TIM2_ARRH=0xd6;           
	mov	0x530f+0, #0xd6
;	main.c: 56: TIM2_ARRL=0x00;
	mov	0x5310+0, #0x00
;	main.c: 57: TIM2_CR1|=(1<<3); //OPM
	bset	21248, #3
;	main.c: 58: TIM2_IER|=(1<<0); //UIE
	ld	a, 0x5303
	or	a, #0x01
	ld	0x5303, a
;	main.c: 60: IR_dec_init();
	call	_IR_dec_init
;	main.c: 61: __asm__("rim");
	rim
;	main.c: 63: delay(5);                                         //этот кусок кода-плавное включение света
	push	#0x05
	push	#0x00
	call	_delay
	addw	sp, #2
;	main.c: 64: for(i=0xd6;i>0x6b;i--)
	ldw	x, #0x00d6
	ldw	_i+0, x
00119$:
;	main.c: 66: if(i<0xd2)flag=1;
	ldw	x, _i+0
	cpw	x, #0x00d2
	jrsge	00102$
	ldw	x, #0x0001
	ldw	_flag+0, x
00102$:
;	main.c: 67: DelayUs(30000);
	push	#0x30
	push	#0x75
	call	_DelayUs
	addw	sp, #2
;	main.c: 64: for(i=0xd6;i>0x6b;i--)
	ldw	x, _i+0
	decw	x
	ldw	_i+0, x
	cpw	x, #0x006b
	jrsgt	00119$
;	main.c: 69: i=0x6b;
	ldw	x, #0x006b
	ldw	_i+0, x
;	main.c: 71: while(1)
00117$:
;	main.c: 75: code =resive_ir();
	call	_resive_ir
	exgw	x, y
;	main.c: 77: if(code==UMENSHENIE)
	cpw	y, #0x0cf2
	jrne	00109$
;	main.c: 79: i=i+2;                     //увеличеваем значение для регистра предварительной загрузки
	ldw	x, _i+0
	incw	x
	incw	x
;	main.c: 80: if(i>=0xd4)flag=0;         //если свет выключен то и упровление не нужно
	ldw	_i+0, x
	cpw	x, #0x00d4
	jrslt	00105$
	clrw	x
	ldw	_flag+0, x
00105$:
;	main.c: 81: if(i>=0xd6)i=0xd6;         //если дальше увеличевать то лампа будет маргать т.к. мы залезем в другой полупериод
	ldw	x, _i+0
	cpw	x, #0x00d6
	jrslt	00109$
	ldw	x, #0x00d6
	ldw	_i+0, x
00109$:
;	main.c: 84: if(code==UVILCHENIE)        //тоже самое только на оборот
	cpw	y, #0x0df2
	jrne	00117$
;	main.c: 87: i=i-2;
	ldw	x, _i+0
	decw	x
	decw	x
;	main.c: 88: if(i<0xd6)flag=1;
	ldw	_i+0, x
	cpw	x, #0x00d6
	jrsge	00111$
	ldw	x, #0x0001
	ldw	_flag+0, x
00111$:
;	main.c: 89: if(i<=0x06)i=0x06;
	ldw	x, _i+0
	cpw	x, #0x0006
	jrsgt	00117$
	ldw	x, #0x0006
	ldw	_i+0, x
	jra	00117$
;	main.c: 97: }
	ret
	.area CODE
	.area INITIALIZER
__xinit__flag:
	.dw #0x0000
__xinit__i:
	.dw #0x0000
	.area CABS (ABS)
