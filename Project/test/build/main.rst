                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 3.8.0 #10562 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module main
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _main
                                     12 	.globl _delay
                                     13 	.globl _rx
                                     14 	.globl _tx
                                     15 	.globl _uart1_init
                                     16 	.globl _gpio_init
                                     17 	.globl _Init_HSI
                                     18 	.globl _Init_HSE
                                     19 ;--------------------------------------------------------
                                     20 ; ram data
                                     21 ;--------------------------------------------------------
                                     22 	.area DATA
                                     23 ;--------------------------------------------------------
                                     24 ; ram data
                                     25 ;--------------------------------------------------------
                                     26 	.area INITIALIZED
                                     27 ;--------------------------------------------------------
                                     28 ; Stack segment in internal ram 
                                     29 ;--------------------------------------------------------
                                     30 	.area	SSEG
      FFFFFF                         31 __start__stack:
      FFFFFF                         32 	.ds	1
                                     33 
                                     34 ;--------------------------------------------------------
                                     35 ; absolute external ram data
                                     36 ;--------------------------------------------------------
                                     37 	.area DABS (ABS)
                                     38 
                                     39 ; default segment ordering for linker
                                     40 	.area HOME
                                     41 	.area GSINIT
                                     42 	.area GSFINAL
                                     43 	.area CONST
                                     44 	.area INITIALIZER
                                     45 	.area CODE
                                     46 
                                     47 ;--------------------------------------------------------
                                     48 ; interrupt vector 
                                     49 ;--------------------------------------------------------
                                     50 	.area HOME
      008000                         51 __interrupt_vect:
      008000 82 00 80 07             52 	int s_GSINIT ; reset
                                     53 ;--------------------------------------------------------
                                     54 ; global & static initialisations
                                     55 ;--------------------------------------------------------
                                     56 	.area HOME
                                     57 	.area GSINIT
                                     58 	.area GSFINAL
                                     59 	.area GSINIT
      008007                         60 __sdcc_gs_init_startup:
      008007                         61 __sdcc_init_data:
                                     62 ; stm8_genXINIT() start
      008007 AE 00 00         [ 2]   63 	ldw x, #l_DATA
      00800A 27 07            [ 1]   64 	jreq	00002$
      00800C                         65 00001$:
      00800C 72 4F 00 00      [ 1]   66 	clr (s_DATA - 1, x)
      008010 5A               [ 2]   67 	decw x
      008011 26 F9            [ 1]   68 	jrne	00001$
      008013                         69 00002$:
      008013 AE 00 00         [ 2]   70 	ldw	x, #l_INITIALIZER
      008016 27 09            [ 1]   71 	jreq	00004$
      008018                         72 00003$:
      008018 D6 80 2A         [ 1]   73 	ld	a, (s_INITIALIZER - 1, x)
      00801B D7 00 00         [ 1]   74 	ld	(s_INITIALIZED - 1, x), a
      00801E 5A               [ 2]   75 	decw	x
      00801F 26 F7            [ 1]   76 	jrne	00003$
      008021                         77 00004$:
                                     78 ; stm8_genXINIT() end
                                     79 	.area GSFINAL
      008021 CC 80 04         [ 2]   80 	jp	__sdcc_program_startup
                                     81 ;--------------------------------------------------------
                                     82 ; Home
                                     83 ;--------------------------------------------------------
                                     84 	.area HOME
                                     85 	.area HOME
      008004                         86 __sdcc_program_startup:
      008004 CC 81 35         [ 2]   87 	jp	_main
                                     88 ;	return from main will return to caller
                                     89 ;--------------------------------------------------------
                                     90 ; code
                                     91 ;--------------------------------------------------------
                                     92 	.area CODE
                                     93 ;	inc/clk_init.h: 7: void Init_HSE(){    
                                     94 ;	-----------------------------------------
                                     95 ;	 function Init_HSE
                                     96 ;	-----------------------------------------
      00802B                         97 _Init_HSE:
                                     98 ;	inc/clk_init.h: 8: CLK_ECKR|=CLK_ECKR_HSEEN;            
      00802B 72 10 50 C1      [ 1]   99 	bset	20673, #0
                                    100 ;	inc/clk_init.h: 9: CLK_SWCR|=CLK_SWCR_SWEN;               
      00802F 72 12 50 C5      [ 1]  101 	bset	20677, #1
                                    102 ;	inc/clk_init.h: 10: while((CLK_ECKR & CLK_ECKR_HSERDY) == 0) {} 
      008033                        103 00101$:
      008033 C6 50 C1         [ 1]  104 	ld	a, 0x50c1
      008036 A5 02            [ 1]  105 	bcp	a, #0x02
      008038 27 F9            [ 1]  106 	jreq	00101$
                                    107 ;	inc/clk_init.h: 11: CLK_CKDIVR = 0;                    
      00803A 35 00 50 C6      [ 1]  108 	mov	0x50c6+0, #0x00
                                    109 ;	inc/clk_init.h: 12: CLK_SWR = 0xB4;                    
      00803E 35 B4 50 C4      [ 1]  110 	mov	0x50c4+0, #0xb4
                                    111 ;	inc/clk_init.h: 13: while ((CLK_SWCR & CLK_SWCR_SWIF) == 0){}
      008042                        112 00104$:
      008042 C6 50 C5         [ 1]  113 	ld	a, 0x50c5
      008045 A5 08            [ 1]  114 	bcp	a, #0x08
      008047 27 F9            [ 1]  115 	jreq	00104$
                                    116 ;	inc/clk_init.h: 14: CLK_CSSR|=CLK_CSSR_CSSEN;
      008049 72 10 50 C8      [ 1]  117 	bset	20680, #0
                                    118 ;	inc/clk_init.h: 15: CLK_CCOR=0; // CLK_CCOR|=(1<<2)|(1<<0);
      00804D 35 00 50 C9      [ 1]  119 	mov	0x50c9+0, #0x00
                                    120 ;	inc/clk_init.h: 16: }
      008051 81               [ 4]  121 	ret
                                    122 ;	inc/clk_init.h: 18: void Init_HSI()
                                    123 ;	-----------------------------------------
                                    124 ;	 function Init_HSI
                                    125 ;	-----------------------------------------
      008052                        126 _Init_HSI:
                                    127 ;	inc/clk_init.h: 20: CLK_ICKR = 0; // Сбрасываем регистр внутреннего тактирования
      008052 35 00 50 C0      [ 1]  128 	mov	0x50c0+0, #0x00
                                    129 ;	inc/clk_init.h: 21: CLK_ICKR|=(1<<0); // Включаем внутренний генератор HSI
      008056 72 10 50 C0      [ 1]  130 	bset	20672, #0
                                    131 ;	inc/clk_init.h: 22: CLK_ECKR = 0; // Отключаем внешний генератор
      00805A 35 00 50 C1      [ 1]  132 	mov	0x50c1+0, #0x00
                                    133 ;	inc/clk_init.h: 23: while ((CLK_ICKR&(1<<1))== 0); // Ждём стабилизации внутреннего генератора
      00805E                        134 00101$:
      00805E C6 50 C0         [ 1]  135 	ld	a, 0x50c0
      008061 A5 02            [ 1]  136 	bcp	a, #0x02
      008063 27 F9            [ 1]  137 	jreq	00101$
                                    138 ;	inc/clk_init.h: 24: CLK_CKDIVR = 0; // Устанавливаем максимальную частоту
      008065 35 00 50 C6      [ 1]  139 	mov	0x50c6+0, #0x00
                                    140 ;	inc/clk_init.h: 25: CLK_CCOR = 0; // Выключаем CCO.
      008069 35 00 50 C9      [ 1]  141 	mov	0x50c9+0, #0x00
                                    142 ;	inc/clk_init.h: 26: CLK_HSITRIMR = 0; // Turn off any HSIU trimming.
      00806D 35 00 50 CC      [ 1]  143 	mov	0x50cc+0, #0x00
                                    144 ;	inc/clk_init.h: 27: CLK_SWIMCCR = 0; // Set SWIM to run at clock / 2.
      008071 35 00 50 CD      [ 1]  145 	mov	0x50cd+0, #0x00
                                    146 ;	inc/clk_init.h: 28: CLK_SWR = 0xe1; // Используем HSI в качестве источника тактиров
      008075 35 E1 50 C4      [ 1]  147 	mov	0x50c4+0, #0xe1
                                    148 ;	inc/clk_init.h: 29: CLK_SWCR = 0; // Сброс флага переключения генераторов
      008079 35 00 50 C5      [ 1]  149 	mov	0x50c5+0, #0x00
                                    150 ;	inc/clk_init.h: 30: CLK_SWCR= CLK_SWCR_SWEN; // Включаем переключение на HSI
      00807D 35 02 50 C5      [ 1]  151 	mov	0x50c5+0, #0x02
                                    152 ;	inc/clk_init.h: 31: while ((CLK_SWCR&(1<<0)) != 0); // Пауза, пока произойдёт переключение(CLK_SWCR_SWBSY != 0)
      008081                        153 00104$:
      008081 C6 50 C5         [ 1]  154 	ld	a, 0x50c5
      008084 44               [ 1]  155 	srl	a
      008085 25 FA            [ 1]  156 	jrc	00104$
                                    157 ;	inc/clk_init.h: 33: }
      008087 81               [ 4]  158 	ret
                                    159 ;	inc/gpio_init.h: 24: void gpio_init(void)
                                    160 ;	-----------------------------------------
                                    161 ;	 function gpio_init
                                    162 ;	-----------------------------------------
      008088                        163 _gpio_init:
                                    164 ;	inc/gpio_init.h: 27: PA_DDR = 0xFF;                                                        //_______PORT_IN
      008088 35 FF 50 02      [ 1]  165 	mov	0x5002+0, #0xff
                                    166 ;	inc/gpio_init.h: 28: PA_CR1 = 0xFF;                                                       //_______DDR________________CR1______________CR2___________FUNCTION  
      00808C 35 FF 50 03      [ 1]  167 	mov	0x5003+0, #0xff
                                    168 ;	inc/gpio_init.h: 29: PA_CR2 = 0x00;                                                      //_______0__________________0________________0_____________bez podtiyzhki,bez prerbIvanii 
      008090 35 00 50 04      [ 1]  169 	mov	0x5004+0, #0x00
                                    170 ;	inc/gpio_init.h: 31: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
      008094 35 00 50 07      [ 1]  171 	mov	0x5007+0, #0x00
                                    172 ;	inc/gpio_init.h: 32: PB_CR1 = 0xff;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
      008098 35 FF 50 08      [ 1]  173 	mov	0x5008+0, #0xff
                                    174 ;	inc/gpio_init.h: 33: PB_CR2 = 0x00;                                                      //_______PORT_OUT
      00809C 35 00 50 09      [ 1]  175 	mov	0x5009+0, #0x00
                                    176 ;	inc/gpio_init.h: 35: PC_DDR = 0xff;                                                        //_______1__________________0________________0_____________otkritiy stok
      0080A0 35 FF 50 0C      [ 1]  177 	mov	0x500c+0, #0xff
                                    178 ;	inc/gpio_init.h: 36: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
      0080A4 35 FF 50 0D      [ 1]  179 	mov	0x500d+0, #0xff
                                    180 ;	inc/gpio_init.h: 37: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
      0080A8 35 00 50 0E      [ 1]  181 	mov	0x500e+0, #0x00
                                    182 ;	inc/gpio_init.h: 39: PD_DDR = 0xFF;   
      0080AC 35 FF 50 11      [ 1]  183 	mov	0x5011+0, #0xff
                                    184 ;	inc/gpio_init.h: 40: PD_CR1 = 0xFF;  
      0080B0 35 FF 50 12      [ 1]  185 	mov	0x5012+0, #0xff
                                    186 ;	inc/gpio_init.h: 41: PD_CR2 = 0x00; 
      0080B4 35 00 50 13      [ 1]  187 	mov	0x5013+0, #0x00
                                    188 ;	inc/gpio_init.h: 43: PE_DDR = 0xFF;   
      0080B8 35 FF 50 16      [ 1]  189 	mov	0x5016+0, #0xff
                                    190 ;	inc/gpio_init.h: 44: PE_CR1 = 0xFF;  
      0080BC 35 FF 50 17      [ 1]  191 	mov	0x5017+0, #0xff
                                    192 ;	inc/gpio_init.h: 45: PE_CR2 = 0x00; 
      0080C0 35 00 50 18      [ 1]  193 	mov	0x5018+0, #0x00
                                    194 ;	inc/gpio_init.h: 47: PF_DDR = 0xFF;   
      0080C4 35 FF 50 1B      [ 1]  195 	mov	0x501b+0, #0xff
                                    196 ;	inc/gpio_init.h: 48: PF_CR1 = 0xFF;  
      0080C8 35 FF 50 1C      [ 1]  197 	mov	0x501c+0, #0xff
                                    198 ;	inc/gpio_init.h: 49: PF_CR2 = 0x00; 
      0080CC 35 00 50 1D      [ 1]  199 	mov	0x501d+0, #0x00
                                    200 ;	inc/gpio_init.h: 54: }
      0080D0 81               [ 4]  201 	ret
                                    202 ;	inc/uart1.h: 1: void uart1_init()
                                    203 ;	-----------------------------------------
                                    204 ;	 function uart1_init
                                    205 ;	-----------------------------------------
      0080D1                        206 _uart1_init:
                                    207 ;	inc/uart1.h: 3: PD_DDR&=~(1<<6);  
      0080D1 72 1D 50 11      [ 1]  208 	bres	20497, #6
                                    209 ;	inc/uart1.h: 4: PD_DDR|=(1<<5);             
      0080D5 72 1A 50 11      [ 1]  210 	bset	20497, #5
                                    211 ;	inc/uart1.h: 5: UART1_CR2|=UART1_CR2_REN;
      0080D9 72 14 52 35      [ 1]  212 	bset	21045, #2
                                    213 ;	inc/uart1.h: 6: UART1_CR2|=UART1_CR2_TEN;  
      0080DD 72 16 52 35      [ 1]  214 	bset	21045, #3
                                    215 ;	inc/uart1.h: 7: UART1_BRR2 = 0x00;             
      0080E1 35 00 52 33      [ 1]  216 	mov	0x5233+0, #0x00
                                    217 ;	inc/uart1.h: 8: UART1_BRR1 = 0x48;            
      0080E5 35 48 52 32      [ 1]  218 	mov	0x5232+0, #0x48
                                    219 ;	inc/uart1.h: 9: }
      0080E9 81               [ 4]  220 	ret
                                    221 ;	inc/uart1.h: 10: void tx(char *str)
                                    222 ;	-----------------------------------------
                                    223 ;	 function tx
                                    224 ;	-----------------------------------------
      0080EA                        225 _tx:
                                    226 ;	inc/uart1.h: 14: while (!(UART1_SR & UART1_SR_TXE)) {}       
      0080EA 1E 03            [ 2]  227 	ldw	x, (0x03, sp)
      0080EC                        228 00101$:
      0080EC C6 52 30         [ 1]  229 	ld	a, 0x5230
      0080EF 2A FB            [ 1]  230 	jrpl	00101$
                                    231 ;	inc/uart1.h: 15: UART1_DR=*str; 
      0080F1 F6               [ 1]  232 	ld	a, (x)
      0080F2 C7 52 31         [ 1]  233 	ld	0x5231, a
                                    234 ;	inc/uart1.h: 16: if(*str=='\r') break;
      0080F5 F6               [ 1]  235 	ld	a, (x)
      0080F6 A1 0D            [ 1]  236 	cp	a, #0x0d
      0080F8 26 01            [ 1]  237 	jrne	00129$
      0080FA 81               [ 4]  238 	ret
      0080FB                        239 00129$:
                                    240 ;	inc/uart1.h: 17: *str++;
      0080FB 5C               [ 1]  241 	incw	x
      0080FC 20 EE            [ 2]  242 	jra	00101$
                                    243 ;	inc/uart1.h: 20: } 
      0080FE 81               [ 4]  244 	ret
                                    245 ;	inc/uart1.h: 21: void rx(char *str)
                                    246 ;	-----------------------------------------
                                    247 ;	 function rx
                                    248 ;	-----------------------------------------
      0080FF                        249 _rx:
                                    250 ;	inc/uart1.h: 23: while (*str!='\r')
      0080FF                        251 00104$:
      0080FF 1E 03            [ 2]  252 	ldw	x, (0x03, sp)
      008101 F6               [ 1]  253 	ld	a, (x)
      008102 A1 0D            [ 1]  254 	cp	a, #0x0d
      008104 26 01            [ 1]  255 	jrne	00129$
      008106 81               [ 4]  256 	ret
      008107                        257 00129$:
                                    258 ;	inc/uart1.h: 26: while ((UART1_SR & UART1_SR_RXNE)!=0)         //Æäåì ïîÿâëåíèÿ áàéòà
      008107                        259 00101$:
      008107 C6 52 30         [ 1]  260 	ld	a, 0x5230
      00810A A5 20            [ 1]  261 	bcp	a, #0x20
      00810C 27 F1            [ 1]  262 	jreq	00104$
                                    263 ;	inc/uart1.h: 28: *str++;
      00810E 5C               [ 1]  264 	incw	x
      00810F 1F 03            [ 2]  265 	ldw	(0x03, sp), x
                                    266 ;	inc/uart1.h: 29: *str=UART1_DR; 
      008111 C6 52 31         [ 1]  267 	ld	a, 0x5231
      008114 F7               [ 1]  268 	ld	(x), a
      008115 20 F0            [ 2]  269 	jra	00101$
                                    270 ;	inc/uart1.h: 32: } 
      008117 81               [ 4]  271 	ret
                                    272 ;	main.c: 6: void delay(int t)
                                    273 ;	-----------------------------------------
                                    274 ;	 function delay
                                    275 ;	-----------------------------------------
      008118                        276 _delay:
      008118 52 02            [ 2]  277 	sub	sp, #2
                                    278 ;	main.c: 9: for(i=0;i<t;i++)
      00811A 5F               [ 1]  279 	clrw	x
      00811B                        280 00107$:
      00811B 13 05            [ 2]  281 	cpw	x, (0x05, sp)
      00811D 2E 13            [ 1]  282 	jrsge	00109$
                                    283 ;	main.c: 11: for(s=0;s<512;s++)
      00811F 0F 02            [ 1]  284 	clr	(0x02, sp)
      008121 A6 02            [ 1]  285 	ld	a, #0x02
      008123 6B 01            [ 1]  286 	ld	(0x01, sp), a
      008125                        287 00105$:
      008125 16 01            [ 2]  288 	ldw	y, (0x01, sp)
      008127 90 5A            [ 2]  289 	decw	y
      008129 17 01            [ 2]  290 	ldw	(0x01, sp), y
      00812B 90 5D            [ 2]  291 	tnzw	y
      00812D 26 F6            [ 1]  292 	jrne	00105$
                                    293 ;	main.c: 9: for(i=0;i<t;i++)
      00812F 5C               [ 1]  294 	incw	x
      008130 20 E9            [ 2]  295 	jra	00107$
      008132                        296 00109$:
                                    297 ;	main.c: 15: }
      008132 5B 02            [ 2]  298 	addw	sp, #2
      008134 81               [ 4]  299 	ret
                                    300 ;	main.c: 17: void main(void){
                                    301 ;	-----------------------------------------
                                    302 ;	 function main
                                    303 ;	-----------------------------------------
      008135                        304 _main:
                                    305 ;	main.c: 19: Init_HSE();
      008135 CD 80 2B         [ 4]  306 	call	_Init_HSE
                                    307 ;	main.c: 21: gpio_init();
      008138 CD 80 88         [ 4]  308 	call	_gpio_init
                                    309 ;	main.c: 22: uart1_init();
      00813B CD 80 D1         [ 4]  310 	call	_uart1_init
                                    311 ;	main.c: 23: while(1){
      00813E                        312 00102$:
                                    313 ;	main.c: 24: tx("test\n\r");
      00813E 4B 24            [ 1]  314 	push	#<___str_0
      008140 4B 80            [ 1]  315 	push	#(___str_0 >> 8)
      008142 CD 80 EA         [ 4]  316 	call	_tx
      008145 5B 02            [ 2]  317 	addw	sp, #2
                                    318 ;	main.c: 25: delay(2000);
      008147 4B D0            [ 1]  319 	push	#0xd0
      008149 4B 07            [ 1]  320 	push	#0x07
      00814B CD 81 18         [ 4]  321 	call	_delay
      00814E 5B 02            [ 2]  322 	addw	sp, #2
      008150 20 EC            [ 2]  323 	jra	00102$
                                    324 ;	main.c: 28: }
      008152 81               [ 4]  325 	ret
                                    326 	.area CODE
                                    327 	.area CONST
      008024                        328 ___str_0:
      008024 74 65 73 74            329 	.ascii "test"
      008028 0A                     330 	.db 0x0a
      008029 0D                     331 	.db 0x0d
      00802A 00                     332 	.db 0x00
                                    333 	.area INITIALIZER
                                    334 	.area CABS (ABS)
