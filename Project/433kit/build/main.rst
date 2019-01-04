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
                                     12 	.globl _EXTI
                                     13 	.globl _TIM2_update
                                     14 	.globl _GPIO_init
                                     15 	.globl _clk_init
                                     16 	.globl _timer
                                     17 ;--------------------------------------------------------
                                     18 ; ram data
                                     19 ;--------------------------------------------------------
                                     20 	.area DATA
                                     21 ;--------------------------------------------------------
                                     22 ; ram data
                                     23 ;--------------------------------------------------------
                                     24 	.area INITIALIZED
      000001                         25 _timer::
      000001                         26 	.ds 1
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
      008000 82 00 80 43             52 	int s_GSINIT ; reset
      008004 82 00 00 00             53 	int 0x000000 ; trap
      008008 82 00 00 00             54 	int 0x000000 ; int0
      00800C 82 00 00 00             55 	int 0x000000 ; int1
      008010 82 00 00 00             56 	int 0x000000 ; int2
      008014 82 00 00 00             57 	int 0x000000 ; int3
      008018 82 00 80 B2             58 	int _EXTI ; int4
      00801C 82 00 00 00             59 	int 0x000000 ; int5
      008020 82 00 00 00             60 	int 0x000000 ; int6
      008024 82 00 00 00             61 	int 0x000000 ; int7
      008028 82 00 00 00             62 	int 0x000000 ; int8
      00802C 82 00 00 00             63 	int 0x000000 ; int9
      008030 82 00 00 00             64 	int 0x000000 ; int10
      008034 82 00 00 00             65 	int 0x000000 ; int11
      008038 82 00 00 00             66 	int 0x000000 ; int12
      00803C 82 00 80 A9             67 	int _TIM2_update ; int13
                                     68 ;--------------------------------------------------------
                                     69 ; global & static initialisations
                                     70 ;--------------------------------------------------------
                                     71 	.area HOME
                                     72 	.area GSINIT
                                     73 	.area GSFINAL
                                     74 	.area GSINIT
      008043                         75 __sdcc_gs_init_startup:
      008043                         76 __sdcc_init_data:
                                     77 ; stm8_genXINIT() start
      008043 AE 00 00         [ 2]   78 	ldw x, #l_DATA
      008046 27 07            [ 1]   79 	jreq	00002$
      008048                         80 00001$:
      008048 72 4F 00 00      [ 1]   81 	clr (s_DATA - 1, x)
      00804C 5A               [ 2]   82 	decw x
      00804D 26 F9            [ 1]   83 	jrne	00001$
      00804F                         84 00002$:
      00804F AE 00 01         [ 2]   85 	ldw	x, #l_INITIALIZER
      008052 27 09            [ 1]   86 	jreq	00004$
      008054                         87 00003$:
      008054 D6 80 5F         [ 1]   88 	ld	a, (s_INITIALIZER - 1, x)
      008057 D7 00 00         [ 1]   89 	ld	(s_INITIALIZED - 1, x), a
      00805A 5A               [ 2]   90 	decw	x
      00805B 26 F7            [ 1]   91 	jrne	00003$
      00805D                         92 00004$:
                                     93 ; stm8_genXINIT() end
                                     94 	.area GSFINAL
      00805D CC 80 40         [ 2]   95 	jp	__sdcc_program_startup
                                     96 ;--------------------------------------------------------
                                     97 ; Home
                                     98 ;--------------------------------------------------------
                                     99 	.area HOME
                                    100 	.area HOME
      008040                        101 __sdcc_program_startup:
      008040 CC 80 B7         [ 2]  102 	jp	_main
                                    103 ;	return from main will return to caller
                                    104 ;--------------------------------------------------------
                                    105 ; code
                                    106 ;--------------------------------------------------------
                                    107 	.area CODE
                                    108 ;	inc/clk_init.h: 7: void clk_init(void){    
                                    109 ;	-----------------------------------------
                                    110 ;	 function clk_init
                                    111 ;	-----------------------------------------
      008061                        112 _clk_init:
                                    113 ;	inc/clk_init.h: 8: CLK_ECKR|=CLK_ECKR_HSEEN;            
      008061 72 10 50 C1      [ 1]  114 	bset	20673, #0
                                    115 ;	inc/clk_init.h: 9: CLK_SWCR|=CLK_SWCR_SWEN;               
      008065 72 12 50 C5      [ 1]  116 	bset	20677, #1
                                    117 ;	inc/clk_init.h: 10: while((CLK_ECKR & CLK_ECKR_HSERDY) == 0) {} 
      008069                        118 00101$:
      008069 C6 50 C1         [ 1]  119 	ld	a, 0x50c1
      00806C A5 02            [ 1]  120 	bcp	a, #0x02
      00806E 27 F9            [ 1]  121 	jreq	00101$
                                    122 ;	inc/clk_init.h: 11: CLK_CKDIVR = 0;                    
      008070 35 00 50 C6      [ 1]  123 	mov	0x50c6+0, #0x00
                                    124 ;	inc/clk_init.h: 12: CLK_SWR = 0xB4;                    
      008074 35 B4 50 C4      [ 1]  125 	mov	0x50c4+0, #0xb4
                                    126 ;	inc/clk_init.h: 13: while ((CLK_SWCR & CLK_SWCR_SWIF) == 0){}
      008078                        127 00104$:
      008078 C6 50 C5         [ 1]  128 	ld	a, 0x50c5
      00807B A5 08            [ 1]  129 	bcp	a, #0x08
      00807D 27 F9            [ 1]  130 	jreq	00104$
                                    131 ;	inc/clk_init.h: 14: CLK_CSSR|=CLK_CSSR_CSSEN;
      00807F 72 10 50 C8      [ 1]  132 	bset	20680, #0
                                    133 ;	inc/clk_init.h: 15: }
      008083 81               [ 4]  134 	ret
                                    135 ;	inc/gpio_init.h: 10: void GPIO_init(void)
                                    136 ;	-----------------------------------------
                                    137 ;	 function GPIO_init
                                    138 ;	-----------------------------------------
      008084                        139 _GPIO_init:
                                    140 ;	inc/gpio_init.h: 17: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
      008084 35 00 50 07      [ 1]  141 	mov	0x5007+0, #0x00
                                    142 ;	inc/gpio_init.h: 18: PB_CR1 = 0xff;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
      008088 35 FF 50 08      [ 1]  143 	mov	0x5008+0, #0xff
                                    144 ;	inc/gpio_init.h: 19: PB_CR2 = 0xff;                                                      //_______PORT_OUT
      00808C 35 FF 50 09      [ 1]  145 	mov	0x5009+0, #0xff
                                    146 ;	inc/gpio_init.h: 21: PC_DDR = 0xff;                                                        //_______1__________________0________________0_____________otkritiy stok
      008090 35 FF 50 0C      [ 1]  147 	mov	0x500c+0, #0xff
                                    148 ;	inc/gpio_init.h: 22: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
      008094 35 FF 50 0D      [ 1]  149 	mov	0x500d+0, #0xff
                                    150 ;	inc/gpio_init.h: 23: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
      008098 35 00 50 0E      [ 1]  151 	mov	0x500e+0, #0x00
                                    152 ;	inc/gpio_init.h: 25: PD_DDR = 0xFF;   
      00809C 35 FF 50 11      [ 1]  153 	mov	0x5011+0, #0xff
                                    154 ;	inc/gpio_init.h: 26: PD_CR1 = 0xFF;  
      0080A0 35 FF 50 12      [ 1]  155 	mov	0x5012+0, #0xff
                                    156 ;	inc/gpio_init.h: 27: PD_CR2 = 0x00; 
      0080A4 35 00 50 13      [ 1]  157 	mov	0x5013+0, #0x00
                                    158 ;	inc/gpio_init.h: 40: }
      0080A8 81               [ 4]  159 	ret
                                    160 ;	main.c: 7: INTERRUPT_HANDLER(TIM2_update,TIM2_OVR_UIF_IRQ)
                                    161 ;	-----------------------------------------
                                    162 ;	 function TIM2_update
                                    163 ;	-----------------------------------------
      0080A9                        164 _TIM2_update:
                                    165 ;	main.c: 9: timer=1;
      0080A9 35 01 00 01      [ 1]  166 	mov	_timer+0, #0x01
                                    167 ;	main.c: 10: TIM2_SR1&=~TIM_SR1_UIF;
      0080AD 72 11 53 04      [ 1]  168 	bres	21252, #0
                                    169 ;	main.c: 11: }
      0080B1 80               [11]  170 	iret
                                    171 ;	main.c: 13: INTERRUPT_HANDLER(EXTI,4)         
                                    172 ;	-----------------------------------------
                                    173 ;	 function EXTI
                                    174 ;	-----------------------------------------
      0080B2                        175 _EXTI:
                                    176 ;	main.c: 15: TIM2_CR1 |= TIM_CR1_CEN;
      0080B2 72 10 53 00      [ 1]  177 	bset	21248, #0
                                    178 ;	main.c: 16: }
      0080B6 80               [11]  179 	iret
                                    180 ;	main.c: 18: void main(void)
                                    181 ;	-----------------------------------------
                                    182 ;	 function main
                                    183 ;	-----------------------------------------
      0080B7                        184 _main:
      0080B7 52 05            [ 2]  185 	sub	sp, #5
                                    186 ;	main.c: 20: unsigned char resiver=0;
      0080B9 0F 03            [ 1]  187 	clr	(0x03, sp)
                                    188 ;	main.c: 21: unsigned char i=0;
      0080BB 0F 05            [ 1]  189 	clr	(0x05, sp)
                                    190 ;	main.c: 23: unsigned char startrx=0;
      0080BD 0F 04            [ 1]  191 	clr	(0x04, sp)
                                    192 ;	main.c: 24: clk_init();
      0080BF CD 80 61         [ 4]  193 	call	_clk_init
                                    194 ;	main.c: 25: GPIO_init();
      0080C2 CD 80 84         [ 4]  195 	call	_GPIO_init
                                    196 ;	main.c: 26: TIM2_PSCR = 8;
      0080C5 35 08 53 0E      [ 1]  197 	mov	0x530e+0, #0x08
                                    198 ;	main.c: 27: TIM2_ARRH = 0x00;
      0080C9 35 00 53 0F      [ 1]  199 	mov	0x530f+0, #0x00
                                    200 ;	main.c: 28: TIM2_ARRL = 0xff;//880uS
      0080CD 35 FF 53 10      [ 1]  201 	mov	0x5310+0, #0xff
                                    202 ;	main.c: 29: TIM2_CR1 |= TIM_CR1_OPM; 
      0080D1 72 16 53 00      [ 1]  203 	bset	21248, #3
                                    204 ;	main.c: 30: TIM2_IER |= TIM_IER_UIE;
      0080D5 C6 53 03         [ 1]  205 	ld	a, 0x5303
      0080D8 AA 01            [ 1]  206 	or	a, #0x01
      0080DA C7 53 03         [ 1]  207 	ld	0x5303, a
                                    208 ;	main.c: 31: EXTI_CR1=4;//00: Падающий фронт и низкий уровень/01: только передний край/10: только падающая кромка/11: Восходящий и опускающийся край
      0080DD 35 04 50 A0      [ 1]  209 	mov	0x50a0+0, #0x04
                                    210 ;	main.c: 32: __asm__("rim\n");
      0080E1 9A               [ 1]  211 	rim
                                    212 ;	main.c: 33: PD_ODR=0x00;
      0080E2 35 00 50 0F      [ 1]  213 	mov	0x500f+0, #0x00
                                    214 ;	main.c: 36: while(!(timer)){
      0080E6                        215 00101$:
      0080E6 72 5D 00 01      [ 1]  216 	tnz	_timer+0
      0080EA 26 06            [ 1]  217 	jrne	00103$
                                    218 ;	main.c: 37: PD_ODR^=(1<<7),t=0;
      0080EC 90 1E 50 0F      [ 1]  219 	bcpl	20495, #7
      0080F0 20 F4            [ 2]  220 	jra	00101$
      0080F2                        221 00103$:
                                    222 ;	main.c: 41: timer=0;
      0080F2 72 5F 00 01      [ 1]  223 	clr	_timer+0
                                    224 ;	main.c: 42: TIM2_ARRH = 0x00;
      0080F6 35 00 53 0F      [ 1]  225 	mov	0x530f+0, #0x00
                                    226 ;	main.c: 44: if(PB_IDR&(1<<7) && !startrx)
      0080FA C6 50 06         [ 1]  227 	ld	a, 0x5006
      0080FD A4 80            [ 1]  228 	and	a, #0x80
      0080FF 6B 02            [ 1]  229 	ld	(0x02, sp), a
      008101 27 0E            [ 1]  230 	jreq	00112$
      008103 0D 04            [ 1]  231 	tnz	(0x04, sp)
      008105 26 0A            [ 1]  232 	jrne	00112$
                                    233 ;	main.c: 45: startrx=1,
      008107 A6 01            [ 1]  234 	ld	a, #0x01
      008109 6B 04            [ 1]  235 	ld	(0x04, sp), a
                                    236 ;	main.c: 46: TIM2_ARRL = 0xaf;
      00810B 35 AF 53 10      [ 1]  237 	mov	0x5310+0, #0xaf
      00810F 20 3B            [ 2]  238 	jra	00113$
      008111                        239 00112$:
                                    240 ;	main.c: 48: resiver|=(1<<i),
      008111 7B 05            [ 1]  241 	ld	a, (0x05, sp)
      008113 95               [ 1]  242 	ld	xh, a
      008114 7B 03            [ 1]  243 	ld	a, (0x03, sp)
      008116 6B 01            [ 1]  244 	ld	(0x01, sp), a
                                    245 ;	main.c: 49: i++;
      008118 7B 05            [ 1]  246 	ld	a, (0x05, sp)
      00811A 4C               [ 1]  247 	inc	a
      00811B 97               [ 1]  248 	ld	xl, a
                                    249 ;	main.c: 48: resiver|=(1<<i),
      00811C A6 01            [ 1]  250 	ld	a, #0x01
      00811E 88               [ 1]  251 	push	a
      00811F 9E               [ 1]  252 	ld	a, xh
      008120 4D               [ 1]  253 	tnz	a
      008121 27 05            [ 1]  254 	jreq	00202$
      008123                        255 00201$:
      008123 08 01            [ 1]  256 	sll	(1, sp)
      008125 4A               [ 1]  257 	dec	a
      008126 26 FB            [ 1]  258 	jrne	00201$
      008128                        259 00202$:
      008128 84               [ 1]  260 	pop	a
                                    261 ;	main.c: 47: else if(PB_IDR&(1<<7) && startrx)
      008129 0D 02            [ 1]  262 	tnz	(0x02, sp)
      00812B 27 0E            [ 1]  263 	jreq	00108$
      00812D 0D 04            [ 1]  264 	tnz	(0x04, sp)
      00812F 27 0A            [ 1]  265 	jreq	00108$
                                    266 ;	main.c: 48: resiver|=(1<<i),
      008131 1A 01            [ 1]  267 	or	a, (0x01, sp)
      008133 6B 03            [ 1]  268 	ld	(0x03, sp), a
                                    269 ;	main.c: 49: i++;
      008135 41               [ 1]  270 	exg	a, xl
      008136 6B 05            [ 1]  271 	ld	(0x05, sp), a
      008138 41               [ 1]  272 	exg	a, xl
      008139 20 11            [ 2]  273 	jra	00113$
      00813B                        274 00108$:
                                    275 ;	main.c: 50: else if(!(PB_IDR&(1<<7)) && startrx)
      00813B 0D 02            [ 1]  276 	tnz	(0x02, sp)
      00813D 26 0D            [ 1]  277 	jrne	00113$
      00813F 0D 04            [ 1]  278 	tnz	(0x04, sp)
      008141 27 09            [ 1]  279 	jreq	00113$
                                    280 ;	main.c: 51: resiver&=~(1<<i),
      008143 43               [ 1]  281 	cpl	a
      008144 14 01            [ 1]  282 	and	a, (0x01, sp)
      008146 6B 03            [ 1]  283 	ld	(0x03, sp), a
                                    284 ;	main.c: 52: i++;
      008148 41               [ 1]  285 	exg	a, xl
      008149 6B 05            [ 1]  286 	ld	(0x05, sp), a
      00814B 41               [ 1]  287 	exg	a, xl
      00814C                        288 00113$:
                                    289 ;	main.c: 54: if(i>=8){
      00814C 7B 05            [ 1]  290 	ld	a, (0x05, sp)
      00814E A1 08            [ 1]  291 	cp	a, #0x08
      008150 25 94            [ 1]  292 	jrc	00101$
                                    293 ;	main.c: 55: i=0;
      008152 0F 05            [ 1]  294 	clr	(0x05, sp)
                                    295 ;	main.c: 56: startrx=0;
      008154 0F 04            [ 1]  296 	clr	(0x04, sp)
                                    297 ;	main.c: 57: TIM2_ARRL = 0xff;
      008156 35 FF 53 10      [ 1]  298 	mov	0x5310+0, #0xff
                                    299 ;	main.c: 58: if(resiver=='D')
      00815A 7B 03            [ 1]  300 	ld	a, (0x03, sp)
      00815C A1 44            [ 1]  301 	cp	a, #0x44
      00815E 26 07            [ 1]  302 	jrne	00124$
                                    303 ;	main.c: 59: PD_ODR=0x01;
      008160 35 01 50 0F      [ 1]  304 	mov	0x500f+0, #0x01
      008164 CC 80 E6         [ 2]  305 	jp	00101$
      008167                        306 00124$:
                                    307 ;	main.c: 60: else if(resiver=='A')
      008167 7B 03            [ 1]  308 	ld	a, (0x03, sp)
      008169 A1 41            [ 1]  309 	cp	a, #0x41
      00816B 26 07            [ 1]  310 	jrne	00121$
                                    311 ;	main.c: 61: PD_ODR=0x10;
      00816D 35 10 50 0F      [ 1]  312 	mov	0x500f+0, #0x10
      008171 CC 80 E6         [ 2]  313 	jp	00101$
      008174                        314 00121$:
                                    315 ;	main.c: 62: else if(resiver=='B')
      008174 7B 03            [ 1]  316 	ld	a, (0x03, sp)
      008176 A1 42            [ 1]  317 	cp	a, #0x42
      008178 26 07            [ 1]  318 	jrne	00118$
                                    319 ;	main.c: 63: PD_ODR=0x04;
      00817A 35 04 50 0F      [ 1]  320 	mov	0x500f+0, #0x04
      00817E CC 80 E6         [ 2]  321 	jp	00101$
      008181                        322 00118$:
                                    323 ;	main.c: 64: else if(resiver=='C')
      008181 7B 03            [ 1]  324 	ld	a, (0x03, sp)
      008183 A1 43            [ 1]  325 	cp	a, #0x43
      008185 27 03            [ 1]  326 	jreq	00219$
      008187 CC 80 E6         [ 2]  327 	jp	00101$
      00818A                        328 00219$:
                                    329 ;	main.c: 65: PD_ODR=0x08;
      00818A 35 08 50 0F      [ 1]  330 	mov	0x500f+0, #0x08
                                    331 ;	main.c: 68: }
      00818E CC 80 E6         [ 2]  332 	jp	00101$
                                    333 	.area CODE
                                    334 	.area CONST
                                    335 	.area INITIALIZER
      008060                        336 __xinit__timer:
      008060 00                     337 	.db #0x00	; 0
                                    338 	.area CABS (ABS)
