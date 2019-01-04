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
                                     13 	.globl _out7seg
                                     14 	.globl _ADC_read
                                     15 	.globl _ADC_INIT
                                     16 	.globl _gpio_init
                                     17 	.globl _clk_init
                                     18 ;--------------------------------------------------------
                                     19 ; ram data
                                     20 ;--------------------------------------------------------
                                     21 	.area DATA
                                     22 ;--------------------------------------------------------
                                     23 ; ram data
                                     24 ;--------------------------------------------------------
                                     25 	.area INITIALIZED
                                     26 ;--------------------------------------------------------
                                     27 ; Stack segment in internal ram 
                                     28 ;--------------------------------------------------------
                                     29 	.area	SSEG
      FFFFFF                         30 __start__stack:
      FFFFFF                         31 	.ds	1
                                     32 
                                     33 ;--------------------------------------------------------
                                     34 ; absolute external ram data
                                     35 ;--------------------------------------------------------
                                     36 	.area DABS (ABS)
                                     37 
                                     38 ; default segment ordering for linker
                                     39 	.area HOME
                                     40 	.area GSINIT
                                     41 	.area GSFINAL
                                     42 	.area CONST
                                     43 	.area INITIALIZER
                                     44 	.area CODE
                                     45 
                                     46 ;--------------------------------------------------------
                                     47 ; interrupt vector 
                                     48 ;--------------------------------------------------------
                                     49 	.area HOME
      008000                         50 __interrupt_vect:
      008000 82 00 80 07             51 	int s_GSINIT ; reset
                                     52 ;--------------------------------------------------------
                                     53 ; global & static initialisations
                                     54 ;--------------------------------------------------------
                                     55 	.area HOME
                                     56 	.area GSINIT
                                     57 	.area GSFINAL
                                     58 	.area GSINIT
      008007                         59 __sdcc_gs_init_startup:
      008007                         60 __sdcc_init_data:
                                     61 ; stm8_genXINIT() start
      008007 AE 00 00         [ 2]   62 	ldw x, #l_DATA
      00800A 27 07            [ 1]   63 	jreq	00002$
      00800C                         64 00001$:
      00800C 72 4F 00 00      [ 1]   65 	clr (s_DATA - 1, x)
      008010 5A               [ 2]   66 	decw x
      008011 26 F9            [ 1]   67 	jrne	00001$
      008013                         68 00002$:
      008013 AE 00 00         [ 2]   69 	ldw	x, #l_INITIALIZER
      008016 27 09            [ 1]   70 	jreq	00004$
      008018                         71 00003$:
      008018 D6 80 23         [ 1]   72 	ld	a, (s_INITIALIZER - 1, x)
      00801B D7 00 00         [ 1]   73 	ld	(s_INITIALIZED - 1, x), a
      00801E 5A               [ 2]   74 	decw	x
      00801F 26 F7            [ 1]   75 	jrne	00003$
      008021                         76 00004$:
                                     77 ; stm8_genXINIT() end
                                     78 	.area GSFINAL
      008021 CC 80 04         [ 2]   79 	jp	__sdcc_program_startup
                                     80 ;--------------------------------------------------------
                                     81 ; Home
                                     82 ;--------------------------------------------------------
                                     83 	.area HOME
                                     84 	.area HOME
      008004                         85 __sdcc_program_startup:
      008004 CC 82 43         [ 2]   86 	jp	_main
                                     87 ;	return from main will return to caller
                                     88 ;--------------------------------------------------------
                                     89 ; code
                                     90 ;--------------------------------------------------------
                                     91 	.area CODE
                                     92 ;	inc/clk_init.h: 7: void clk_init(void){    
                                     93 ;	-----------------------------------------
                                     94 ;	 function clk_init
                                     95 ;	-----------------------------------------
      008024                         96 _clk_init:
                                     97 ;	inc/clk_init.h: 8: CLK_ECKR|=CLK_ECKR_HSEEN;            
      008024 72 10 50 C1      [ 1]   98 	bset	20673, #0
                                     99 ;	inc/clk_init.h: 9: CLK_SWCR|=CLK_SWCR_SWEN;               
      008028 72 12 50 C5      [ 1]  100 	bset	20677, #1
                                    101 ;	inc/clk_init.h: 10: while((CLK_ECKR & CLK_ECKR_HSERDY) == 0) {} 
      00802C                        102 00101$:
      00802C C6 50 C1         [ 1]  103 	ld	a, 0x50c1
      00802F A5 02            [ 1]  104 	bcp	a, #0x02
      008031 27 F9            [ 1]  105 	jreq	00101$
                                    106 ;	inc/clk_init.h: 11: CLK_CKDIVR = 0;                    
      008033 35 00 50 C6      [ 1]  107 	mov	0x50c6+0, #0x00
                                    108 ;	inc/clk_init.h: 12: CLK_SWR = 0xB4;                    
      008037 35 B4 50 C4      [ 1]  109 	mov	0x50c4+0, #0xb4
                                    110 ;	inc/clk_init.h: 13: while ((CLK_SWCR & CLK_SWCR_SWIF) == 0){}
      00803B                        111 00104$:
      00803B C6 50 C5         [ 1]  112 	ld	a, 0x50c5
      00803E A5 08            [ 1]  113 	bcp	a, #0x08
      008040 27 F9            [ 1]  114 	jreq	00104$
                                    115 ;	inc/clk_init.h: 14: CLK_CSSR|=CLK_CSSR_CSSEN;
      008042 72 10 50 C8      [ 1]  116 	bset	20680, #0
                                    117 ;	inc/clk_init.h: 15: }
      008046 81               [ 4]  118 	ret
                                    119 ;	inc/gpio_init.h: 24: void gpio_init(void)
                                    120 ;	-----------------------------------------
                                    121 ;	 function gpio_init
                                    122 ;	-----------------------------------------
      008047                        123 _gpio_init:
                                    124 ;	inc/gpio_init.h: 27: PA_DDR = 0xFF;                                                        //_______PORT_IN
      008047 35 FF 50 02      [ 1]  125 	mov	0x5002+0, #0xff
                                    126 ;	inc/gpio_init.h: 28: PA_CR1 = 0xFF;                                                       //_______DDR________________CR1______________CR2___________FUNCTION  
      00804B 35 FF 50 03      [ 1]  127 	mov	0x5003+0, #0xff
                                    128 ;	inc/gpio_init.h: 29: PA_CR2 = 0x00;                                                      //_______0__________________0________________0_____________bez podtiyzhki,bez prerbIvanii 
      00804F 35 00 50 04      [ 1]  129 	mov	0x5004+0, #0x00
                                    130 ;	inc/gpio_init.h: 31: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
      008053 35 00 50 07      [ 1]  131 	mov	0x5007+0, #0x00
                                    132 ;	inc/gpio_init.h: 32: PB_CR1 = 0x00;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
      008057 35 00 50 08      [ 1]  133 	mov	0x5008+0, #0x00
                                    134 ;	inc/gpio_init.h: 33: PB_CR2 = 0x00;                                                      //_______PORT_OUT
      00805B 35 00 50 09      [ 1]  135 	mov	0x5009+0, #0x00
                                    136 ;	inc/gpio_init.h: 35: PC_DDR = 0xFF;                                                        //_______1__________________0________________0_____________otkritiy stok
      00805F 35 FF 50 0C      [ 1]  137 	mov	0x500c+0, #0xff
                                    138 ;	inc/gpio_init.h: 36: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
      008063 35 FF 50 0D      [ 1]  139 	mov	0x500d+0, #0xff
                                    140 ;	inc/gpio_init.h: 37: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
      008067 35 00 50 0E      [ 1]  141 	mov	0x500e+0, #0x00
                                    142 ;	inc/gpio_init.h: 39: PD_DDR = 0x3F;   
      00806B 35 3F 50 11      [ 1]  143 	mov	0x5011+0, #0x3f
                                    144 ;	inc/gpio_init.h: 40: PD_CR1 = 0xFF;  
      00806F 35 FF 50 12      [ 1]  145 	mov	0x5012+0, #0xff
                                    146 ;	inc/gpio_init.h: 41: PD_CR2 = 0x00; 
      008073 35 00 50 13      [ 1]  147 	mov	0x5013+0, #0x00
                                    148 ;	inc/gpio_init.h: 43: PE_DDR = 0xFF;   
      008077 35 FF 50 16      [ 1]  149 	mov	0x5016+0, #0xff
                                    150 ;	inc/gpio_init.h: 44: PE_CR1 = 0xFF;  
      00807B 35 FF 50 17      [ 1]  151 	mov	0x5017+0, #0xff
                                    152 ;	inc/gpio_init.h: 45: PE_CR2 = 0x00; 
      00807F 35 00 50 18      [ 1]  153 	mov	0x5018+0, #0x00
                                    154 ;	inc/gpio_init.h: 47: PF_DDR = 0xFF;   
      008083 35 FF 50 1B      [ 1]  155 	mov	0x501b+0, #0xff
                                    156 ;	inc/gpio_init.h: 48: PF_CR1 = 0xFF;  
      008087 35 FF 50 1C      [ 1]  157 	mov	0x501c+0, #0xff
                                    158 ;	inc/gpio_init.h: 49: PF_CR2 = 0x00; 
      00808B 35 00 50 1D      [ 1]  159 	mov	0x501d+0, #0x00
                                    160 ;	inc/gpio_init.h: 54: }
      00808F 81               [ 4]  161 	ret
                                    162 ;	inc/ADC.h: 51: void ADC_INIT(void){
                                    163 ;	-----------------------------------------
                                    164 ;	 function ADC_INIT
                                    165 ;	-----------------------------------------
      008090                        166 _ADC_INIT:
                                    167 ;	inc/ADC.h: 52: ADC_CSR_CH0;           //Выбераем канал
      008090 C6 54 00         [ 1]  168 	ld	a, 0x5400
      008093 A4 F0            [ 1]  169 	and	a, #0xf0
      008095 C7 54 00         [ 1]  170 	ld	0x5400, a
                                    171 ;	inc/ADC.h: 53: ADC_CR1_SPSEL8;  //Делитель на 18            
      008098 72 1C 54 01      [ 1]  172 	bset	21505, #6
                                    173 ;	inc/ADC.h: 54: ADC_TDRL_DIS(0);       //Отключаем тригер Шмидта
      00809C 72 10 54 07      [ 1]  174 	bset	21511, #0
                                    175 ;	inc/ADC.h: 55: ADC_CR2_ALIGN_LEFT;    //Выравнивание по левому краю
      0080A0 72 17 54 02      [ 1]  176 	bres	21506, #3
                                    177 ;	inc/ADC.h: 56: ADC_CR1_ADON_ON;       //Первый запуск ADC
      0080A4 72 10 54 01      [ 1]  178 	bset	21505, #0
                                    179 ;	inc/ADC.h: 57: }
      0080A8 81               [ 4]  180 	ret
                                    181 ;	inc/ADC.h: 58: int ADC_read(void){
                                    182 ;	-----------------------------------------
                                    183 ;	 function ADC_read
                                    184 ;	-----------------------------------------
      0080A9                        185 _ADC_read:
                                    186 ;	inc/ADC.h: 60: ADC_CR1_ADON_ON;
      0080A9 C6 54 01         [ 1]  187 	ld	a, 0x5401
      0080AC AA 01            [ 1]  188 	or	a, #0x01
      0080AE C7 54 01         [ 1]  189 	ld	0x5401, a
                                    190 ;	inc/ADC.h: 61: for(t=0;t<64;t++){
      0080B1 90 AE 00 40      [ 2]  191 	ldw	y, #0x0040
      0080B5                        192 00104$:
                                    193 ;	inc/ADC.h: 62: __asm__("nop\n");
      0080B5 9D               [ 1]  194 	nop
      0080B6 93               [ 1]  195 	ldw	x, y
      0080B7 5A               [ 2]  196 	decw	x
      0080B8 90 93            [ 1]  197 	ldw	y, x
                                    198 ;	inc/ADC.h: 61: for(t=0;t<64;t++){
      0080BA 5D               [ 2]  199 	tnzw	x
      0080BB 26 F8            [ 1]  200 	jrne	00104$
                                    201 ;	inc/ADC.h: 64: data=ADC_DRH;
      0080BD C6 54 04         [ 1]  202 	ld	a, 0x5404
      0080C0 5F               [ 1]  203 	clrw	x
      0080C1 97               [ 1]  204 	ld	xl, a
                                    205 ;	inc/ADC.h: 65: return data;
                                    206 ;	inc/ADC.h: 66: }
      0080C2 81               [ 4]  207 	ret
                                    208 ;	inc/7sig.h: 11: void out7seg(volatile int t,volatile int q)
                                    209 ;	-----------------------------------------
                                    210 ;	 function out7seg
                                    211 ;	-----------------------------------------
      0080C3                        212 _out7seg:
                                    213 ;	inc/7sig.h: 13: int num=0;
      0080C3 5F               [ 1]  214 	clrw	x
                                    215 ;	inc/7sig.h: 14: PC_ODR=0xff;
      0080C4 35 FF 50 0A      [ 1]  216 	mov	0x500a+0, #0xff
                                    217 ;	inc/7sig.h: 15: PD_ODR|=(1<<3)|(1<<1)|(1<<2);
      0080C8 C6 50 0F         [ 1]  218 	ld	a, 0x500f
      0080CB AA 0E            [ 1]  219 	or	a, #0x0e
      0080CD C7 50 0F         [ 1]  220 	ld	0x500f, a
                                    221 ;	inc/7sig.h: 17: if(q==0) num=(t%1000/100),PD_ODR&=~(1<<1);
      0080D0 16 05            [ 2]  222 	ldw	y, (0x05, sp)
      0080D2 26 1E            [ 1]  223 	jrne	00102$
      0080D4 4B E8            [ 1]  224 	push	#0xe8
      0080D6 4B 03            [ 1]  225 	push	#0x03
      0080D8 1E 05            [ 2]  226 	ldw	x, (0x05, sp)
      0080DA 89               [ 2]  227 	pushw	x
      0080DB CD 83 66         [ 4]  228 	call	__modsint
      0080DE 5B 04            [ 2]  229 	addw	sp, #4
      0080E0 4B 64            [ 1]  230 	push	#0x64
      0080E2 4B 00            [ 1]  231 	push	#0x00
      0080E4 89               [ 2]  232 	pushw	x
      0080E5 CD 83 7C         [ 4]  233 	call	__divsint
      0080E8 5B 04            [ 2]  234 	addw	sp, #4
      0080EA C6 50 0F         [ 1]  235 	ld	a, 0x500f
      0080ED A4 FD            [ 1]  236 	and	a, #0xfd
      0080EF C7 50 0F         [ 1]  237 	ld	0x500f, a
      0080F2                        238 00102$:
                                    239 ;	inc/7sig.h: 18: if(q==1) num=(t%100/10),PD_ODR&=~(1<<2);
      0080F2 89               [ 2]  240 	pushw	x
      0080F3 1E 07            [ 2]  241 	ldw	x, (0x07, sp)
      0080F5 5A               [ 2]  242 	decw	x
      0080F6 85               [ 2]  243 	popw	x
      0080F7 26 1E            [ 1]  244 	jrne	00104$
      0080F9 4B 64            [ 1]  245 	push	#0x64
      0080FB 4B 00            [ 1]  246 	push	#0x00
      0080FD 1E 05            [ 2]  247 	ldw	x, (0x05, sp)
      0080FF 89               [ 2]  248 	pushw	x
      008100 CD 83 66         [ 4]  249 	call	__modsint
      008103 5B 04            [ 2]  250 	addw	sp, #4
      008105 4B 0A            [ 1]  251 	push	#0x0a
      008107 4B 00            [ 1]  252 	push	#0x00
      008109 89               [ 2]  253 	pushw	x
      00810A CD 83 7C         [ 4]  254 	call	__divsint
      00810D 5B 04            [ 2]  255 	addw	sp, #4
      00810F C6 50 0F         [ 1]  256 	ld	a, 0x500f
      008112 A4 FB            [ 1]  257 	and	a, #0xfb
      008114 C7 50 0F         [ 1]  258 	ld	0x500f, a
      008117                        259 00104$:
                                    260 ;	inc/7sig.h: 19: if(q==2) num=(t%10),PD_ODR&=~(1<<3);
      008117 89               [ 2]  261 	pushw	x
      008118 1E 07            [ 2]  262 	ldw	x, (0x07, sp)
      00811A A3 00 02         [ 2]  263 	cpw	x, #0x0002
      00811D 85               [ 2]  264 	popw	x
      00811E 26 14            [ 1]  265 	jrne	00106$
      008120 4B 0A            [ 1]  266 	push	#0x0a
      008122 4B 00            [ 1]  267 	push	#0x00
      008124 1E 05            [ 2]  268 	ldw	x, (0x05, sp)
      008126 89               [ 2]  269 	pushw	x
      008127 CD 83 66         [ 4]  270 	call	__modsint
      00812A 5B 04            [ 2]  271 	addw	sp, #4
      00812C C6 50 0F         [ 1]  272 	ld	a, 0x500f
      00812F A4 F7            [ 1]  273 	and	a, #0xf7
      008131 C7 50 0F         [ 1]  274 	ld	0x500f, a
      008134                        275 00106$:
                                    276 ;	inc/7sig.h: 20: switch (num)
      008134 5D               [ 2]  277 	tnzw	x
      008135 2A 01            [ 1]  278 	jrpl	00153$
      008137 81               [ 4]  279 	ret
      008138                        280 00153$:
      008138 A3 00 09         [ 2]  281 	cpw	x, #0x0009
      00813B 2D 01            [ 1]  282 	jrsle	00154$
      00813D 81               [ 4]  283 	ret
      00813E                        284 00154$:
      00813E 58               [ 2]  285 	sllw	x
      00813F DE 81 43         [ 2]  286 	ldw	x, (#00155$, x)
      008142 FC               [ 2]  287 	jp	(x)
      008143                        288 00155$:
      008143 81 57                  289 	.dw	#00107$
      008145 81 70                  290 	.dw	#00108$
      008147 81 79                  291 	.dw	#00109$
      008149 81 8E                  292 	.dw	#00110$
      00814B 81 A3                  293 	.dw	#00111$
      00814D 81 B4                  294 	.dw	#00112$
      00814F 81 C9                  295 	.dw	#00113$
      008151 81 E2                  296 	.dw	#00114$
      008153 81 EF                  297 	.dw	#00115$
      008155 82 0C                  298 	.dw	#00116$
                                    299 ;	inc/7sig.h: 22: case 0:   
      008157                        300 00107$:
                                    301 ;	inc/7sig.h: 23: segA,segB,segC,segD,segE,segF;
      008157 72 13 50 0A      [ 1]  302 	bres	20490, #1
      00815B 72 15 50 0A      [ 1]  303 	bres	20490, #2
      00815F 72 17 50 0A      [ 1]  304 	bres	20490, #3
      008163 72 1B 50 0A      [ 1]  305 	bres	20490, #5
      008167 72 19 50 0A      [ 1]  306 	bres	20490, #4
      00816B 72 1F 50 0A      [ 1]  307 	bres	20490, #7
                                    308 ;	inc/7sig.h: 24: break;
      00816F 81               [ 4]  309 	ret
                                    310 ;	inc/7sig.h: 25: case 1:   
      008170                        311 00108$:
                                    312 ;	inc/7sig.h: 26: segB,segC;
      008170 72 15 50 0A      [ 1]  313 	bres	20490, #2
      008174 72 17 50 0A      [ 1]  314 	bres	20490, #3
                                    315 ;	inc/7sig.h: 27: break;
      008178 81               [ 4]  316 	ret
                                    317 ;	inc/7sig.h: 28: case 2:   
      008179                        318 00109$:
                                    319 ;	inc/7sig.h: 29: segA,segB,segG,segD,segE;
      008179 72 13 50 0A      [ 1]  320 	bres	20490, #1
      00817D 72 15 50 0A      [ 1]  321 	bres	20490, #2
      008181 72 1D 50 0A      [ 1]  322 	bres	20490, #6
      008185 72 1B 50 0A      [ 1]  323 	bres	20490, #5
      008189 72 19 50 0A      [ 1]  324 	bres	20490, #4
                                    325 ;	inc/7sig.h: 30: break;
      00818D 81               [ 4]  326 	ret
                                    327 ;	inc/7sig.h: 31: case 3:   
      00818E                        328 00110$:
                                    329 ;	inc/7sig.h: 32: segA,segB,segC,segD,segG;
      00818E 72 13 50 0A      [ 1]  330 	bres	20490, #1
      008192 72 15 50 0A      [ 1]  331 	bres	20490, #2
      008196 72 17 50 0A      [ 1]  332 	bres	20490, #3
      00819A 72 1B 50 0A      [ 1]  333 	bres	20490, #5
      00819E 72 1D 50 0A      [ 1]  334 	bres	20490, #6
                                    335 ;	inc/7sig.h: 33: break;
      0081A2 81               [ 4]  336 	ret
                                    337 ;	inc/7sig.h: 34: case 4:   
      0081A3                        338 00111$:
                                    339 ;	inc/7sig.h: 35: segF,segB,segG,segC;
      0081A3 72 1F 50 0A      [ 1]  340 	bres	20490, #7
      0081A7 72 15 50 0A      [ 1]  341 	bres	20490, #2
      0081AB 72 1D 50 0A      [ 1]  342 	bres	20490, #6
      0081AF 72 17 50 0A      [ 1]  343 	bres	20490, #3
                                    344 ;	inc/7sig.h: 36: break;
      0081B3 81               [ 4]  345 	ret
                                    346 ;	inc/7sig.h: 37: case 5:   
      0081B4                        347 00112$:
                                    348 ;	inc/7sig.h: 38: segA,segC,segD,segF,segG;
      0081B4 72 13 50 0A      [ 1]  349 	bres	20490, #1
      0081B8 72 17 50 0A      [ 1]  350 	bres	20490, #3
      0081BC 72 1B 50 0A      [ 1]  351 	bres	20490, #5
      0081C0 72 1F 50 0A      [ 1]  352 	bres	20490, #7
      0081C4 72 1D 50 0A      [ 1]  353 	bres	20490, #6
                                    354 ;	inc/7sig.h: 39: break;
      0081C8 81               [ 4]  355 	ret
                                    356 ;	inc/7sig.h: 40: case 6:   
      0081C9                        357 00113$:
                                    358 ;	inc/7sig.h: 41: segA,segC,segD,segE,segF,segG;
      0081C9 72 13 50 0A      [ 1]  359 	bres	20490, #1
      0081CD 72 17 50 0A      [ 1]  360 	bres	20490, #3
      0081D1 72 1B 50 0A      [ 1]  361 	bres	20490, #5
      0081D5 72 19 50 0A      [ 1]  362 	bres	20490, #4
      0081D9 72 1F 50 0A      [ 1]  363 	bres	20490, #7
      0081DD 72 1D 50 0A      [ 1]  364 	bres	20490, #6
                                    365 ;	inc/7sig.h: 42: break;
      0081E1 81               [ 4]  366 	ret
                                    367 ;	inc/7sig.h: 43: case 7:   
      0081E2                        368 00114$:
                                    369 ;	inc/7sig.h: 44: segA,segB,segC;
      0081E2 72 13 50 0A      [ 1]  370 	bres	20490, #1
      0081E6 72 15 50 0A      [ 1]  371 	bres	20490, #2
      0081EA 72 17 50 0A      [ 1]  372 	bres	20490, #3
                                    373 ;	inc/7sig.h: 45: break;
      0081EE 81               [ 4]  374 	ret
                                    375 ;	inc/7sig.h: 46: case 8:   
      0081EF                        376 00115$:
                                    377 ;	inc/7sig.h: 47: segA,segB,segC,segD,segE,segF,segG;
      0081EF 72 13 50 0A      [ 1]  378 	bres	20490, #1
      0081F3 72 15 50 0A      [ 1]  379 	bres	20490, #2
      0081F7 72 17 50 0A      [ 1]  380 	bres	20490, #3
      0081FB 72 1B 50 0A      [ 1]  381 	bres	20490, #5
      0081FF 72 19 50 0A      [ 1]  382 	bres	20490, #4
      008203 72 1F 50 0A      [ 1]  383 	bres	20490, #7
      008207 72 1D 50 0A      [ 1]  384 	bres	20490, #6
                                    385 ;	inc/7sig.h: 48: break;
      00820B 81               [ 4]  386 	ret
                                    387 ;	inc/7sig.h: 49: case 9:   
      00820C                        388 00116$:
                                    389 ;	inc/7sig.h: 50: segA,segB,segC,segD,segF,segG;
      00820C 72 13 50 0A      [ 1]  390 	bres	20490, #1
      008210 72 15 50 0A      [ 1]  391 	bres	20490, #2
      008214 72 17 50 0A      [ 1]  392 	bres	20490, #3
      008218 72 1B 50 0A      [ 1]  393 	bres	20490, #5
      00821C 72 1F 50 0A      [ 1]  394 	bres	20490, #7
      008220 72 1D 50 0A      [ 1]  395 	bres	20490, #6
                                    396 ;	inc/7sig.h: 54: }
                                    397 ;	inc/7sig.h: 56: }
      008224 81               [ 4]  398 	ret
                                    399 ;	main.c: 6: void delay(int t)
                                    400 ;	-----------------------------------------
                                    401 ;	 function delay
                                    402 ;	-----------------------------------------
      008225                        403 _delay:
      008225 52 02            [ 2]  404 	sub	sp, #2
                                    405 ;	main.c: 9: for(i=0;i<t;i++)
      008227 5F               [ 1]  406 	clrw	x
      008228                        407 00107$:
      008228 13 05            [ 2]  408 	cpw	x, (0x05, sp)
      00822A 2E 14            [ 1]  409 	jrsge	00109$
                                    410 ;	main.c: 11: for(s=0;s<1512;s++)
      00822C 90 AE 05 E8      [ 2]  411 	ldw	y, #0x05e8
      008230 17 01            [ 2]  412 	ldw	(0x01, sp), y
      008232                        413 00105$:
                                    414 ;	main.c: 13: __asm__("nop\n");
      008232 9D               [ 1]  415 	nop
      008233 16 01            [ 2]  416 	ldw	y, (0x01, sp)
      008235 90 5A            [ 2]  417 	decw	y
      008237 17 01            [ 2]  418 	ldw	(0x01, sp), y
                                    419 ;	main.c: 11: for(s=0;s<1512;s++)
      008239 90 5D            [ 2]  420 	tnzw	y
      00823B 26 F5            [ 1]  421 	jrne	00105$
                                    422 ;	main.c: 9: for(i=0;i<t;i++)
      00823D 5C               [ 1]  423 	incw	x
      00823E 20 E8            [ 2]  424 	jra	00107$
      008240                        425 00109$:
                                    426 ;	main.c: 16: }
      008240 5B 02            [ 2]  427 	addw	sp, #2
      008242 81               [ 4]  428 	ret
                                    429 ;	main.c: 18: void main(void)
                                    430 ;	-----------------------------------------
                                    431 ;	 function main
                                    432 ;	-----------------------------------------
      008243                        433 _main:
      008243 52 12            [ 2]  434 	sub	sp, #18
                                    435 ;	main.c: 20: int f=150,w=0,s=0,t=0,q=0,counter=0,ironON=200,ironOFF=55,format_data=0,oldadc=0,adc_data=0;
      008245 AE 00 96         [ 2]  436 	ldw	x, #0x0096
      008248 1F 0B            [ 2]  437 	ldw	(0x0b, sp), x
      00824A 5F               [ 1]  438 	clrw	x
      00824B 1F 0D            [ 2]  439 	ldw	(0x0d, sp), x
      00824D 5F               [ 1]  440 	clrw	x
      00824E 1F 11            [ 2]  441 	ldw	(0x11, sp), x
      008250 5F               [ 1]  442 	clrw	x
      008251 1F 0F            [ 2]  443 	ldw	(0x0f, sp), x
      008253 AE 00 C8         [ 2]  444 	ldw	x, #0x00c8
      008256 1F 09            [ 2]  445 	ldw	(0x09, sp), x
      008258 AE 00 37         [ 2]  446 	ldw	x, #0x0037
      00825B 1F 07            [ 2]  447 	ldw	(0x07, sp), x
      00825D 5F               [ 1]  448 	clrw	x
      00825E 1F 05            [ 2]  449 	ldw	(0x05, sp), x
      008260 5F               [ 1]  450 	clrw	x
      008261 1F 01            [ 2]  451 	ldw	(0x01, sp), x
                                    452 ;	main.c: 21: clk_init();
      008263 CD 80 24         [ 4]  453 	call	_clk_init
                                    454 ;	main.c: 22: gpio_init();
      008266 CD 80 47         [ 4]  455 	call	_gpio_init
                                    456 ;	main.c: 23: ADC_INIT();
      008269 CD 80 90         [ 4]  457 	call	_ADC_INIT
                                    458 ;	main.c: 24: while(1)
      00826C                        459 00136$:
                                    460 ;	main.c: 26: if(counter<=32) counter++;
      00826C 1E 0F            [ 2]  461 	ldw	x, (0x0f, sp)
      00826E A3 00 20         [ 2]  462 	cpw	x, #0x0020
      008271 2C 05            [ 1]  463 	jrsgt	00102$
      008273 1E 0F            [ 2]  464 	ldw	x, (0x0f, sp)
      008275 5C               [ 1]  465 	incw	x
      008276 1F 0F            [ 2]  466 	ldw	(0x0f, sp), x
      008278                        467 00102$:
                                    468 ;	main.c: 27: if(counter>32) counter=0;
      008278 1E 0F            [ 2]  469 	ldw	x, (0x0f, sp)
      00827A A3 00 20         [ 2]  470 	cpw	x, #0x0020
      00827D 2D 03            [ 1]  471 	jrsle	00104$
      00827F 5F               [ 1]  472 	clrw	x
      008280 1F 0F            [ 2]  473 	ldw	(0x0f, sp), x
      008282                        474 00104$:
                                    475 ;	main.c: 28: if((counter&(1<<2))!=0)
      008282 7B 10            [ 1]  476 	ld	a, (0x10, sp)
      008284 A5 04            [ 1]  477 	bcp	a, #0x04
      008286 27 65            [ 1]  478 	jreq	00118$
                                    479 ;	main.c: 30: out7seg(format_data,t);
      008288 1E 0D            [ 2]  480 	ldw	x, (0x0d, sp)
      00828A 89               [ 2]  481 	pushw	x
      00828B 1E 07            [ 2]  482 	ldw	x, (0x07, sp)
      00828D 89               [ 2]  483 	pushw	x
      00828E CD 80 C3         [ 4]  484 	call	_out7seg
      008291 5B 04            [ 2]  485 	addw	sp, #4
                                    486 ;	main.c: 31: w=(PD_IDR&((1<<7)|(1<<6)));
      008293 C6 50 10         [ 1]  487 	ld	a, 0x5010
      008296 A4 C0            [ 1]  488 	and	a, #0xc0
      008298 5F               [ 1]  489 	clrw	x
      008299 97               [ 1]  490 	ld	xl, a
      00829A 1F 03            [ 2]  491 	ldw	(0x03, sp), x
                                    492 ;	main.c: 32: if(w==128&&q==192&&f<500)   f=f+1;
      00829C 1E 11            [ 2]  493 	ldw	x, (0x11, sp)
      00829E A3 00 C0         [ 2]  494 	cpw	x, #0x00c0
      0082A1 26 03            [ 1]  495 	jrne	00249$
      0082A3 A6 01            [ 1]  496 	ld	a, #0x01
      0082A5 21                     497 	.byte 0x21
      0082A6                        498 00249$:
      0082A6 4F               [ 1]  499 	clr	a
      0082A7                        500 00250$:
      0082A7 1E 03            [ 2]  501 	ldw	x, (0x03, sp)
      0082A9 A3 00 80         [ 2]  502 	cpw	x, #0x0080
      0082AC 26 0F            [ 1]  503 	jrne	00106$
      0082AE 4D               [ 1]  504 	tnz	a
      0082AF 27 0C            [ 1]  505 	jreq	00106$
      0082B1 1E 0B            [ 2]  506 	ldw	x, (0x0b, sp)
      0082B3 A3 01 F4         [ 2]  507 	cpw	x, #0x01f4
      0082B6 2E 05            [ 1]  508 	jrsge	00106$
      0082B8 1E 0B            [ 2]  509 	ldw	x, (0x0b, sp)
      0082BA 5C               [ 1]  510 	incw	x
      0082BB 1F 0B            [ 2]  511 	ldw	(0x0b, sp), x
      0082BD                        512 00106$:
                                    513 ;	main.c: 33: if(w==64&&q==192&&f>0)    f=f-1;
      0082BD 1E 03            [ 2]  514 	ldw	x, (0x03, sp)
      0082BF A3 00 40         [ 2]  515 	cpw	x, #0x0040
      0082C2 26 0F            [ 1]  516 	jrne	00110$
      0082C4 4D               [ 1]  517 	tnz	a
      0082C5 27 0C            [ 1]  518 	jreq	00110$
      0082C7 1E 0B            [ 2]  519 	ldw	x, (0x0b, sp)
      0082C9 A3 00 00         [ 2]  520 	cpw	x, #0x0000
      0082CC 2D 05            [ 1]  521 	jrsle	00110$
      0082CE 1E 0B            [ 2]  522 	ldw	x, (0x0b, sp)
      0082D0 5A               [ 2]  523 	decw	x
      0082D1 1F 0B            [ 2]  524 	ldw	(0x0b, sp), x
      0082D3                        525 00110$:
                                    526 ;	main.c: 34: q=w;
      0082D3 16 03            [ 2]  527 	ldw	y, (0x03, sp)
      0082D5 17 11            [ 2]  528 	ldw	(0x11, sp), y
                                    529 ;	main.c: 36: if(t<=2)t++;
      0082D7 1E 0D            [ 2]  530 	ldw	x, (0x0d, sp)
      0082D9 A3 00 02         [ 2]  531 	cpw	x, #0x0002
      0082DC 2C 05            [ 1]  532 	jrsgt	00114$
      0082DE 1E 0D            [ 2]  533 	ldw	x, (0x0d, sp)
      0082E0 5C               [ 1]  534 	incw	x
      0082E1 1F 0D            [ 2]  535 	ldw	(0x0d, sp), x
      0082E3                        536 00114$:
                                    537 ;	main.c: 37: if(t>2)t=0;
      0082E3 1E 0D            [ 2]  538 	ldw	x, (0x0d, sp)
      0082E5 A3 00 02         [ 2]  539 	cpw	x, #0x0002
      0082E8 2D 03            [ 1]  540 	jrsle	00118$
      0082EA 5F               [ 1]  541 	clrw	x
      0082EB 1F 0D            [ 2]  542 	ldw	(0x0d, sp), x
      0082ED                        543 00118$:
                                    544 ;	main.c: 40: if(counter==8||counter==16||counter==24)
      0082ED 1E 0F            [ 2]  545 	ldw	x, (0x0f, sp)
      0082EF A3 00 08         [ 2]  546 	cpw	x, #0x0008
      0082F2 27 11            [ 1]  547 	jreq	00131$
      0082F4 1E 0F            [ 2]  548 	ldw	x, (0x0f, sp)
      0082F6 A3 00 10         [ 2]  549 	cpw	x, #0x0010
      0082F9 27 0A            [ 1]  550 	jreq	00131$
      0082FB 1E 0F            [ 2]  551 	ldw	x, (0x0f, sp)
      0082FD A3 00 18         [ 2]  552 	cpw	x, #0x0018
      008300 27 03            [ 1]  553 	jreq	00271$
      008302 CC 82 6C         [ 2]  554 	jp	00136$
      008305                        555 00271$:
      008305                        556 00131$:
                                    557 ;	main.c: 43: if(ironON!=0)
      008305 1E 09            [ 2]  558 	ldw	x, (0x09, sp)
      008307 27 0D            [ 1]  559 	jreq	00120$
                                    560 ;	main.c: 45: PD_ODR|=(1<<0);
      008309 C6 50 0F         [ 1]  561 	ld	a, 0x500f
      00830C AA 01            [ 1]  562 	or	a, #0x01
      00830E C7 50 0F         [ 1]  563 	ld	0x500f, a
                                    564 ;	main.c: 46: --ironON;
      008311 1E 09            [ 2]  565 	ldw	x, (0x09, sp)
      008313 5A               [ 2]  566 	decw	x
      008314 1F 09            [ 2]  567 	ldw	(0x09, sp), x
      008316                        568 00120$:
                                    569 ;	main.c: 49: if(ironON==0&&ironOFF!=0)
      008316 1E 09            [ 2]  570 	ldw	x, (0x09, sp)
      008318 26 11            [ 1]  571 	jrne	00122$
      00831A 1E 07            [ 2]  572 	ldw	x, (0x07, sp)
      00831C 27 0D            [ 1]  573 	jreq	00122$
                                    574 ;	main.c: 51: PD_ODR&=~(1<<0);
      00831E C6 50 0F         [ 1]  575 	ld	a, 0x500f
      008321 A4 FE            [ 1]  576 	and	a, #0xfe
      008323 C7 50 0F         [ 1]  577 	ld	0x500f, a
                                    578 ;	main.c: 52: --ironOFF;
      008326 1E 07            [ 2]  579 	ldw	x, (0x07, sp)
      008328 5A               [ 2]  580 	decw	x
      008329 1F 07            [ 2]  581 	ldw	(0x07, sp), x
      00832B                        582 00122$:
                                    583 ;	main.c: 55: if(ironON==0&&ironOFF==0)
      00832B 1E 09            [ 2]  584 	ldw	x, (0x09, sp)
      00832D 27 03            [ 1]  585 	jreq	00275$
      00832F CC 82 6C         [ 2]  586 	jp	00136$
      008332                        587 00275$:
      008332 1E 07            [ 2]  588 	ldw	x, (0x07, sp)
      008334 27 03            [ 1]  589 	jreq	00276$
      008336 CC 82 6C         [ 2]  590 	jp	00136$
      008339                        591 00276$:
                                    592 ;	main.c: 57: adc_data=ADC_read();
      008339 CD 80 A9         [ 4]  593 	call	_ADC_read
                                    594 ;	main.c: 58: adc_data=adc_data+oldadc;
      00833C 72 FB 01         [ 2]  595 	addw	x, (0x01, sp)
                                    596 ;	main.c: 59: adc_data=adc_data>>1;
      00833F 57               [ 2]  597 	sraw	x
                                    598 ;	main.c: 60: format_data=adc_data;
      008340 1F 05            [ 2]  599 	ldw	(0x05, sp), x
                                    600 ;	main.c: 61: oldadc=adc_data;
      008342 1F 01            [ 2]  601 	ldw	(0x01, sp), x
                                    602 ;	main.c: 63: ironON=f-format_data;
      008344 50               [ 2]  603 	negw	x
      008345 72 FB 0B         [ 2]  604 	addw	x, (0x0b, sp)
                                    605 ;	main.c: 64: if(ironON>120)ironON=120;
      008348 1F 09            [ 2]  606 	ldw	(0x09, sp), x
      00834A A3 00 78         [ 2]  607 	cpw	x, #0x0078
      00834D 2D 05            [ 1]  608 	jrsle	00125$
      00834F AE 00 78         [ 2]  609 	ldw	x, #0x0078
      008352 1F 09            [ 2]  610 	ldw	(0x09, sp), x
      008354                        611 00125$:
                                    612 ;	main.c: 65: if(ironON<0)ironON=0;
      008354 0D 09            [ 1]  613 	tnz	(0x09, sp)
      008356 2A 03            [ 1]  614 	jrpl	00127$
      008358 5F               [ 1]  615 	clrw	x
      008359 1F 09            [ 2]  616 	ldw	(0x09, sp), x
      00835B                        617 00127$:
                                    618 ;	main.c: 66: ironOFF=128-ironON;
      00835B AE 00 80         [ 2]  619 	ldw	x, #0x0080
      00835E 72 F0 09         [ 2]  620 	subw	x, (0x09, sp)
      008361 1F 07            [ 2]  621 	ldw	(0x07, sp), x
                                    622 ;	main.c: 71: }
      008363 CC 82 6C         [ 2]  623 	jp	00136$
                                    624 	.area CODE
                                    625 	.area CONST
                                    626 	.area INITIALIZER
                                    627 	.area CABS (ABS)
