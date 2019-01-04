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
                                     13 	.globl _SPI_deinit
                                     14 	.globl _chip_deselect
                                     15 	.globl _chip_select
                                     16 	.globl _SPI_read
                                     17 	.globl _SPI_write
                                     18 	.globl _SPI_init
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
      008000 82 00 80 07             54 	int s_GSINIT ; reset
                                     55 ;--------------------------------------------------------
                                     56 ; global & static initialisations
                                     57 ;--------------------------------------------------------
                                     58 	.area HOME
                                     59 	.area GSINIT
                                     60 	.area GSFINAL
                                     61 	.area GSINIT
      008007                         62 __sdcc_gs_init_startup:
      008007                         63 __sdcc_init_data:
                                     64 ; stm8_genXINIT() start
      008007 AE 00 00         [ 2]   65 	ldw x, #l_DATA
      00800A 27 07            [ 1]   66 	jreq	00002$
      00800C                         67 00001$:
      00800C 72 4F 00 00      [ 1]   68 	clr (s_DATA - 1, x)
      008010 5A               [ 2]   69 	decw x
      008011 26 F9            [ 1]   70 	jrne	00001$
      008013                         71 00002$:
      008013 AE 00 00         [ 2]   72 	ldw	x, #l_INITIALIZER
      008016 27 09            [ 1]   73 	jreq	00004$
      008018                         74 00003$:
      008018 D6 80 23         [ 1]   75 	ld	a, (s_INITIALIZER - 1, x)
      00801B D7 00 00         [ 1]   76 	ld	(s_INITIALIZED - 1, x), a
      00801E 5A               [ 2]   77 	decw	x
      00801F 26 F7            [ 1]   78 	jrne	00003$
      008021                         79 00004$:
                                     80 ; stm8_genXINIT() end
                                     81 	.area GSFINAL
      008021 CC 80 04         [ 2]   82 	jp	__sdcc_program_startup
                                     83 ;--------------------------------------------------------
                                     84 ; Home
                                     85 ;--------------------------------------------------------
                                     86 	.area HOME
                                     87 	.area HOME
      008004                         88 __sdcc_program_startup:
      008004 CC 80 E7         [ 2]   89 	jp	_main
                                     90 ;	return from main will return to caller
                                     91 ;--------------------------------------------------------
                                     92 ; code
                                     93 ;--------------------------------------------------------
                                     94 	.area CODE
                                     95 ;	inc/clk_init.h: 7: void clk_init(void){    
                                     96 ;	-----------------------------------------
                                     97 ;	 function clk_init
                                     98 ;	-----------------------------------------
      008024                         99 _clk_init:
                                    100 ;	inc/clk_init.h: 8: CLK_ECKR|=CLK_ECKR_HSEEN;            
      008024 72 10 50 C1      [ 1]  101 	bset	20673, #0
                                    102 ;	inc/clk_init.h: 9: CLK_SWCR|=CLK_SWCR_SWEN;               
      008028 72 12 50 C5      [ 1]  103 	bset	20677, #1
                                    104 ;	inc/clk_init.h: 10: while((CLK_ECKR & CLK_ECKR_HSERDY) == 0) {} 
      00802C                        105 00101$:
      00802C C6 50 C1         [ 1]  106 	ld	a, 0x50c1
      00802F A5 02            [ 1]  107 	bcp	a, #0x02
      008031 27 F9            [ 1]  108 	jreq	00101$
                                    109 ;	inc/clk_init.h: 11: CLK_CKDIVR = 0;                    
      008033 35 00 50 C6      [ 1]  110 	mov	0x50c6+0, #0x00
                                    111 ;	inc/clk_init.h: 12: CLK_SWR = 0xB4;                    
      008037 35 B4 50 C4      [ 1]  112 	mov	0x50c4+0, #0xb4
                                    113 ;	inc/clk_init.h: 13: while ((CLK_SWCR & CLK_SWCR_SWIF) == 0){}
      00803B                        114 00104$:
      00803B C6 50 C5         [ 1]  115 	ld	a, 0x50c5
      00803E A5 08            [ 1]  116 	bcp	a, #0x08
      008040 27 F9            [ 1]  117 	jreq	00104$
                                    118 ;	inc/clk_init.h: 14: CLK_CSSR|=CLK_CSSR_CSSEN;
      008042 72 10 50 C8      [ 1]  119 	bset	20680, #0
                                    120 ;	inc/clk_init.h: 15: }
      008046 81               [ 4]  121 	ret
                                    122 ;	inc/gpio_init.h: 10: void GPIO_init(void)
                                    123 ;	-----------------------------------------
                                    124 ;	 function GPIO_init
                                    125 ;	-----------------------------------------
      008047                        126 _GPIO_init:
                                    127 ;	inc/gpio_init.h: 17: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
      008047 35 00 50 07      [ 1]  128 	mov	0x5007+0, #0x00
                                    129 ;	inc/gpio_init.h: 18: PB_CR1 = 0xff;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
      00804B 35 FF 50 08      [ 1]  130 	mov	0x5008+0, #0xff
                                    131 ;	inc/gpio_init.h: 19: PB_CR2 = 0xff;                                                      //_______PORT_OUT
      00804F 35 FF 50 09      [ 1]  132 	mov	0x5009+0, #0xff
                                    133 ;	inc/gpio_init.h: 21: PC_DDR = 0xff;                                                        //_______1__________________0________________0_____________otkritiy stok
      008053 35 FF 50 0C      [ 1]  134 	mov	0x500c+0, #0xff
                                    135 ;	inc/gpio_init.h: 22: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
      008057 35 FF 50 0D      [ 1]  136 	mov	0x500d+0, #0xff
                                    137 ;	inc/gpio_init.h: 23: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
      00805B 35 00 50 0E      [ 1]  138 	mov	0x500e+0, #0x00
                                    139 ;	inc/gpio_init.h: 25: PD_DDR = 0xFF;   
      00805F 35 FF 50 11      [ 1]  140 	mov	0x5011+0, #0xff
                                    141 ;	inc/gpio_init.h: 26: PD_CR1 = 0xFF;  
      008063 35 FF 50 12      [ 1]  142 	mov	0x5012+0, #0xff
                                    143 ;	inc/gpio_init.h: 27: PD_CR2 = 0x00; 
      008067 35 00 50 13      [ 1]  144 	mov	0x5013+0, #0x00
                                    145 ;	inc/gpio_init.h: 40: }
      00806B 81               [ 4]  146 	ret
                                    147 ;	main.c: 6: void SPI_init() {
                                    148 ;	-----------------------------------------
                                    149 ;	 function SPI_init
                                    150 ;	-----------------------------------------
      00806C                        151 _SPI_init:
                                    152 ;	main.c: 8: PC_DDR |= (1 << CS_PIN);
      00806C 72 18 50 0C      [ 1]  153 	bset	20492, #4
                                    154 ;	main.c: 9: PC_CR1 |= (1 << CS_PIN);
      008070 72 18 50 0D      [ 1]  155 	bset	20493, #4
                                    156 ;	main.c: 10: PC_ODR |= (1 << CS_PIN);
      008074 72 18 50 0A      [ 1]  157 	bset	20490, #4
                                    158 ;	main.c: 12: SPI_CR2 = SPI_CR2_SSM | SPI_CR2_SSI;//без этой настройки требуется подключить вывод NSS к VDD
      008078 35 03 52 01      [ 1]  159 	mov	0x5201+0, #0x03
                                    160 ;	main.c: 13: SPI_CR1 = SPI_CR1_MSTR | SPI_CR1_SPE | SPI_CR1_BR0;// | SPI_CR1_BR2;//??????SPI_CR1_BR(0)???????
      00807C 35 4C 52 00      [ 1]  161 	mov	0x5200+0, #0x4c
                                    162 ;	main.c: 15: }
      008080 81               [ 4]  163 	ret
                                    164 ;	main.c: 17: void SPI_write(int data) {
                                    165 ;	-----------------------------------------
                                    166 ;	 function SPI_write
                                    167 ;	-----------------------------------------
      008081                        168 _SPI_write:
                                    169 ;	main.c: 18: SPI_DR = data;
      008081 7B 04            [ 1]  170 	ld	a, (0x04, sp)
      008083 C7 52 04         [ 1]  171 	ld	0x5204, a
                                    172 ;	main.c: 19: while (!(SPI_SR & SPI_SR_TXE));
      008086                        173 00101$:
      008086 C6 52 03         [ 1]  174 	ld	a, 0x5203
      008089 A5 02            [ 1]  175 	bcp	a, #0x02
      00808B 27 F9            [ 1]  176 	jreq	00101$
                                    177 ;	main.c: 20: }
      00808D 81               [ 4]  178 	ret
                                    179 ;	main.c: 21: int SPI_read() {
                                    180 ;	-----------------------------------------
                                    181 ;	 function SPI_read
                                    182 ;	-----------------------------------------
      00808E                        183 _SPI_read:
                                    184 ;	main.c: 22: SPI_write(0xFF);
      00808E 4B FF            [ 1]  185 	push	#0xff
      008090 4B 00            [ 1]  186 	push	#0x00
      008092 CD 80 81         [ 4]  187 	call	_SPI_write
      008095 5B 02            [ 2]  188 	addw	sp, #2
                                    189 ;	main.c: 23: while (!(SPI_SR & SPI_SR_RXNE));
      008097                        190 00101$:
      008097 C6 52 03         [ 1]  191 	ld	a, 0x5203
      00809A 44               [ 1]  192 	srl	a
      00809B 24 FA            [ 1]  193 	jrnc	00101$
                                    194 ;	main.c: 24: return SPI_DR;
      00809D C6 52 04         [ 1]  195 	ld	a, 0x5204
      0080A0 5F               [ 1]  196 	clrw	x
      0080A1 97               [ 1]  197 	ld	xl, a
                                    198 ;	main.c: 25: }
      0080A2 81               [ 4]  199 	ret
                                    200 ;	main.c: 26: void chip_select() {
                                    201 ;	-----------------------------------------
                                    202 ;	 function chip_select
                                    203 ;	-----------------------------------------
      0080A3                        204 _chip_select:
                                    205 ;	main.c: 27: PC_ODR &= ~(1 << CS_PIN);
      0080A3 72 19 50 0A      [ 1]  206 	bres	20490, #4
                                    207 ;	main.c: 28: }
      0080A7 81               [ 4]  208 	ret
                                    209 ;	main.c: 29: void chip_deselect() {
                                    210 ;	-----------------------------------------
                                    211 ;	 function chip_deselect
                                    212 ;	-----------------------------------------
      0080A8                        213 _chip_deselect:
                                    214 ;	main.c: 30: while ((SPI_SR & SPI_SR_BSY));
      0080A8                        215 00101$:
      0080A8 C6 52 03         [ 1]  216 	ld	a, 0x5203
      0080AB 2B FB            [ 1]  217 	jrmi	00101$
                                    218 ;	main.c: 31: PC_ODR |= (1 << CS_PIN);
      0080AD 72 18 50 0A      [ 1]  219 	bset	20490, #4
                                    220 ;	main.c: 32: }
      0080B1 81               [ 4]  221 	ret
                                    222 ;	main.c: 33: void SPI_deinit() {
                                    223 ;	-----------------------------------------
                                    224 ;	 function SPI_deinit
                                    225 ;	-----------------------------------------
      0080B2                        226 _SPI_deinit:
                                    227 ;	main.c: 34: while (!(SPI_SR & SPI_SR_RXNE));
      0080B2                        228 00101$:
      0080B2 C6 52 03         [ 1]  229 	ld	a, 0x5203
      0080B5 97               [ 1]  230 	ld	xl, a
      0080B6 44               [ 1]  231 	srl	a
      0080B7 24 F9            [ 1]  232 	jrnc	00101$
                                    233 ;	main.c: 35: while (!(SPI_SR & SPI_SR_TXE));
      0080B9 9F               [ 1]  234 	ld	a, xl
      0080BA A4 02            [ 1]  235 	and	a, #0x02
      0080BC                        236 00104$:
      0080BC 4D               [ 1]  237 	tnz	a
      0080BD 27 FD            [ 1]  238 	jreq	00104$
                                    239 ;	main.c: 36: while ((SPI_SR & SPI_SR_BSY));
      0080BF 9F               [ 1]  240 	ld	a, xl
      0080C0 A4 80            [ 1]  241 	and	a, #0x80
      0080C2                        242 00107$:
      0080C2 4D               [ 1]  243 	tnz	a
      0080C3 26 FD            [ 1]  244 	jrne	00107$
                                    245 ;	main.c: 37: SPI_CR1 &=~ SPI_CR1_SPE;
      0080C5 72 1D 52 00      [ 1]  246 	bres	20992, #6
                                    247 ;	main.c: 38: }
      0080C9 81               [ 4]  248 	ret
                                    249 ;	main.c: 39: void delay(int t)
                                    250 ;	-----------------------------------------
                                    251 ;	 function delay
                                    252 ;	-----------------------------------------
      0080CA                        253 _delay:
      0080CA 52 02            [ 2]  254 	sub	sp, #2
                                    255 ;	main.c: 42: for(i=0;i<t;i++)
      0080CC 5F               [ 1]  256 	clrw	x
      0080CD                        257 00107$:
      0080CD 13 05            [ 2]  258 	cpw	x, (0x05, sp)
      0080CF 2E 13            [ 1]  259 	jrsge	00109$
                                    260 ;	main.c: 44: for(s=0;s<512;s++)
      0080D1 0F 02            [ 1]  261 	clr	(0x02, sp)
      0080D3 A6 02            [ 1]  262 	ld	a, #0x02
      0080D5 6B 01            [ 1]  263 	ld	(0x01, sp), a
      0080D7                        264 00105$:
      0080D7 16 01            [ 2]  265 	ldw	y, (0x01, sp)
      0080D9 90 5A            [ 2]  266 	decw	y
      0080DB 17 01            [ 2]  267 	ldw	(0x01, sp), y
      0080DD 90 5D            [ 2]  268 	tnzw	y
      0080DF 26 F6            [ 1]  269 	jrne	00105$
                                    270 ;	main.c: 42: for(i=0;i<t;i++)
      0080E1 5C               [ 1]  271 	incw	x
      0080E2 20 E9            [ 2]  272 	jra	00107$
      0080E4                        273 00109$:
                                    274 ;	main.c: 48: }
      0080E4 5B 02            [ 2]  275 	addw	sp, #2
      0080E6 81               [ 4]  276 	ret
                                    277 ;	main.c: 50: void main(void)
                                    278 ;	-----------------------------------------
                                    279 ;	 function main
                                    280 ;	-----------------------------------------
      0080E7                        281 _main:
      0080E7 52 10            [ 2]  282 	sub	sp, #16
                                    283 ;	main.c: 52: clk_init();
      0080E9 CD 80 24         [ 4]  284 	call	_clk_init
                                    285 ;	main.c: 53: GPIO_init();
      0080EC CD 80 47         [ 4]  286 	call	_GPIO_init
                                    287 ;	main.c: 54: int data[]={'t','e','s','t','\n','\r'};
      0080EF 96               [ 1]  288 	ldw	x, sp
      0080F0 5C               [ 1]  289 	incw	x
      0080F1 1F 0D            [ 2]  290 	ldw	(0x0d, sp), x
      0080F3 90 AE 00 74      [ 2]  291 	ldw	y, #0x0074
      0080F7 FF               [ 2]  292 	ldw	(x), y
      0080F8 1E 0D            [ 2]  293 	ldw	x, (0x0d, sp)
      0080FA 90 AE 00 65      [ 2]  294 	ldw	y, #0x0065
      0080FE EF 02            [ 2]  295 	ldw	(0x02, x), y
      008100 1E 0D            [ 2]  296 	ldw	x, (0x0d, sp)
      008102 90 AE 00 73      [ 2]  297 	ldw	y, #0x0073
      008106 EF 04            [ 2]  298 	ldw	(0x0004, x), y
      008108 1E 0D            [ 2]  299 	ldw	x, (0x0d, sp)
      00810A 90 AE 00 74      [ 2]  300 	ldw	y, #0x0074
      00810E EF 06            [ 2]  301 	ldw	(0x0006, x), y
      008110 1E 0D            [ 2]  302 	ldw	x, (0x0d, sp)
      008112 90 AE 00 0A      [ 2]  303 	ldw	y, #0x000a
      008116 EF 08            [ 2]  304 	ldw	(0x0008, x), y
      008118 1E 0D            [ 2]  305 	ldw	x, (0x0d, sp)
      00811A 1C 00 0A         [ 2]  306 	addw	x, #0x000a
      00811D 90 AE 00 0D      [ 2]  307 	ldw	y, #0x000d
      008121 FF               [ 2]  308 	ldw	(x), y
                                    309 ;	main.c: 55: PC_DDR |= (1 << CS_PIN);
      008122 72 18 50 0C      [ 1]  310 	bset	20492, #4
                                    311 ;	main.c: 56: PC_CR1 |= (1 << CS_PIN);
      008126 72 18 50 0D      [ 1]  312 	bset	20493, #4
                                    313 ;	main.c: 57: PC_ODR |= (1 << CS_PIN);
      00812A 72 18 50 0A      [ 1]  314 	bset	20490, #4
                                    315 ;	main.c: 59: SPI_init();
      00812E CD 80 6C         [ 4]  316 	call	_SPI_init
                                    317 ;	main.c: 60: PD_ODR|=(1<<0);
      008131 C6 50 0F         [ 1]  318 	ld	a, 0x500f
      008134 AA 01            [ 1]  319 	or	a, #0x01
      008136 C7 50 0F         [ 1]  320 	ld	0x500f, a
                                    321 ;	main.c: 61: while (1) {
      008139                        322 00103$:
                                    323 ;	main.c: 62: chip_select();
      008139 CD 80 A3         [ 4]  324 	call	_chip_select
                                    325 ;	main.c: 63: for(int i=0;i<6;i++){
      00813C 5F               [ 1]  326 	clrw	x
      00813D 1F 0F            [ 2]  327 	ldw	(0x0f, sp), x
      00813F                        328 00106$:
      00813F 1E 0F            [ 2]  329 	ldw	x, (0x0f, sp)
      008141 A3 00 06         [ 2]  330 	cpw	x, #0x0006
      008144 2E 1D            [ 1]  331 	jrsge	00101$
                                    332 ;	main.c: 64: SPI_write(data[i]);
      008146 1E 0F            [ 2]  333 	ldw	x, (0x0f, sp)
      008148 58               [ 2]  334 	sllw	x
      008149 72 FB 0D         [ 2]  335 	addw	x, (0x0d, sp)
      00814C FE               [ 2]  336 	ldw	x, (x)
      00814D 89               [ 2]  337 	pushw	x
      00814E CD 80 81         [ 4]  338 	call	_SPI_write
      008151 5B 02            [ 2]  339 	addw	sp, #2
                                    340 ;	main.c: 65: delay(1);
      008153 4B 01            [ 1]  341 	push	#0x01
      008155 4B 00            [ 1]  342 	push	#0x00
      008157 CD 80 CA         [ 4]  343 	call	_delay
      00815A 5B 02            [ 2]  344 	addw	sp, #2
                                    345 ;	main.c: 63: for(int i=0;i<6;i++){
      00815C 1E 0F            [ 2]  346 	ldw	x, (0x0f, sp)
      00815E 5C               [ 1]  347 	incw	x
      00815F 1F 0F            [ 2]  348 	ldw	(0x0f, sp), x
      008161 20 DC            [ 2]  349 	jra	00106$
      008163                        350 00101$:
                                    351 ;	main.c: 67: chip_deselect();
      008163 CD 80 A8         [ 4]  352 	call	_chip_deselect
                                    353 ;	main.c: 68: delay(500);
      008166 4B F4            [ 1]  354 	push	#0xf4
      008168 4B 01            [ 1]  355 	push	#0x01
      00816A CD 80 CA         [ 4]  356 	call	_delay
      00816D 5B 02            [ 2]  357 	addw	sp, #2
                                    358 ;	main.c: 69: PD_ODR &=~ (1<<0);
      00816F C6 50 0F         [ 1]  359 	ld	a, 0x500f
      008172 A4 FE            [ 1]  360 	and	a, #0xfe
      008174 C7 50 0F         [ 1]  361 	ld	0x500f, a
      008177 20 C0            [ 2]  362 	jra	00103$
                                    363 ;	main.c: 71: }
      008179 5B 10            [ 2]  364 	addw	sp, #16
      00817B 81               [ 4]  365 	ret
                                    366 	.area CODE
                                    367 	.area CONST
                                    368 	.area INITIALIZER
                                    369 	.area CABS (ABS)
