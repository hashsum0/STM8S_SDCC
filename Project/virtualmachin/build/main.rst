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
                                     14 	.globl _ADC_read
                                     15 	.globl _ADC_INIT
                                     16 	.globl _GPIO_init
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
      000001                         30 __start__stack:
      000001                         31 	.ds	1
                                     32 
                                     33 ;--------------------------------------------------------
                                     34 ; absolute external ram data
                                     35 ;--------------------------------------------------------
                                     36 	.area DABS (ABS)
                                     37 ;--------------------------------------------------------
                                     38 ; interrupt vector 
                                     39 ;--------------------------------------------------------
                                     40 	.area HOME
      008000                         41 __interrupt_vect:
      008000 82 00 80 83             42 	int s_GSINIT ;reset
      008004 82 00 00 00             43 	int 0x0000 ;trap
      008008 82 00 00 00             44 	int 0x0000 ;int0
      00800C 82 00 00 00             45 	int 0x0000 ;int1
      008010 82 00 00 00             46 	int 0x0000 ;int2
      008014 82 00 00 00             47 	int 0x0000 ;int3
      008018 82 00 00 00             48 	int 0x0000 ;int4
      00801C 82 00 00 00             49 	int 0x0000 ;int5
      008020 82 00 00 00             50 	int 0x0000 ;int6
      008024 82 00 00 00             51 	int 0x0000 ;int7
      008028 82 00 00 00             52 	int 0x0000 ;int8
      00802C 82 00 00 00             53 	int 0x0000 ;int9
      008030 82 00 00 00             54 	int 0x0000 ;int10
      008034 82 00 00 00             55 	int 0x0000 ;int11
      008038 82 00 00 00             56 	int 0x0000 ;int12
      00803C 82 00 00 00             57 	int 0x0000 ;int13
      008040 82 00 00 00             58 	int 0x0000 ;int14
      008044 82 00 00 00             59 	int 0x0000 ;int15
      008048 82 00 00 00             60 	int 0x0000 ;int16
      00804C 82 00 00 00             61 	int 0x0000 ;int17
      008050 82 00 00 00             62 	int 0x0000 ;int18
      008054 82 00 00 00             63 	int 0x0000 ;int19
      008058 82 00 00 00             64 	int 0x0000 ;int20
      00805C 82 00 00 00             65 	int 0x0000 ;int21
      008060 82 00 00 00             66 	int 0x0000 ;int22
      008064 82 00 00 00             67 	int 0x0000 ;int23
      008068 82 00 00 00             68 	int 0x0000 ;int24
      00806C 82 00 00 00             69 	int 0x0000 ;int25
      008070 82 00 00 00             70 	int 0x0000 ;int26
      008074 82 00 00 00             71 	int 0x0000 ;int27
      008078 82 00 00 00             72 	int 0x0000 ;int28
      00807C 82 00 00 00             73 	int 0x0000 ;int29
                                     74 ;--------------------------------------------------------
                                     75 ; global & static initialisations
                                     76 ;--------------------------------------------------------
                                     77 	.area HOME
                                     78 	.area GSINIT
                                     79 	.area GSFINAL
                                     80 	.area GSINIT
      008083                         81 __sdcc_gs_init_startup:
      008083                         82 __sdcc_init_data:
                                     83 ; stm8_genXINIT() start
      008083 AE 00 00         [ 2]   84 	ldw x, #l_DATA
      008086 27 07            [ 1]   85 	jreq	00002$
      008088                         86 00001$:
      008088 72 4F 00 00      [ 1]   87 	clr (s_DATA - 1, x)
      00808C 5A               [ 2]   88 	decw x
      00808D 26 F9            [ 1]   89 	jrne	00001$
      00808F                         90 00002$:
      00808F AE 00 00         [ 2]   91 	ldw	x, #l_INITIALIZER
      008092 27 09            [ 1]   92 	jreq	00004$
      008094                         93 00003$:
      008094 D6 83 D8         [ 1]   94 	ld	a, (s_INITIALIZER - 1, x)
      008097 D7 00 00         [ 1]   95 	ld	(s_INITIALIZED - 1, x), a
      00809A 5A               [ 2]   96 	decw	x
      00809B 26 F7            [ 1]   97 	jrne	00003$
      00809D                         98 00004$:
                                     99 ; stm8_genXINIT() end
                                    100 	.area GSFINAL
      00809D CC 80 80         [ 2]  101 	jp	__sdcc_program_startup
                                    102 ;--------------------------------------------------------
                                    103 ; Home
                                    104 ;--------------------------------------------------------
                                    105 	.area HOME
                                    106 	.area HOME
      008080                        107 __sdcc_program_startup:
      008080 CC 83 86         [ 2]  108 	jp	_main
                                    109 ;	return from main will return to caller
                                    110 ;--------------------------------------------------------
                                    111 ; code
                                    112 ;--------------------------------------------------------
                                    113 	.area CODE
                                    114 ;	inc/clk_init.h: 7: void clk_init(void){    
                                    115 ;	-----------------------------------------
                                    116 ;	 function clk_init
                                    117 ;	-----------------------------------------
      0080A0                        118 _clk_init:
                                    119 ;	inc/clk_init.h: 8: CLK_ECKR|=CLK_ECKR_HSEEN;            
      0080A0 72 10 50 C1      [ 1]  120 	bset	0x50c1, #0
                                    121 ;	inc/clk_init.h: 9: CLK_SWCR|=CLK_SWCR_SWEN;               
      0080A4 AE 50 C5         [ 2]  122 	ldw	x, #0x50c5
      0080A7 F6               [ 1]  123 	ld	a, (x)
      0080A8 AA 02            [ 1]  124 	or	a, #0x02
      0080AA F7               [ 1]  125 	ld	(x), a
                                    126 ;	inc/clk_init.h: 10: while((CLK_ECKR & CLK_ECKR_HSERDY) == 0) {} 
      0080AB                        127 00101$:
      0080AB AE 50 C1         [ 2]  128 	ldw	x, #0x50c1
      0080AE F6               [ 1]  129 	ld	a, (x)
      0080AF A5 02            [ 1]  130 	bcp	a, #0x02
      0080B1 27 F8            [ 1]  131 	jreq	00101$
                                    132 ;	inc/clk_init.h: 11: CLK_CKDIVR = 0;                    
      0080B3 35 00 50 C6      [ 1]  133 	mov	0x50c6+0, #0x00
                                    134 ;	inc/clk_init.h: 12: CLK_SWR = 0xB4;                    
      0080B7 35 B4 50 C4      [ 1]  135 	mov	0x50c4+0, #0xb4
                                    136 ;	inc/clk_init.h: 13: while ((CLK_SWCR & CLK_SWCR_SWIF) == 0){}
      0080BB                        137 00104$:
      0080BB AE 50 C5         [ 2]  138 	ldw	x, #0x50c5
      0080BE F6               [ 1]  139 	ld	a, (x)
      0080BF A5 08            [ 1]  140 	bcp	a, #0x08
      0080C1 27 F8            [ 1]  141 	jreq	00104$
                                    142 ;	inc/clk_init.h: 14: CLK_CSSR|=CLK_CSSR_CSSEN;
      0080C3 72 10 50 C8      [ 1]  143 	bset	0x50c8, #0
      0080C7 81               [ 4]  144 	ret
                                    145 ;	inc/gpio_init.h: 2: void GPIO_init(void)
                                    146 ;	-----------------------------------------
                                    147 ;	 function GPIO_init
                                    148 ;	-----------------------------------------
      0080C8                        149 _GPIO_init:
                                    150 ;	inc/gpio_init.h: 5: PA_DDR = 0xFF;                                                        //_______PORT_IN
      0080C8 35 FF 50 02      [ 1]  151 	mov	0x5002+0, #0xff
                                    152 ;	inc/gpio_init.h: 6: PA_CR1 = 0xFF;                                                       //_______DDR________________CR1______________CR2___________FUNCTION  
      0080CC 35 FF 50 03      [ 1]  153 	mov	0x5003+0, #0xff
                                    154 ;	inc/gpio_init.h: 7: PA_CR2 = 0x00;                                                      //_______0__________________0________________0_____________bez podtiyzhki,bez prerbIvanii 
      0080D0 35 00 50 04      [ 1]  155 	mov	0x5004+0, #0x00
                                    156 ;	inc/gpio_init.h: 9: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
      0080D4 35 00 50 07      [ 1]  157 	mov	0x5007+0, #0x00
                                    158 ;	inc/gpio_init.h: 10: PB_CR1 = 0x00;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
      0080D8 35 00 50 08      [ 1]  159 	mov	0x5008+0, #0x00
                                    160 ;	inc/gpio_init.h: 11: PB_CR2 = 0x00;                                                      //_______PORT_OUT
      0080DC 35 00 50 09      [ 1]  161 	mov	0x5009+0, #0x00
                                    162 ;	inc/gpio_init.h: 13: PC_DDR = 0xFF;                                                        //_______1__________________0________________0_____________otkritiy stok
      0080E0 35 FF 50 0C      [ 1]  163 	mov	0x500c+0, #0xff
                                    164 ;	inc/gpio_init.h: 14: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
      0080E4 35 FF 50 0D      [ 1]  165 	mov	0x500d+0, #0xff
                                    166 ;	inc/gpio_init.h: 15: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
      0080E8 35 00 50 0E      [ 1]  167 	mov	0x500e+0, #0x00
                                    168 ;	inc/gpio_init.h: 17: PD_DDR = 0x3F;   
      0080EC 35 3F 50 11      [ 1]  169 	mov	0x5011+0, #0x3f
                                    170 ;	inc/gpio_init.h: 18: PD_CR1 = 0xFF;  
      0080F0 35 FF 50 12      [ 1]  171 	mov	0x5012+0, #0xff
                                    172 ;	inc/gpio_init.h: 19: PD_CR2 = 0x00; 
      0080F4 35 00 50 13      [ 1]  173 	mov	0x5013+0, #0x00
                                    174 ;	inc/gpio_init.h: 21: PE_DDR = 0xFF;   
      0080F8 35 FF 50 16      [ 1]  175 	mov	0x5016+0, #0xff
                                    176 ;	inc/gpio_init.h: 22: PE_CR1 = 0xFF;  
      0080FC 35 FF 50 17      [ 1]  177 	mov	0x5017+0, #0xff
                                    178 ;	inc/gpio_init.h: 23: PE_CR2 = 0x00; 
      008100 35 00 50 18      [ 1]  179 	mov	0x5018+0, #0x00
                                    180 ;	inc/gpio_init.h: 25: PF_DDR = 0xFF;   
      008104 35 FF 50 1B      [ 1]  181 	mov	0x501b+0, #0xff
                                    182 ;	inc/gpio_init.h: 26: PF_CR1 = 0xFF;  
      008108 35 FF 50 1C      [ 1]  183 	mov	0x501c+0, #0xff
                                    184 ;	inc/gpio_init.h: 27: PF_CR2 = 0x00; 
      00810C 35 00 50 1D      [ 1]  185 	mov	0x501d+0, #0x00
                                    186 ;	inc/gpio_init.h: 29: PG_DDR = 0xFF;   
      008110 35 FF 50 20      [ 1]  187 	mov	0x5020+0, #0xff
                                    188 ;	inc/gpio_init.h: 30: PG_CR1 = 0xFF;  
      008114 35 FF 50 21      [ 1]  189 	mov	0x5021+0, #0xff
                                    190 ;	inc/gpio_init.h: 31: PG_CR2 = 0x00; 
      008118 35 00 50 22      [ 1]  191 	mov	0x5022+0, #0x00
      00811C 81               [ 4]  192 	ret
                                    193 ;	inc/ADC.h: 51: void ADC_INIT(void){
                                    194 ;	-----------------------------------------
                                    195 ;	 function ADC_INIT
                                    196 ;	-----------------------------------------
      00811D                        197 _ADC_INIT:
                                    198 ;	inc/ADC.h: 52: ADC_CSR_CH0;           //Выбераем канал
      00811D AE 54 00         [ 2]  199 	ldw	x, #0x5400
      008120 F6               [ 1]  200 	ld	a, (x)
      008121 A4 F0            [ 1]  201 	and	a, #0xf0
      008123 F7               [ 1]  202 	ld	(x), a
                                    203 ;	inc/ADC.h: 53: ADC_CR1_SPSEL8;  //Делитель на 18            
      008124 AE 54 01         [ 2]  204 	ldw	x, #0x5401
      008127 F6               [ 1]  205 	ld	a, (x)
      008128 AA 40            [ 1]  206 	or	a, #0x40
      00812A F7               [ 1]  207 	ld	(x), a
                                    208 ;	inc/ADC.h: 54: ADC_TDRL_DIS(0);       //Отключаем тригер Шмидта
      00812B 72 10 54 07      [ 1]  209 	bset	0x5407, #0
                                    210 ;	inc/ADC.h: 55: ADC_CR2_ALIGN_LEFT;    //Выравнивание по левому краю
      00812F AE 54 02         [ 2]  211 	ldw	x, #0x5402
      008132 F6               [ 1]  212 	ld	a, (x)
      008133 A4 F7            [ 1]  213 	and	a, #0xf7
      008135 F7               [ 1]  214 	ld	(x), a
                                    215 ;	inc/ADC.h: 56: ADC_CR1_ADON_ON;       //Первый запуск ADC
      008136 72 10 54 01      [ 1]  216 	bset	0x5401, #0
      00813A 81               [ 4]  217 	ret
                                    218 ;	inc/ADC.h: 58: int ADC_read(void){
                                    219 ;	-----------------------------------------
                                    220 ;	 function ADC_read
                                    221 ;	-----------------------------------------
      00813B                        222 _ADC_read:
      00813B 52 04            [ 2]  223 	sub	sp, #4
                                    224 ;	inc/ADC.h: 60: ADC_CR1_ADON_ON;
      00813D AE 54 01         [ 2]  225 	ldw	x, #0x5401
      008140 F6               [ 1]  226 	ld	a, (x)
      008141 AA 01            [ 1]  227 	or	a, #0x01
      008143 F7               [ 1]  228 	ld	(x), a
                                    229 ;	inc/ADC.h: 61: for(t=0;t<64;t++){
      008144 AE 00 40         [ 2]  230 	ldw	x, #0x0040
      008147                        231 00104$:
                                    232 ;	inc/ADC.h: 62: __asm__("nop\n");
      008147 9D               [ 1]  233 	nop
      008148 5A               [ 2]  234 	decw	x
                                    235 ;	inc/ADC.h: 61: for(t=0;t<64;t++){
      008149 1F 03            [ 2]  236 	ldw	(0x03, sp), x
      00814B 90 93            [ 1]  237 	ldw	y, x
      00814D 26 F8            [ 1]  238 	jrne	00104$
                                    239 ;	inc/ADC.h: 64: data=ADC_DRH<<2;
      00814F AE 54 04         [ 2]  240 	ldw	x, #0x5404
      008152 F6               [ 1]  241 	ld	a, (x)
      008153 5F               [ 1]  242 	clrw	x
      008154 97               [ 1]  243 	ld	xl, a
      008155 58               [ 2]  244 	sllw	x
      008156 58               [ 2]  245 	sllw	x
      008157 1F 01            [ 2]  246 	ldw	(0x01, sp), x
                                    247 ;	inc/ADC.h: 65: data=data+ADC_DRL;
      008159 AE 54 05         [ 2]  248 	ldw	x, #0x5405
      00815C F6               [ 1]  249 	ld	a, (x)
      00815D 5F               [ 1]  250 	clrw	x
      00815E 97               [ 1]  251 	ld	xl, a
      00815F 72 FB 01         [ 2]  252 	addw	x, (0x01, sp)
                                    253 ;	inc/ADC.h: 67: return data;
      008162 5B 04            [ 2]  254 	addw	sp, #4
      008164 81               [ 4]  255 	ret
                                    256 ;	inc/7sig.h: 11: void out7seg(volatile int t,volatile int q)
                                    257 ;	-----------------------------------------
                                    258 ;	 function out7seg
                                    259 ;	-----------------------------------------
      008165                        260 _out7seg:
      008165 52 02            [ 2]  261 	sub	sp, #2
                                    262 ;	inc/7sig.h: 13: int num=0;
      008167 5F               [ 1]  263 	clrw	x
      008168 1F 01            [ 2]  264 	ldw	(0x01, sp), x
                                    265 ;	inc/7sig.h: 14: PC_ODR=0xff;
      00816A 35 FF 50 0A      [ 1]  266 	mov	0x500a+0, #0xff
                                    267 ;	inc/7sig.h: 15: PE_ODR|=(1<<0)|(1<<1)|(1<<2);
      00816E AE 50 14         [ 2]  268 	ldw	x, #0x5014
      008171 F6               [ 1]  269 	ld	a, (x)
      008172 AA 07            [ 1]  270 	or	a, #0x07
      008174 F7               [ 1]  271 	ld	(x), a
                                    272 ;	inc/7sig.h: 17: if(q==0) num=(t%1000/100),PD_ODR&=~(1<<1);
      008175 1E 07            [ 2]  273 	ldw	x, (0x07, sp)
      008177 26 1F            [ 1]  274 	jrne	00102$
      008179 4B E8            [ 1]  275 	push	#0xe8
      00817B 4B 03            [ 1]  276 	push	#0x03
      00817D 1E 07            [ 2]  277 	ldw	x, (0x07, sp)
      00817F 89               [ 2]  278 	pushw	x
      008180 CD 83 AF         [ 4]  279 	call	__modsint
      008183 5B 04            [ 2]  280 	addw	sp, #4
      008185 4B 64            [ 1]  281 	push	#0x64
      008187 4B 00            [ 1]  282 	push	#0x00
      008189 89               [ 2]  283 	pushw	x
      00818A CD 83 C5         [ 4]  284 	call	__divsint
      00818D 5B 04            [ 2]  285 	addw	sp, #4
      00818F 1F 01            [ 2]  286 	ldw	(0x01, sp), x
      008191 AE 50 0F         [ 2]  287 	ldw	x, #0x500f
      008194 F6               [ 1]  288 	ld	a, (x)
      008195 A4 FD            [ 1]  289 	and	a, #0xfd
      008197 F7               [ 1]  290 	ld	(x), a
      008198                        291 00102$:
                                    292 ;	inc/7sig.h: 18: if(q==1) num=(t%100/10),PD_ODR&=~(1<<2);
      008198 1E 07            [ 2]  293 	ldw	x, (0x07, sp)
      00819A A3 00 01         [ 2]  294 	cpw	x, #0x0001
      00819D 26 1F            [ 1]  295 	jrne	00104$
      00819F 4B 64            [ 1]  296 	push	#0x64
      0081A1 4B 00            [ 1]  297 	push	#0x00
      0081A3 1E 07            [ 2]  298 	ldw	x, (0x07, sp)
      0081A5 89               [ 2]  299 	pushw	x
      0081A6 CD 83 AF         [ 4]  300 	call	__modsint
      0081A9 5B 04            [ 2]  301 	addw	sp, #4
      0081AB 4B 0A            [ 1]  302 	push	#0x0a
      0081AD 4B 00            [ 1]  303 	push	#0x00
      0081AF 89               [ 2]  304 	pushw	x
      0081B0 CD 83 C5         [ 4]  305 	call	__divsint
      0081B3 5B 04            [ 2]  306 	addw	sp, #4
      0081B5 1F 01            [ 2]  307 	ldw	(0x01, sp), x
      0081B7 AE 50 0F         [ 2]  308 	ldw	x, #0x500f
      0081BA F6               [ 1]  309 	ld	a, (x)
      0081BB A4 FB            [ 1]  310 	and	a, #0xfb
      0081BD F7               [ 1]  311 	ld	(x), a
      0081BE                        312 00104$:
                                    313 ;	inc/7sig.h: 19: if(q==2) num=(t%10),PD_ODR&=~(1<<0);
      0081BE 1E 07            [ 2]  314 	ldw	x, (0x07, sp)
      0081C0 A3 00 02         [ 2]  315 	cpw	x, #0x0002
      0081C3 26 15            [ 1]  316 	jrne	00106$
      0081C5 4B 0A            [ 1]  317 	push	#0x0a
      0081C7 4B 00            [ 1]  318 	push	#0x00
      0081C9 1E 07            [ 2]  319 	ldw	x, (0x07, sp)
      0081CB 89               [ 2]  320 	pushw	x
      0081CC CD 83 AF         [ 4]  321 	call	__modsint
      0081CF 5B 04            [ 2]  322 	addw	sp, #4
      0081D1 1F 01            [ 2]  323 	ldw	(0x01, sp), x
      0081D3 AE 50 0F         [ 2]  324 	ldw	x, #0x500f
      0081D6 F6               [ 1]  325 	ld	a, (x)
      0081D7 A4 FE            [ 1]  326 	and	a, #0xfe
      0081D9 F7               [ 1]  327 	ld	(x), a
      0081DA                        328 00106$:
                                    329 ;	inc/7sig.h: 20: switch (num)
      0081DA 0D 01            [ 1]  330 	tnz	(0x01, sp)
      0081DC 2A 03            [ 1]  331 	jrpl	00148$
      0081DE CC 83 66         [ 2]  332 	jp	00119$
      0081E1                        333 00148$:
      0081E1 1E 01            [ 2]  334 	ldw	x, (0x01, sp)
      0081E3 A3 00 09         [ 2]  335 	cpw	x, #0x0009
      0081E6 2D 03            [ 1]  336 	jrsle	00149$
      0081E8 CC 83 66         [ 2]  337 	jp	00119$
      0081EB                        338 00149$:
      0081EB 1E 01            [ 2]  339 	ldw	x, (0x01, sp)
      0081ED 58               [ 2]  340 	sllw	x
      0081EE DE 81 F2         [ 2]  341 	ldw	x, (#00150$, x)
      0081F1 FC               [ 2]  342 	jp	(x)
      0081F2                        343 00150$:
      0081F2 82 06                  344 	.dw	#00107$
      0081F4 82 33                  345 	.dw	#00108$
      0081F6 82 44                  346 	.dw	#00109$
      0081F8 82 6A                  347 	.dw	#00110$
      0081FA 82 90                  348 	.dw	#00111$
      0081FC 82 AC                  349 	.dw	#00112$
      0081FE 82 CF                  350 	.dw	#00113$
      008200 82 F8                  351 	.dw	#00114$
      008202 83 0F                  352 	.dw	#00115$
      008204 83 3F                  353 	.dw	#00116$
                                    354 ;	inc/7sig.h: 22: case 0:   
      008206                        355 00107$:
                                    356 ;	inc/7sig.h: 23: segA,segB,segC,segD,segE,segF;
      008206 AE 50 0A         [ 2]  357 	ldw	x, #0x500a
      008209 F6               [ 1]  358 	ld	a, (x)
      00820A A4 FD            [ 1]  359 	and	a, #0xfd
      00820C F7               [ 1]  360 	ld	(x), a
      00820D AE 50 0A         [ 2]  361 	ldw	x, #0x500a
      008210 F6               [ 1]  362 	ld	a, (x)
      008211 A4 FB            [ 1]  363 	and	a, #0xfb
      008213 F7               [ 1]  364 	ld	(x), a
      008214 AE 50 0A         [ 2]  365 	ldw	x, #0x500a
      008217 F6               [ 1]  366 	ld	a, (x)
      008218 A4 F7            [ 1]  367 	and	a, #0xf7
      00821A F7               [ 1]  368 	ld	(x), a
      00821B AE 50 0A         [ 2]  369 	ldw	x, #0x500a
      00821E F6               [ 1]  370 	ld	a, (x)
      00821F A4 DF            [ 1]  371 	and	a, #0xdf
      008221 F7               [ 1]  372 	ld	(x), a
      008222 AE 50 1E         [ 2]  373 	ldw	x, #0x501e
      008225 F6               [ 1]  374 	ld	a, (x)
      008226 A4 EF            [ 1]  375 	and	a, #0xef
      008228 F7               [ 1]  376 	ld	(x), a
      008229 AE 50 0A         [ 2]  377 	ldw	x, #0x500a
      00822C F6               [ 1]  378 	ld	a, (x)
      00822D A4 7F            [ 1]  379 	and	a, #0x7f
      00822F F7               [ 1]  380 	ld	(x), a
                                    381 ;	inc/7sig.h: 24: break;
      008230 CC 83 66         [ 2]  382 	jp	00119$
                                    383 ;	inc/7sig.h: 25: case 1:   
      008233                        384 00108$:
                                    385 ;	inc/7sig.h: 26: segB,segC;
      008233 AE 50 0A         [ 2]  386 	ldw	x, #0x500a
      008236 F6               [ 1]  387 	ld	a, (x)
      008237 A4 FB            [ 1]  388 	and	a, #0xfb
      008239 F7               [ 1]  389 	ld	(x), a
      00823A AE 50 0A         [ 2]  390 	ldw	x, #0x500a
      00823D F6               [ 1]  391 	ld	a, (x)
      00823E A4 F7            [ 1]  392 	and	a, #0xf7
      008240 F7               [ 1]  393 	ld	(x), a
                                    394 ;	inc/7sig.h: 27: break;
      008241 CC 83 66         [ 2]  395 	jp	00119$
                                    396 ;	inc/7sig.h: 28: case 2:   
      008244                        397 00109$:
                                    398 ;	inc/7sig.h: 29: segA,segB,segG,segD,segE;
      008244 AE 50 0A         [ 2]  399 	ldw	x, #0x500a
      008247 F6               [ 1]  400 	ld	a, (x)
      008248 A4 FD            [ 1]  401 	and	a, #0xfd
      00824A F7               [ 1]  402 	ld	(x), a
      00824B AE 50 0A         [ 2]  403 	ldw	x, #0x500a
      00824E F6               [ 1]  404 	ld	a, (x)
      00824F A4 FB            [ 1]  405 	and	a, #0xfb
      008251 F7               [ 1]  406 	ld	(x), a
      008252 AE 50 0A         [ 2]  407 	ldw	x, #0x500a
      008255 F6               [ 1]  408 	ld	a, (x)
      008256 A4 BF            [ 1]  409 	and	a, #0xbf
      008258 F7               [ 1]  410 	ld	(x), a
      008259 AE 50 0A         [ 2]  411 	ldw	x, #0x500a
      00825C F6               [ 1]  412 	ld	a, (x)
      00825D A4 DF            [ 1]  413 	and	a, #0xdf
      00825F F7               [ 1]  414 	ld	(x), a
      008260 AE 50 1E         [ 2]  415 	ldw	x, #0x501e
      008263 F6               [ 1]  416 	ld	a, (x)
      008264 A4 EF            [ 1]  417 	and	a, #0xef
      008266 F7               [ 1]  418 	ld	(x), a
                                    419 ;	inc/7sig.h: 30: break;
      008267 CC 83 66         [ 2]  420 	jp	00119$
                                    421 ;	inc/7sig.h: 31: case 3:   
      00826A                        422 00110$:
                                    423 ;	inc/7sig.h: 32: segA,segB,segC,segD,segG;
      00826A AE 50 0A         [ 2]  424 	ldw	x, #0x500a
      00826D F6               [ 1]  425 	ld	a, (x)
      00826E A4 FD            [ 1]  426 	and	a, #0xfd
      008270 F7               [ 1]  427 	ld	(x), a
      008271 AE 50 0A         [ 2]  428 	ldw	x, #0x500a
      008274 F6               [ 1]  429 	ld	a, (x)
      008275 A4 FB            [ 1]  430 	and	a, #0xfb
      008277 F7               [ 1]  431 	ld	(x), a
      008278 AE 50 0A         [ 2]  432 	ldw	x, #0x500a
      00827B F6               [ 1]  433 	ld	a, (x)
      00827C A4 F7            [ 1]  434 	and	a, #0xf7
      00827E F7               [ 1]  435 	ld	(x), a
      00827F AE 50 0A         [ 2]  436 	ldw	x, #0x500a
      008282 F6               [ 1]  437 	ld	a, (x)
      008283 A4 DF            [ 1]  438 	and	a, #0xdf
      008285 F7               [ 1]  439 	ld	(x), a
      008286 AE 50 0A         [ 2]  440 	ldw	x, #0x500a
      008289 F6               [ 1]  441 	ld	a, (x)
      00828A A4 BF            [ 1]  442 	and	a, #0xbf
      00828C F7               [ 1]  443 	ld	(x), a
                                    444 ;	inc/7sig.h: 33: break;
      00828D CC 83 66         [ 2]  445 	jp	00119$
                                    446 ;	inc/7sig.h: 34: case 4:   
      008290                        447 00111$:
                                    448 ;	inc/7sig.h: 35: segF,segB,segG,segC;
      008290 72 1F 50 0A      [ 1]  449 	bres	0x500a, #7
      008294 AE 50 0A         [ 2]  450 	ldw	x, #0x500a
      008297 F6               [ 1]  451 	ld	a, (x)
      008298 A4 FB            [ 1]  452 	and	a, #0xfb
      00829A F7               [ 1]  453 	ld	(x), a
      00829B AE 50 0A         [ 2]  454 	ldw	x, #0x500a
      00829E F6               [ 1]  455 	ld	a, (x)
      00829F A4 BF            [ 1]  456 	and	a, #0xbf
      0082A1 F7               [ 1]  457 	ld	(x), a
      0082A2 AE 50 0A         [ 2]  458 	ldw	x, #0x500a
      0082A5 F6               [ 1]  459 	ld	a, (x)
      0082A6 A4 F7            [ 1]  460 	and	a, #0xf7
      0082A8 F7               [ 1]  461 	ld	(x), a
                                    462 ;	inc/7sig.h: 36: break;
      0082A9 CC 83 66         [ 2]  463 	jp	00119$
                                    464 ;	inc/7sig.h: 37: case 5:   
      0082AC                        465 00112$:
                                    466 ;	inc/7sig.h: 38: segA,segC,segD,segF,segG;
      0082AC AE 50 0A         [ 2]  467 	ldw	x, #0x500a
      0082AF F6               [ 1]  468 	ld	a, (x)
      0082B0 A4 FD            [ 1]  469 	and	a, #0xfd
      0082B2 F7               [ 1]  470 	ld	(x), a
      0082B3 AE 50 0A         [ 2]  471 	ldw	x, #0x500a
      0082B6 F6               [ 1]  472 	ld	a, (x)
      0082B7 A4 F7            [ 1]  473 	and	a, #0xf7
      0082B9 F7               [ 1]  474 	ld	(x), a
      0082BA AE 50 0A         [ 2]  475 	ldw	x, #0x500a
      0082BD F6               [ 1]  476 	ld	a, (x)
      0082BE A4 DF            [ 1]  477 	and	a, #0xdf
      0082C0 F7               [ 1]  478 	ld	(x), a
      0082C1 72 1F 50 0A      [ 1]  479 	bres	0x500a, #7
      0082C5 AE 50 0A         [ 2]  480 	ldw	x, #0x500a
      0082C8 F6               [ 1]  481 	ld	a, (x)
      0082C9 A4 BF            [ 1]  482 	and	a, #0xbf
      0082CB F7               [ 1]  483 	ld	(x), a
                                    484 ;	inc/7sig.h: 39: break;
      0082CC CC 83 66         [ 2]  485 	jp	00119$
                                    486 ;	inc/7sig.h: 40: case 6:   
      0082CF                        487 00113$:
                                    488 ;	inc/7sig.h: 41: segA,segC,segD,segE,segF,segG;
      0082CF AE 50 0A         [ 2]  489 	ldw	x, #0x500a
      0082D2 F6               [ 1]  490 	ld	a, (x)
      0082D3 A4 FD            [ 1]  491 	and	a, #0xfd
      0082D5 F7               [ 1]  492 	ld	(x), a
      0082D6 AE 50 0A         [ 2]  493 	ldw	x, #0x500a
      0082D9 F6               [ 1]  494 	ld	a, (x)
      0082DA A4 F7            [ 1]  495 	and	a, #0xf7
      0082DC F7               [ 1]  496 	ld	(x), a
      0082DD AE 50 0A         [ 2]  497 	ldw	x, #0x500a
      0082E0 F6               [ 1]  498 	ld	a, (x)
      0082E1 A4 DF            [ 1]  499 	and	a, #0xdf
      0082E3 F7               [ 1]  500 	ld	(x), a
      0082E4 AE 50 1E         [ 2]  501 	ldw	x, #0x501e
      0082E7 F6               [ 1]  502 	ld	a, (x)
      0082E8 A4 EF            [ 1]  503 	and	a, #0xef
      0082EA F7               [ 1]  504 	ld	(x), a
      0082EB 72 1F 50 0A      [ 1]  505 	bres	0x500a, #7
      0082EF AE 50 0A         [ 2]  506 	ldw	x, #0x500a
      0082F2 F6               [ 1]  507 	ld	a, (x)
      0082F3 A4 BF            [ 1]  508 	and	a, #0xbf
      0082F5 F7               [ 1]  509 	ld	(x), a
                                    510 ;	inc/7sig.h: 42: break;
      0082F6 20 6E            [ 2]  511 	jra	00119$
                                    512 ;	inc/7sig.h: 43: case 7:   
      0082F8                        513 00114$:
                                    514 ;	inc/7sig.h: 44: segA,segB,segC;
      0082F8 AE 50 0A         [ 2]  515 	ldw	x, #0x500a
      0082FB F6               [ 1]  516 	ld	a, (x)
      0082FC A4 FD            [ 1]  517 	and	a, #0xfd
      0082FE F7               [ 1]  518 	ld	(x), a
      0082FF AE 50 0A         [ 2]  519 	ldw	x, #0x500a
      008302 F6               [ 1]  520 	ld	a, (x)
      008303 A4 FB            [ 1]  521 	and	a, #0xfb
      008305 F7               [ 1]  522 	ld	(x), a
      008306 AE 50 0A         [ 2]  523 	ldw	x, #0x500a
      008309 F6               [ 1]  524 	ld	a, (x)
      00830A A4 F7            [ 1]  525 	and	a, #0xf7
      00830C F7               [ 1]  526 	ld	(x), a
                                    527 ;	inc/7sig.h: 45: break;
      00830D 20 57            [ 2]  528 	jra	00119$
                                    529 ;	inc/7sig.h: 46: case 8:   
      00830F                        530 00115$:
                                    531 ;	inc/7sig.h: 47: segA,segB,segC,segD,segE,segF,segG;
      00830F AE 50 0A         [ 2]  532 	ldw	x, #0x500a
      008312 F6               [ 1]  533 	ld	a, (x)
      008313 A4 FD            [ 1]  534 	and	a, #0xfd
      008315 F7               [ 1]  535 	ld	(x), a
      008316 AE 50 0A         [ 2]  536 	ldw	x, #0x500a
      008319 F6               [ 1]  537 	ld	a, (x)
      00831A A4 FB            [ 1]  538 	and	a, #0xfb
      00831C F7               [ 1]  539 	ld	(x), a
      00831D AE 50 0A         [ 2]  540 	ldw	x, #0x500a
      008320 F6               [ 1]  541 	ld	a, (x)
      008321 A4 F7            [ 1]  542 	and	a, #0xf7
      008323 F7               [ 1]  543 	ld	(x), a
      008324 AE 50 0A         [ 2]  544 	ldw	x, #0x500a
      008327 F6               [ 1]  545 	ld	a, (x)
      008328 A4 DF            [ 1]  546 	and	a, #0xdf
      00832A F7               [ 1]  547 	ld	(x), a
      00832B AE 50 1E         [ 2]  548 	ldw	x, #0x501e
      00832E F6               [ 1]  549 	ld	a, (x)
      00832F A4 EF            [ 1]  550 	and	a, #0xef
      008331 F7               [ 1]  551 	ld	(x), a
      008332 72 1F 50 0A      [ 1]  552 	bres	0x500a, #7
      008336 AE 50 0A         [ 2]  553 	ldw	x, #0x500a
      008339 F6               [ 1]  554 	ld	a, (x)
      00833A A4 BF            [ 1]  555 	and	a, #0xbf
      00833C F7               [ 1]  556 	ld	(x), a
                                    557 ;	inc/7sig.h: 48: break;
      00833D 20 27            [ 2]  558 	jra	00119$
                                    559 ;	inc/7sig.h: 49: case 9:   
      00833F                        560 00116$:
                                    561 ;	inc/7sig.h: 50: segA,segB,segC,segD,segF,segG;
      00833F AE 50 0A         [ 2]  562 	ldw	x, #0x500a
      008342 F6               [ 1]  563 	ld	a, (x)
      008343 A4 FD            [ 1]  564 	and	a, #0xfd
      008345 F7               [ 1]  565 	ld	(x), a
      008346 AE 50 0A         [ 2]  566 	ldw	x, #0x500a
      008349 F6               [ 1]  567 	ld	a, (x)
      00834A A4 FB            [ 1]  568 	and	a, #0xfb
      00834C F7               [ 1]  569 	ld	(x), a
      00834D AE 50 0A         [ 2]  570 	ldw	x, #0x500a
      008350 F6               [ 1]  571 	ld	a, (x)
      008351 A4 F7            [ 1]  572 	and	a, #0xf7
      008353 F7               [ 1]  573 	ld	(x), a
      008354 AE 50 0A         [ 2]  574 	ldw	x, #0x500a
      008357 F6               [ 1]  575 	ld	a, (x)
      008358 A4 DF            [ 1]  576 	and	a, #0xdf
      00835A F7               [ 1]  577 	ld	(x), a
      00835B 72 1F 50 0A      [ 1]  578 	bres	0x500a, #7
      00835F AE 50 0A         [ 2]  579 	ldw	x, #0x500a
      008362 F6               [ 1]  580 	ld	a, (x)
      008363 A4 BF            [ 1]  581 	and	a, #0xbf
      008365 F7               [ 1]  582 	ld	(x), a
                                    583 ;	inc/7sig.h: 54: }
      008366                        584 00119$:
      008366 5B 02            [ 2]  585 	addw	sp, #2
      008368 81               [ 4]  586 	ret
                                    587 ;	main.c: 8: void delay(int t)
                                    588 ;	-----------------------------------------
                                    589 ;	 function delay
                                    590 ;	-----------------------------------------
      008369                        591 _delay:
      008369 52 02            [ 2]  592 	sub	sp, #2
                                    593 ;	main.c: 11: for(i=0;i<t;i++)
      00836B 5F               [ 1]  594 	clrw	x
      00836C                        595 00107$:
      00836C 13 05            [ 2]  596 	cpw	x, (0x05, sp)
      00836E 2E 13            [ 1]  597 	jrsge	00109$
                                    598 ;	main.c: 13: for(s=0;s<1512;s++)
      008370 90 AE 05 E8      [ 2]  599 	ldw	y, #0x05e8
      008374 17 01            [ 2]  600 	ldw	(0x01, sp), y
      008376                        601 00105$:
      008376 16 01            [ 2]  602 	ldw	y, (0x01, sp)
      008378 90 5A            [ 2]  603 	decw	y
      00837A 17 01            [ 2]  604 	ldw	(0x01, sp), y
      00837C 90 5D            [ 2]  605 	tnzw	y
      00837E 26 F6            [ 1]  606 	jrne	00105$
                                    607 ;	main.c: 11: for(i=0;i<t;i++)
      008380 5C               [ 1]  608 	incw	x
      008381 20 E9            [ 2]  609 	jra	00107$
      008383                        610 00109$:
      008383 5B 02            [ 2]  611 	addw	sp, #2
      008385 81               [ 4]  612 	ret
                                    613 ;	main.c: 20: void main(void)
                                    614 ;	-----------------------------------------
                                    615 ;	 function main
                                    616 ;	-----------------------------------------
      008386                        617 _main:
                                    618 ;	main.c: 24: clk_init();
      008386 CD 80 A0         [ 4]  619 	call	_clk_init
                                    620 ;	main.c: 25: GPIO_init();
      008389 CD 80 C8         [ 4]  621 	call	_GPIO_init
                                    622 ;	main.c: 28: while(1)
      00838C                        623 00102$:
                                    624 ;	main.c: 30: bit1(PD_ODR,2);
      00838C AE 50 0F         [ 2]  625 	ldw	x, #0x500f
      00838F F6               [ 1]  626 	ld	a, (x)
      008390 AA 04            [ 1]  627 	or	a, #0x04
      008392 F7               [ 1]  628 	ld	(x), a
                                    629 ;	main.c: 31: delay(100);
      008393 4B 64            [ 1]  630 	push	#0x64
      008395 4B 00            [ 1]  631 	push	#0x00
      008397 CD 83 69         [ 4]  632 	call	_delay
      00839A 5B 02            [ 2]  633 	addw	sp, #2
                                    634 ;	main.c: 32: bit0(PD_ODR,2);
      00839C AE 50 0F         [ 2]  635 	ldw	x, #0x500f
      00839F F6               [ 1]  636 	ld	a, (x)
      0083A0 A4 FB            [ 1]  637 	and	a, #0xfb
      0083A2 F7               [ 1]  638 	ld	(x), a
                                    639 ;	main.c: 33: delay(100);
      0083A3 4B 64            [ 1]  640 	push	#0x64
      0083A5 4B 00            [ 1]  641 	push	#0x00
      0083A7 CD 83 69         [ 4]  642 	call	_delay
      0083AA 5B 02            [ 2]  643 	addw	sp, #2
      0083AC 20 DE            [ 2]  644 	jra	00102$
      0083AE 81               [ 4]  645 	ret
                                    646 	.area CODE
                                    647 	.area INITIALIZER
                                    648 	.area CABS (ABS)
