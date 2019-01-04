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
                                     13 	.globl _ADC_ch_1
                                     14 	.globl _ADC_ch_0
                                     15 	.globl _gpio_init
                                     16 	.globl _Init_HSI
                                     17 	.globl _Init_HSE
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
      008094 D6 82 2E         [ 1]   94 	ld	a, (s_INITIALIZER - 1, x)
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
      008080 CC 81 8E         [ 2]  108 	jp	_main
                                    109 ;	return from main will return to caller
                                    110 ;--------------------------------------------------------
                                    111 ; code
                                    112 ;--------------------------------------------------------
                                    113 	.area CODE
                                    114 ;	inc/clk_init.h: 7: void Init_HSE(){    
                                    115 ;	-----------------------------------------
                                    116 ;	 function Init_HSE
                                    117 ;	-----------------------------------------
      0080A0                        118 _Init_HSE:
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
                                    144 ;	inc/clk_init.h: 15: CLK_CCOR=0; // CLK_CCOR|=(1<<2)|(1<<0);
      0080C7 35 00 50 C9      [ 1]  145 	mov	0x50c9+0, #0x00
      0080CB 81               [ 4]  146 	ret
                                    147 ;	inc/clk_init.h: 18: void Init_HSI()
                                    148 ;	-----------------------------------------
                                    149 ;	 function Init_HSI
                                    150 ;	-----------------------------------------
      0080CC                        151 _Init_HSI:
                                    152 ;	inc/clk_init.h: 20: CLK_ICKR = 0; // Сбрасываем регистр внутреннего тактирования
      0080CC 35 00 50 C0      [ 1]  153 	mov	0x50c0+0, #0x00
                                    154 ;	inc/clk_init.h: 21: CLK_ICKR|=(1<<0); // Включаем внутренний генератор HSI
      0080D0 72 10 50 C0      [ 1]  155 	bset	0x50c0, #0
                                    156 ;	inc/clk_init.h: 22: CLK_ECKR = 0; // Отключаем внешний генератор
      0080D4 35 00 50 C1      [ 1]  157 	mov	0x50c1+0, #0x00
                                    158 ;	inc/clk_init.h: 23: while ((CLK_ICKR&(1<<1))== 0); // Ждём стабилизации внутреннего генератора
      0080D8                        159 00101$:
      0080D8 AE 50 C0         [ 2]  160 	ldw	x, #0x50c0
      0080DB F6               [ 1]  161 	ld	a, (x)
      0080DC A5 02            [ 1]  162 	bcp	a, #0x02
      0080DE 27 F8            [ 1]  163 	jreq	00101$
                                    164 ;	inc/clk_init.h: 24: CLK_CKDIVR = 0; // Устанавливаем максимальную частоту
      0080E0 35 00 50 C6      [ 1]  165 	mov	0x50c6+0, #0x00
                                    166 ;	inc/clk_init.h: 25: CLK_CCOR = 0; // Выключаем CCO.
      0080E4 35 00 50 C9      [ 1]  167 	mov	0x50c9+0, #0x00
                                    168 ;	inc/clk_init.h: 26: CLK_HSITRIMR = 0; // Turn off any HSIU trimming.
      0080E8 35 00 50 CC      [ 1]  169 	mov	0x50cc+0, #0x00
                                    170 ;	inc/clk_init.h: 27: CLK_SWIMCCR = 0; // Set SWIM to run at clock / 2.
      0080EC 35 00 50 CD      [ 1]  171 	mov	0x50cd+0, #0x00
                                    172 ;	inc/clk_init.h: 28: CLK_SWR = 0xe1; // Используем HSI в качестве источника тактиров
      0080F0 35 E1 50 C4      [ 1]  173 	mov	0x50c4+0, #0xe1
                                    174 ;	inc/clk_init.h: 29: CLK_SWCR = 0; // Сброс флага переключения генераторов
      0080F4 35 00 50 C5      [ 1]  175 	mov	0x50c5+0, #0x00
                                    176 ;	inc/clk_init.h: 30: CLK_SWCR= CLK_SWCR_SWEN; // Включаем переключение на HSI
      0080F8 35 02 50 C5      [ 1]  177 	mov	0x50c5+0, #0x02
                                    178 ;	inc/clk_init.h: 31: while ((CLK_SWCR&(1<<0)) != 0); // Пауза, пока произойдёт переключение(CLK_SWCR_SWBSY != 0)
      0080FC                        179 00104$:
      0080FC AE 50 C5         [ 2]  180 	ldw	x, #0x50c5
      0080FF F6               [ 1]  181 	ld	a, (x)
      008100 44               [ 1]  182 	srl	a
      008101 25 F9            [ 1]  183 	jrc	00104$
      008103 81               [ 4]  184 	ret
                                    185 ;	inc/gpio_init.h: 24: void gpio_init(void)
                                    186 ;	-----------------------------------------
                                    187 ;	 function gpio_init
                                    188 ;	-----------------------------------------
      008104                        189 _gpio_init:
                                    190 ;	inc/gpio_init.h: 27: PA_DDR = 0xFF;                                                        //_______PORT_IN
      008104 35 FF 50 02      [ 1]  191 	mov	0x5002+0, #0xff
                                    192 ;	inc/gpio_init.h: 28: PA_CR1 = 0xFF;                                                       //_______DDR________________CR1______________CR2___________FUNCTION  
      008108 35 FF 50 03      [ 1]  193 	mov	0x5003+0, #0xff
                                    194 ;	inc/gpio_init.h: 29: PA_CR2 = 0x00;                                                      //_______0__________________0________________0_____________bez podtiyzhki,bez prerbIvanii 
      00810C 35 00 50 04      [ 1]  195 	mov	0x5004+0, #0x00
                                    196 ;	inc/gpio_init.h: 31: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
      008110 35 00 50 07      [ 1]  197 	mov	0x5007+0, #0x00
                                    198 ;	inc/gpio_init.h: 32: PB_CR1 = 0x00;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
      008114 35 00 50 08      [ 1]  199 	mov	0x5008+0, #0x00
                                    200 ;	inc/gpio_init.h: 33: PB_CR2 = 0x00;                                                      //_______PORT_OUT
      008118 35 00 50 09      [ 1]  201 	mov	0x5009+0, #0x00
                                    202 ;	inc/gpio_init.h: 35: PC_DDR = 0xFF;                                                        //_______1__________________0________________0_____________otkritiy stok
      00811C 35 FF 50 0C      [ 1]  203 	mov	0x500c+0, #0xff
                                    204 ;	inc/gpio_init.h: 36: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
      008120 35 FF 50 0D      [ 1]  205 	mov	0x500d+0, #0xff
                                    206 ;	inc/gpio_init.h: 37: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
      008124 35 00 50 0E      [ 1]  207 	mov	0x500e+0, #0x00
                                    208 ;	inc/gpio_init.h: 39: PD_DDR = 0x00;   
      008128 35 00 50 11      [ 1]  209 	mov	0x5011+0, #0x00
                                    210 ;	inc/gpio_init.h: 40: PD_CR1 = 0x00;  
      00812C 35 00 50 12      [ 1]  211 	mov	0x5012+0, #0x00
                                    212 ;	inc/gpio_init.h: 41: PD_CR2 = 0x00; 
      008130 35 00 50 13      [ 1]  213 	mov	0x5013+0, #0x00
                                    214 ;	inc/gpio_init.h: 43: PE_DDR = 0xFF;   
      008134 35 FF 50 16      [ 1]  215 	mov	0x5016+0, #0xff
                                    216 ;	inc/gpio_init.h: 44: PE_CR1 = 0xFF;  
      008138 35 FF 50 17      [ 1]  217 	mov	0x5017+0, #0xff
                                    218 ;	inc/gpio_init.h: 45: PE_CR2 = 0x00; 
      00813C 35 00 50 18      [ 1]  219 	mov	0x5018+0, #0x00
                                    220 ;	inc/gpio_init.h: 47: PF_DDR = 0xFF;   
      008140 35 FF 50 1B      [ 1]  221 	mov	0x501b+0, #0xff
                                    222 ;	inc/gpio_init.h: 48: PF_CR1 = 0xFF;  
      008144 35 FF 50 1C      [ 1]  223 	mov	0x501c+0, #0xff
                                    224 ;	inc/gpio_init.h: 49: PF_CR2 = 0x00; 
      008148 35 00 50 1D      [ 1]  225 	mov	0x501d+0, #0x00
      00814C 81               [ 4]  226 	ret
                                    227 ;	inc/ADC.h: 51: int ADC_ch_0(void){
                                    228 ;	-----------------------------------------
                                    229 ;	 function ADC_ch_0
                                    230 ;	-----------------------------------------
      00814D                        231 _ADC_ch_0:
                                    232 ;	inc/ADC.h: 53: ADC_CSR_CH2;           //Выбераем канал
      00814D AE 54 00         [ 2]  233 	ldw	x, #0x5400
      008150 F6               [ 1]  234 	ld	a, (x)
      008151 AA 02            [ 1]  235 	or	a, #0x02
      008153 F7               [ 1]  236 	ld	(x), a
                                    237 ;	inc/ADC.h: 57: ADC_CR1_ADON_ON;       //Первый запуск ADC
      008154 72 10 54 01      [ 1]  238 	bset	0x5401, #0
                                    239 ;	inc/ADC.h: 62: data=ADC_DRH;
      008158 AE 54 04         [ 2]  240 	ldw	x, #0x5404
      00815B F6               [ 1]  241 	ld	a, (x)
      00815C 5F               [ 1]  242 	clrw	x
      00815D 97               [ 1]  243 	ld	xl, a
                                    244 ;	inc/ADC.h: 64: return data;
      00815E 81               [ 4]  245 	ret
                                    246 ;	inc/ADC.h: 66: int ADC_ch_1(void){
                                    247 ;	-----------------------------------------
                                    248 ;	 function ADC_ch_1
                                    249 ;	-----------------------------------------
      00815F                        250 _ADC_ch_1:
                                    251 ;	inc/ADC.h: 68: ADC_CSR_CH3;           //Выбераем канал
      00815F AE 54 00         [ 2]  252 	ldw	x, #0x5400
      008162 F6               [ 1]  253 	ld	a, (x)
      008163 AA 03            [ 1]  254 	or	a, #0x03
      008165 F7               [ 1]  255 	ld	(x), a
                                    256 ;	inc/ADC.h: 72: ADC_CR1_ADON_ON;       //Первый запуск ADC
      008166 72 10 54 01      [ 1]  257 	bset	0x5401, #0
                                    258 ;	inc/ADC.h: 77: data=ADC_DRH;
      00816A AE 54 04         [ 2]  259 	ldw	x, #0x5404
      00816D F6               [ 1]  260 	ld	a, (x)
      00816E 5F               [ 1]  261 	clrw	x
      00816F 97               [ 1]  262 	ld	xl, a
                                    263 ;	inc/ADC.h: 79: return data;
      008170 81               [ 4]  264 	ret
                                    265 ;	main.c: 5: void delay(int t)
                                    266 ;	-----------------------------------------
                                    267 ;	 function delay
                                    268 ;	-----------------------------------------
      008171                        269 _delay:
      008171 52 02            [ 2]  270 	sub	sp, #2
                                    271 ;	main.c: 8: for(i=0;i<t;i++)
      008173 5F               [ 1]  272 	clrw	x
      008174                        273 00107$:
      008174 13 05            [ 2]  274 	cpw	x, (0x05, sp)
      008176 2E 13            [ 1]  275 	jrsge	00109$
                                    276 ;	main.c: 10: for(s=0;s<1512;s++)
      008178 90 AE 05 E8      [ 2]  277 	ldw	y, #0x05e8
      00817C 17 01            [ 2]  278 	ldw	(0x01, sp), y
      00817E                        279 00105$:
      00817E 16 01            [ 2]  280 	ldw	y, (0x01, sp)
      008180 90 5A            [ 2]  281 	decw	y
      008182 17 01            [ 2]  282 	ldw	(0x01, sp), y
      008184 90 5D            [ 2]  283 	tnzw	y
      008186 26 F6            [ 1]  284 	jrne	00105$
                                    285 ;	main.c: 8: for(i=0;i<t;i++)
      008188 5C               [ 1]  286 	incw	x
      008189 20 E9            [ 2]  287 	jra	00107$
      00818B                        288 00109$:
      00818B 5B 02            [ 2]  289 	addw	sp, #2
      00818D 81               [ 4]  290 	ret
                                    291 ;	main.c: 16: void main(void)
                                    292 ;	-----------------------------------------
                                    293 ;	 function main
                                    294 ;	-----------------------------------------
      00818E                        295 _main:
                                    296 ;	main.c: 19: Init_HSE();
      00818E CD 80 A0         [ 4]  297 	call	_Init_HSE
                                    298 ;	main.c: 20: gpio_init();
      008191 CD 81 04         [ 4]  299 	call	_gpio_init
                                    300 ;	main.c: 22: ADC_CR1_SPSEL8;  //Делитель на 18            
      008194 AE 54 01         [ 2]  301 	ldw	x, #0x5401
      008197 F6               [ 1]  302 	ld	a, (x)
      008198 AA 40            [ 1]  303 	or	a, #0x40
      00819A F7               [ 1]  304 	ld	(x), a
                                    305 ;	main.c: 23: ADC_TDRL_DIS(5);       //Отключаем тригер Шмидта
      00819B AE 54 07         [ 2]  306 	ldw	x, #0x5407
      00819E F6               [ 1]  307 	ld	a, (x)
      00819F AA 20            [ 1]  308 	or	a, #0x20
      0081A1 F7               [ 1]  309 	ld	(x), a
                                    310 ;	main.c: 24: ADC_TDRL_DIS(6);       //Отключаем тригер Шмидта
      0081A2 AE 54 07         [ 2]  311 	ldw	x, #0x5407
      0081A5 F6               [ 1]  312 	ld	a, (x)
      0081A6 AA 40            [ 1]  313 	or	a, #0x40
      0081A8 F7               [ 1]  314 	ld	(x), a
                                    315 ;	main.c: 25: ADC_CR2_ALIGN_LEFT;    //Выравнивание по левому краю
      0081A9 AE 54 02         [ 2]  316 	ldw	x, #0x5402
      0081AC F6               [ 1]  317 	ld	a, (x)
      0081AD A4 F7            [ 1]  318 	and	a, #0xf7
      0081AF F7               [ 1]  319 	ld	(x), a
                                    320 ;	main.c: 26: ADC_CR1_ADON_ON;       //Первый запуск ADC
      0081B0 72 10 54 01      [ 1]  321 	bset	0x5401, #0
                                    322 ;	main.c: 28: while(1)
      0081B4                        323 00108$:
                                    324 ;	main.c: 31: ADC_CSR&=~((1<<3)|(1<<2)|(1<<1)|(1<<0));
      0081B4 AE 54 00         [ 2]  325 	ldw	x, #0x5400
      0081B7 F6               [ 1]  326 	ld	a, (x)
      0081B8 A4 F0            [ 1]  327 	and	a, #0xf0
      0081BA F7               [ 1]  328 	ld	(x), a
                                    329 ;	main.c: 32: ADC_CSR_CH5;           //Выбераем канал
      0081BB AE 54 00         [ 2]  330 	ldw	x, #0x5400
      0081BE F6               [ 1]  331 	ld	a, (x)
      0081BF AA 05            [ 1]  332 	or	a, #0x05
      0081C1 F7               [ 1]  333 	ld	(x), a
                                    334 ;	main.c: 33: ADC_CR1_ADON_ON;       //запуск ADC
      0081C2 72 10 54 01      [ 1]  335 	bset	0x5401, #0
                                    336 ;	main.c: 34: while(!(ADC_CSR&(1<<7))) //ждем окончания преобразования
      0081C6                        337 00101$:
                                    338 ;	main.c: 31: ADC_CSR&=~((1<<3)|(1<<2)|(1<<1)|(1<<0));
      0081C6 AE 54 00         [ 2]  339 	ldw	x, #0x5400
      0081C9 F6               [ 1]  340 	ld	a, (x)
                                    341 ;	main.c: 34: while(!(ADC_CSR&(1<<7))) //ждем окончания преобразования
      0081CA 4D               [ 1]  342 	tnz	a
      0081CB 2B 03            [ 1]  343 	jrmi	00103$
                                    344 ;	main.c: 36: __asm__("nop\n");
      0081CD 9D               [ 1]  345 	nop
      0081CE 20 F6            [ 2]  346 	jra	00101$
      0081D0                        347 00103$:
                                    348 ;	main.c: 38: s=ADC_DRH; //первым читается значемый регистр в данном случае ADC_DRH
      0081D0 AE 54 04         [ 2]  349 	ldw	x, #0x5404
      0081D3 88               [ 1]  350 	push	a
      0081D4 F6               [ 1]  351 	ld	a, (x)
      0081D5 97               [ 1]  352 	ld	xl, a
      0081D6 84               [ 1]  353 	pop	a
      0081D7 02               [ 1]  354 	rlwa	x
      0081D8 4F               [ 1]  355 	clr	a
      0081D9 01               [ 1]  356 	rrwa	x
                                    357 ;	main.c: 40: ADC_CSR&=~(1<<7); //очищаем флаг окончания преобразования
      0081DA A4 7F            [ 1]  358 	and	a, #0x7f
      0081DC 90 AE 54 00      [ 2]  359 	ldw	y, #0x5400
      0081E0 90 F7            [ 1]  360 	ld	(y), a
                                    361 ;	main.c: 41: PC_ODR=s; 
      0081E2 9F               [ 1]  362 	ld	a, xl
      0081E3 AE 50 0A         [ 2]  363 	ldw	x, #0x500a
      0081E6 F7               [ 1]  364 	ld	(x), a
                                    365 ;	main.c: 42: delay(100);
      0081E7 4B 64            [ 1]  366 	push	#0x64
      0081E9 4B 00            [ 1]  367 	push	#0x00
      0081EB CD 81 71         [ 4]  368 	call	_delay
      0081EE 5B 02            [ 2]  369 	addw	sp, #2
                                    370 ;	main.c: 45: ADC_CSR&=~((1<<3)|(1<<2)|(1<<1)|(1<<0));
      0081F0 AE 54 00         [ 2]  371 	ldw	x, #0x5400
      0081F3 F6               [ 1]  372 	ld	a, (x)
      0081F4 A4 F0            [ 1]  373 	and	a, #0xf0
      0081F6 F7               [ 1]  374 	ld	(x), a
                                    375 ;	main.c: 46: ADC_CSR_CH6;           //Выбераем канал
      0081F7 AE 54 00         [ 2]  376 	ldw	x, #0x5400
      0081FA F6               [ 1]  377 	ld	a, (x)
      0081FB AA 06            [ 1]  378 	or	a, #0x06
      0081FD F7               [ 1]  379 	ld	(x), a
                                    380 ;	main.c: 47: ADC_CR1_ADON_ON;       //запуск ADC
      0081FE 72 10 54 01      [ 1]  381 	bset	0x5401, #0
                                    382 ;	main.c: 48: while(!(ADC_CSR&(1<<7)))
      008202                        383 00104$:
                                    384 ;	main.c: 31: ADC_CSR&=~((1<<3)|(1<<2)|(1<<1)|(1<<0));
      008202 AE 54 00         [ 2]  385 	ldw	x, #0x5400
      008205 F6               [ 1]  386 	ld	a, (x)
                                    387 ;	main.c: 48: while(!(ADC_CSR&(1<<7)))
      008206 4D               [ 1]  388 	tnz	a
      008207 2B 03            [ 1]  389 	jrmi	00106$
                                    390 ;	main.c: 50: __asm__("nop\n");
      008209 9D               [ 1]  391 	nop
      00820A 20 F6            [ 2]  392 	jra	00104$
      00820C                        393 00106$:
                                    394 ;	main.c: 52: s=ADC_DRH;
      00820C AE 54 04         [ 2]  395 	ldw	x, #0x5404
      00820F 88               [ 1]  396 	push	a
      008210 F6               [ 1]  397 	ld	a, (x)
      008211 97               [ 1]  398 	ld	xl, a
      008212 84               [ 1]  399 	pop	a
      008213 02               [ 1]  400 	rlwa	x
      008214 4F               [ 1]  401 	clr	a
      008215 01               [ 1]  402 	rrwa	x
                                    403 ;	main.c: 54: ADC_CSR&=~(1<<7);
      008216 A4 7F            [ 1]  404 	and	a, #0x7f
      008218 90 AE 54 00      [ 2]  405 	ldw	y, #0x5400
      00821C 90 F7            [ 1]  406 	ld	(y), a
                                    407 ;	main.c: 55: PC_ODR=s; 
      00821E 9F               [ 1]  408 	ld	a, xl
      00821F AE 50 0A         [ 2]  409 	ldw	x, #0x500a
      008222 F7               [ 1]  410 	ld	(x), a
                                    411 ;	main.c: 56: delay(100); 
      008223 4B 64            [ 1]  412 	push	#0x64
      008225 4B 00            [ 1]  413 	push	#0x00
      008227 CD 81 71         [ 4]  414 	call	_delay
      00822A 5B 02            [ 2]  415 	addw	sp, #2
                                    416 ;	main.c: 57: s=i=0;
      00822C 20 86            [ 2]  417 	jra	00108$
      00822E 81               [ 4]  418 	ret
                                    419 	.area CODE
                                    420 	.area INITIALIZER
                                    421 	.area CABS (ABS)
