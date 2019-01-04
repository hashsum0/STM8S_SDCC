                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 3.6.0 #9615 (Linux)
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
                                     17 	.globl _Init_HSI
                                     18 	.globl _Init_HSE
                                     19 	.globl _q
                                     20 ;--------------------------------------------------------
                                     21 ; ram data
                                     22 ;--------------------------------------------------------
                                     23 	.area DATA
                                     24 ;--------------------------------------------------------
                                     25 ; ram data
                                     26 ;--------------------------------------------------------
                                     27 	.area INITIALIZED
      000001                         28 _q::
      000001                         29 	.ds 2
                                     30 ;--------------------------------------------------------
                                     31 ; Stack segment in internal ram 
                                     32 ;--------------------------------------------------------
                                     33 	.area	SSEG
      000003                         34 __start__stack:
      000003                         35 	.ds	1
                                     36 
                                     37 ;--------------------------------------------------------
                                     38 ; absolute external ram data
                                     39 ;--------------------------------------------------------
                                     40 	.area DABS (ABS)
                                     41 ;--------------------------------------------------------
                                     42 ; interrupt vector 
                                     43 ;--------------------------------------------------------
                                     44 	.area HOME
      008000                         45 __interrupt_vect:
      008000 82 00 80 83             46 	int s_GSINIT ;reset
      008004 82 00 00 00             47 	int 0x0000 ;trap
      008008 82 00 00 00             48 	int 0x0000 ;int0
      00800C 82 00 00 00             49 	int 0x0000 ;int1
      008010 82 00 00 00             50 	int 0x0000 ;int2
      008014 82 00 00 00             51 	int 0x0000 ;int3
      008018 82 00 00 00             52 	int 0x0000 ;int4
      00801C 82 00 00 00             53 	int 0x0000 ;int5
      008020 82 00 00 00             54 	int 0x0000 ;int6
      008024 82 00 00 00             55 	int 0x0000 ;int7
      008028 82 00 00 00             56 	int 0x0000 ;int8
      00802C 82 00 00 00             57 	int 0x0000 ;int9
      008030 82 00 00 00             58 	int 0x0000 ;int10
      008034 82 00 00 00             59 	int 0x0000 ;int11
      008038 82 00 00 00             60 	int 0x0000 ;int12
      00803C 82 00 00 00             61 	int 0x0000 ;int13
      008040 82 00 00 00             62 	int 0x0000 ;int14
      008044 82 00 00 00             63 	int 0x0000 ;int15
      008048 82 00 00 00             64 	int 0x0000 ;int16
      00804C 82 00 00 00             65 	int 0x0000 ;int17
      008050 82 00 00 00             66 	int 0x0000 ;int18
      008054 82 00 00 00             67 	int 0x0000 ;int19
      008058 82 00 00 00             68 	int 0x0000 ;int20
      00805C 82 00 00 00             69 	int 0x0000 ;int21
      008060 82 00 00 00             70 	int 0x0000 ;int22
      008064 82 00 00 00             71 	int 0x0000 ;int23
      008068 82 00 00 00             72 	int 0x0000 ;int24
      00806C 82 00 00 00             73 	int 0x0000 ;int25
      008070 82 00 00 00             74 	int 0x0000 ;int26
      008074 82 00 00 00             75 	int 0x0000 ;int27
      008078 82 00 00 00             76 	int 0x0000 ;int28
      00807C 82 00 00 00             77 	int 0x0000 ;int29
                                     78 ;--------------------------------------------------------
                                     79 ; global & static initialisations
                                     80 ;--------------------------------------------------------
                                     81 	.area HOME
                                     82 	.area GSINIT
                                     83 	.area GSFINAL
                                     84 	.area GSINIT
      008083                         85 __sdcc_gs_init_startup:
      008083                         86 __sdcc_init_data:
                                     87 ; stm8_genXINIT() start
      008083 AE 00 00         [ 2]   88 	ldw x, #l_DATA
      008086 27 07            [ 1]   89 	jreq	00002$
      008088                         90 00001$:
      008088 72 4F 00 00      [ 1]   91 	clr (s_DATA - 1, x)
      00808C 5A               [ 2]   92 	decw x
      00808D 26 F9            [ 1]   93 	jrne	00001$
      00808F                         94 00002$:
      00808F AE 00 02         [ 2]   95 	ldw	x, #l_INITIALIZER
      008092 27 09            [ 1]   96 	jreq	00004$
      008094                         97 00003$:
      008094 D6 8F 29         [ 1]   98 	ld	a, (s_INITIALIZER - 1, x)
      008097 D7 00 00         [ 1]   99 	ld	(s_INITIALIZED - 1, x), a
      00809A 5A               [ 2]  100 	decw	x
      00809B 26 F7            [ 1]  101 	jrne	00003$
      00809D                        102 00004$:
                                    103 ; stm8_genXINIT() end
                                    104 	.area GSFINAL
      00809D CC 80 80         [ 2]  105 	jp	__sdcc_program_startup
                                    106 ;--------------------------------------------------------
                                    107 ; Home
                                    108 ;--------------------------------------------------------
                                    109 	.area HOME
                                    110 	.area HOME
      008080                        111 __sdcc_program_startup:
      008080 CC 83 C4         [ 2]  112 	jp	_main
                                    113 ;	return from main will return to caller
                                    114 ;--------------------------------------------------------
                                    115 ; code
                                    116 ;--------------------------------------------------------
                                    117 	.area CODE
                                    118 ;	inc/clk_init.h: 7: void Init_HSE(){    
                                    119 ;	-----------------------------------------
                                    120 ;	 function Init_HSE
                                    121 ;	-----------------------------------------
      0080A0                        122 _Init_HSE:
                                    123 ;	inc/clk_init.h: 8: CLK_ECKR|=CLK_ECKR_HSEEN;            
      0080A0 72 10 50 C1      [ 1]  124 	bset	0x50c1, #0
                                    125 ;	inc/clk_init.h: 9: CLK_SWCR|=CLK_SWCR_SWEN;               
      0080A4 AE 50 C5         [ 2]  126 	ldw	x, #0x50c5
      0080A7 F6               [ 1]  127 	ld	a, (x)
      0080A8 AA 02            [ 1]  128 	or	a, #0x02
      0080AA F7               [ 1]  129 	ld	(x), a
                                    130 ;	inc/clk_init.h: 10: while((CLK_ECKR & CLK_ECKR_HSERDY) == 0) {} 
      0080AB                        131 00101$:
      0080AB AE 50 C1         [ 2]  132 	ldw	x, #0x50c1
      0080AE F6               [ 1]  133 	ld	a, (x)
      0080AF A5 02            [ 1]  134 	bcp	a, #0x02
      0080B1 27 F8            [ 1]  135 	jreq	00101$
                                    136 ;	inc/clk_init.h: 11: CLK_CKDIVR = 0;                    
      0080B3 35 00 50 C6      [ 1]  137 	mov	0x50c6+0, #0x00
                                    138 ;	inc/clk_init.h: 12: CLK_SWR = 0xB4;                    
      0080B7 35 B4 50 C4      [ 1]  139 	mov	0x50c4+0, #0xb4
                                    140 ;	inc/clk_init.h: 13: while ((CLK_SWCR & CLK_SWCR_SWIF) == 0){}
      0080BB                        141 00104$:
      0080BB AE 50 C5         [ 2]  142 	ldw	x, #0x50c5
      0080BE F6               [ 1]  143 	ld	a, (x)
      0080BF A5 08            [ 1]  144 	bcp	a, #0x08
      0080C1 27 F8            [ 1]  145 	jreq	00104$
                                    146 ;	inc/clk_init.h: 14: CLK_CSSR|=CLK_CSSR_CSSEN;
      0080C3 72 10 50 C8      [ 1]  147 	bset	0x50c8, #0
                                    148 ;	inc/clk_init.h: 15: CLK_CCOR=0; // CLK_CCOR|=(1<<2)|(1<<0);
      0080C7 35 00 50 C9      [ 1]  149 	mov	0x50c9+0, #0x00
      0080CB 81               [ 4]  150 	ret
                                    151 ;	inc/clk_init.h: 18: void Init_HSI()
                                    152 ;	-----------------------------------------
                                    153 ;	 function Init_HSI
                                    154 ;	-----------------------------------------
      0080CC                        155 _Init_HSI:
                                    156 ;	inc/clk_init.h: 20: CLK_ICKR = 0; // Сбрасываем регистр внутреннего тактирования
      0080CC 35 00 50 C0      [ 1]  157 	mov	0x50c0+0, #0x00
                                    158 ;	inc/clk_init.h: 21: CLK_ICKR|=(1<<0); // Включаем внутренний генератор HSI
      0080D0 72 10 50 C0      [ 1]  159 	bset	0x50c0, #0
                                    160 ;	inc/clk_init.h: 22: CLK_ECKR = 0; // Отключаем внешний генератор
      0080D4 35 00 50 C1      [ 1]  161 	mov	0x50c1+0, #0x00
                                    162 ;	inc/clk_init.h: 23: while ((CLK_ICKR&(1<<1))== 0); // Ждём стабилизации внутреннего генератора
      0080D8                        163 00101$:
      0080D8 AE 50 C0         [ 2]  164 	ldw	x, #0x50c0
      0080DB F6               [ 1]  165 	ld	a, (x)
      0080DC A5 02            [ 1]  166 	bcp	a, #0x02
      0080DE 27 F8            [ 1]  167 	jreq	00101$
                                    168 ;	inc/clk_init.h: 24: CLK_CKDIVR = 0; // Устанавливаем максимальную частоту
      0080E0 35 00 50 C6      [ 1]  169 	mov	0x50c6+0, #0x00
                                    170 ;	inc/clk_init.h: 25: CLK_CCOR = 0; // Выключаем CCO.
      0080E4 35 00 50 C9      [ 1]  171 	mov	0x50c9+0, #0x00
                                    172 ;	inc/clk_init.h: 26: CLK_HSITRIMR = 0; // Turn off any HSIU trimming.
      0080E8 35 00 50 CC      [ 1]  173 	mov	0x50cc+0, #0x00
                                    174 ;	inc/clk_init.h: 27: CLK_SWIMCCR = 0; // Set SWIM to run at clock / 2.
      0080EC 35 00 50 CD      [ 1]  175 	mov	0x50cd+0, #0x00
                                    176 ;	inc/clk_init.h: 28: CLK_SWR = 0xe1; // Используем HSI в качестве источника тактиров
      0080F0 35 E1 50 C4      [ 1]  177 	mov	0x50c4+0, #0xe1
                                    178 ;	inc/clk_init.h: 29: CLK_SWCR = 0; // Сброс флага переключения генераторов
      0080F4 35 00 50 C5      [ 1]  179 	mov	0x50c5+0, #0x00
                                    180 ;	inc/clk_init.h: 30: CLK_SWCR= CLK_SWCR_SWEN; // Включаем переключение на HSI
      0080F8 35 02 50 C5      [ 1]  181 	mov	0x50c5+0, #0x02
                                    182 ;	inc/clk_init.h: 31: while ((CLK_SWCR&(1<<0)) != 0); // Пауза, пока произойдёт переключение(CLK_SWCR_SWBSY != 0)
      0080FC                        183 00104$:
      0080FC AE 50 C5         [ 2]  184 	ldw	x, #0x50c5
      0080FF F6               [ 1]  185 	ld	a, (x)
      008100 44               [ 1]  186 	srl	a
      008101 25 F9            [ 1]  187 	jrc	00104$
      008103 81               [ 4]  188 	ret
                                    189 ;	inc/gpio_init.h: 4: void GPIO_init(void)
                                    190 ;	-----------------------------------------
                                    191 ;	 function GPIO_init
                                    192 ;	-----------------------------------------
      008104                        193 _GPIO_init:
                                    194 ;	inc/gpio_init.h: 7: PA_DDR = 0xFF;                                                        //_______PORT_IN
      008104 35 FF 50 02      [ 1]  195 	mov	0x5002+0, #0xff
                                    196 ;	inc/gpio_init.h: 8: PA_CR1 = 0xFF;                                                       //_______DDR________________CR1______________CR2___________FUNCTION  
      008108 35 FF 50 03      [ 1]  197 	mov	0x5003+0, #0xff
                                    198 ;	inc/gpio_init.h: 9: PA_CR2 = 0x00;                                                      //_______0__________________0________________0_____________bez podtiyzhki,bez prerbIvanii 
      00810C 35 00 50 04      [ 1]  199 	mov	0x5004+0, #0x00
                                    200 ;	inc/gpio_init.h: 11: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
      008110 35 00 50 07      [ 1]  201 	mov	0x5007+0, #0x00
                                    202 ;	inc/gpio_init.h: 12: PB_CR1 = 0x00;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
      008114 35 00 50 08      [ 1]  203 	mov	0x5008+0, #0x00
                                    204 ;	inc/gpio_init.h: 13: PB_CR2 = 0x00;                                                      //_______PORT_OUT
      008118 35 00 50 09      [ 1]  205 	mov	0x5009+0, #0x00
                                    206 ;	inc/gpio_init.h: 15: PC_DDR = 0xFF;                                                        //_______1__________________0________________0_____________otkritiy stok
      00811C 35 FF 50 0C      [ 1]  207 	mov	0x500c+0, #0xff
                                    208 ;	inc/gpio_init.h: 16: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
      008120 35 FF 50 0D      [ 1]  209 	mov	0x500d+0, #0xff
                                    210 ;	inc/gpio_init.h: 17: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
      008124 35 00 50 0E      [ 1]  211 	mov	0x500e+0, #0x00
                                    212 ;	inc/gpio_init.h: 19: PD_DDR = 0x3F;   
      008128 35 3F 50 11      [ 1]  213 	mov	0x5011+0, #0x3f
                                    214 ;	inc/gpio_init.h: 20: PD_CR1 = 0xFF;  
      00812C 35 FF 50 12      [ 1]  215 	mov	0x5012+0, #0xff
                                    216 ;	inc/gpio_init.h: 21: PD_CR2 = 0x00; 
      008130 35 00 50 13      [ 1]  217 	mov	0x5013+0, #0x00
                                    218 ;	inc/gpio_init.h: 23: PE_DDR = 0x01;   
      008134 35 01 50 16      [ 1]  219 	mov	0x5016+0, #0x01
                                    220 ;	inc/gpio_init.h: 24: PE_CR1 = 0x01;  
      008138 35 01 50 17      [ 1]  221 	mov	0x5017+0, #0x01
                                    222 ;	inc/gpio_init.h: 25: PE_CR2 = 0x00; 
      00813C 35 00 50 18      [ 1]  223 	mov	0x5018+0, #0x00
                                    224 ;	inc/gpio_init.h: 27: PF_DDR = 0xFF;   
      008140 35 FF 50 1B      [ 1]  225 	mov	0x501b+0, #0xff
                                    226 ;	inc/gpio_init.h: 28: PF_CR1 = 0xFF;  
      008144 35 FF 50 1C      [ 1]  227 	mov	0x501c+0, #0xff
                                    228 ;	inc/gpio_init.h: 29: PF_CR2 = 0x00; 
      008148 35 00 50 1D      [ 1]  229 	mov	0x501d+0, #0x00
                                    230 ;	inc/gpio_init.h: 31: PG_DDR = 0xFF;   
      00814C 35 FF 50 20      [ 1]  231 	mov	0x5020+0, #0xff
                                    232 ;	inc/gpio_init.h: 32: PG_CR1 = 0xFF;  
      008150 35 FF 50 21      [ 1]  233 	mov	0x5021+0, #0xff
                                    234 ;	inc/gpio_init.h: 33: PG_CR2 = 0x00; 
      008154 35 00 50 22      [ 1]  235 	mov	0x5022+0, #0x00
      008158 81               [ 4]  236 	ret
                                    237 ;	inc/ADC.h: 51: void ADC_INIT(void){
                                    238 ;	-----------------------------------------
                                    239 ;	 function ADC_INIT
                                    240 ;	-----------------------------------------
      008159                        241 _ADC_INIT:
                                    242 ;	inc/ADC.h: 52: ADC_CSR_CH9;           //Выбераем канал
      008159 AE 54 00         [ 2]  243 	ldw	x, #0x5400
      00815C F6               [ 1]  244 	ld	a, (x)
      00815D AA 09            [ 1]  245 	or	a, #0x09
      00815F F7               [ 1]  246 	ld	(x), a
                                    247 ;	inc/ADC.h: 53: ADC_CR1_SPSEL8;  //Делитель на 18            
      008160 AE 54 01         [ 2]  248 	ldw	x, #0x5401
      008163 F6               [ 1]  249 	ld	a, (x)
      008164 AA 40            [ 1]  250 	or	a, #0x40
      008166 F7               [ 1]  251 	ld	(x), a
                                    252 ;	inc/ADC.h: 54: ADC_TDRL_DIS(0);       //Отключаем тригер Шмидта
      008167 72 10 54 07      [ 1]  253 	bset	0x5407, #0
                                    254 ;	inc/ADC.h: 55: ADC_CR2_ALIGN_LEFT;    //Выравнивание по левому краю
      00816B AE 54 02         [ 2]  255 	ldw	x, #0x5402
      00816E F6               [ 1]  256 	ld	a, (x)
      00816F A4 F7            [ 1]  257 	and	a, #0xf7
      008171 F7               [ 1]  258 	ld	(x), a
                                    259 ;	inc/ADC.h: 56: ADC_CR1_ADON_ON;       //Первый запуск ADC
      008172 72 10 54 01      [ 1]  260 	bset	0x5401, #0
      008176 81               [ 4]  261 	ret
                                    262 ;	inc/ADC.h: 58: int ADC_read(void){
                                    263 ;	-----------------------------------------
                                    264 ;	 function ADC_read
                                    265 ;	-----------------------------------------
      008177                        266 _ADC_read:
      008177 52 04            [ 2]  267 	sub	sp, #4
                                    268 ;	inc/ADC.h: 60: ADC_CR1_ADON_ON;
      008179 AE 54 01         [ 2]  269 	ldw	x, #0x5401
      00817C F6               [ 1]  270 	ld	a, (x)
      00817D AA 01            [ 1]  271 	or	a, #0x01
      00817F F7               [ 1]  272 	ld	(x), a
                                    273 ;	inc/ADC.h: 61: for(t=0;t<64;t++){
      008180 AE 00 40         [ 2]  274 	ldw	x, #0x0040
      008183                        275 00104$:
                                    276 ;	inc/ADC.h: 62: __asm__("nop\n");
      008183 9D               [ 1]  277 	nop
      008184 5A               [ 2]  278 	decw	x
      008185 1F 03            [ 2]  279 	ldw	(0x03, sp), x
      008187 1E 03            [ 2]  280 	ldw	x, (0x03, sp)
                                    281 ;	inc/ADC.h: 61: for(t=0;t<64;t++){
      008189 16 03            [ 2]  282 	ldw	y, (0x03, sp)
      00818B 26 F6            [ 1]  283 	jrne	00104$
                                    284 ;	inc/ADC.h: 64: data=ADC_DRH<<2;
      00818D AE 54 04         [ 2]  285 	ldw	x, #0x5404
      008190 F6               [ 1]  286 	ld	a, (x)
      008191 5F               [ 1]  287 	clrw	x
      008192 97               [ 1]  288 	ld	xl, a
      008193 58               [ 2]  289 	sllw	x
      008194 58               [ 2]  290 	sllw	x
      008195 1F 01            [ 2]  291 	ldw	(0x01, sp), x
                                    292 ;	inc/ADC.h: 65: data=data+ADC_DRL;
      008197 AE 54 05         [ 2]  293 	ldw	x, #0x5405
      00819A F6               [ 1]  294 	ld	a, (x)
      00819B 5F               [ 1]  295 	clrw	x
      00819C 97               [ 1]  296 	ld	xl, a
      00819D 72 FB 01         [ 2]  297 	addw	x, (0x01, sp)
                                    298 ;	inc/ADC.h: 66: data=data>>1;
      0081A0 57               [ 2]  299 	sraw	x
                                    300 ;	inc/ADC.h: 67: return data;
      0081A1 5B 04            [ 2]  301 	addw	sp, #4
      0081A3 81               [ 4]  302 	ret
                                    303 ;	inc/7sig.h: 11: void out7seg(volatile int t)
                                    304 ;	-----------------------------------------
                                    305 ;	 function out7seg
                                    306 ;	-----------------------------------------
      0081A4                        307 _out7seg:
      0081A4 52 02            [ 2]  308 	sub	sp, #2
                                    309 ;	inc/7sig.h: 13: int num=0;
      0081A6 5F               [ 1]  310 	clrw	x
      0081A7 1F 01            [ 2]  311 	ldw	(0x01, sp), x
                                    312 ;	inc/7sig.h: 14: PC_ODR=0x00;
      0081A9 35 00 50 0A      [ 1]  313 	mov	0x500a+0, #0x00
                                    314 ;	inc/7sig.h: 15: PG_ODR=0x00;
      0081AD 35 00 50 1E      [ 1]  315 	mov	0x501e+0, #0x00
                                    316 ;	inc/7sig.h: 16: PD_ODR&=~((1<<4) |(1<<3)|(1<<2));
      0081B1 AE 50 0F         [ 2]  317 	ldw	x, #0x500f
      0081B4 F6               [ 1]  318 	ld	a, (x)
      0081B5 A4 E3            [ 1]  319 	and	a, #0xe3
      0081B7 F7               [ 1]  320 	ld	(x), a
                                    321 ;	inc/7sig.h: 20: if(q==0) num=(t%1000/100),PD_ODR|=(1<<2);
      0081B8 CE 00 01         [ 2]  322 	ldw	x, _q+0
      0081BB 26 1F            [ 1]  323 	jrne	00102$
      0081BD 4B E8            [ 1]  324 	push	#0xe8
      0081BF 4B 03            [ 1]  325 	push	#0x03
      0081C1 1E 07            [ 2]  326 	ldw	x, (0x07, sp)
      0081C3 89               [ 2]  327 	pushw	x
      0081C4 CD 8C 42         [ 4]  328 	call	__modsint
      0081C7 5B 04            [ 2]  329 	addw	sp, #4
      0081C9 4B 64            [ 1]  330 	push	#0x64
      0081CB 4B 00            [ 1]  331 	push	#0x00
      0081CD 89               [ 2]  332 	pushw	x
      0081CE CD 8C 58         [ 4]  333 	call	__divsint
      0081D1 5B 04            [ 2]  334 	addw	sp, #4
      0081D3 1F 01            [ 2]  335 	ldw	(0x01, sp), x
      0081D5 AE 50 0F         [ 2]  336 	ldw	x, #0x500f
      0081D8 F6               [ 1]  337 	ld	a, (x)
      0081D9 AA 04            [ 1]  338 	or	a, #0x04
      0081DB F7               [ 1]  339 	ld	(x), a
      0081DC                        340 00102$:
                                    341 ;	inc/7sig.h: 21: if(q==1) num=(t%100/10),PD_ODR|=(1<<3);
      0081DC CE 00 01         [ 2]  342 	ldw	x, _q+0
      0081DF A3 00 01         [ 2]  343 	cpw	x, #0x0001
      0081E2 26 1F            [ 1]  344 	jrne	00104$
      0081E4 4B 64            [ 1]  345 	push	#0x64
      0081E6 4B 00            [ 1]  346 	push	#0x00
      0081E8 1E 07            [ 2]  347 	ldw	x, (0x07, sp)
      0081EA 89               [ 2]  348 	pushw	x
      0081EB CD 8C 42         [ 4]  349 	call	__modsint
      0081EE 5B 04            [ 2]  350 	addw	sp, #4
      0081F0 4B 0A            [ 1]  351 	push	#0x0a
      0081F2 4B 00            [ 1]  352 	push	#0x00
      0081F4 89               [ 2]  353 	pushw	x
      0081F5 CD 8C 58         [ 4]  354 	call	__divsint
      0081F8 5B 04            [ 2]  355 	addw	sp, #4
      0081FA 1F 01            [ 2]  356 	ldw	(0x01, sp), x
      0081FC AE 50 0F         [ 2]  357 	ldw	x, #0x500f
      0081FF F6               [ 1]  358 	ld	a, (x)
      008200 AA 08            [ 1]  359 	or	a, #0x08
      008202 F7               [ 1]  360 	ld	(x), a
      008203                        361 00104$:
                                    362 ;	inc/7sig.h: 22: if(q==2) num=(t%10),PD_ODR|=(1<<4);
      008203 CE 00 01         [ 2]  363 	ldw	x, _q+0
      008206 A3 00 02         [ 2]  364 	cpw	x, #0x0002
      008209 26 15            [ 1]  365 	jrne	00106$
      00820B 4B 0A            [ 1]  366 	push	#0x0a
      00820D 4B 00            [ 1]  367 	push	#0x00
      00820F 1E 07            [ 2]  368 	ldw	x, (0x07, sp)
      008211 89               [ 2]  369 	pushw	x
      008212 CD 8C 42         [ 4]  370 	call	__modsint
      008215 5B 04            [ 2]  371 	addw	sp, #4
      008217 1F 01            [ 2]  372 	ldw	(0x01, sp), x
      008219 AE 50 0F         [ 2]  373 	ldw	x, #0x500f
      00821C F6               [ 1]  374 	ld	a, (x)
      00821D AA 10            [ 1]  375 	or	a, #0x10
      00821F F7               [ 1]  376 	ld	(x), a
      008220                        377 00106$:
                                    378 ;	inc/7sig.h: 23: q++;
      008220 CE 00 01         [ 2]  379 	ldw	x, _q+0
      008223 5C               [ 2]  380 	incw	x
                                    381 ;	inc/7sig.h: 24: if(q>2) q=0;
      008224 CF 00 01         [ 2]  382 	ldw	_q+0, x
      008227 A3 00 02         [ 2]  383 	cpw	x, #0x0002
      00822A 2D 04            [ 1]  384 	jrsle	00108$
      00822C 5F               [ 1]  385 	clrw	x
      00822D CF 00 01         [ 2]  386 	ldw	_q+0, x
      008230                        387 00108$:
                                    388 ;	inc/7sig.h: 25: switch (num)
      008230 0D 01            [ 1]  389 	tnz	(0x01, sp)
      008232 2A 03            [ 1]  390 	jrpl	00155$
      008234 CC 83 A4         [ 2]  391 	jp	00121$
      008237                        392 00155$:
      008237 1E 01            [ 2]  393 	ldw	x, (0x01, sp)
      008239 A3 00 09         [ 2]  394 	cpw	x, #0x0009
      00823C 2D 03            [ 1]  395 	jrsle	00156$
      00823E CC 83 A4         [ 2]  396 	jp	00121$
      008241                        397 00156$:
      008241 1E 01            [ 2]  398 	ldw	x, (0x01, sp)
      008243 58               [ 2]  399 	sllw	x
      008244 DE 82 48         [ 2]  400 	ldw	x, (#00157$, x)
      008247 FC               [ 2]  401 	jp	(x)
      008248                        402 00157$:
      008248 82 5C                  403 	.dw	#00109$
      00824A 82 86                  404 	.dw	#00110$
      00824C 82 94                  405 	.dw	#00111$
      00824E 82 B7                  406 	.dw	#00112$
      008250 82 DA                  407 	.dw	#00113$
      008252 82 F3                  408 	.dw	#00114$
      008254 83 16                  409 	.dw	#00115$
      008256 83 3F                  410 	.dw	#00116$
      008258 83 53                  411 	.dw	#00117$
      00825A 83 80                  412 	.dw	#00118$
                                    413 ;	inc/7sig.h: 27: case 0:   
      00825C                        414 00109$:
                                    415 ;	inc/7sig.h: 28: segA,segB,segC,segD,segE,segF;
      00825C AE 50 1E         [ 2]  416 	ldw	x, #0x501e
      00825F F6               [ 1]  417 	ld	a, (x)
      008260 AA 02            [ 1]  418 	or	a, #0x02
      008262 F7               [ 1]  419 	ld	(x), a
      008263 72 10 50 1E      [ 1]  420 	bset	0x501e, #0
      008267 AE 50 0A         [ 2]  421 	ldw	x, #0x500a
      00826A F6               [ 1]  422 	ld	a, (x)
      00826B AA 20            [ 1]  423 	or	a, #0x20
      00826D F7               [ 1]  424 	ld	(x), a
      00826E AE 50 0A         [ 2]  425 	ldw	x, #0x500a
      008271 F6               [ 1]  426 	ld	a, (x)
      008272 AA 04            [ 1]  427 	or	a, #0x04
      008274 F7               [ 1]  428 	ld	(x), a
      008275 AE 50 0A         [ 2]  429 	ldw	x, #0x500a
      008278 F6               [ 1]  430 	ld	a, (x)
      008279 AA 08            [ 1]  431 	or	a, #0x08
      00827B F7               [ 1]  432 	ld	(x), a
      00827C AE 50 0A         [ 2]  433 	ldw	x, #0x500a
      00827F F6               [ 1]  434 	ld	a, (x)
      008280 AA 80            [ 1]  435 	or	a, #0x80
      008282 F7               [ 1]  436 	ld	(x), a
                                    437 ;	inc/7sig.h: 29: break;
      008283 CC 83 A4         [ 2]  438 	jp	00121$
                                    439 ;	inc/7sig.h: 30: case 1:   
      008286                        440 00110$:
                                    441 ;	inc/7sig.h: 31: segB,segC;
      008286 72 10 50 1E      [ 1]  442 	bset	0x501e, #0
      00828A AE 50 0A         [ 2]  443 	ldw	x, #0x500a
      00828D F6               [ 1]  444 	ld	a, (x)
      00828E AA 20            [ 1]  445 	or	a, #0x20
      008290 F7               [ 1]  446 	ld	(x), a
                                    447 ;	inc/7sig.h: 32: break;
      008291 CC 83 A4         [ 2]  448 	jp	00121$
                                    449 ;	inc/7sig.h: 33: case 2:   
      008294                        450 00111$:
                                    451 ;	inc/7sig.h: 34: segA,segB,segG,segD,segE;
      008294 AE 50 1E         [ 2]  452 	ldw	x, #0x501e
      008297 F6               [ 1]  453 	ld	a, (x)
      008298 AA 02            [ 1]  454 	or	a, #0x02
      00829A F7               [ 1]  455 	ld	(x), a
      00829B 72 10 50 1E      [ 1]  456 	bset	0x501e, #0
      00829F AE 50 0A         [ 2]  457 	ldw	x, #0x500a
      0082A2 F6               [ 1]  458 	ld	a, (x)
      0082A3 AA 40            [ 1]  459 	or	a, #0x40
      0082A5 F7               [ 1]  460 	ld	(x), a
      0082A6 AE 50 0A         [ 2]  461 	ldw	x, #0x500a
      0082A9 F6               [ 1]  462 	ld	a, (x)
      0082AA AA 04            [ 1]  463 	or	a, #0x04
      0082AC F7               [ 1]  464 	ld	(x), a
      0082AD AE 50 0A         [ 2]  465 	ldw	x, #0x500a
      0082B0 F6               [ 1]  466 	ld	a, (x)
      0082B1 AA 08            [ 1]  467 	or	a, #0x08
      0082B3 F7               [ 1]  468 	ld	(x), a
                                    469 ;	inc/7sig.h: 35: break;
      0082B4 CC 83 A4         [ 2]  470 	jp	00121$
                                    471 ;	inc/7sig.h: 36: case 3:   
      0082B7                        472 00112$:
                                    473 ;	inc/7sig.h: 37: segA,segB,segC,segD,segG;
      0082B7 AE 50 1E         [ 2]  474 	ldw	x, #0x501e
      0082BA F6               [ 1]  475 	ld	a, (x)
      0082BB AA 02            [ 1]  476 	or	a, #0x02
      0082BD F7               [ 1]  477 	ld	(x), a
      0082BE 72 10 50 1E      [ 1]  478 	bset	0x501e, #0
      0082C2 AE 50 0A         [ 2]  479 	ldw	x, #0x500a
      0082C5 F6               [ 1]  480 	ld	a, (x)
      0082C6 AA 20            [ 1]  481 	or	a, #0x20
      0082C8 F7               [ 1]  482 	ld	(x), a
      0082C9 AE 50 0A         [ 2]  483 	ldw	x, #0x500a
      0082CC F6               [ 1]  484 	ld	a, (x)
      0082CD AA 04            [ 1]  485 	or	a, #0x04
      0082CF F7               [ 1]  486 	ld	(x), a
      0082D0 AE 50 0A         [ 2]  487 	ldw	x, #0x500a
      0082D3 F6               [ 1]  488 	ld	a, (x)
      0082D4 AA 40            [ 1]  489 	or	a, #0x40
      0082D6 F7               [ 1]  490 	ld	(x), a
                                    491 ;	inc/7sig.h: 38: break;
      0082D7 CC 83 A4         [ 2]  492 	jp	00121$
                                    493 ;	inc/7sig.h: 39: case 4:   
      0082DA                        494 00113$:
                                    495 ;	inc/7sig.h: 40: segF,segB,segG,segC;
      0082DA 72 1E 50 0A      [ 1]  496 	bset	0x500a, #7
      0082DE 72 10 50 1E      [ 1]  497 	bset	0x501e, #0
      0082E2 AE 50 0A         [ 2]  498 	ldw	x, #0x500a
      0082E5 F6               [ 1]  499 	ld	a, (x)
      0082E6 AA 40            [ 1]  500 	or	a, #0x40
      0082E8 F7               [ 1]  501 	ld	(x), a
      0082E9 AE 50 0A         [ 2]  502 	ldw	x, #0x500a
      0082EC F6               [ 1]  503 	ld	a, (x)
      0082ED AA 20            [ 1]  504 	or	a, #0x20
      0082EF F7               [ 1]  505 	ld	(x), a
                                    506 ;	inc/7sig.h: 41: break;
      0082F0 CC 83 A4         [ 2]  507 	jp	00121$
                                    508 ;	inc/7sig.h: 42: case 5:   
      0082F3                        509 00114$:
                                    510 ;	inc/7sig.h: 43: segA,segC,segD,segF,segG;
      0082F3 AE 50 1E         [ 2]  511 	ldw	x, #0x501e
      0082F6 F6               [ 1]  512 	ld	a, (x)
      0082F7 AA 02            [ 1]  513 	or	a, #0x02
      0082F9 F7               [ 1]  514 	ld	(x), a
      0082FA AE 50 0A         [ 2]  515 	ldw	x, #0x500a
      0082FD F6               [ 1]  516 	ld	a, (x)
      0082FE AA 20            [ 1]  517 	or	a, #0x20
      008300 F7               [ 1]  518 	ld	(x), a
      008301 AE 50 0A         [ 2]  519 	ldw	x, #0x500a
      008304 F6               [ 1]  520 	ld	a, (x)
      008305 AA 04            [ 1]  521 	or	a, #0x04
      008307 F7               [ 1]  522 	ld	(x), a
      008308 72 1E 50 0A      [ 1]  523 	bset	0x500a, #7
      00830C AE 50 0A         [ 2]  524 	ldw	x, #0x500a
      00830F F6               [ 1]  525 	ld	a, (x)
      008310 AA 40            [ 1]  526 	or	a, #0x40
      008312 F7               [ 1]  527 	ld	(x), a
                                    528 ;	inc/7sig.h: 44: break;
      008313 CC 83 A4         [ 2]  529 	jp	00121$
                                    530 ;	inc/7sig.h: 45: case 6:   
      008316                        531 00115$:
                                    532 ;	inc/7sig.h: 46: segA,segC,segD,segE,segF,segG;
      008316 AE 50 1E         [ 2]  533 	ldw	x, #0x501e
      008319 F6               [ 1]  534 	ld	a, (x)
      00831A AA 02            [ 1]  535 	or	a, #0x02
      00831C F7               [ 1]  536 	ld	(x), a
      00831D AE 50 0A         [ 2]  537 	ldw	x, #0x500a
      008320 F6               [ 1]  538 	ld	a, (x)
      008321 AA 20            [ 1]  539 	or	a, #0x20
      008323 F7               [ 1]  540 	ld	(x), a
      008324 AE 50 0A         [ 2]  541 	ldw	x, #0x500a
      008327 F6               [ 1]  542 	ld	a, (x)
      008328 AA 04            [ 1]  543 	or	a, #0x04
      00832A F7               [ 1]  544 	ld	(x), a
      00832B AE 50 0A         [ 2]  545 	ldw	x, #0x500a
      00832E F6               [ 1]  546 	ld	a, (x)
      00832F AA 08            [ 1]  547 	or	a, #0x08
      008331 F7               [ 1]  548 	ld	(x), a
      008332 72 1E 50 0A      [ 1]  549 	bset	0x500a, #7
      008336 AE 50 0A         [ 2]  550 	ldw	x, #0x500a
      008339 F6               [ 1]  551 	ld	a, (x)
      00833A AA 40            [ 1]  552 	or	a, #0x40
      00833C F7               [ 1]  553 	ld	(x), a
                                    554 ;	inc/7sig.h: 47: break;
      00833D 20 65            [ 2]  555 	jra	00121$
                                    556 ;	inc/7sig.h: 48: case 7:   
      00833F                        557 00116$:
                                    558 ;	inc/7sig.h: 49: segA,segB,segC;
      00833F AE 50 1E         [ 2]  559 	ldw	x, #0x501e
      008342 F6               [ 1]  560 	ld	a, (x)
      008343 AA 02            [ 1]  561 	or	a, #0x02
      008345 F7               [ 1]  562 	ld	(x), a
      008346 72 10 50 1E      [ 1]  563 	bset	0x501e, #0
      00834A AE 50 0A         [ 2]  564 	ldw	x, #0x500a
      00834D F6               [ 1]  565 	ld	a, (x)
      00834E AA 20            [ 1]  566 	or	a, #0x20
      008350 F7               [ 1]  567 	ld	(x), a
                                    568 ;	inc/7sig.h: 50: break;
      008351 20 51            [ 2]  569 	jra	00121$
                                    570 ;	inc/7sig.h: 51: case 8:   
      008353                        571 00117$:
                                    572 ;	inc/7sig.h: 52: segA,segB,segC,segD,segE,segF,segG;
      008353 AE 50 1E         [ 2]  573 	ldw	x, #0x501e
      008356 F6               [ 1]  574 	ld	a, (x)
      008357 AA 02            [ 1]  575 	or	a, #0x02
      008359 F7               [ 1]  576 	ld	(x), a
      00835A 72 10 50 1E      [ 1]  577 	bset	0x501e, #0
      00835E AE 50 0A         [ 2]  578 	ldw	x, #0x500a
      008361 F6               [ 1]  579 	ld	a, (x)
      008362 AA 20            [ 1]  580 	or	a, #0x20
      008364 F7               [ 1]  581 	ld	(x), a
      008365 AE 50 0A         [ 2]  582 	ldw	x, #0x500a
      008368 F6               [ 1]  583 	ld	a, (x)
      008369 AA 04            [ 1]  584 	or	a, #0x04
      00836B F7               [ 1]  585 	ld	(x), a
      00836C AE 50 0A         [ 2]  586 	ldw	x, #0x500a
      00836F F6               [ 1]  587 	ld	a, (x)
      008370 AA 08            [ 1]  588 	or	a, #0x08
      008372 F7               [ 1]  589 	ld	(x), a
      008373 72 1E 50 0A      [ 1]  590 	bset	0x500a, #7
      008377 AE 50 0A         [ 2]  591 	ldw	x, #0x500a
      00837A F6               [ 1]  592 	ld	a, (x)
      00837B AA 40            [ 1]  593 	or	a, #0x40
      00837D F7               [ 1]  594 	ld	(x), a
                                    595 ;	inc/7sig.h: 53: break;
      00837E 20 24            [ 2]  596 	jra	00121$
                                    597 ;	inc/7sig.h: 54: case 9:   
      008380                        598 00118$:
                                    599 ;	inc/7sig.h: 55: segA,segB,segC,segD,segF,segG;
      008380 AE 50 1E         [ 2]  600 	ldw	x, #0x501e
      008383 F6               [ 1]  601 	ld	a, (x)
      008384 AA 02            [ 1]  602 	or	a, #0x02
      008386 F7               [ 1]  603 	ld	(x), a
      008387 72 10 50 1E      [ 1]  604 	bset	0x501e, #0
      00838B AE 50 0A         [ 2]  605 	ldw	x, #0x500a
      00838E F6               [ 1]  606 	ld	a, (x)
      00838F AA 20            [ 1]  607 	or	a, #0x20
      008391 F7               [ 1]  608 	ld	(x), a
      008392 AE 50 0A         [ 2]  609 	ldw	x, #0x500a
      008395 F6               [ 1]  610 	ld	a, (x)
      008396 AA 04            [ 1]  611 	or	a, #0x04
      008398 F7               [ 1]  612 	ld	(x), a
      008399 72 1E 50 0A      [ 1]  613 	bset	0x500a, #7
      00839D AE 50 0A         [ 2]  614 	ldw	x, #0x500a
      0083A0 F6               [ 1]  615 	ld	a, (x)
      0083A1 AA 40            [ 1]  616 	or	a, #0x40
      0083A3 F7               [ 1]  617 	ld	(x), a
                                    618 ;	inc/7sig.h: 59: }
      0083A4                        619 00121$:
      0083A4 5B 02            [ 2]  620 	addw	sp, #2
      0083A6 81               [ 4]  621 	ret
                                    622 ;	main.c: 9: void delay(int t)
                                    623 ;	-----------------------------------------
                                    624 ;	 function delay
                                    625 ;	-----------------------------------------
      0083A7                        626 _delay:
      0083A7 52 02            [ 2]  627 	sub	sp, #2
                                    628 ;	main.c: 12: for(i=0;i<t;i++)
      0083A9 5F               [ 1]  629 	clrw	x
      0083AA                        630 00107$:
      0083AA 13 05            [ 2]  631 	cpw	x, (0x05, sp)
      0083AC 2E 13            [ 1]  632 	jrsge	00109$
                                    633 ;	main.c: 14: for(s=0;s<32;s++)
      0083AE 90 AE 00 20      [ 2]  634 	ldw	y, #0x0020
      0083B2 17 01            [ 2]  635 	ldw	(0x01, sp), y
      0083B4                        636 00105$:
      0083B4 16 01            [ 2]  637 	ldw	y, (0x01, sp)
      0083B6 90 5A            [ 2]  638 	decw	y
      0083B8 17 01            [ 2]  639 	ldw	(0x01, sp), y
      0083BA 90 5D            [ 2]  640 	tnzw	y
      0083BC 26 F6            [ 1]  641 	jrne	00105$
                                    642 ;	main.c: 12: for(i=0;i<t;i++)
      0083BE 5C               [ 2]  643 	incw	x
      0083BF 20 E9            [ 2]  644 	jra	00107$
      0083C1                        645 00109$:
      0083C1 5B 02            [ 2]  646 	addw	sp, #2
      0083C3 81               [ 4]  647 	ret
                                    648 ;	main.c: 20: void main(void)
                                    649 ;	-----------------------------------------
                                    650 ;	 function main
                                    651 ;	-----------------------------------------
      0083C4                        652 _main:
      0083C4 52 22            [ 2]  653 	sub	sp, #34
                                    654 ;	main.c: 24: int vzd=5,Kvzd=18,count=0,w=0,q=0;
      0083C6 5F               [ 1]  655 	clrw	x
      0083C7 1F 17            [ 2]  656 	ldw	(0x17, sp), x
      0083C9 5F               [ 1]  657 	clrw	x
      0083CA 1F 13            [ 2]  658 	ldw	(0x13, sp), x
                                    659 ;	main.c: 25: int ustavka=280;								
      0083CC AE 01 18         [ 2]  660 	ldw	x, #0x0118
      0083CF 1F 11            [ 2]  661 	ldw	(0x11, sp), x
                                    662 ;	main.c: 26: int lcd=0;								
      0083D1 5F               [ 1]  663 	clrw	x
      0083D2 1F 0B            [ 2]  664 	ldw	(0x0b, sp), x
                                    665 ;	main.c: 29: float result=0.0,oldresult=0.0,k=0.2,Nresult=0.0;							
      0083D4 5F               [ 1]  666 	clrw	x
      0083D5 1F 03            [ 2]  667 	ldw	(0x03, sp), x
      0083D7 1F 01            [ 2]  668 	ldw	(0x01, sp), x
                                    669 ;	main.c: 32: Init_HSI();
      0083D9 CD 80 CC         [ 4]  670 	call	_Init_HSI
                                    671 ;	main.c: 33: GPIO_init();
      0083DC CD 81 04         [ 4]  672 	call	_GPIO_init
                                    673 ;	main.c: 34: ADC_INIT();
      0083DF CD 81 59         [ 4]  674 	call	_ADC_INIT
                                    675 ;	main.c: 37: while(1)
      0083E2                        676 00126$:
                                    677 ;	main.c: 39: PC_ODR=0x00;
      0083E2 35 00 50 0A      [ 1]  678 	mov	0x500a+0, #0x00
                                    679 ;	main.c: 40: PG_ODR=0x00;
      0083E6 35 00 50 1E      [ 1]  680 	mov	0x501e+0, #0x00
                                    681 ;	main.c: 41: PD_ODR&=~((1<<4) |(1<<3)|(1<<2));
      0083EA AE 50 0F         [ 2]  682 	ldw	x, #0x500f
      0083ED F6               [ 1]  683 	ld	a, (x)
      0083EE A4 E3            [ 1]  684 	and	a, #0xe3
      0083F0 F7               [ 1]  685 	ld	(x), a
                                    686 ;	main.c: 42: delay(32);
      0083F1 4B 20            [ 1]  687 	push	#0x20
      0083F3 4B 00            [ 1]  688 	push	#0x00
      0083F5 CD 83 A7         [ 4]  689 	call	_delay
      0083F8 5B 02            [ 2]  690 	addw	sp, #2
                                    691 ;	main.c: 43: adc_data=ADC_read();						
      0083FA CD 81 77         [ 4]  692 	call	_ADC_read
                                    693 ;	main.c: 44: result=(k*adc_data)+(1-k)*oldresult;
      0083FD 89               [ 2]  694 	pushw	x
      0083FE CD 8B 77         [ 4]  695 	call	___sint2fs
      008401 5B 02            [ 2]  696 	addw	sp, #2
      008403 89               [ 2]  697 	pushw	x
      008404 90 89            [ 2]  698 	pushw	y
      008406 4B CD            [ 1]  699 	push	#0xcd
      008408 4B CC            [ 1]  700 	push	#0xcc
      00840A 4B 4C            [ 1]  701 	push	#0x4c
      00840C 4B 3E            [ 1]  702 	push	#0x3e
      00840E CD 85 BA         [ 4]  703 	call	___fsmul
      008411 5B 08            [ 2]  704 	addw	sp, #8
      008413 1F 1D            [ 2]  705 	ldw	(0x1d, sp), x
      008415 17 1B            [ 2]  706 	ldw	(0x1b, sp), y
      008417 1E 03            [ 2]  707 	ldw	x, (0x03, sp)
      008419 89               [ 2]  708 	pushw	x
      00841A 1E 03            [ 2]  709 	ldw	x, (0x03, sp)
      00841C 89               [ 2]  710 	pushw	x
      00841D 4B CD            [ 1]  711 	push	#0xcd
      00841F 4B CC            [ 1]  712 	push	#0xcc
      008421 4B 4C            [ 1]  713 	push	#0x4c
      008423 4B 3F            [ 1]  714 	push	#0x3f
      008425 CD 85 BA         [ 4]  715 	call	___fsmul
      008428 5B 08            [ 2]  716 	addw	sp, #8
      00842A 89               [ 2]  717 	pushw	x
      00842B 90 89            [ 2]  718 	pushw	y
      00842D 1E 21            [ 2]  719 	ldw	x, (0x21, sp)
      00842F 89               [ 2]  720 	pushw	x
      008430 1E 21            [ 2]  721 	ldw	x, (0x21, sp)
      008432 89               [ 2]  722 	pushw	x
      008433 CD 88 BD         [ 4]  723 	call	___fsadd
      008436 5B 08            [ 2]  724 	addw	sp, #8
      008438 1F 07            [ 2]  725 	ldw	(0x07, sp), x
      00843A 17 05            [ 2]  726 	ldw	(0x05, sp), y
                                    727 ;	main.c: 45: oldresult=result;
      00843C 16 07            [ 2]  728 	ldw	y, (0x07, sp)
      00843E 17 03            [ 2]  729 	ldw	(0x03, sp), y
      008440 16 05            [ 2]  730 	ldw	y, (0x05, sp)
      008442 17 01            [ 2]  731 	ldw	(0x01, sp), y
                                    732 ;	main.c: 46: Nresult=result+((ustavka>>1)-23);
      008444 1E 11            [ 2]  733 	ldw	x, (0x11, sp)
      008446 57               [ 2]  734 	sraw	x
      008447 1D 00 17         [ 2]  735 	subw	x, #0x0017
      00844A 89               [ 2]  736 	pushw	x
      00844B CD 8B 77         [ 4]  737 	call	___sint2fs
      00844E 5B 02            [ 2]  738 	addw	sp, #2
      008450 89               [ 2]  739 	pushw	x
      008451 90 89            [ 2]  740 	pushw	y
      008453 1E 0B            [ 2]  741 	ldw	x, (0x0b, sp)
      008455 89               [ 2]  742 	pushw	x
      008456 1E 0B            [ 2]  743 	ldw	x, (0x0b, sp)
      008458 89               [ 2]  744 	pushw	x
      008459 CD 88 BD         [ 4]  745 	call	___fsadd
      00845C 5B 08            [ 2]  746 	addw	sp, #8
      00845E 1F 0F            [ 2]  747 	ldw	(0x0f, sp), x
      008460 17 0D            [ 2]  748 	ldw	(0x0d, sp), y
                                    749 ;	main.c: 47: vzd=(ustavka-Nresult)*4+16;
      008462 1E 11            [ 2]  750 	ldw	x, (0x11, sp)
      008464 89               [ 2]  751 	pushw	x
      008465 CD 8B 77         [ 4]  752 	call	___sint2fs
      008468 5B 02            [ 2]  753 	addw	sp, #2
      00846A 1F 21            [ 2]  754 	ldw	(0x21, sp), x
      00846C 1E 0F            [ 2]  755 	ldw	x, (0x0f, sp)
      00846E 89               [ 2]  756 	pushw	x
      00846F 1E 0F            [ 2]  757 	ldw	x, (0x0f, sp)
      008471 89               [ 2]  758 	pushw	x
      008472 1E 25            [ 2]  759 	ldw	x, (0x25, sp)
      008474 89               [ 2]  760 	pushw	x
      008475 90 89            [ 2]  761 	pushw	y
      008477 CD 85 97         [ 4]  762 	call	___fssub
      00847A 5B 08            [ 2]  763 	addw	sp, #8
      00847C 89               [ 2]  764 	pushw	x
      00847D 90 89            [ 2]  765 	pushw	y
      00847F 5F               [ 1]  766 	clrw	x
      008480 89               [ 2]  767 	pushw	x
      008481 4B 80            [ 1]  768 	push	#0x80
      008483 4B 40            [ 1]  769 	push	#0x40
      008485 CD 85 BA         [ 4]  770 	call	___fsmul
      008488 5B 08            [ 2]  771 	addw	sp, #8
      00848A 4B 00            [ 1]  772 	push	#0x00
      00848C 4B 00            [ 1]  773 	push	#0x00
      00848E 4B 80            [ 1]  774 	push	#0x80
      008490 4B 41            [ 1]  775 	push	#0x41
      008492 89               [ 2]  776 	pushw	x
      008493 90 89            [ 2]  777 	pushw	y
      008495 CD 88 BD         [ 4]  778 	call	___fsadd
      008498 5B 08            [ 2]  779 	addw	sp, #8
      00849A 89               [ 2]  780 	pushw	x
      00849B 90 89            [ 2]  781 	pushw	y
      00849D CD 8B 88         [ 4]  782 	call	___fs2sint
      0084A0 5B 04            [ 2]  783 	addw	sp, #4
      0084A2 1F 19            [ 2]  784 	ldw	(0x19, sp), x
                                    785 ;	main.c: 48: if(vzd>100)vzd=100;
      0084A4 1E 19            [ 2]  786 	ldw	x, (0x19, sp)
      0084A6 A3 00 64         [ 2]  787 	cpw	x, #0x0064
      0084A9 2D 05            [ 1]  788 	jrsle	00102$
      0084AB AE 00 64         [ 2]  789 	ldw	x, #0x0064
      0084AE 1F 19            [ 2]  790 	ldw	(0x19, sp), x
      0084B0                        791 00102$:
                                    792 ;	main.c: 49: if(vzd<4)vzd=4;
      0084B0 1E 19            [ 2]  793 	ldw	x, (0x19, sp)
      0084B2 A3 00 04         [ 2]  794 	cpw	x, #0x0004
      0084B5 2E 05            [ 1]  795 	jrsge	00104$
      0084B7 AE 00 04         [ 2]  796 	ldw	x, #0x0004
      0084BA 1F 19            [ 2]  797 	ldw	(0x19, sp), x
      0084BC                        798 00104$:
                                    799 ;	main.c: 50: if(count<=0)count=24,lcd=Nresult; 
      0084BC 1E 17            [ 2]  800 	ldw	x, (0x17, sp)
      0084BE A3 00 00         [ 2]  801 	cpw	x, #0x0000
      0084C1 2C 12            [ 1]  802 	jrsgt	00106$
      0084C3 AE 00 18         [ 2]  803 	ldw	x, #0x0018
      0084C6 1F 17            [ 2]  804 	ldw	(0x17, sp), x
      0084C8 1E 0F            [ 2]  805 	ldw	x, (0x0f, sp)
      0084CA 89               [ 2]  806 	pushw	x
      0084CB 1E 0F            [ 2]  807 	ldw	x, (0x0f, sp)
      0084CD 89               [ 2]  808 	pushw	x
      0084CE CD 8B 88         [ 4]  809 	call	___fs2sint
      0084D1 5B 04            [ 2]  810 	addw	sp, #4
      0084D3 1F 0B            [ 2]  811 	ldw	(0x0b, sp), x
      0084D5                        812 00106$:
                                    813 ;	main.c: 53: bit_h(PE_ODR,0);
      0084D5 AE 50 14         [ 2]  814 	ldw	x, #0x5014
      0084D8 F6               [ 1]  815 	ld	a, (x)
      0084D9 AA 01            [ 1]  816 	or	a, #0x01
      0084DB F7               [ 1]  817 	ld	(x), a
                                    818 ;	main.c: 54: for(period=0;period<100;period++)
      0084DC 5F               [ 1]  819 	clrw	x
      0084DD 1F 09            [ 2]  820 	ldw	(0x09, sp), x
      0084DF                        821 00128$:
                                    822 ;	main.c: 56: if(period==vzd)bit_l(PE_ODR,0);
      0084DF 1E 09            [ 2]  823 	ldw	x, (0x09, sp)
      0084E1 13 19            [ 2]  824 	cpw	x, (0x19, sp)
      0084E3 26 07            [ 1]  825 	jrne	00108$
      0084E5 AE 50 14         [ 2]  826 	ldw	x, #0x5014
      0084E8 F6               [ 1]  827 	ld	a, (x)
      0084E9 A4 FE            [ 1]  828 	and	a, #0xfe
      0084EB F7               [ 1]  829 	ld	(x), a
      0084EC                        830 00108$:
                                    831 ;	main.c: 57: if(period==20||period==60||period==100||period==140||period==180||period==220)out7seg(lcd);
      0084EC 1E 09            [ 2]  832 	ldw	x, (0x09, sp)
      0084EE A3 00 14         [ 2]  833 	cpw	x, #0x0014
      0084F1 27 23            [ 1]  834 	jreq	00109$
      0084F3 1E 09            [ 2]  835 	ldw	x, (0x09, sp)
      0084F5 A3 00 3C         [ 2]  836 	cpw	x, #0x003c
      0084F8 27 1C            [ 1]  837 	jreq	00109$
      0084FA 1E 09            [ 2]  838 	ldw	x, (0x09, sp)
      0084FC A3 00 64         [ 2]  839 	cpw	x, #0x0064
      0084FF 27 15            [ 1]  840 	jreq	00109$
      008501 1E 09            [ 2]  841 	ldw	x, (0x09, sp)
      008503 A3 00 8C         [ 2]  842 	cpw	x, #0x008c
      008506 27 0E            [ 1]  843 	jreq	00109$
      008508 1E 09            [ 2]  844 	ldw	x, (0x09, sp)
      00850A A3 00 B4         [ 2]  845 	cpw	x, #0x00b4
      00850D 27 07            [ 1]  846 	jreq	00109$
      00850F 1E 09            [ 2]  847 	ldw	x, (0x09, sp)
      008511 A3 00 DC         [ 2]  848 	cpw	x, #0x00dc
      008514 26 08            [ 1]  849 	jrne	00110$
      008516                        850 00109$:
      008516 1E 0B            [ 2]  851 	ldw	x, (0x0b, sp)
      008518 89               [ 2]  852 	pushw	x
      008519 CD 81 A4         [ 4]  853 	call	_out7seg
      00851C 5B 02            [ 2]  854 	addw	sp, #2
      00851E                        855 00110$:
                                    856 ;	main.c: 58: delay(2);
      00851E 4B 02            [ 1]  857 	push	#0x02
      008520 4B 00            [ 1]  858 	push	#0x00
      008522 CD 83 A7         [ 4]  859 	call	_delay
      008525 5B 02            [ 2]  860 	addw	sp, #2
                                    861 ;	main.c: 59: w=(PD_IDR&((1<<7)|(1<<6)));
      008527 AE 50 10         [ 2]  862 	ldw	x, #0x5010
      00852A F6               [ 1]  863 	ld	a, (x)
      00852B A4 C0            [ 1]  864 	and	a, #0xc0
      00852D 5F               [ 1]  865 	clrw	x
      00852E 97               [ 1]  866 	ld	xl, a
      00852F 1F 15            [ 2]  867 	ldw	(0x15, sp), x
                                    868 ;	main.c: 60: if(w==0&&q==64&&ustavka<500) ustavka=ustavka+5,count=400,lcd=ustavka;
      008531 1E 15            [ 2]  869 	ldw	x, (0x15, sp)
      008533 26 1E            [ 1]  870 	jrne	00117$
      008535 1E 13            [ 2]  871 	ldw	x, (0x13, sp)
      008537 A3 00 40         [ 2]  872 	cpw	x, #0x0040
      00853A 26 17            [ 1]  873 	jrne	00117$
      00853C 1E 11            [ 2]  874 	ldw	x, (0x11, sp)
      00853E A3 01 F4         [ 2]  875 	cpw	x, #0x01f4
      008541 2E 10            [ 1]  876 	jrsge	00117$
      008543 1E 11            [ 2]  877 	ldw	x, (0x11, sp)
      008545 1C 00 05         [ 2]  878 	addw	x, #0x0005
      008548 1F 11            [ 2]  879 	ldw	(0x11, sp), x
      00854A AE 01 90         [ 2]  880 	ldw	x, #0x0190
      00854D 1F 17            [ 2]  881 	ldw	(0x17, sp), x
      00854F 16 11            [ 2]  882 	ldw	y, (0x11, sp)
      008551 17 0B            [ 2]  883 	ldw	(0x0b, sp), y
      008553                        884 00117$:
                                    885 ;	main.c: 61: if(w==0&&q==128&&ustavka>200) ustavka=ustavka-5,count=400,lcd=ustavka;
      008553 1E 15            [ 2]  886 	ldw	x, (0x15, sp)
      008555 26 1E            [ 1]  887 	jrne	00121$
      008557 1E 13            [ 2]  888 	ldw	x, (0x13, sp)
      008559 A3 00 80         [ 2]  889 	cpw	x, #0x0080
      00855C 26 17            [ 1]  890 	jrne	00121$
      00855E 1E 11            [ 2]  891 	ldw	x, (0x11, sp)
      008560 A3 00 C8         [ 2]  892 	cpw	x, #0x00c8
      008563 2D 10            [ 1]  893 	jrsle	00121$
      008565 1E 11            [ 2]  894 	ldw	x, (0x11, sp)
      008567 1D 00 05         [ 2]  895 	subw	x, #0x0005
      00856A 1F 11            [ 2]  896 	ldw	(0x11, sp), x
      00856C AE 01 90         [ 2]  897 	ldw	x, #0x0190
      00856F 1F 17            [ 2]  898 	ldw	(0x17, sp), x
      008571 16 11            [ 2]  899 	ldw	y, (0x11, sp)
      008573 17 0B            [ 2]  900 	ldw	(0x0b, sp), y
      008575                        901 00121$:
                                    902 ;	main.c: 62: q=w;
      008575 16 15            [ 2]  903 	ldw	y, (0x15, sp)
      008577 17 13            [ 2]  904 	ldw	(0x13, sp), y
                                    905 ;	main.c: 54: for(period=0;period<100;period++)
      008579 1E 09            [ 2]  906 	ldw	x, (0x09, sp)
      00857B 5C               [ 2]  907 	incw	x
      00857C 1F 09            [ 2]  908 	ldw	(0x09, sp), x
      00857E 1E 09            [ 2]  909 	ldw	x, (0x09, sp)
      008580 A3 00 64         [ 2]  910 	cpw	x, #0x0064
      008583 2E 03            [ 1]  911 	jrsge	00239$
      008585 CC 84 DF         [ 2]  912 	jp	00128$
      008588                        913 00239$:
                                    914 ;	main.c: 64: bit_l(PE_ODR,0);
      008588 72 11 50 14      [ 1]  915 	bres	0x5014, #0
                                    916 ;	main.c: 65: count--;
      00858C 1E 17            [ 2]  917 	ldw	x, (0x17, sp)
      00858E 5A               [ 2]  918 	decw	x
      00858F 1F 17            [ 2]  919 	ldw	(0x17, sp), x
      008591 CC 83 E2         [ 2]  920 	jp	00126$
      008594 5B 22            [ 2]  921 	addw	sp, #34
      008596 81               [ 4]  922 	ret
                                    923 	.area CODE
                                    924 	.area INITIALIZER
      008F2A                        925 __xinit__q:
      008F2A 00 00                  926 	.dw #0x0000
                                    927 	.area CABS (ABS)
