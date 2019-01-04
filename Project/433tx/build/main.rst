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
                                     12 	.globl _send_byte
                                     13 	.globl _tx_stop_bit
                                     14 	.globl _tx_start_bit
                                     15 	.globl _tx_cli_bit
                                     16 	.globl _tx_set_bit
                                     17 	.globl _tim_wait
                                     18 	.globl _TIM2_update
                                     19 	.globl _GPIO_init
                                     20 	.globl _clk_init
                                     21 ;--------------------------------------------------------
                                     22 ; ram data
                                     23 ;--------------------------------------------------------
                                     24 	.area DATA
                                     25 ;--------------------------------------------------------
                                     26 ; ram data
                                     27 ;--------------------------------------------------------
                                     28 	.area INITIALIZED
                                     29 ;--------------------------------------------------------
                                     30 ; Stack segment in internal ram 
                                     31 ;--------------------------------------------------------
                                     32 	.area	SSEG
      FFFFFF                         33 __start__stack:
      FFFFFF                         34 	.ds	1
                                     35 
                                     36 ;--------------------------------------------------------
                                     37 ; absolute external ram data
                                     38 ;--------------------------------------------------------
                                     39 	.area DABS (ABS)
                                     40 
                                     41 ; default segment ordering for linker
                                     42 	.area HOME
                                     43 	.area GSINIT
                                     44 	.area GSFINAL
                                     45 	.area CONST
                                     46 	.area INITIALIZER
                                     47 	.area CODE
                                     48 
                                     49 ;--------------------------------------------------------
                                     50 ; interrupt vector 
                                     51 ;--------------------------------------------------------
                                     52 	.area HOME
      008000                         53 __interrupt_vect:
      008000 82 00 80 43             54 	int s_GSINIT ; reset
      008004 82 00 00 00             55 	int 0x000000 ; trap
      008008 82 00 00 00             56 	int 0x000000 ; int0
      00800C 82 00 00 00             57 	int 0x000000 ; int1
      008010 82 00 00 00             58 	int 0x000000 ; int2
      008014 82 00 00 00             59 	int 0x000000 ; int3
      008018 82 00 00 00             60 	int 0x000000 ; int4
      00801C 82 00 00 00             61 	int 0x000000 ; int5
      008020 82 00 00 00             62 	int 0x000000 ; int6
      008024 82 00 00 00             63 	int 0x000000 ; int7
      008028 82 00 00 00             64 	int 0x000000 ; int8
      00802C 82 00 00 00             65 	int 0x000000 ; int9
      008030 82 00 00 00             66 	int 0x000000 ; int10
      008034 82 00 00 00             67 	int 0x000000 ; int11
      008038 82 00 00 00             68 	int 0x000000 ; int12
      00803C 82 00 80 A4             69 	int _TIM2_update ; int13
                                     70 ;--------------------------------------------------------
                                     71 ; global & static initialisations
                                     72 ;--------------------------------------------------------
                                     73 	.area HOME
                                     74 	.area GSINIT
                                     75 	.area GSFINAL
                                     76 	.area GSINIT
      008043                         77 __sdcc_gs_init_startup:
      008043                         78 __sdcc_init_data:
                                     79 ; stm8_genXINIT() start
      008043 AE 00 00         [ 2]   80 	ldw x, #l_DATA
      008046 27 07            [ 1]   81 	jreq	00002$
      008048                         82 00001$:
      008048 72 4F 00 00      [ 1]   83 	clr (s_DATA - 1, x)
      00804C 5A               [ 2]   84 	decw x
      00804D 26 F9            [ 1]   85 	jrne	00001$
      00804F                         86 00002$:
      00804F AE 00 00         [ 2]   87 	ldw	x, #l_INITIALIZER
      008052 27 09            [ 1]   88 	jreq	00004$
      008054                         89 00003$:
      008054 D6 80 5F         [ 1]   90 	ld	a, (s_INITIALIZER - 1, x)
      008057 D7 00 00         [ 1]   91 	ld	(s_INITIALIZED - 1, x), a
      00805A 5A               [ 2]   92 	decw	x
      00805B 26 F7            [ 1]   93 	jrne	00003$
      00805D                         94 00004$:
                                     95 ; stm8_genXINIT() end
                                     96 	.area GSFINAL
      00805D CC 80 40         [ 2]   97 	jp	__sdcc_program_startup
                                     98 ;--------------------------------------------------------
                                     99 ; Home
                                    100 ;--------------------------------------------------------
                                    101 	.area HOME
                                    102 	.area HOME
      008040                        103 __sdcc_program_startup:
      008040 CC 81 58         [ 2]  104 	jp	_main
                                    105 ;	return from main will return to caller
                                    106 ;--------------------------------------------------------
                                    107 ; code
                                    108 ;--------------------------------------------------------
                                    109 	.area CODE
                                    110 ;	inc/clk_init.h: 7: void clk_init(void){    
                                    111 ;	-----------------------------------------
                                    112 ;	 function clk_init
                                    113 ;	-----------------------------------------
      008060                        114 _clk_init:
                                    115 ;	inc/clk_init.h: 8: CLK_ECKR|=CLK_ECKR_HSEEN;            
      008060 72 10 50 C1      [ 1]  116 	bset	20673, #0
                                    117 ;	inc/clk_init.h: 9: CLK_SWCR|=CLK_SWCR_SWEN;               
      008064 72 12 50 C5      [ 1]  118 	bset	20677, #1
                                    119 ;	inc/clk_init.h: 10: while((CLK_ECKR & CLK_ECKR_HSERDY) == 0) {} 
      008068                        120 00101$:
      008068 C6 50 C1         [ 1]  121 	ld	a, 0x50c1
      00806B A5 02            [ 1]  122 	bcp	a, #0x02
      00806D 27 F9            [ 1]  123 	jreq	00101$
                                    124 ;	inc/clk_init.h: 11: CLK_CKDIVR = 0;                    
      00806F 35 00 50 C6      [ 1]  125 	mov	0x50c6+0, #0x00
                                    126 ;	inc/clk_init.h: 12: CLK_SWR = 0xB4;                    
      008073 35 B4 50 C4      [ 1]  127 	mov	0x50c4+0, #0xb4
                                    128 ;	inc/clk_init.h: 13: while ((CLK_SWCR & CLK_SWCR_SWIF) == 0){}
      008077                        129 00104$:
      008077 C6 50 C5         [ 1]  130 	ld	a, 0x50c5
      00807A A5 08            [ 1]  131 	bcp	a, #0x08
      00807C 27 F9            [ 1]  132 	jreq	00104$
                                    133 ;	inc/clk_init.h: 15: }
      00807E 81               [ 4]  134 	ret
                                    135 ;	inc/gpio_init.h: 10: void GPIO_init(void)
                                    136 ;	-----------------------------------------
                                    137 ;	 function GPIO_init
                                    138 ;	-----------------------------------------
      00807F                        139 _GPIO_init:
                                    140 ;	inc/gpio_init.h: 17: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
      00807F 35 00 50 07      [ 1]  141 	mov	0x5007+0, #0x00
                                    142 ;	inc/gpio_init.h: 18: PB_CR1 = 0x00;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
      008083 35 00 50 08      [ 1]  143 	mov	0x5008+0, #0x00
                                    144 ;	inc/gpio_init.h: 19: PB_CR2 = 0x00;                                                      //_______PORT_OUT
      008087 35 00 50 09      [ 1]  145 	mov	0x5009+0, #0x00
                                    146 ;	inc/gpio_init.h: 21: PC_DDR = 0x00;                                                        //_______1__________________0________________0_____________otkritiy stok
      00808B 35 00 50 0C      [ 1]  147 	mov	0x500c+0, #0x00
                                    148 ;	inc/gpio_init.h: 22: PC_CR1 = 0x00;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
      00808F 35 00 50 0D      [ 1]  149 	mov	0x500d+0, #0x00
                                    150 ;	inc/gpio_init.h: 23: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
      008093 35 00 50 0E      [ 1]  151 	mov	0x500e+0, #0x00
                                    152 ;	inc/gpio_init.h: 25: PD_DDR = 0xFF;   
      008097 35 FF 50 11      [ 1]  153 	mov	0x5011+0, #0xff
                                    154 ;	inc/gpio_init.h: 26: PD_CR1 = 0xFF;  
      00809B 35 FF 50 12      [ 1]  155 	mov	0x5012+0, #0xff
                                    156 ;	inc/gpio_init.h: 27: PD_CR2 = 0x00; 
      00809F 35 00 50 13      [ 1]  157 	mov	0x5013+0, #0x00
                                    158 ;	inc/gpio_init.h: 40: }
      0080A3 81               [ 4]  159 	ret
                                    160 ;	main.c: 9: INTERRUPT_HANDLER(TIM2_update,TIM2_OVR_UIF_IRQ)
                                    161 ;	-----------------------------------------
                                    162 ;	 function TIM2_update
                                    163 ;	-----------------------------------------
      0080A4                        164 _TIM2_update:
                                    165 ;	main.c: 11: TIM2_SR1 &= ~TIM_SR1_UIF;
      0080A4 72 11 53 04      [ 1]  166 	bres	21252, #0
                                    167 ;	main.c: 12: }
      0080A8 80               [11]  168 	iret
                                    169 ;	main.c: 13: void tim_wait(unsigned char reg_h, unsigned char reg_l)
                                    170 ;	-----------------------------------------
                                    171 ;	 function tim_wait
                                    172 ;	-----------------------------------------
      0080A9                        173 _tim_wait:
                                    174 ;	main.c: 15: TIM2_ARRH = reg_h;
      0080A9 AE 53 0F         [ 2]  175 	ldw	x, #0x530f
      0080AC 7B 03            [ 1]  176 	ld	a, (0x03, sp)
      0080AE F7               [ 1]  177 	ld	(x), a
                                    178 ;	main.c: 16: TIM2_ARRL = reg_l;
      0080AF AE 53 10         [ 2]  179 	ldw	x, #0x5310
      0080B2 7B 04            [ 1]  180 	ld	a, (0x04, sp)
      0080B4 F7               [ 1]  181 	ld	(x), a
                                    182 ;	main.c: 17: TIM2_CR1 |= TIM_CR1_CEN;
      0080B5 C6 53 00         [ 1]  183 	ld	a, 0x5300
      0080B8 AA 01            [ 1]  184 	or	a, #0x01
      0080BA C7 53 00         [ 1]  185 	ld	0x5300, a
                                    186 ;	main.c: 18: __asm__("wfi\n");
      0080BD 8F               [10]  187 	wfi
                                    188 ;	main.c: 19: }
      0080BE 81               [ 4]  189 	ret
                                    190 ;	main.c: 20: void tx_set_bit()
                                    191 ;	-----------------------------------------
                                    192 ;	 function tx_set_bit
                                    193 ;	-----------------------------------------
      0080BF                        194 _tx_set_bit:
                                    195 ;	main.c: 22: out_set_bit;
      0080BF 72 18 50 0F      [ 1]  196 	bset	20495, #4
                                    197 ;	main.c: 23: tim_wait(0x00,0x40);//0x00,0x0f
      0080C3 4B 40            [ 1]  198 	push	#0x40
      0080C5 4B 00            [ 1]  199 	push	#0x00
      0080C7 CD 80 A9         [ 4]  200 	call	_tim_wait
      0080CA 5B 02            [ 2]  201 	addw	sp, #2
                                    202 ;	main.c: 24: out_cli_bit;
      0080CC 72 19 50 0F      [ 1]  203 	bres	20495, #4
                                    204 ;	main.c: 25: tim_wait(0x00,0x20);//0x00,0x08
      0080D0 4B 20            [ 1]  205 	push	#0x20
      0080D2 4B 00            [ 1]  206 	push	#0x00
      0080D4 CD 80 A9         [ 4]  207 	call	_tim_wait
      0080D7 5B 02            [ 2]  208 	addw	sp, #2
                                    209 ;	main.c: 26: }
      0080D9 81               [ 4]  210 	ret
                                    211 ;	main.c: 27: void tx_cli_bit()
                                    212 ;	-----------------------------------------
                                    213 ;	 function tx_cli_bit
                                    214 ;	-----------------------------------------
      0080DA                        215 _tx_cli_bit:
                                    216 ;	main.c: 29: out_set_bit;
      0080DA 72 18 50 0F      [ 1]  217 	bset	20495, #4
                                    218 ;	main.c: 30: tim_wait(0x00,0x20);//0x00,0x08
      0080DE 4B 20            [ 1]  219 	push	#0x20
      0080E0 4B 00            [ 1]  220 	push	#0x00
      0080E2 CD 80 A9         [ 4]  221 	call	_tim_wait
      0080E5 5B 02            [ 2]  222 	addw	sp, #2
                                    223 ;	main.c: 31: out_cli_bit;
      0080E7 72 19 50 0F      [ 1]  224 	bres	20495, #4
                                    225 ;	main.c: 32: tim_wait(0x00,0x20);//0x00,0x08
      0080EB 4B 20            [ 1]  226 	push	#0x20
      0080ED 4B 00            [ 1]  227 	push	#0x00
      0080EF CD 80 A9         [ 4]  228 	call	_tim_wait
      0080F2 5B 02            [ 2]  229 	addw	sp, #2
                                    230 ;	main.c: 33: }
      0080F4 81               [ 4]  231 	ret
                                    232 ;	main.c: 34: void tx_start_bit()
                                    233 ;	-----------------------------------------
                                    234 ;	 function tx_start_bit
                                    235 ;	-----------------------------------------
      0080F5                        236 _tx_start_bit:
                                    237 ;	main.c: 36: out_set_bit;
      0080F5 72 18 50 0F      [ 1]  238 	bset	20495, #4
                                    239 ;	main.c: 37: tim_wait(0x00,0x80);//0x00,0x47
      0080F9 4B 80            [ 1]  240 	push	#0x80
      0080FB 4B 00            [ 1]  241 	push	#0x00
      0080FD CD 80 A9         [ 4]  242 	call	_tim_wait
      008100 5B 02            [ 2]  243 	addw	sp, #2
                                    244 ;	main.c: 38: out_cli_bit;
      008102 72 19 50 0F      [ 1]  245 	bres	20495, #4
                                    246 ;	main.c: 39: tim_wait(0x00,0x20);//0x00,0x08
      008106 4B 20            [ 1]  247 	push	#0x20
      008108 4B 00            [ 1]  248 	push	#0x00
      00810A CD 80 A9         [ 4]  249 	call	_tim_wait
      00810D 5B 02            [ 2]  250 	addw	sp, #2
                                    251 ;	main.c: 40: }
      00810F 81               [ 4]  252 	ret
                                    253 ;	main.c: 41: void tx_stop_bit()
                                    254 ;	-----------------------------------------
                                    255 ;	 function tx_stop_bit
                                    256 ;	-----------------------------------------
      008110                        257 _tx_stop_bit:
                                    258 ;	main.c: 43: out_cli_bit;
      008110 72 19 50 0F      [ 1]  259 	bres	20495, #4
                                    260 ;	main.c: 44: tim_wait(0x00,0x80);
      008114 4B 80            [ 1]  261 	push	#0x80
      008116 4B 00            [ 1]  262 	push	#0x00
      008118 CD 80 A9         [ 4]  263 	call	_tim_wait
      00811B 5B 02            [ 2]  264 	addw	sp, #2
                                    265 ;	main.c: 45: }
      00811D 81               [ 4]  266 	ret
                                    267 ;	main.c: 46: void send_byte(unsigned char data)
                                    268 ;	-----------------------------------------
                                    269 ;	 function send_byte
                                    270 ;	-----------------------------------------
      00811E                        271 _send_byte:
      00811E 52 04            [ 2]  272 	sub	sp, #4
                                    273 ;	main.c: 49: tx_start_bit();
      008120 CD 80 F5         [ 4]  274 	call	_tx_start_bit
                                    275 ;	main.c: 50: for(i=0;i<=7;i++)
      008123 5F               [ 1]  276 	clrw	x
      008124 1F 03            [ 2]  277 	ldw	(0x03, sp), x
      008126                        278 00105$:
                                    279 ;	main.c: 52: if(data&(1<<i))tx_set_bit();
      008126 5F               [ 1]  280 	clrw	x
      008127 5C               [ 1]  281 	incw	x
      008128 7B 04            [ 1]  282 	ld	a, (0x04, sp)
      00812A 27 04            [ 1]  283 	jreq	00126$
      00812C                        284 00125$:
      00812C 58               [ 2]  285 	sllw	x
      00812D 4A               [ 1]  286 	dec	a
      00812E 26 FC            [ 1]  287 	jrne	00125$
      008130                        288 00126$:
      008130 7B 07            [ 1]  289 	ld	a, (0x07, sp)
      008132 6B 02            [ 1]  290 	ld	(0x02, sp), a
      008134 0F 01            [ 1]  291 	clr	(0x01, sp)
      008136 9F               [ 1]  292 	ld	a, xl
      008137 14 02            [ 1]  293 	and	a, (0x02, sp)
      008139 02               [ 1]  294 	rlwa	x
      00813A 14 01            [ 1]  295 	and	a, (0x01, sp)
      00813C 95               [ 1]  296 	ld	xh, a
      00813D 5D               [ 2]  297 	tnzw	x
      00813E 27 05            [ 1]  298 	jreq	00102$
      008140 CD 80 BF         [ 4]  299 	call	_tx_set_bit
      008143 20 03            [ 2]  300 	jra	00106$
      008145                        301 00102$:
                                    302 ;	main.c: 53: else tx_cli_bit();
      008145 CD 80 DA         [ 4]  303 	call	_tx_cli_bit
      008148                        304 00106$:
                                    305 ;	main.c: 50: for(i=0;i<=7;i++)
      008148 1E 03            [ 2]  306 	ldw	x, (0x03, sp)
      00814A 5C               [ 1]  307 	incw	x
      00814B 1F 03            [ 2]  308 	ldw	(0x03, sp), x
      00814D A3 00 07         [ 2]  309 	cpw	x, #0x0007
      008150 2D D4            [ 1]  310 	jrsle	00105$
                                    311 ;	main.c: 55: tx_stop_bit();
      008152 CD 81 10         [ 4]  312 	call	_tx_stop_bit
                                    313 ;	main.c: 56: }
      008155 5B 04            [ 2]  314 	addw	sp, #4
      008157 81               [ 4]  315 	ret
                                    316 ;	main.c: 57: void main(void)
                                    317 ;	-----------------------------------------
                                    318 ;	 function main
                                    319 ;	-----------------------------------------
      008158                        320 _main:
                                    321 ;	main.c: 59: clk_init();
      008158 CD 80 60         [ 4]  322 	call	_clk_init
                                    323 ;	main.c: 60: GPIO_init();
      00815B CD 80 7F         [ 4]  324 	call	_GPIO_init
                                    325 ;	main.c: 61: TIM2_PSCR = 10;
      00815E 35 0A 53 0E      [ 1]  326 	mov	0x530e+0, #0x0a
                                    327 ;	main.c: 62: TIM2_CR1|=TIM_CR1_OPM; 
      008162 72 16 53 00      [ 1]  328 	bset	21248, #3
                                    329 ;	main.c: 63: TIM2_IER |= TIM_IER_UIE;
      008166 72 10 53 03      [ 1]  330 	bset	21251, #0
                                    331 ;	main.c: 65: while(1)
      00816A                        332 00110$:
                                    333 ;	main.c: 67: if(!(PC_IDR&(1<<3))){
      00816A C6 50 0B         [ 1]  334 	ld	a, 0x500b
      00816D A5 08            [ 1]  335 	bcp	a, #0x08
      00816F 26 06            [ 1]  336 	jrne	00102$
                                    337 ;	main.c: 68: send_byte('A');
      008171 4B 41            [ 1]  338 	push	#0x41
      008173 CD 81 1E         [ 4]  339 	call	_send_byte
      008176 84               [ 1]  340 	pop	a
      008177                        341 00102$:
                                    342 ;	main.c: 70: if(!(PC_IDR&(1<<4))){
      008177 C6 50 0B         [ 1]  343 	ld	a, 0x500b
      00817A A5 10            [ 1]  344 	bcp	a, #0x10
      00817C 26 06            [ 1]  345 	jrne	00104$
                                    346 ;	main.c: 71: send_byte('B');
      00817E 4B 42            [ 1]  347 	push	#0x42
      008180 CD 81 1E         [ 4]  348 	call	_send_byte
      008183 84               [ 1]  349 	pop	a
      008184                        350 00104$:
                                    351 ;	main.c: 73: if(!(PC_IDR&(1<<5))){
      008184 C6 50 0B         [ 1]  352 	ld	a, 0x500b
      008187 A5 20            [ 1]  353 	bcp	a, #0x20
      008189 26 06            [ 1]  354 	jrne	00106$
                                    355 ;	main.c: 74: send_byte('C');
      00818B 4B 43            [ 1]  356 	push	#0x43
      00818D CD 81 1E         [ 4]  357 	call	_send_byte
      008190 84               [ 1]  358 	pop	a
      008191                        359 00106$:
                                    360 ;	main.c: 76: if(!(PC_IDR&(1<<6))){
      008191 C6 50 0B         [ 1]  361 	ld	a, 0x500b
      008194 A5 40            [ 1]  362 	bcp	a, #0x40
      008196 26 D2            [ 1]  363 	jrne	00110$
                                    364 ;	main.c: 77: send_byte('D');
      008198 4B 44            [ 1]  365 	push	#0x44
      00819A CD 81 1E         [ 4]  366 	call	_send_byte
      00819D 84               [ 1]  367 	pop	a
      00819E 20 CA            [ 2]  368 	jra	00110$
                                    369 ;	main.c: 81: }
      0081A0 81               [ 4]  370 	ret
                                    371 	.area CODE
                                    372 	.area CONST
                                    373 	.area INITIALIZER
                                    374 	.area CABS (ABS)
