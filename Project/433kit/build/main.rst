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
                                     16 	.globl _flag
                                     17 ;--------------------------------------------------------
                                     18 ; ram data
                                     19 ;--------------------------------------------------------
                                     20 	.area DATA
                                     21 ;--------------------------------------------------------
                                     22 ; ram data
                                     23 ;--------------------------------------------------------
                                     24 	.area INITIALIZED
      000001                         25 _flag::
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
                                    160 ;	main.c: 15: INTERRUPT_HANDLER(TIM2_update,TIM2_OVR_UIF_IRQ){
                                    161 ;	-----------------------------------------
                                    162 ;	 function TIM2_update
                                    163 ;	-----------------------------------------
      0080A9                        164 _TIM2_update:
                                    165 ;	main.c: 16: SetBit(flag,tim_end);
      0080A9 72 12 00 01      [ 1]  166 	bset	_flag+0, #1
                                    167 ;	main.c: 17: TIM2_SR1&=~TIM_SR1_UIF;
      0080AD 72 11 53 04      [ 1]  168 	bres	21252, #0
                                    169 ;	main.c: 18: }
      0080B1 80               [11]  170 	iret
                                    171 ;	main.c: 20: INTERRUPT_HANDLER(EXTI,4){
                                    172 ;	-----------------------------------------
                                    173 ;	 function EXTI
                                    174 ;	-----------------------------------------
      0080B2                        175 _EXTI:
                                    176 ;	main.c: 21: SetBit(flag,ext_intrrpt);
      0080B2 72 10 00 01      [ 1]  177 	bset	_flag+0, #0
                                    178 ;	main.c: 22: }
      0080B6 80               [11]  179 	iret
                                    180 ;	main.c: 24: void main(void){
                                    181 ;	-----------------------------------------
                                    182 ;	 function main
                                    183 ;	-----------------------------------------
      0080B7                        184 _main:
      0080B7 52 02            [ 2]  185 	sub	sp, #2
                                    186 ;	main.c: 25: unsigned char resiver=0;
      0080B9 4F               [ 1]  187 	clr	a
      0080BA 97               [ 1]  188 	ld	xl, a
                                    189 ;	main.c: 26: unsigned char i=0;
      0080BB 4F               [ 1]  190 	clr	a
      0080BC 95               [ 1]  191 	ld	xh, a
                                    192 ;	main.c: 27: clk_init();
      0080BD 89               [ 2]  193 	pushw	x
      0080BE CD 80 61         [ 4]  194 	call	_clk_init
      0080C1 CD 80 84         [ 4]  195 	call	_GPIO_init
      0080C4 85               [ 2]  196 	popw	x
                                    197 ;	main.c: 29: TIM2_PSCR = 8;
      0080C5 35 08 53 0E      [ 1]  198 	mov	0x530e+0, #0x08
                                    199 ;	main.c: 30: TIM2_CR1 |= TIM_CR1_OPM; 
      0080C9 72 16 53 00      [ 1]  200 	bset	21248, #3
                                    201 ;	main.c: 31: TIM2_IER |= TIM_IER_UIE;
      0080CD C6 53 03         [ 1]  202 	ld	a, 0x5303
      0080D0 AA 01            [ 1]  203 	or	a, #0x01
      0080D2 C7 53 03         [ 1]  204 	ld	0x5303, a
                                    205 ;	main.c: 32: EXTI_CR1=4;//00: Падающий фронт и низкий уровень/01: только передний край/10: только падающая кромка/11: Восходящий и опускающийся край
      0080D5 35 04 50 A0      [ 1]  206 	mov	0x50a0+0, #0x04
                                    207 ;	main.c: 33: __asm__("rim\n");
      0080D9 9A               [ 1]  208 	rim
                                    209 ;	main.c: 34: PD_ODR=0x00;
      0080DA 35 00 50 0F      [ 1]  210 	mov	0x500f+0, #0x00
                                    211 ;	main.c: 37: while(!(GetBit(flag,startbit))){//wait startbit
      0080DE                        212 00112$:
      0080DE 72 09 00 01 02   [ 2]  213 	btjf	_flag+0, #4, 00257$
      0080E3 20 5B            [ 2]  214 	jra	00130$
      0080E5                        215 00257$:
                                    216 ;	main.c: 38: if(GetBit(flag,ext_intrrpt)){
      0080E5 72 00 00 01 02   [ 2]  217 	btjt	_flag+0, #0, 00259$
      0080EA 20 25            [ 2]  218 	jra	00105$
      0080EC                        219 00259$:
                                    220 ;	main.c: 39: if(!(GetBit(flag,tim_count))){
      0080EC 72 05 00 01 02   [ 2]  221 	btjf	_flag+0, #2, 00261$
      0080F1 20 16            [ 2]  222 	jra	00102$
      0080F3                        223 00261$:
                                    224 ;	main.c: 40: TIM2_ARRH = 0x01;
      0080F3 35 01 53 0F      [ 1]  225 	mov	0x530f+0, #0x01
                                    226 ;	main.c: 41: TIM2_ARRL = 0xdf;  
      0080F7 35 DF 53 10      [ 1]  227 	mov	0x5310+0, #0xdf
                                    228 ;	main.c: 42: TIM2_CR1 |= TIM_CR1_CEN;
      0080FB 72 10 53 00      [ 1]  229 	bset	21248, #0
                                    230 ;	main.c: 43: SetBit(flag,tim_count);
      0080FF 72 14 00 01      [ 1]  231 	bset	_flag+0, #2
                                    232 ;	main.c: 44: ClearBit(flag,ext_intrrpt);            
      008103 72 11 00 01      [ 1]  233 	bres	_flag+0, #0
      008107 20 08            [ 2]  234 	jra	00105$
      008109                        235 00102$:
                                    236 ;	main.c: 46: SetBit(flag,err_tim_count);
      008109 72 16 00 01      [ 1]  237 	bset	_flag+0, #3
                                    238 ;	main.c: 47: ClearBit(flag,ext_intrrpt);
      00810D 72 11 00 01      [ 1]  239 	bres	_flag+0, #0
      008111                        240 00105$:
                                    241 ;	main.c: 50: if(GetBit(flag,tim_end)){
      008111 72 02 00 01 02   [ 2]  242 	btjt	_flag+0, #1, 00263$
      008116 20 C6            [ 2]  243 	jra	00112$
      008118                        244 00263$:
                                    245 ;	main.c: 51: if(!(GetBit(flag,err_tim_count)) && PB_IDR&(1<<7)){
      008118 72 07 00 01 02   [ 2]  246 	btjf	_flag+0, #3, 00265$
      00811D 20 13            [ 2]  247 	jra	00107$
      00811F                        248 00265$:
      00811F C6 50 06         [ 1]  249 	ld	a, 0x5006
      008122 2A 0E            [ 1]  250 	jrpl	00107$
                                    251 ;	main.c: 52: ClearBit(flag,tim_count);
      008124 72 15 00 01      [ 1]  252 	bres	_flag+0, #2
                                    253 ;	main.c: 53: ClearBit(flag,tim_end);
      008128 72 13 00 01      [ 1]  254 	bres	_flag+0, #1
                                    255 ;	main.c: 54: SetBit(flag,startbit);
      00812C 72 18 00 01      [ 1]  256 	bset	_flag+0, #4
      008130 20 AC            [ 2]  257 	jra	00112$
      008132                        258 00107$:
                                    259 ;	main.c: 56: ClearBit(flag,tim_end);
      008132 72 13 00 01      [ 1]  260 	bres	_flag+0, #1
                                    261 ;	main.c: 57: ClearBit(flag,err_tim_count);
      008136 72 17 00 01      [ 1]  262 	bres	_flag+0, #3
                                    263 ;	main.c: 58: ClearBit(flag,tim_count); 
      00813A 72 15 00 01      [ 1]  264 	bres	_flag+0, #2
      00813E 20 9E            [ 2]  265 	jra	00112$
                                    266 ;	main.c: 63: while(i<8){//wait startbit
      008140                        267 00130$:
      008140 9E               [ 1]  268 	ld	a, xh
      008141 A1 08            [ 1]  269 	cp	a, #0x08
      008143 4F               [ 1]  270 	clr	a
      008144 49               [ 1]  271 	rlc	a
      008145 26 03            [ 1]  272 	jrne	00267$
      008147 CC 81 F4         [ 2]  273 	jp	00132$
      00814A                        274 00267$:
                                    275 ;	main.c: 64: if(GetBit(flag,ext_intrrpt)){
      00814A 72 00 00 01 02   [ 2]  276 	btjt	_flag+0, #0, 00269$
      00814F 20 25            [ 2]  277 	jra	00119$
      008151                        278 00269$:
                                    279 ;	main.c: 65: if(!(GetBit(flag,tim_count))){
      008151 72 05 00 01 02   [ 2]  280 	btjf	_flag+0, #2, 00271$
      008156 20 16            [ 2]  281 	jra	00116$
      008158                        282 00271$:
                                    283 ;	main.c: 66: TIM2_ARRH = 0x00;
      008158 35 00 53 0F      [ 1]  284 	mov	0x530f+0, #0x00
                                    285 ;	main.c: 67: TIM2_ARRL = 0xaf;  
      00815C 35 AF 53 10      [ 1]  286 	mov	0x5310+0, #0xaf
                                    287 ;	main.c: 68: TIM2_CR1 |= TIM_CR1_CEN;
      008160 72 10 53 00      [ 1]  288 	bset	21248, #0
                                    289 ;	main.c: 69: SetBit(flag,tim_count);
      008164 72 14 00 01      [ 1]  290 	bset	_flag+0, #2
                                    291 ;	main.c: 70: ClearBit(flag,ext_intrrpt);            
      008168 72 11 00 01      [ 1]  292 	bres	_flag+0, #0
      00816C 20 08            [ 2]  293 	jra	00119$
      00816E                        294 00116$:
                                    295 ;	main.c: 72: SetBit(flag,err_tim_count);
      00816E 72 16 00 01      [ 1]  296 	bset	_flag+0, #3
                                    297 ;	main.c: 73: ClearBit(flag,ext_intrrpt);
      008172 72 11 00 01      [ 1]  298 	bres	_flag+0, #0
      008176                        299 00119$:
                                    300 ;	main.c: 76: if(GetBit(flag,tim_end)){
      008176 72 02 00 01 02   [ 2]  301 	btjt	_flag+0, #1, 00273$
      00817B 20 C3            [ 2]  302 	jra	00130$
      00817D                        303 00273$:
                                    304 ;	main.c: 77: if(!(GetBit(flag,err_tim_count)) && PB_IDR&(1<<7)){
      00817D 72 07 00 01 02   [ 2]  305 	btjf	_flag+0, #3, 00275$
      008182 20 25            [ 2]  306 	jra	00125$
      008184                        307 00275$:
      008184 C6 50 06         [ 1]  308 	ld	a, 0x5006
      008187 2A 20            [ 1]  309 	jrpl	00125$
                                    310 ;	main.c: 78: resiver|=(1<<i),
      008189 9E               [ 1]  311 	ld	a, xh
      00818A 88               [ 1]  312 	push	a
      00818B A6 01            [ 1]  313 	ld	a, #0x01
      00818D 6B 03            [ 1]  314 	ld	(0x03, sp), a
      00818F 84               [ 1]  315 	pop	a
      008190 4D               [ 1]  316 	tnz	a
      008191 27 05            [ 1]  317 	jreq	00278$
      008193                        318 00277$:
      008193 08 02            [ 1]  319 	sll	(0x02, sp)
      008195 4A               [ 1]  320 	dec	a
      008196 26 FB            [ 1]  321 	jrne	00277$
      008198                        322 00278$:
      008198 9F               [ 1]  323 	ld	a, xl
      008199 1A 02            [ 1]  324 	or	a, (0x02, sp)
      00819B 97               [ 1]  325 	ld	xl, a
                                    326 ;	main.c: 79: i++;
      00819C 1C 01 00         [ 2]  327 	addw	x, #256
                                    328 ;	main.c: 80: ClearBit(flag,tim_count);
      00819F 72 15 00 01      [ 1]  329 	bres	_flag+0, #2
                                    330 ;	main.c: 81: ClearBit(flag,tim_end);
      0081A3 72 13 00 01      [ 1]  331 	bres	_flag+0, #1
      0081A7 20 97            [ 2]  332 	jra	00130$
      0081A9                        333 00125$:
                                    334 ;	main.c: 82: }else if(!(GetBit(flag,err_tim_count)) && !(PB_IDR&(1<<7))){
      0081A9 C6 00 01         [ 1]  335 	ld	a, _flag+0
      0081AC A4 08            [ 1]  336 	and	a, #0x08
                                    337 ;	main.c: 53: ClearBit(flag,tim_end);
      0081AE 88               [ 1]  338 	push	a
      0081AF C6 00 01         [ 1]  339 	ld	a, _flag+0
      0081B2 A4 FD            [ 1]  340 	and	a, #0xfd
      0081B4 6B 02            [ 1]  341 	ld	(0x02, sp), a
      0081B6 84               [ 1]  342 	pop	a
                                    343 ;	main.c: 82: }else if(!(GetBit(flag,err_tim_count)) && !(PB_IDR&(1<<7))){
      0081B7 4D               [ 1]  344 	tnz	a
      0081B8 26 2A            [ 1]  345 	jrne	00121$
      0081BA C6 50 06         [ 1]  346 	ld	a, 0x5006
      0081BD 2B 25            [ 1]  347 	jrmi	00121$
                                    348 ;	main.c: 83: resiver&=~(1<<i),
      0081BF 90 93            [ 1]  349 	ldw	y, x
      0081C1 A6 01            [ 1]  350 	ld	a, #0x01
      0081C3 88               [ 1]  351 	push	a
      0081C4 90 9E            [ 1]  352 	ld	a, yh
      0081C6 4D               [ 1]  353 	tnz	a
      0081C7 27 05            [ 1]  354 	jreq	00282$
      0081C9                        355 00281$:
      0081C9 08 01            [ 1]  356 	sll	(1, sp)
      0081CB 4A               [ 1]  357 	dec	a
      0081CC 26 FB            [ 1]  358 	jrne	00281$
      0081CE                        359 00282$:
      0081CE 84               [ 1]  360 	pop	a
      0081CF 43               [ 1]  361 	cpl	a
      0081D0 89               [ 2]  362 	pushw	x
      0081D1 14 02            [ 1]  363 	and	a, (2, sp)
      0081D3 85               [ 2]  364 	popw	x
      0081D4 97               [ 1]  365 	ld	xl, a
                                    366 ;	main.c: 84: i++;
      0081D5 1C 01 00         [ 2]  367 	addw	x, #256
                                    368 ;	main.c: 85: ClearBit(flag,tim_end);
      0081D8 7B 01            [ 1]  369 	ld	a, (0x01, sp)
      0081DA C7 00 01         [ 1]  370 	ld	_flag+0, a
                                    371 ;	main.c: 86: ClearBit(flag,tim_count);
      0081DD 72 15 00 01      [ 1]  372 	bres	_flag+0, #2
      0081E1 CC 81 40         [ 2]  373 	jp	00130$
      0081E4                        374 00121$:
                                    375 ;	main.c: 88: ClearBit(flag,tim_end);
      0081E4 7B 01            [ 1]  376 	ld	a, (0x01, sp)
      0081E6 C7 00 01         [ 1]  377 	ld	_flag+0, a
                                    378 ;	main.c: 89: ClearBit(flag,err_tim_count);
      0081E9 72 17 00 01      [ 1]  379 	bres	_flag+0, #3
                                    380 ;	main.c: 90: ClearBit(flag,tim_count); 
      0081ED 72 15 00 01      [ 1]  381 	bres	_flag+0, #2
      0081F1 CC 81 40         [ 2]  382 	jp	00130$
      0081F4                        383 00132$:
                                    384 ;	main.c: 94: __asm__("sim\n");
      0081F4 9B               [ 1]  385 	sim
                                    386 ;	main.c: 95: if(i>=8){
      0081F5 4D               [ 1]  387 	tnz	a
      0081F6 26 30            [ 1]  388 	jrne	00145$
                                    389 ;	main.c: 96: i=0;
      0081F8 4F               [ 1]  390 	clr	a
      0081F9 95               [ 1]  391 	ld	xh, a
                                    392 ;	main.c: 97: ClearBit(flag,startbit);
      0081FA 72 19 00 01      [ 1]  393 	bres	_flag+0, #4
                                    394 ;	main.c: 98: if(resiver=='D'){
      0081FE 9F               [ 1]  395 	ld	a, xl
      0081FF A1 44            [ 1]  396 	cp	a, #0x44
      008201 26 06            [ 1]  397 	jrne	00142$
                                    398 ;	main.c: 99: PD_ODR=0x01;
      008203 35 01 50 0F      [ 1]  399 	mov	0x500f+0, #0x01
      008207 20 1F            [ 2]  400 	jra	00145$
      008209                        401 00142$:
                                    402 ;	main.c: 100: }else if(resiver=='A'){
      008209 9F               [ 1]  403 	ld	a, xl
      00820A A1 41            [ 1]  404 	cp	a, #0x41
      00820C 26 06            [ 1]  405 	jrne	00139$
                                    406 ;	main.c: 101: PD_ODR=0x10;
      00820E 35 10 50 0F      [ 1]  407 	mov	0x500f+0, #0x10
      008212 20 14            [ 2]  408 	jra	00145$
      008214                        409 00139$:
                                    410 ;	main.c: 102: }else if(resiver=='B'){
      008214 9F               [ 1]  411 	ld	a, xl
      008215 A1 42            [ 1]  412 	cp	a, #0x42
      008217 26 06            [ 1]  413 	jrne	00136$
                                    414 ;	main.c: 103: PD_ODR=0x04;
      008219 35 04 50 0F      [ 1]  415 	mov	0x500f+0, #0x04
      00821D 20 09            [ 2]  416 	jra	00145$
      00821F                        417 00136$:
                                    418 ;	main.c: 104: }else if(resiver=='C'){
      00821F 9F               [ 1]  419 	ld	a, xl
      008220 A1 43            [ 1]  420 	cp	a, #0x43
      008222 26 04            [ 1]  421 	jrne	00145$
                                    422 ;	main.c: 105: PD_ODR=0x08;
      008224 35 08 50 0F      [ 1]  423 	mov	0x500f+0, #0x08
      008228                        424 00145$:
                                    425 ;	main.c: 108: __asm__("rim\n");
      008228 9A               [ 1]  426 	rim
                                    427 ;	main.c: 110: }
      008229 CC 80 DE         [ 2]  428 	jp	00112$
                                    429 	.area CODE
                                    430 	.area CONST
                                    431 	.area INITIALIZER
      008060                        432 __xinit__flag:
      008060 00                     433 	.db #0x00	; 0
                                    434 	.area CABS (ABS)
