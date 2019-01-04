                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 3.6.4 #9794 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module main
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _main
                                     12 	.globl _delay
                                     13 	.globl _out7seg
                                     14 	.globl _test
                                     15 	.globl _rx
                                     16 	.globl _tx
                                     17 	.globl _uart1_init
                                     18 	.globl _GPIO_init
                                     19 	.globl _clk_init
                                     20 	.globl _q
                                     21 	.globl _x
                                     22 ;--------------------------------------------------------
                                     23 ; ram data
                                     24 ;--------------------------------------------------------
                                     25 	.area DATA
                                     26 ;--------------------------------------------------------
                                     27 ; ram data
                                     28 ;--------------------------------------------------------
                                     29 	.area INITIALIZED
      000001                         30 _x::
      000001                         31 	.ds 2
      000003                         32 _q::
      000003                         33 	.ds 2
                                     34 ;--------------------------------------------------------
                                     35 ; Stack segment in internal ram 
                                     36 ;--------------------------------------------------------
                                     37 	.area	SSEG
      000005                         38 __start__stack:
      000005                         39 	.ds	1
                                     40 
                                     41 ;--------------------------------------------------------
                                     42 ; absolute external ram data
                                     43 ;--------------------------------------------------------
                                     44 	.area DABS (ABS)
                                     45 ;--------------------------------------------------------
                                     46 ; interrupt vector 
                                     47 ;--------------------------------------------------------
                                     48 	.area HOME
      008000                         49 __interrupt_vect:
      008000 82 00 80 83             50 	int s_GSINIT ;reset
      008004 82 00 00 00             51 	int 0x0000 ;trap
      008008 82 00 00 00             52 	int 0x0000 ;int0
      00800C 82 00 00 00             53 	int 0x0000 ;int1
      008010 82 00 00 00             54 	int 0x0000 ;int2
      008014 82 00 00 00             55 	int 0x0000 ;int3
      008018 82 00 00 00             56 	int 0x0000 ;int4
      00801C 82 00 00 00             57 	int 0x0000 ;int5
      008020 82 00 00 00             58 	int 0x0000 ;int6
      008024 82 00 00 00             59 	int 0x0000 ;int7
      008028 82 00 00 00             60 	int 0x0000 ;int8
      00802C 82 00 00 00             61 	int 0x0000 ;int9
      008030 82 00 00 00             62 	int 0x0000 ;int10
      008034 82 00 00 00             63 	int 0x0000 ;int11
      008038 82 00 00 00             64 	int 0x0000 ;int12
      00803C 82 00 00 00             65 	int 0x0000 ;int13
      008040 82 00 00 00             66 	int 0x0000 ;int14
      008044 82 00 00 00             67 	int 0x0000 ;int15
      008048 82 00 00 00             68 	int 0x0000 ;int16
      00804C 82 00 00 00             69 	int 0x0000 ;int17
      008050 82 00 00 00             70 	int 0x0000 ;int18
      008054 82 00 00 00             71 	int 0x0000 ;int19
      008058 82 00 00 00             72 	int 0x0000 ;int20
      00805C 82 00 00 00             73 	int 0x0000 ;int21
      008060 82 00 00 00             74 	int 0x0000 ;int22
      008064 82 00 00 00             75 	int 0x0000 ;int23
      008068 82 00 00 00             76 	int 0x0000 ;int24
      00806C 82 00 00 00             77 	int 0x0000 ;int25
      008070 82 00 00 00             78 	int 0x0000 ;int26
      008074 82 00 00 00             79 	int 0x0000 ;int27
      008078 82 00 00 00             80 	int 0x0000 ;int28
      00807C 82 00 00 00             81 	int 0x0000 ;int29
                                     82 ;--------------------------------------------------------
                                     83 ; global & static initialisations
                                     84 ;--------------------------------------------------------
                                     85 	.area HOME
                                     86 	.area GSINIT
                                     87 	.area GSFINAL
                                     88 	.area GSINIT
      008083                         89 __sdcc_gs_init_startup:
      008083                         90 __sdcc_init_data:
                                     91 ; stm8_genXINIT() start
      008083 AE 00 00         [ 2]   92 	ldw x, #l_DATA
      008086 27 07            [ 1]   93 	jreq	00002$
      008088                         94 00001$:
      008088 72 4F 00 00      [ 1]   95 	clr (s_DATA - 1, x)
      00808C 5A               [ 2]   96 	decw x
      00808D 26 F9            [ 1]   97 	jrne	00001$
      00808F                         98 00002$:
      00808F AE 00 04         [ 2]   99 	ldw	x, #l_INITIALIZER
      008092 27 09            [ 1]  100 	jreq	00004$
      008094                        101 00003$:
      008094 D6 84 9A         [ 1]  102 	ld	a, (s_INITIALIZER - 1, x)
      008097 D7 00 00         [ 1]  103 	ld	(s_INITIALIZED - 1, x), a
      00809A 5A               [ 2]  104 	decw	x
      00809B 26 F7            [ 1]  105 	jrne	00003$
      00809D                        106 00004$:
                                    107 ; stm8_genXINIT() end
                                    108 	.area GSFINAL
      00809D CC 80 80         [ 2]  109 	jp	__sdcc_program_startup
                                    110 ;--------------------------------------------------------
                                    111 ; Home
                                    112 ;--------------------------------------------------------
                                    113 	.area HOME
                                    114 	.area HOME
      008080                        115 __sdcc_program_startup:
      008080 CC 83 EC         [ 2]  116 	jp	_main
                                    117 ;	return from main will return to caller
                                    118 ;--------------------------------------------------------
                                    119 ; code
                                    120 ;--------------------------------------------------------
                                    121 	.area CODE
                                    122 ;	inc/clk_init.h: 7: void clk_init(void){    
                                    123 ;	-----------------------------------------
                                    124 ;	 function clk_init
                                    125 ;	-----------------------------------------
      0080A0                        126 _clk_init:
                                    127 ;	inc/clk_init.h: 8: CLK_ECKR|=CLK_ECKR_HSEEN;            
      0080A0 72 10 50 C1      [ 1]  128 	bset	0x50c1, #0
                                    129 ;	inc/clk_init.h: 9: CLK_SWCR|=CLK_SWCR_SWEN;               
      0080A4 AE 50 C5         [ 2]  130 	ldw	x, #0x50c5
      0080A7 F6               [ 1]  131 	ld	a, (x)
      0080A8 AA 02            [ 1]  132 	or	a, #0x02
      0080AA F7               [ 1]  133 	ld	(x), a
                                    134 ;	inc/clk_init.h: 10: while((CLK_ECKR & CLK_ECKR_HSERDY) == 0) {} 
      0080AB                        135 00101$:
      0080AB AE 50 C1         [ 2]  136 	ldw	x, #0x50c1
      0080AE F6               [ 1]  137 	ld	a, (x)
      0080AF A5 02            [ 1]  138 	bcp	a, #0x02
      0080B1 27 F8            [ 1]  139 	jreq	00101$
                                    140 ;	inc/clk_init.h: 11: CLK_CKDIVR = 0;                    
      0080B3 35 00 50 C6      [ 1]  141 	mov	0x50c6+0, #0x00
                                    142 ;	inc/clk_init.h: 12: CLK_SWR = 0xB4;                    
      0080B7 35 B4 50 C4      [ 1]  143 	mov	0x50c4+0, #0xb4
                                    144 ;	inc/clk_init.h: 13: while ((CLK_SWCR & CLK_SWCR_SWIF) == 0){}
      0080BB                        145 00104$:
      0080BB AE 50 C5         [ 2]  146 	ldw	x, #0x50c5
      0080BE F6               [ 1]  147 	ld	a, (x)
      0080BF A5 08            [ 1]  148 	bcp	a, #0x08
      0080C1 27 F8            [ 1]  149 	jreq	00104$
                                    150 ;	inc/clk_init.h: 14: CLK_CSSR|=CLK_CSSR_CSSEN;
      0080C3 72 10 50 C8      [ 1]  151 	bset	0x50c8, #0
      0080C7 81               [ 4]  152 	ret
                                    153 ;	inc/gpio_init.h: 1: void GPIO_init(void)
                                    154 ;	-----------------------------------------
                                    155 ;	 function GPIO_init
                                    156 ;	-----------------------------------------
      0080C8                        157 _GPIO_init:
                                    158 ;	inc/gpio_init.h: 4: PA_DDR = 0xFF;                                                        //_______PORT_IN
      0080C8 35 FF 50 02      [ 1]  159 	mov	0x5002+0, #0xff
                                    160 ;	inc/gpio_init.h: 5: PA_CR1 = 0xFF;                                                       //_______DDR________________CR1______________CR2___________FUNCTION  
      0080CC 35 FF 50 03      [ 1]  161 	mov	0x5003+0, #0xff
                                    162 ;	inc/gpio_init.h: 6: PA_CR2 = 0x00;                                                      //_______0__________________0________________0_____________bez podtiyzhki,bez prerbIvanii 
      0080D0 35 00 50 04      [ 1]  163 	mov	0x5004+0, #0x00
                                    164 ;	inc/gpio_init.h: 8: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
      0080D4 35 00 50 07      [ 1]  165 	mov	0x5007+0, #0x00
                                    166 ;	inc/gpio_init.h: 9: PB_CR1 = 0xff;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
      0080D8 35 FF 50 08      [ 1]  167 	mov	0x5008+0, #0xff
                                    168 ;	inc/gpio_init.h: 10: PB_CR2 = 0xff;                                                      //_______PORT_OUT
      0080DC 35 FF 50 09      [ 1]  169 	mov	0x5009+0, #0xff
                                    170 ;	inc/gpio_init.h: 12: PC_DDR = 0xFF;                                                        //_______1__________________0________________0_____________otkritiy stok
      0080E0 35 FF 50 0C      [ 1]  171 	mov	0x500c+0, #0xff
                                    172 ;	inc/gpio_init.h: 13: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
      0080E4 35 FF 50 0D      [ 1]  173 	mov	0x500d+0, #0xff
                                    174 ;	inc/gpio_init.h: 14: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
      0080E8 35 00 50 0E      [ 1]  175 	mov	0x500e+0, #0x00
                                    176 ;	inc/gpio_init.h: 16: PD_DDR = 0x3F;   
      0080EC 35 3F 50 11      [ 1]  177 	mov	0x5011+0, #0x3f
                                    178 ;	inc/gpio_init.h: 17: PD_CR1 = 0xFF;  
      0080F0 35 FF 50 12      [ 1]  179 	mov	0x5012+0, #0xff
                                    180 ;	inc/gpio_init.h: 18: PD_CR2 = 0x00; 
      0080F4 35 00 50 13      [ 1]  181 	mov	0x5013+0, #0x00
                                    182 ;	inc/gpio_init.h: 20: PE_DDR = 0xFF;   
      0080F8 35 FF 50 16      [ 1]  183 	mov	0x5016+0, #0xff
                                    184 ;	inc/gpio_init.h: 21: PE_CR1 = 0xFF;  
      0080FC 35 FF 50 17      [ 1]  185 	mov	0x5017+0, #0xff
                                    186 ;	inc/gpio_init.h: 22: PE_CR2 = 0x00; 
      008100 35 00 50 18      [ 1]  187 	mov	0x5018+0, #0x00
                                    188 ;	inc/gpio_init.h: 24: PF_DDR = 0xFF;   
      008104 35 FF 50 1B      [ 1]  189 	mov	0x501b+0, #0xff
                                    190 ;	inc/gpio_init.h: 25: PF_CR1 = 0xFF;  
      008108 35 FF 50 1C      [ 1]  191 	mov	0x501c+0, #0xff
                                    192 ;	inc/gpio_init.h: 26: PF_CR2 = 0x00; 
      00810C 35 00 50 1D      [ 1]  193 	mov	0x501d+0, #0x00
      008110 81               [ 4]  194 	ret
                                    195 ;	inc/uart1.h: 2: void uart1_init()
                                    196 ;	-----------------------------------------
                                    197 ;	 function uart1_init
                                    198 ;	-----------------------------------------
      008111                        199 _uart1_init:
                                    200 ;	inc/uart1.h: 4: PD_DDR&=~(1<<6);  
      008111 AE 50 11         [ 2]  201 	ldw	x, #0x5011
      008114 F6               [ 1]  202 	ld	a, (x)
      008115 A4 BF            [ 1]  203 	and	a, #0xbf
      008117 F7               [ 1]  204 	ld	(x), a
                                    205 ;	inc/uart1.h: 5: PD_DDR|=(1<<5);    
      008118 AE 50 11         [ 2]  206 	ldw	x, #0x5011
      00811B F6               [ 1]  207 	ld	a, (x)
      00811C AA 20            [ 1]  208 	or	a, #0x20
      00811E F7               [ 1]  209 	ld	(x), a
                                    210 ;	inc/uart1.h: 6: PD_CR1&=~(1<<6);  
      00811F AE 50 12         [ 2]  211 	ldw	x, #0x5012
      008122 F6               [ 1]  212 	ld	a, (x)
      008123 A4 BF            [ 1]  213 	and	a, #0xbf
      008125 F7               [ 1]  214 	ld	(x), a
                                    215 ;	inc/uart1.h: 7: PD_CR2&=~(1<<6);         
      008126 AE 50 13         [ 2]  216 	ldw	x, #0x5013
      008129 F6               [ 1]  217 	ld	a, (x)
      00812A A4 BF            [ 1]  218 	and	a, #0xbf
      00812C F7               [ 1]  219 	ld	(x), a
                                    220 ;	inc/uart1.h: 8: UART1_CR2|=UART1_CR2_REN;
      00812D AE 52 35         [ 2]  221 	ldw	x, #0x5235
      008130 F6               [ 1]  222 	ld	a, (x)
      008131 AA 04            [ 1]  223 	or	a, #0x04
      008133 F7               [ 1]  224 	ld	(x), a
                                    225 ;	inc/uart1.h: 9: UART1_CR2|=UART1_CR2_TEN;  
      008134 AE 52 35         [ 2]  226 	ldw	x, #0x5235
      008137 F6               [ 1]  227 	ld	a, (x)
      008138 AA 08            [ 1]  228 	or	a, #0x08
      00813A F7               [ 1]  229 	ld	(x), a
                                    230 ;	inc/uart1.h: 10: UART1_BRR2 = 0x00;             
      00813B 35 00 52 33      [ 1]  231 	mov	0x5233+0, #0x00
                                    232 ;	inc/uart1.h: 11: UART1_BRR1 = 0x48;            
      00813F 35 48 52 32      [ 1]  233 	mov	0x5232+0, #0x48
      008143 81               [ 4]  234 	ret
                                    235 ;	inc/uart1.h: 13: void tx(char *str)
                                    236 ;	-----------------------------------------
                                    237 ;	 function tx
                                    238 ;	-----------------------------------------
      008144                        239 _tx:
                                    240 ;	inc/uart1.h: 17: while (!(UART1_SR & UART1_SR_TXE)) {}       
      008144 1E 03            [ 2]  241 	ldw	x, (0x03, sp)
      008146                        242 00101$:
      008146 90 AE 52 30      [ 2]  243 	ldw	y, #0x5230
      00814A 90 F6            [ 1]  244 	ld	a, (y)
      00814C 4D               [ 1]  245 	tnz	a
      00814D 2A F7            [ 1]  246 	jrpl	00101$
                                    247 ;	inc/uart1.h: 18: UART1_DR=*str; 
      00814F F6               [ 1]  248 	ld	a, (x)
      008150 90 AE 52 31      [ 2]  249 	ldw	y, #0x5231
      008154 90 F7            [ 1]  250 	ld	(y), a
                                    251 ;	inc/uart1.h: 19: if(*str=='\r') break;
      008156 F6               [ 1]  252 	ld	a, (x)
      008157 A1 0D            [ 1]  253 	cp	a, #0x0d
      008159 26 01            [ 1]  254 	jrne	00126$
      00815B 81               [ 4]  255 	ret
      00815C                        256 00126$:
                                    257 ;	inc/uart1.h: 20: *str++;
      00815C 5C               [ 1]  258 	incw	x
      00815D 20 E7            [ 2]  259 	jra	00101$
      00815F 81               [ 4]  260 	ret
                                    261 ;	inc/uart1.h: 24: void rx(char *str)
                                    262 ;	-----------------------------------------
                                    263 ;	 function rx
                                    264 ;	-----------------------------------------
      008160                        265 _rx:
                                    266 ;	inc/uart1.h: 26: char r=0;
      008160 4F               [ 1]  267 	clr	a
                                    268 ;	inc/uart1.h: 27: while (r!='\r')
      008161 16 03            [ 2]  269 	ldw	y, (0x03, sp)
      008163                        270 00104$:
      008163 A1 0D            [ 1]  271 	cp	a, #0x0d
      008165 26 01            [ 1]  272 	jrne	00127$
      008167 81               [ 4]  273 	ret
      008168                        274 00127$:
                                    275 ;	inc/uart1.h: 29: UART1_SR&=~(1<<5); 
      008168 AE 52 30         [ 2]  276 	ldw	x, #0x5230
      00816B F6               [ 1]  277 	ld	a, (x)
      00816C A4 DF            [ 1]  278 	and	a, #0xdf
      00816E F7               [ 1]  279 	ld	(x), a
                                    280 ;	inc/uart1.h: 30: while ((UART1_SR & UART1_SR_RXNE)==0)         //Æäåì ïîÿâëåíèÿ áàéòà
      00816F                        281 00101$:
      00816F AE 52 30         [ 2]  282 	ldw	x, #0x5230
      008172 F6               [ 1]  283 	ld	a, (x)
      008173 A5 20            [ 1]  284 	bcp	a, #0x20
      008175 26 03            [ 1]  285 	jrne	00103$
                                    286 ;	inc/uart1.h: 33: __asm__("nop\n");
      008177 9D               [ 1]  287 	nop
      008178 20 F5            [ 2]  288 	jra	00101$
      00817A                        289 00103$:
                                    290 ;	inc/uart1.h: 35: r=UART1_DR; 
      00817A AE 52 31         [ 2]  291 	ldw	x, #0x5231
      00817D F6               [ 1]  292 	ld	a, (x)
                                    293 ;	inc/uart1.h: 37: *str++=r;
      00817E 90 F7            [ 1]  294 	ld	(y), a
      008180 90 5C            [ 1]  295 	incw	y
      008182 20 DF            [ 2]  296 	jra	00104$
      008184 81               [ 4]  297 	ret
                                    298 ;	inc/uart1.h: 41: void test()
                                    299 ;	-----------------------------------------
                                    300 ;	 function test
                                    301 ;	-----------------------------------------
      008185                        302 _test:
                                    303 ;	inc/uart1.h: 44: if(x==0)PC_ODR=2;
      008185 CE 00 01         [ 2]  304 	ldw	x, _x+0
      008188 26 04            [ 1]  305 	jrne	00102$
      00818A 35 02 50 0A      [ 1]  306 	mov	0x500a+0, #0x02
      00818E                        307 00102$:
                                    308 ;	inc/uart1.h: 45: if(x==1)PC_ODR=4;
      00818E CE 00 01         [ 2]  309 	ldw	x, _x+0
      008191 A3 00 01         [ 2]  310 	cpw	x, #0x0001
      008194 26 04            [ 1]  311 	jrne	00104$
      008196 35 04 50 0A      [ 1]  312 	mov	0x500a+0, #0x04
      00819A                        313 00104$:
                                    314 ;	inc/uart1.h: 46: if(x==2)PC_ODR=8;
      00819A CE 00 01         [ 2]  315 	ldw	x, _x+0
      00819D A3 00 02         [ 2]  316 	cpw	x, #0x0002
      0081A0 26 04            [ 1]  317 	jrne	00106$
      0081A2 35 08 50 0A      [ 1]  318 	mov	0x500a+0, #0x08
      0081A6                        319 00106$:
                                    320 ;	inc/uart1.h: 47: x++;
      0081A6 CE 00 01         [ 2]  321 	ldw	x, _x+0
      0081A9 5C               [ 1]  322 	incw	x
                                    323 ;	inc/uart1.h: 48: if(x>2) x=0;
      0081AA CF 00 01         [ 2]  324 	ldw	_x+0, x
      0081AD A3 00 02         [ 2]  325 	cpw	x, #0x0002
      0081B0 2C 01            [ 1]  326 	jrsgt	00134$
      0081B2 81               [ 4]  327 	ret
      0081B3                        328 00134$:
      0081B3 5F               [ 1]  329 	clrw	x
      0081B4 CF 00 01         [ 2]  330 	ldw	_x+0, x
      0081B7 81               [ 4]  331 	ret
                                    332 ;	inc/7sig.h: 11: void out7seg(volatile int t)
                                    333 ;	-----------------------------------------
                                    334 ;	 function out7seg
                                    335 ;	-----------------------------------------
      0081B8                        336 _out7seg:
      0081B8 52 02            [ 2]  337 	sub	sp, #2
                                    338 ;	inc/7sig.h: 13: int num=0;
      0081BA 5F               [ 1]  339 	clrw	x
      0081BB 1F 01            [ 2]  340 	ldw	(0x01, sp), x
                                    341 ;	inc/7sig.h: 14: PC_ODR=0xff;
      0081BD 35 FF 50 0A      [ 1]  342 	mov	0x500a+0, #0xff
                                    343 ;	inc/7sig.h: 15: PD_ODR|=(1<<3)|(1<<1)|(1<<2);
      0081C1 AE 50 0F         [ 2]  344 	ldw	x, #0x500f
      0081C4 F6               [ 1]  345 	ld	a, (x)
      0081C5 AA 0E            [ 1]  346 	or	a, #0x0e
      0081C7 F7               [ 1]  347 	ld	(x), a
                                    348 ;	inc/7sig.h: 17: if(q==0) num=(t%1000/100),PD_ODR&=~(1<<1);
      0081C8 CE 00 03         [ 2]  349 	ldw	x, _q+0
      0081CB 26 1F            [ 1]  350 	jrne	00102$
      0081CD 4B E8            [ 1]  351 	push	#0xe8
      0081CF 4B 03            [ 1]  352 	push	#0x03
      0081D1 1E 07            [ 2]  353 	ldw	x, (0x07, sp)
      0081D3 89               [ 2]  354 	pushw	x
      0081D4 CD 84 71         [ 4]  355 	call	__modsint
      0081D7 5B 04            [ 2]  356 	addw	sp, #4
      0081D9 4B 64            [ 1]  357 	push	#0x64
      0081DB 4B 00            [ 1]  358 	push	#0x00
      0081DD 89               [ 2]  359 	pushw	x
      0081DE CD 84 87         [ 4]  360 	call	__divsint
      0081E1 5B 04            [ 2]  361 	addw	sp, #4
      0081E3 1F 01            [ 2]  362 	ldw	(0x01, sp), x
      0081E5 AE 50 0F         [ 2]  363 	ldw	x, #0x500f
      0081E8 F6               [ 1]  364 	ld	a, (x)
      0081E9 A4 FD            [ 1]  365 	and	a, #0xfd
      0081EB F7               [ 1]  366 	ld	(x), a
      0081EC                        367 00102$:
                                    368 ;	inc/7sig.h: 18: if(q==1) num=(t%100/10),PD_ODR&=~(1<<2);
      0081EC CE 00 03         [ 2]  369 	ldw	x, _q+0
      0081EF A3 00 01         [ 2]  370 	cpw	x, #0x0001
      0081F2 26 1F            [ 1]  371 	jrne	00104$
      0081F4 4B 64            [ 1]  372 	push	#0x64
      0081F6 4B 00            [ 1]  373 	push	#0x00
      0081F8 1E 07            [ 2]  374 	ldw	x, (0x07, sp)
      0081FA 89               [ 2]  375 	pushw	x
      0081FB CD 84 71         [ 4]  376 	call	__modsint
      0081FE 5B 04            [ 2]  377 	addw	sp, #4
      008200 4B 0A            [ 1]  378 	push	#0x0a
      008202 4B 00            [ 1]  379 	push	#0x00
      008204 89               [ 2]  380 	pushw	x
      008205 CD 84 87         [ 4]  381 	call	__divsint
      008208 5B 04            [ 2]  382 	addw	sp, #4
      00820A 1F 01            [ 2]  383 	ldw	(0x01, sp), x
      00820C AE 50 0F         [ 2]  384 	ldw	x, #0x500f
      00820F F6               [ 1]  385 	ld	a, (x)
      008210 A4 FB            [ 1]  386 	and	a, #0xfb
      008212 F7               [ 1]  387 	ld	(x), a
      008213                        388 00104$:
                                    389 ;	inc/7sig.h: 19: if(q==2) num=(t%10),PD_ODR&=~(1<<3);
      008213 CE 00 03         [ 2]  390 	ldw	x, _q+0
      008216 A3 00 02         [ 2]  391 	cpw	x, #0x0002
      008219 26 15            [ 1]  392 	jrne	00106$
      00821B 4B 0A            [ 1]  393 	push	#0x0a
      00821D 4B 00            [ 1]  394 	push	#0x00
      00821F 1E 07            [ 2]  395 	ldw	x, (0x07, sp)
      008221 89               [ 2]  396 	pushw	x
      008222 CD 84 71         [ 4]  397 	call	__modsint
      008225 5B 04            [ 2]  398 	addw	sp, #4
      008227 1F 01            [ 2]  399 	ldw	(0x01, sp), x
      008229 AE 50 0F         [ 2]  400 	ldw	x, #0x500f
      00822C F6               [ 1]  401 	ld	a, (x)
      00822D A4 F7            [ 1]  402 	and	a, #0xf7
      00822F F7               [ 1]  403 	ld	(x), a
      008230                        404 00106$:
                                    405 ;	inc/7sig.h: 20: q++;
      008230 CE 00 03         [ 2]  406 	ldw	x, _q+0
      008233 5C               [ 1]  407 	incw	x
                                    408 ;	inc/7sig.h: 21: if(q>2) q=0;
      008234 CF 00 03         [ 2]  409 	ldw	_q+0, x
      008237 A3 00 02         [ 2]  410 	cpw	x, #0x0002
      00823A 2D 04            [ 1]  411 	jrsle	00108$
      00823C 5F               [ 1]  412 	clrw	x
      00823D CF 00 03         [ 2]  413 	ldw	_q+0, x
      008240                        414 00108$:
                                    415 ;	inc/7sig.h: 22: switch (num)
      008240 0D 01            [ 1]  416 	tnz	(0x01, sp)
      008242 2A 03            [ 1]  417 	jrpl	00155$
      008244 CC 83 CC         [ 2]  418 	jp	00121$
      008247                        419 00155$:
      008247 1E 01            [ 2]  420 	ldw	x, (0x01, sp)
      008249 A3 00 09         [ 2]  421 	cpw	x, #0x0009
      00824C 2D 03            [ 1]  422 	jrsle	00156$
      00824E CC 83 CC         [ 2]  423 	jp	00121$
      008251                        424 00156$:
      008251 1E 01            [ 2]  425 	ldw	x, (0x01, sp)
      008253 58               [ 2]  426 	sllw	x
      008254 DE 82 58         [ 2]  427 	ldw	x, (#00157$, x)
      008257 FC               [ 2]  428 	jp	(x)
      008258                        429 00157$:
      008258 82 6C                  430 	.dw	#00109$
      00825A 82 99                  431 	.dw	#00110$
      00825C 82 AA                  432 	.dw	#00111$
      00825E 82 D0                  433 	.dw	#00112$
      008260 82 F6                  434 	.dw	#00113$
      008262 83 12                  435 	.dw	#00114$
      008264 83 35                  436 	.dw	#00115$
      008266 83 5E                  437 	.dw	#00116$
      008268 83 75                  438 	.dw	#00117$
      00826A 83 A5                  439 	.dw	#00118$
                                    440 ;	inc/7sig.h: 24: case 0:   
      00826C                        441 00109$:
                                    442 ;	inc/7sig.h: 25: segA,segB,segC,segD,segE,segF;
      00826C AE 50 0A         [ 2]  443 	ldw	x, #0x500a
      00826F F6               [ 1]  444 	ld	a, (x)
      008270 A4 FD            [ 1]  445 	and	a, #0xfd
      008272 F7               [ 1]  446 	ld	(x), a
      008273 AE 50 0A         [ 2]  447 	ldw	x, #0x500a
      008276 F6               [ 1]  448 	ld	a, (x)
      008277 A4 FB            [ 1]  449 	and	a, #0xfb
      008279 F7               [ 1]  450 	ld	(x), a
      00827A AE 50 0A         [ 2]  451 	ldw	x, #0x500a
      00827D F6               [ 1]  452 	ld	a, (x)
      00827E A4 F7            [ 1]  453 	and	a, #0xf7
      008280 F7               [ 1]  454 	ld	(x), a
      008281 AE 50 0A         [ 2]  455 	ldw	x, #0x500a
      008284 F6               [ 1]  456 	ld	a, (x)
      008285 A4 DF            [ 1]  457 	and	a, #0xdf
      008287 F7               [ 1]  458 	ld	(x), a
      008288 AE 50 0A         [ 2]  459 	ldw	x, #0x500a
      00828B F6               [ 1]  460 	ld	a, (x)
      00828C A4 EF            [ 1]  461 	and	a, #0xef
      00828E F7               [ 1]  462 	ld	(x), a
      00828F AE 50 0A         [ 2]  463 	ldw	x, #0x500a
      008292 F6               [ 1]  464 	ld	a, (x)
      008293 A4 7F            [ 1]  465 	and	a, #0x7f
      008295 F7               [ 1]  466 	ld	(x), a
                                    467 ;	inc/7sig.h: 26: break;
      008296 CC 83 CC         [ 2]  468 	jp	00121$
                                    469 ;	inc/7sig.h: 27: case 1:   
      008299                        470 00110$:
                                    471 ;	inc/7sig.h: 28: segB,segC;
      008299 AE 50 0A         [ 2]  472 	ldw	x, #0x500a
      00829C F6               [ 1]  473 	ld	a, (x)
      00829D A4 FB            [ 1]  474 	and	a, #0xfb
      00829F F7               [ 1]  475 	ld	(x), a
      0082A0 AE 50 0A         [ 2]  476 	ldw	x, #0x500a
      0082A3 F6               [ 1]  477 	ld	a, (x)
      0082A4 A4 F7            [ 1]  478 	and	a, #0xf7
      0082A6 F7               [ 1]  479 	ld	(x), a
                                    480 ;	inc/7sig.h: 29: break;
      0082A7 CC 83 CC         [ 2]  481 	jp	00121$
                                    482 ;	inc/7sig.h: 30: case 2:   
      0082AA                        483 00111$:
                                    484 ;	inc/7sig.h: 31: segA,segB,segG,segD,segE;
      0082AA AE 50 0A         [ 2]  485 	ldw	x, #0x500a
      0082AD F6               [ 1]  486 	ld	a, (x)
      0082AE A4 FD            [ 1]  487 	and	a, #0xfd
      0082B0 F7               [ 1]  488 	ld	(x), a
      0082B1 AE 50 0A         [ 2]  489 	ldw	x, #0x500a
      0082B4 F6               [ 1]  490 	ld	a, (x)
      0082B5 A4 FB            [ 1]  491 	and	a, #0xfb
      0082B7 F7               [ 1]  492 	ld	(x), a
      0082B8 AE 50 0A         [ 2]  493 	ldw	x, #0x500a
      0082BB F6               [ 1]  494 	ld	a, (x)
      0082BC A4 BF            [ 1]  495 	and	a, #0xbf
      0082BE F7               [ 1]  496 	ld	(x), a
      0082BF AE 50 0A         [ 2]  497 	ldw	x, #0x500a
      0082C2 F6               [ 1]  498 	ld	a, (x)
      0082C3 A4 DF            [ 1]  499 	and	a, #0xdf
      0082C5 F7               [ 1]  500 	ld	(x), a
      0082C6 AE 50 0A         [ 2]  501 	ldw	x, #0x500a
      0082C9 F6               [ 1]  502 	ld	a, (x)
      0082CA A4 EF            [ 1]  503 	and	a, #0xef
      0082CC F7               [ 1]  504 	ld	(x), a
                                    505 ;	inc/7sig.h: 32: break;
      0082CD CC 83 CC         [ 2]  506 	jp	00121$
                                    507 ;	inc/7sig.h: 33: case 3:   
      0082D0                        508 00112$:
                                    509 ;	inc/7sig.h: 34: segA,segB,segC,segD,segG;
      0082D0 AE 50 0A         [ 2]  510 	ldw	x, #0x500a
      0082D3 F6               [ 1]  511 	ld	a, (x)
      0082D4 A4 FD            [ 1]  512 	and	a, #0xfd
      0082D6 F7               [ 1]  513 	ld	(x), a
      0082D7 AE 50 0A         [ 2]  514 	ldw	x, #0x500a
      0082DA F6               [ 1]  515 	ld	a, (x)
      0082DB A4 FB            [ 1]  516 	and	a, #0xfb
      0082DD F7               [ 1]  517 	ld	(x), a
      0082DE AE 50 0A         [ 2]  518 	ldw	x, #0x500a
      0082E1 F6               [ 1]  519 	ld	a, (x)
      0082E2 A4 F7            [ 1]  520 	and	a, #0xf7
      0082E4 F7               [ 1]  521 	ld	(x), a
      0082E5 AE 50 0A         [ 2]  522 	ldw	x, #0x500a
      0082E8 F6               [ 1]  523 	ld	a, (x)
      0082E9 A4 DF            [ 1]  524 	and	a, #0xdf
      0082EB F7               [ 1]  525 	ld	(x), a
      0082EC AE 50 0A         [ 2]  526 	ldw	x, #0x500a
      0082EF F6               [ 1]  527 	ld	a, (x)
      0082F0 A4 BF            [ 1]  528 	and	a, #0xbf
      0082F2 F7               [ 1]  529 	ld	(x), a
                                    530 ;	inc/7sig.h: 35: break;
      0082F3 CC 83 CC         [ 2]  531 	jp	00121$
                                    532 ;	inc/7sig.h: 36: case 4:   
      0082F6                        533 00113$:
                                    534 ;	inc/7sig.h: 37: segF,segB,segG,segC;
      0082F6 72 1F 50 0A      [ 1]  535 	bres	0x500a, #7
      0082FA AE 50 0A         [ 2]  536 	ldw	x, #0x500a
      0082FD F6               [ 1]  537 	ld	a, (x)
      0082FE A4 FB            [ 1]  538 	and	a, #0xfb
      008300 F7               [ 1]  539 	ld	(x), a
      008301 AE 50 0A         [ 2]  540 	ldw	x, #0x500a
      008304 F6               [ 1]  541 	ld	a, (x)
      008305 A4 BF            [ 1]  542 	and	a, #0xbf
      008307 F7               [ 1]  543 	ld	(x), a
      008308 AE 50 0A         [ 2]  544 	ldw	x, #0x500a
      00830B F6               [ 1]  545 	ld	a, (x)
      00830C A4 F7            [ 1]  546 	and	a, #0xf7
      00830E F7               [ 1]  547 	ld	(x), a
                                    548 ;	inc/7sig.h: 38: break;
      00830F CC 83 CC         [ 2]  549 	jp	00121$
                                    550 ;	inc/7sig.h: 39: case 5:   
      008312                        551 00114$:
                                    552 ;	inc/7sig.h: 40: segA,segC,segD,segF,segG;
      008312 AE 50 0A         [ 2]  553 	ldw	x, #0x500a
      008315 F6               [ 1]  554 	ld	a, (x)
      008316 A4 FD            [ 1]  555 	and	a, #0xfd
      008318 F7               [ 1]  556 	ld	(x), a
      008319 AE 50 0A         [ 2]  557 	ldw	x, #0x500a
      00831C F6               [ 1]  558 	ld	a, (x)
      00831D A4 F7            [ 1]  559 	and	a, #0xf7
      00831F F7               [ 1]  560 	ld	(x), a
      008320 AE 50 0A         [ 2]  561 	ldw	x, #0x500a
      008323 F6               [ 1]  562 	ld	a, (x)
      008324 A4 DF            [ 1]  563 	and	a, #0xdf
      008326 F7               [ 1]  564 	ld	(x), a
      008327 72 1F 50 0A      [ 1]  565 	bres	0x500a, #7
      00832B AE 50 0A         [ 2]  566 	ldw	x, #0x500a
      00832E F6               [ 1]  567 	ld	a, (x)
      00832F A4 BF            [ 1]  568 	and	a, #0xbf
      008331 F7               [ 1]  569 	ld	(x), a
                                    570 ;	inc/7sig.h: 41: break;
      008332 CC 83 CC         [ 2]  571 	jp	00121$
                                    572 ;	inc/7sig.h: 42: case 6:   
      008335                        573 00115$:
                                    574 ;	inc/7sig.h: 43: segA,segC,segD,segE,segF,segG;
      008335 AE 50 0A         [ 2]  575 	ldw	x, #0x500a
      008338 F6               [ 1]  576 	ld	a, (x)
      008339 A4 FD            [ 1]  577 	and	a, #0xfd
      00833B F7               [ 1]  578 	ld	(x), a
      00833C AE 50 0A         [ 2]  579 	ldw	x, #0x500a
      00833F F6               [ 1]  580 	ld	a, (x)
      008340 A4 F7            [ 1]  581 	and	a, #0xf7
      008342 F7               [ 1]  582 	ld	(x), a
      008343 AE 50 0A         [ 2]  583 	ldw	x, #0x500a
      008346 F6               [ 1]  584 	ld	a, (x)
      008347 A4 DF            [ 1]  585 	and	a, #0xdf
      008349 F7               [ 1]  586 	ld	(x), a
      00834A AE 50 0A         [ 2]  587 	ldw	x, #0x500a
      00834D F6               [ 1]  588 	ld	a, (x)
      00834E A4 EF            [ 1]  589 	and	a, #0xef
      008350 F7               [ 1]  590 	ld	(x), a
      008351 72 1F 50 0A      [ 1]  591 	bres	0x500a, #7
      008355 AE 50 0A         [ 2]  592 	ldw	x, #0x500a
      008358 F6               [ 1]  593 	ld	a, (x)
      008359 A4 BF            [ 1]  594 	and	a, #0xbf
      00835B F7               [ 1]  595 	ld	(x), a
                                    596 ;	inc/7sig.h: 44: break;
      00835C 20 6E            [ 2]  597 	jra	00121$
                                    598 ;	inc/7sig.h: 45: case 7:   
      00835E                        599 00116$:
                                    600 ;	inc/7sig.h: 46: segA,segB,segC;
      00835E AE 50 0A         [ 2]  601 	ldw	x, #0x500a
      008361 F6               [ 1]  602 	ld	a, (x)
      008362 A4 FD            [ 1]  603 	and	a, #0xfd
      008364 F7               [ 1]  604 	ld	(x), a
      008365 AE 50 0A         [ 2]  605 	ldw	x, #0x500a
      008368 F6               [ 1]  606 	ld	a, (x)
      008369 A4 FB            [ 1]  607 	and	a, #0xfb
      00836B F7               [ 1]  608 	ld	(x), a
      00836C AE 50 0A         [ 2]  609 	ldw	x, #0x500a
      00836F F6               [ 1]  610 	ld	a, (x)
      008370 A4 F7            [ 1]  611 	and	a, #0xf7
      008372 F7               [ 1]  612 	ld	(x), a
                                    613 ;	inc/7sig.h: 47: break;
      008373 20 57            [ 2]  614 	jra	00121$
                                    615 ;	inc/7sig.h: 48: case 8:   
      008375                        616 00117$:
                                    617 ;	inc/7sig.h: 49: segA,segB,segC,segD,segE,segF,segG;
      008375 AE 50 0A         [ 2]  618 	ldw	x, #0x500a
      008378 F6               [ 1]  619 	ld	a, (x)
      008379 A4 FD            [ 1]  620 	and	a, #0xfd
      00837B F7               [ 1]  621 	ld	(x), a
      00837C AE 50 0A         [ 2]  622 	ldw	x, #0x500a
      00837F F6               [ 1]  623 	ld	a, (x)
      008380 A4 FB            [ 1]  624 	and	a, #0xfb
      008382 F7               [ 1]  625 	ld	(x), a
      008383 AE 50 0A         [ 2]  626 	ldw	x, #0x500a
      008386 F6               [ 1]  627 	ld	a, (x)
      008387 A4 F7            [ 1]  628 	and	a, #0xf7
      008389 F7               [ 1]  629 	ld	(x), a
      00838A AE 50 0A         [ 2]  630 	ldw	x, #0x500a
      00838D F6               [ 1]  631 	ld	a, (x)
      00838E A4 DF            [ 1]  632 	and	a, #0xdf
      008390 F7               [ 1]  633 	ld	(x), a
      008391 AE 50 0A         [ 2]  634 	ldw	x, #0x500a
      008394 F6               [ 1]  635 	ld	a, (x)
      008395 A4 EF            [ 1]  636 	and	a, #0xef
      008397 F7               [ 1]  637 	ld	(x), a
      008398 72 1F 50 0A      [ 1]  638 	bres	0x500a, #7
      00839C AE 50 0A         [ 2]  639 	ldw	x, #0x500a
      00839F F6               [ 1]  640 	ld	a, (x)
      0083A0 A4 BF            [ 1]  641 	and	a, #0xbf
      0083A2 F7               [ 1]  642 	ld	(x), a
                                    643 ;	inc/7sig.h: 50: break;
      0083A3 20 27            [ 2]  644 	jra	00121$
                                    645 ;	inc/7sig.h: 51: case 9:   
      0083A5                        646 00118$:
                                    647 ;	inc/7sig.h: 52: segA,segB,segC,segD,segF,segG;
      0083A5 AE 50 0A         [ 2]  648 	ldw	x, #0x500a
      0083A8 F6               [ 1]  649 	ld	a, (x)
      0083A9 A4 FD            [ 1]  650 	and	a, #0xfd
      0083AB F7               [ 1]  651 	ld	(x), a
      0083AC AE 50 0A         [ 2]  652 	ldw	x, #0x500a
      0083AF F6               [ 1]  653 	ld	a, (x)
      0083B0 A4 FB            [ 1]  654 	and	a, #0xfb
      0083B2 F7               [ 1]  655 	ld	(x), a
      0083B3 AE 50 0A         [ 2]  656 	ldw	x, #0x500a
      0083B6 F6               [ 1]  657 	ld	a, (x)
      0083B7 A4 F7            [ 1]  658 	and	a, #0xf7
      0083B9 F7               [ 1]  659 	ld	(x), a
      0083BA AE 50 0A         [ 2]  660 	ldw	x, #0x500a
      0083BD F6               [ 1]  661 	ld	a, (x)
      0083BE A4 DF            [ 1]  662 	and	a, #0xdf
      0083C0 F7               [ 1]  663 	ld	(x), a
      0083C1 72 1F 50 0A      [ 1]  664 	bres	0x500a, #7
      0083C5 AE 50 0A         [ 2]  665 	ldw	x, #0x500a
      0083C8 F6               [ 1]  666 	ld	a, (x)
      0083C9 A4 BF            [ 1]  667 	and	a, #0xbf
      0083CB F7               [ 1]  668 	ld	(x), a
                                    669 ;	inc/7sig.h: 56: }
      0083CC                        670 00121$:
      0083CC 5B 02            [ 2]  671 	addw	sp, #2
      0083CE 81               [ 4]  672 	ret
                                    673 ;	main.c: 7: void delay(int t)
                                    674 ;	-----------------------------------------
                                    675 ;	 function delay
                                    676 ;	-----------------------------------------
      0083CF                        677 _delay:
      0083CF 52 02            [ 2]  678 	sub	sp, #2
                                    679 ;	main.c: 10: for(i=0;i<t;i++)
      0083D1 5F               [ 1]  680 	clrw	x
      0083D2                        681 00107$:
      0083D2 13 05            [ 2]  682 	cpw	x, (0x05, sp)
      0083D4 2E 13            [ 1]  683 	jrsge	00109$
                                    684 ;	main.c: 12: for(s=0;s<1512;s++)
      0083D6 90 AE 05 E8      [ 2]  685 	ldw	y, #0x05e8
      0083DA 17 01            [ 2]  686 	ldw	(0x01, sp), y
      0083DC                        687 00105$:
      0083DC 16 01            [ 2]  688 	ldw	y, (0x01, sp)
      0083DE 90 5A            [ 2]  689 	decw	y
      0083E0 17 01            [ 2]  690 	ldw	(0x01, sp), y
      0083E2 90 5D            [ 2]  691 	tnzw	y
      0083E4 26 F6            [ 1]  692 	jrne	00105$
                                    693 ;	main.c: 10: for(i=0;i<t;i++)
      0083E6 5C               [ 1]  694 	incw	x
      0083E7 20 E9            [ 2]  695 	jra	00107$
      0083E9                        696 00109$:
      0083E9 5B 02            [ 2]  697 	addw	sp, #2
      0083EB 81               [ 4]  698 	ret
                                    699 ;	main.c: 18: void main(void)
                                    700 ;	-----------------------------------------
                                    701 ;	 function main
                                    702 ;	-----------------------------------------
      0083EC                        703 _main:
      0083EC 52 08            [ 2]  704 	sub	sp, #8
                                    705 ;	main.c: 21: int z=0,q=0,w=0,cont=0;
      0083EE 5F               [ 1]  706 	clrw	x
      0083EF 1F 07            [ 2]  707 	ldw	(0x07, sp), x
      0083F1 5F               [ 1]  708 	clrw	x
      0083F2 1F 05            [ 2]  709 	ldw	(0x05, sp), x
      0083F4 5F               [ 1]  710 	clrw	x
      0083F5 1F 01            [ 2]  711 	ldw	(0x01, sp), x
                                    712 ;	main.c: 22: clk_init();
      0083F7 CD 80 A0         [ 4]  713 	call	_clk_init
                                    714 ;	main.c: 23: GPIO_init();
      0083FA CD 80 C8         [ 4]  715 	call	_GPIO_init
                                    716 ;	main.c: 25: while(1)
      0083FD                        717 00118$:
                                    718 ;	main.c: 27: if(cont==48)
      0083FD 1E 01            [ 2]  719 	ldw	x, (0x01, sp)
      0083FF A3 00 30         [ 2]  720 	cpw	x, #0x0030
      008402 26 43            [ 1]  721 	jrne	00110$
                                    722 ;	main.c: 29: w=(PD_IDR&((1<<7)|(1<<6)));
      008404 AE 50 10         [ 2]  723 	ldw	x, #0x5010
      008407 F6               [ 1]  724 	ld	a, (x)
      008408 A4 C0            [ 1]  725 	and	a, #0xc0
      00840A 5F               [ 1]  726 	clrw	x
      00840B 97               [ 1]  727 	ld	xl, a
                                    728 ;	main.c: 30: if(w==192&&q==64&&z<500) z++;
      00840C 1F 03            [ 2]  729 	ldw	(0x03, sp), x
      00840E A3 00 C0         [ 2]  730 	cpw	x, #0x00c0
      008411 26 03            [ 1]  731 	jrne	00170$
      008413 A6 01            [ 1]  732 	ld	a, #0x01
      008415 21                     733 	.byte 0x21
      008416                        734 00170$:
      008416 4F               [ 1]  735 	clr	a
      008417                        736 00171$:
      008417 4D               [ 1]  737 	tnz	a
      008418 27 13            [ 1]  738 	jreq	00102$
      00841A 1E 05            [ 2]  739 	ldw	x, (0x05, sp)
      00841C A3 00 40         [ 2]  740 	cpw	x, #0x0040
      00841F 26 0C            [ 1]  741 	jrne	00102$
      008421 1E 07            [ 2]  742 	ldw	x, (0x07, sp)
      008423 A3 01 F4         [ 2]  743 	cpw	x, #0x01f4
      008426 2E 05            [ 1]  744 	jrsge	00102$
      008428 1E 07            [ 2]  745 	ldw	x, (0x07, sp)
      00842A 5C               [ 1]  746 	incw	x
      00842B 1F 07            [ 2]  747 	ldw	(0x07, sp), x
      00842D                        748 00102$:
                                    749 ;	main.c: 31: if(w==192&&q==128&&z>0) z--;
      00842D 4D               [ 1]  750 	tnz	a
      00842E 27 13            [ 1]  751 	jreq	00106$
      008430 1E 05            [ 2]  752 	ldw	x, (0x05, sp)
      008432 A3 00 80         [ 2]  753 	cpw	x, #0x0080
      008435 26 0C            [ 1]  754 	jrne	00106$
      008437 1E 07            [ 2]  755 	ldw	x, (0x07, sp)
      008439 A3 00 00         [ 2]  756 	cpw	x, #0x0000
      00843C 2D 05            [ 1]  757 	jrsle	00106$
      00843E 1E 07            [ 2]  758 	ldw	x, (0x07, sp)
      008440 5A               [ 2]  759 	decw	x
      008441 1F 07            [ 2]  760 	ldw	(0x07, sp), x
      008443                        761 00106$:
                                    762 ;	main.c: 32: q=w;
      008443 16 03            [ 2]  763 	ldw	y, (0x03, sp)
      008445 17 05            [ 2]  764 	ldw	(0x05, sp), y
                                    765 ;	main.c: 33: w=0;
      008447                        766 00110$:
                                    767 ;	main.c: 35: if(cont<=48)cont++;
      008447 1E 01            [ 2]  768 	ldw	x, (0x01, sp)
      008449 A3 00 30         [ 2]  769 	cpw	x, #0x0030
      00844C 2C 05            [ 1]  770 	jrsgt	00112$
      00844E 1E 01            [ 2]  771 	ldw	x, (0x01, sp)
      008450 5C               [ 1]  772 	incw	x
      008451 1F 01            [ 2]  773 	ldw	(0x01, sp), x
      008453                        774 00112$:
                                    775 ;	main.c: 36: if(cont>48)cont=0;
      008453 1E 01            [ 2]  776 	ldw	x, (0x01, sp)
      008455 A3 00 30         [ 2]  777 	cpw	x, #0x0030
      008458 2D 03            [ 1]  778 	jrsle	00114$
      00845A 5F               [ 1]  779 	clrw	x
      00845B 1F 01            [ 2]  780 	ldw	(0x01, sp), x
      00845D                        781 00114$:
                                    782 ;	main.c: 37: if(cont==48)out7seg(z);
      00845D 1E 01            [ 2]  783 	ldw	x, (0x01, sp)
      00845F A3 00 30         [ 2]  784 	cpw	x, #0x0030
      008462 26 99            [ 1]  785 	jrne	00118$
      008464 1E 07            [ 2]  786 	ldw	x, (0x07, sp)
      008466 89               [ 2]  787 	pushw	x
      008467 CD 81 B8         [ 4]  788 	call	_out7seg
      00846A 5B 02            [ 2]  789 	addw	sp, #2
      00846C 20 8F            [ 2]  790 	jra	00118$
      00846E 5B 08            [ 2]  791 	addw	sp, #8
      008470 81               [ 4]  792 	ret
                                    793 	.area CODE
                                    794 	.area INITIALIZER
      00849B                        795 __xinit__x:
      00849B 00 00                  796 	.dw #0x0000
      00849D                        797 __xinit__q:
      00849D 00 00                  798 	.dw #0x0000
                                    799 	.area CABS (ABS)
