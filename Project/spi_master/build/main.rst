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
                                     19 	.globl _rx
                                     20 	.globl _tx
                                     21 	.globl _uart1_init
                                     22 	.globl _clk_init
                                     23 ;--------------------------------------------------------
                                     24 ; ram data
                                     25 ;--------------------------------------------------------
                                     26 	.area DATA
                                     27 ;--------------------------------------------------------
                                     28 ; ram data
                                     29 ;--------------------------------------------------------
                                     30 	.area INITIALIZED
                                     31 ;--------------------------------------------------------
                                     32 ; Stack segment in internal ram 
                                     33 ;--------------------------------------------------------
                                     34 	.area	SSEG
      FFFFFF                         35 __start__stack:
      FFFFFF                         36 	.ds	1
                                     37 
                                     38 ;--------------------------------------------------------
                                     39 ; absolute external ram data
                                     40 ;--------------------------------------------------------
                                     41 	.area DABS (ABS)
                                     42 
                                     43 ; default segment ordering for linker
                                     44 	.area HOME
                                     45 	.area GSINIT
                                     46 	.area GSFINAL
                                     47 	.area CONST
                                     48 	.area INITIALIZER
                                     49 	.area CODE
                                     50 
                                     51 ;--------------------------------------------------------
                                     52 ; interrupt vector 
                                     53 ;--------------------------------------------------------
                                     54 	.area HOME
      008000                         55 __interrupt_vect:
      008000 82 00 80 07             56 	int s_GSINIT ; reset
                                     57 ;--------------------------------------------------------
                                     58 ; global & static initialisations
                                     59 ;--------------------------------------------------------
                                     60 	.area HOME
                                     61 	.area GSINIT
                                     62 	.area GSFINAL
                                     63 	.area GSINIT
      008007                         64 __sdcc_gs_init_startup:
      008007                         65 __sdcc_init_data:
                                     66 ; stm8_genXINIT() start
      008007 AE 00 00         [ 2]   67 	ldw x, #l_DATA
      00800A 27 07            [ 1]   68 	jreq	00002$
      00800C                         69 00001$:
      00800C 72 4F 00 00      [ 1]   70 	clr (s_DATA - 1, x)
      008010 5A               [ 2]   71 	decw x
      008011 26 F9            [ 1]   72 	jrne	00001$
      008013                         73 00002$:
      008013 AE 00 00         [ 2]   74 	ldw	x, #l_INITIALIZER
      008016 27 09            [ 1]   75 	jreq	00004$
      008018                         76 00003$:
      008018 D6 80 23         [ 1]   77 	ld	a, (s_INITIALIZER - 1, x)
      00801B D7 00 00         [ 1]   78 	ld	(s_INITIALIZED - 1, x), a
      00801E 5A               [ 2]   79 	decw	x
      00801F 26 F7            [ 1]   80 	jrne	00003$
      008021                         81 00004$:
                                     82 ; stm8_genXINIT() end
                                     83 	.area GSFINAL
      008021 CC 80 04         [ 2]   84 	jp	__sdcc_program_startup
                                     85 ;--------------------------------------------------------
                                     86 ; Home
                                     87 ;--------------------------------------------------------
                                     88 	.area HOME
                                     89 	.area HOME
      008004                         90 __sdcc_program_startup:
      008004 CC 81 09         [ 2]   91 	jp	_main
                                     92 ;	return from main will return to caller
                                     93 ;--------------------------------------------------------
                                     94 ; code
                                     95 ;--------------------------------------------------------
                                     96 	.area CODE
                                     97 ;	inc/clk_init.h: 7: void clk_init(void){    
                                     98 ;	-----------------------------------------
                                     99 ;	 function clk_init
                                    100 ;	-----------------------------------------
      008024                        101 _clk_init:
                                    102 ;	inc/clk_init.h: 8: CLK_ECKR|=CLK_ECKR_HSEEN;            
      008024 72 10 50 C1      [ 1]  103 	bset	20673, #0
                                    104 ;	inc/clk_init.h: 9: CLK_SWCR|=CLK_SWCR_SWEN;               
      008028 72 12 50 C5      [ 1]  105 	bset	20677, #1
                                    106 ;	inc/clk_init.h: 10: while((CLK_ECKR & CLK_ECKR_HSERDY) == 0) {} 
      00802C                        107 00101$:
      00802C C6 50 C1         [ 1]  108 	ld	a, 0x50c1
      00802F A5 02            [ 1]  109 	bcp	a, #0x02
      008031 27 F9            [ 1]  110 	jreq	00101$
                                    111 ;	inc/clk_init.h: 11: CLK_CKDIVR = 0;                    
      008033 35 00 50 C6      [ 1]  112 	mov	0x50c6+0, #0x00
                                    113 ;	inc/clk_init.h: 12: CLK_SWR = 0xB4;                    
      008037 35 B4 50 C4      [ 1]  114 	mov	0x50c4+0, #0xb4
                                    115 ;	inc/clk_init.h: 13: while ((CLK_SWCR & CLK_SWCR_SWIF) == 0){}
      00803B                        116 00104$:
      00803B C6 50 C5         [ 1]  117 	ld	a, 0x50c5
      00803E A5 08            [ 1]  118 	bcp	a, #0x08
      008040 27 F9            [ 1]  119 	jreq	00104$
                                    120 ;	inc/clk_init.h: 14: CLK_CSSR|=CLK_CSSR_CSSEN;
      008042 72 10 50 C8      [ 1]  121 	bset	20680, #0
                                    122 ;	inc/clk_init.h: 15: }
      008046 81               [ 4]  123 	ret
                                    124 ;	inc/uart1.h: 1: void uart1_init()
                                    125 ;	-----------------------------------------
                                    126 ;	 function uart1_init
                                    127 ;	-----------------------------------------
      008047                        128 _uart1_init:
                                    129 ;	inc/uart1.h: 3: PD_DDR&=~(1<<6);  
      008047 72 1D 50 11      [ 1]  130 	bres	20497, #6
                                    131 ;	inc/uart1.h: 4: PD_DDR|=(1<<5);             
      00804B 72 1A 50 11      [ 1]  132 	bset	20497, #5
                                    133 ;	inc/uart1.h: 5: UART1_CR2|=UART1_CR2_REN;
      00804F 72 14 52 35      [ 1]  134 	bset	21045, #2
                                    135 ;	inc/uart1.h: 6: UART1_CR2|=UART1_CR2_TEN;  
      008053 72 16 52 35      [ 1]  136 	bset	21045, #3
                                    137 ;	inc/uart1.h: 7: UART1_BRR2 = 0x00;             
      008057 35 00 52 33      [ 1]  138 	mov	0x5233+0, #0x00
                                    139 ;	inc/uart1.h: 8: UART1_BRR1 = 0x48;            
      00805B 35 48 52 32      [ 1]  140 	mov	0x5232+0, #0x48
                                    141 ;	inc/uart1.h: 9: }
      00805F 81               [ 4]  142 	ret
                                    143 ;	inc/uart1.h: 10: void tx(char *str)
                                    144 ;	-----------------------------------------
                                    145 ;	 function tx
                                    146 ;	-----------------------------------------
      008060                        147 _tx:
                                    148 ;	inc/uart1.h: 14: while (!(UART1_SR & UART1_SR_TXE)) {}       
      008060 1E 03            [ 2]  149 	ldw	x, (0x03, sp)
      008062                        150 00101$:
      008062 C6 52 30         [ 1]  151 	ld	a, 0x5230
      008065 2A FB            [ 1]  152 	jrpl	00101$
                                    153 ;	inc/uart1.h: 15: UART1_DR=*str; 
      008067 F6               [ 1]  154 	ld	a, (x)
      008068 C7 52 31         [ 1]  155 	ld	0x5231, a
                                    156 ;	inc/uart1.h: 16: if(*str=='\r') break;
      00806B F6               [ 1]  157 	ld	a, (x)
      00806C A1 0D            [ 1]  158 	cp	a, #0x0d
      00806E 26 01            [ 1]  159 	jrne	00129$
      008070 81               [ 4]  160 	ret
      008071                        161 00129$:
                                    162 ;	inc/uart1.h: 17: *str++;
      008071 5C               [ 1]  163 	incw	x
      008072 20 EE            [ 2]  164 	jra	00101$
                                    165 ;	inc/uart1.h: 20: } 
      008074 81               [ 4]  166 	ret
                                    167 ;	inc/uart1.h: 21: void rx(char *str)
                                    168 ;	-----------------------------------------
                                    169 ;	 function rx
                                    170 ;	-----------------------------------------
      008075                        171 _rx:
                                    172 ;	inc/uart1.h: 23: while (*str!='\r')
      008075                        173 00104$:
      008075 1E 03            [ 2]  174 	ldw	x, (0x03, sp)
      008077 F6               [ 1]  175 	ld	a, (x)
      008078 A1 0D            [ 1]  176 	cp	a, #0x0d
      00807A 26 01            [ 1]  177 	jrne	00129$
      00807C 81               [ 4]  178 	ret
      00807D                        179 00129$:
                                    180 ;	inc/uart1.h: 26: while ((UART1_SR & UART1_SR_RXNE)!=0)         //Æäåì ïîÿâëåíèÿ áàéòà
      00807D                        181 00101$:
      00807D C6 52 30         [ 1]  182 	ld	a, 0x5230
      008080 A5 20            [ 1]  183 	bcp	a, #0x20
      008082 27 F1            [ 1]  184 	jreq	00104$
                                    185 ;	inc/uart1.h: 28: *str++;
      008084 5C               [ 1]  186 	incw	x
      008085 1F 03            [ 2]  187 	ldw	(0x03, sp), x
                                    188 ;	inc/uart1.h: 29: *str=UART1_DR; 
      008087 C6 52 31         [ 1]  189 	ld	a, 0x5231
      00808A F7               [ 1]  190 	ld	(x), a
      00808B 20 F0            [ 2]  191 	jra	00101$
                                    192 ;	inc/uart1.h: 32: } 
      00808D 81               [ 4]  193 	ret
                                    194 ;	inc/spi_master.h: 2: void SPI_init() {
                                    195 ;	-----------------------------------------
                                    196 ;	 function SPI_init
                                    197 ;	-----------------------------------------
      00808E                        198 _SPI_init:
                                    199 ;	inc/spi_master.h: 4: PC_DDR |= (1 << CS_PIN);
      00808E 72 18 50 0C      [ 1]  200 	bset	20492, #4
                                    201 ;	inc/spi_master.h: 5: PC_CR1 |= (1 << CS_PIN);
      008092 72 18 50 0D      [ 1]  202 	bset	20493, #4
                                    203 ;	inc/spi_master.h: 6: PC_ODR |= (1 << CS_PIN);
      008096 72 18 50 0A      [ 1]  204 	bset	20490, #4
                                    205 ;	inc/spi_master.h: 8: SPI_CR2 = SPI_CR2_SSM | SPI_CR2_SSI;//без этой настройки требуется подключить вывод NSS к VDD
      00809A 35 03 52 01      [ 1]  206 	mov	0x5201+0, #0x03
                                    207 ;	inc/spi_master.h: 9: SPI_CR1 = SPI_CR1_MSTR | SPI_CR1_SPE | SPI_CR1_BR0;// | SPI_CR1_BR2;//??????SPI_CR1_BR(0)???????
      00809E 35 4C 52 00      [ 1]  208 	mov	0x5200+0, #0x4c
                                    209 ;	inc/spi_master.h: 11: }
      0080A2 81               [ 4]  210 	ret
                                    211 ;	inc/spi_master.h: 13: void SPI_write(int data) {
                                    212 ;	-----------------------------------------
                                    213 ;	 function SPI_write
                                    214 ;	-----------------------------------------
      0080A3                        215 _SPI_write:
                                    216 ;	inc/spi_master.h: 14: SPI_DR = data;
      0080A3 7B 04            [ 1]  217 	ld	a, (0x04, sp)
      0080A5 C7 52 04         [ 1]  218 	ld	0x5204, a
                                    219 ;	inc/spi_master.h: 15: while (!(SPI_SR & SPI_SR_TXE));
      0080A8                        220 00101$:
      0080A8 C6 52 03         [ 1]  221 	ld	a, 0x5203
      0080AB A5 02            [ 1]  222 	bcp	a, #0x02
      0080AD 27 F9            [ 1]  223 	jreq	00101$
                                    224 ;	inc/spi_master.h: 16: }
      0080AF 81               [ 4]  225 	ret
                                    226 ;	inc/spi_master.h: 17: int SPI_read() {
                                    227 ;	-----------------------------------------
                                    228 ;	 function SPI_read
                                    229 ;	-----------------------------------------
      0080B0                        230 _SPI_read:
                                    231 ;	inc/spi_master.h: 18: SPI_write(0xFF);
      0080B0 4B FF            [ 1]  232 	push	#0xff
      0080B2 4B 00            [ 1]  233 	push	#0x00
      0080B4 CD 80 A3         [ 4]  234 	call	_SPI_write
      0080B7 5B 02            [ 2]  235 	addw	sp, #2
                                    236 ;	inc/spi_master.h: 19: while (!(SPI_SR & SPI_SR_RXNE));
      0080B9                        237 00101$:
      0080B9 C6 52 03         [ 1]  238 	ld	a, 0x5203
      0080BC 44               [ 1]  239 	srl	a
      0080BD 24 FA            [ 1]  240 	jrnc	00101$
                                    241 ;	inc/spi_master.h: 20: return SPI_DR;
      0080BF C6 52 04         [ 1]  242 	ld	a, 0x5204
      0080C2 5F               [ 1]  243 	clrw	x
      0080C3 97               [ 1]  244 	ld	xl, a
                                    245 ;	inc/spi_master.h: 21: }
      0080C4 81               [ 4]  246 	ret
                                    247 ;	inc/spi_master.h: 22: void chip_select() {
                                    248 ;	-----------------------------------------
                                    249 ;	 function chip_select
                                    250 ;	-----------------------------------------
      0080C5                        251 _chip_select:
                                    252 ;	inc/spi_master.h: 23: PC_ODR &= ~(1 << CS_PIN);
      0080C5 72 19 50 0A      [ 1]  253 	bres	20490, #4
                                    254 ;	inc/spi_master.h: 24: }
      0080C9 81               [ 4]  255 	ret
                                    256 ;	inc/spi_master.h: 25: void chip_deselect() {
                                    257 ;	-----------------------------------------
                                    258 ;	 function chip_deselect
                                    259 ;	-----------------------------------------
      0080CA                        260 _chip_deselect:
                                    261 ;	inc/spi_master.h: 26: while ((SPI_SR & SPI_SR_BSY));
      0080CA                        262 00101$:
      0080CA C6 52 03         [ 1]  263 	ld	a, 0x5203
      0080CD 2B FB            [ 1]  264 	jrmi	00101$
                                    265 ;	inc/spi_master.h: 27: PC_ODR |= (1 << CS_PIN);
      0080CF 72 18 50 0A      [ 1]  266 	bset	20490, #4
                                    267 ;	inc/spi_master.h: 28: }
      0080D3 81               [ 4]  268 	ret
                                    269 ;	inc/spi_master.h: 29: void SPI_deinit() {
                                    270 ;	-----------------------------------------
                                    271 ;	 function SPI_deinit
                                    272 ;	-----------------------------------------
      0080D4                        273 _SPI_deinit:
                                    274 ;	inc/spi_master.h: 30: while (!(SPI_SR & SPI_SR_RXNE));
      0080D4                        275 00101$:
      0080D4 C6 52 03         [ 1]  276 	ld	a, 0x5203
      0080D7 97               [ 1]  277 	ld	xl, a
      0080D8 44               [ 1]  278 	srl	a
      0080D9 24 F9            [ 1]  279 	jrnc	00101$
                                    280 ;	inc/spi_master.h: 31: while (!(SPI_SR & SPI_SR_TXE));
      0080DB 9F               [ 1]  281 	ld	a, xl
      0080DC A4 02            [ 1]  282 	and	a, #0x02
      0080DE                        283 00104$:
      0080DE 4D               [ 1]  284 	tnz	a
      0080DF 27 FD            [ 1]  285 	jreq	00104$
                                    286 ;	inc/spi_master.h: 32: while ((SPI_SR & SPI_SR_BSY));
      0080E1 9F               [ 1]  287 	ld	a, xl
      0080E2 A4 80            [ 1]  288 	and	a, #0x80
      0080E4                        289 00107$:
      0080E4 4D               [ 1]  290 	tnz	a
      0080E5 26 FD            [ 1]  291 	jrne	00107$
                                    292 ;	inc/spi_master.h: 33: SPI_CR1 &=~ SPI_CR1_SPE;
      0080E7 72 1D 52 00      [ 1]  293 	bres	20992, #6
                                    294 ;	inc/spi_master.h: 34: }
      0080EB 81               [ 4]  295 	ret
                                    296 ;	main.c: 8: void delay(int t)
                                    297 ;	-----------------------------------------
                                    298 ;	 function delay
                                    299 ;	-----------------------------------------
      0080EC                        300 _delay:
      0080EC 52 02            [ 2]  301 	sub	sp, #2
                                    302 ;	main.c: 11: for(i=0;i<t;i++)
      0080EE 5F               [ 1]  303 	clrw	x
      0080EF                        304 00107$:
      0080EF 13 05            [ 2]  305 	cpw	x, (0x05, sp)
      0080F1 2E 13            [ 1]  306 	jrsge	00109$
                                    307 ;	main.c: 13: for(s=0;s<512;s++)
      0080F3 0F 02            [ 1]  308 	clr	(0x02, sp)
      0080F5 A6 02            [ 1]  309 	ld	a, #0x02
      0080F7 6B 01            [ 1]  310 	ld	(0x01, sp), a
      0080F9                        311 00105$:
      0080F9 16 01            [ 2]  312 	ldw	y, (0x01, sp)
      0080FB 90 5A            [ 2]  313 	decw	y
      0080FD 17 01            [ 2]  314 	ldw	(0x01, sp), y
      0080FF 90 5D            [ 2]  315 	tnzw	y
      008101 26 F6            [ 1]  316 	jrne	00105$
                                    317 ;	main.c: 11: for(i=0;i<t;i++)
      008103 5C               [ 1]  318 	incw	x
      008104 20 E9            [ 2]  319 	jra	00107$
      008106                        320 00109$:
                                    321 ;	main.c: 17: }
      008106 5B 02            [ 2]  322 	addw	sp, #2
      008108 81               [ 4]  323 	ret
                                    324 ;	main.c: 19: void main(void)
                                    325 ;	-----------------------------------------
                                    326 ;	 function main
                                    327 ;	-----------------------------------------
      008109                        328 _main:
      008109 52 02            [ 2]  329 	sub	sp, #2
                                    330 ;	main.c: 21: clk_init();
      00810B CD 80 24         [ 4]  331 	call	_clk_init
                                    332 ;	main.c: 22: uart1_init();
      00810E CD 80 47         [ 4]  333 	call	_uart1_init
                                    334 ;	main.c: 25: SPI_init();
      008111 CD 80 8E         [ 4]  335 	call	_SPI_init
                                    336 ;	main.c: 26: while (1) {
      008114                        337 00105$:
                                    338 ;	main.c: 27: chip_select();
      008114 CD 80 C5         [ 4]  339 	call	_chip_select
                                    340 ;	main.c: 29: res=SPI_read();
      008117 CD 80 B0         [ 4]  341 	call	_SPI_read
      00811A 1F 01            [ 2]  342 	ldw	(0x01, sp), x
                                    343 ;	main.c: 30: chip_deselect();
      00811C CD 80 CA         [ 4]  344 	call	_chip_deselect
                                    345 ;	main.c: 31: while (!(UART1_SR & UART1_SR_TXE)) {}
      00811F                        346 00101$:
      00811F C6 52 30         [ 1]  347 	ld	a, 0x5230
      008122 2A FB            [ 1]  348 	jrpl	00101$
                                    349 ;	main.c: 32: UART1_DR=res;
      008124 7B 02            [ 1]  350 	ld	a, (0x02, sp)
      008126 C7 52 31         [ 1]  351 	ld	0x5231, a
                                    352 ;	main.c: 33: delay(50);
      008129 4B 32            [ 1]  353 	push	#0x32
      00812B 4B 00            [ 1]  354 	push	#0x00
      00812D CD 80 EC         [ 4]  355 	call	_delay
      008130 5B 02            [ 2]  356 	addw	sp, #2
      008132 20 E0            [ 2]  357 	jra	00105$
                                    358 ;	main.c: 35: }
      008134 5B 02            [ 2]  359 	addw	sp, #2
      008136 81               [ 4]  360 	ret
                                    361 	.area CODE
                                    362 	.area CONST
                                    363 	.area INITIALIZER
                                    364 	.area CABS (ABS)
