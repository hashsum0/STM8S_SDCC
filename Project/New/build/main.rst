                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 3.6.9 #10207 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module main
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _main
                                     12 	.globl _EXTI_PORTC_IRQHandler
                                     13 	.globl _TIM2_OVR_UIF
                                     14 	.globl _delay
                                     15 	.globl _DelayUs
                                     16 	.globl _resive_ir
                                     17 	.globl _DelayMs
                                     18 	.globl _IR_dec_init
                                     19 	.globl _GPIO_init
                                     20 	.globl _clk_init_HSI
                                     21 	.globl _clk_init_HSE
                                     22 	.globl _i
                                     23 	.globl _flag
                                     24 ;--------------------------------------------------------
                                     25 ; ram data
                                     26 ;--------------------------------------------------------
                                     27 	.area DATA
      000001                         28 _resive_ir_oldcode_1_20:
      000001                         29 	.ds 2
                                     30 ;--------------------------------------------------------
                                     31 ; ram data
                                     32 ;--------------------------------------------------------
                                     33 	.area INITIALIZED
      000003                         34 _flag::
      000003                         35 	.ds 2
      000005                         36 _i::
      000005                         37 	.ds 2
                                     38 ;--------------------------------------------------------
                                     39 ; Stack segment in internal ram 
                                     40 ;--------------------------------------------------------
                                     41 	.area	SSEG
      FFFFFF                         42 __start__stack:
      FFFFFF                         43 	.ds	1
                                     44 
                                     45 ;--------------------------------------------------------
                                     46 ; absolute external ram data
                                     47 ;--------------------------------------------------------
                                     48 	.area DABS (ABS)
                                     49 ;--------------------------------------------------------
                                     50 ; interrupt vector 
                                     51 ;--------------------------------------------------------
                                     52 	.area HOME
      008000                         53 __interrupt_vect:
      008000 82 00 80 43             54 	int s_GSINIT ; reset
      008004 82 00 00 00             55 	int 0x0000 ; trap
      008008 82 00 00 00             56 	int 0x0000 ; int0
      00800C 82 00 00 00             57 	int 0x0000 ; int1
      008010 82 00 00 00             58 	int 0x0000 ; int2
      008014 82 00 00 00             59 	int 0x0000 ; int3
      008018 82 00 00 00             60 	int 0x0000 ; int4
      00801C 82 00 81 E6             61 	int _EXTI_PORTC_IRQHandler ; int5
      008020 82 00 00 00             62 	int 0x0000 ; int6
      008024 82 00 00 00             63 	int 0x0000 ; int7
      008028 82 00 00 00             64 	int 0x0000 ; int8
      00802C 82 00 00 00             65 	int 0x0000 ; int9
      008030 82 00 00 00             66 	int 0x0000 ; int10
      008034 82 00 00 00             67 	int 0x0000 ; int11
      008038 82 00 00 00             68 	int 0x0000 ; int12
      00803C 82 00 81 CA             69 	int _TIM2_OVR_UIF ; int13
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
      008043 AE 00 02         [ 2]   80 	ldw x, #l_DATA
      008046 27 07            [ 1]   81 	jreq	00002$
      008048                         82 00001$:
      008048 72 4F 00 00      [ 1]   83 	clr (s_DATA - 1, x)
      00804C 5A               [ 2]   84 	decw x
      00804D 26 F9            [ 1]   85 	jrne	00001$
      00804F                         86 00002$:
      00804F AE 00 04         [ 2]   87 	ldw	x, #l_INITIALIZER
      008052 27 09            [ 1]   88 	jreq	00004$
      008054                         89 00003$:
      008054 D6 82 A6         [ 1]   90 	ld	a, (s_INITIALIZER - 1, x)
      008057 D7 00 02         [ 1]   91 	ld	(s_INITIALIZED - 1, x), a
      00805A 5A               [ 2]   92 	decw	x
      00805B 26 F7            [ 1]   93 	jrne	00003$
      00805D                         94 00004$:
                                     95 ; stm8_genXINIT() end
                                     96 ;	inc/IR_decoder.h: 39: static int oldcode = 0;
      00805D 5F               [ 1]   97 	clrw	x
      00805E CF 00 01         [ 2]   98 	ldw	_resive_ir_oldcode_1_20+0, x
                                     99 	.area GSFINAL
      008061 CC 80 40         [ 2]  100 	jp	__sdcc_program_startup
                                    101 ;--------------------------------------------------------
                                    102 ; Home
                                    103 ;--------------------------------------------------------
                                    104 	.area HOME
                                    105 	.area HOME
      008040                        106 __sdcc_program_startup:
      008040 CC 81 F5         [ 2]  107 	jp	_main
                                    108 ;	return from main will return to caller
                                    109 ;--------------------------------------------------------
                                    110 ; code
                                    111 ;--------------------------------------------------------
                                    112 	.area CODE
                                    113 ;	inc/clk_init.h: 7: void clk_init_HSE(void){    
                                    114 ;	-----------------------------------------
                                    115 ;	 function clk_init_HSE
                                    116 ;	-----------------------------------------
      008064                        117 _clk_init_HSE:
                                    118 ;	inc/clk_init.h: 8: CLK_ECKR|=CLK_ECKR_HSEEN;            
      008064 72 10 50 C1      [ 1]  119 	bset	20673, #0
                                    120 ;	inc/clk_init.h: 9: CLK_SWCR|=CLK_SWCR_SWEN;               
      008068 72 12 50 C5      [ 1]  121 	bset	20677, #1
                                    122 ;	inc/clk_init.h: 10: while((CLK_ECKR & CLK_ECKR_HSERDY) == 0) {} 
      00806C                        123 00101$:
      00806C C6 50 C1         [ 1]  124 	ld	a, 0x50c1
      00806F A5 02            [ 1]  125 	bcp	a, #0x02
      008071 27 F9            [ 1]  126 	jreq	00101$
                                    127 ;	inc/clk_init.h: 11: CLK_CKDIVR = 0;                    
      008073 35 00 50 C6      [ 1]  128 	mov	0x50c6+0, #0x00
                                    129 ;	inc/clk_init.h: 12: CLK_SWR = 0xB4;                    
      008077 35 B4 50 C4      [ 1]  130 	mov	0x50c4+0, #0xb4
                                    131 ;	inc/clk_init.h: 13: while ((CLK_SWCR & CLK_SWCR_SWIF) == 0){}
      00807B                        132 00104$:
      00807B C6 50 C5         [ 1]  133 	ld	a, 0x50c5
      00807E A5 08            [ 1]  134 	bcp	a, #0x08
      008080 27 F9            [ 1]  135 	jreq	00104$
                                    136 ;	inc/clk_init.h: 14: CLK_CSSR|=CLK_CSSR_CSSEN;
      008082 72 10 50 C8      [ 1]  137 	bset	20680, #0
                                    138 ;	inc/clk_init.h: 16: }
      008086 81               [ 4]  139 	ret
                                    140 ;	inc/clk_init.h: 18: void clk_init_HSI()
                                    141 ;	-----------------------------------------
                                    142 ;	 function clk_init_HSI
                                    143 ;	-----------------------------------------
      008087                        144 _clk_init_HSI:
                                    145 ;	inc/clk_init.h: 20: CLK_ICKR = 0; // Сбрасываем регистр внутреннего тактирования
      008087 35 00 50 C0      [ 1]  146 	mov	0x50c0+0, #0x00
                                    147 ;	inc/clk_init.h: 21: CLK_ICKR|=(1<<0); // Включаем внутренний генератор HSI
      00808B 72 10 50 C0      [ 1]  148 	bset	20672, #0
                                    149 ;	inc/clk_init.h: 22: CLK_ECKR = 0; // Отключаем внешний генератор
      00808F 35 00 50 C1      [ 1]  150 	mov	0x50c1+0, #0x00
                                    151 ;	inc/clk_init.h: 23: while ((CLK_ICKR&(1<<1))== 0); // Ждём стабилизации внутреннего генератора
      008093                        152 00101$:
      008093 C6 50 C0         [ 1]  153 	ld	a, 0x50c0
      008096 A5 02            [ 1]  154 	bcp	a, #0x02
      008098 27 F9            [ 1]  155 	jreq	00101$
                                    156 ;	inc/clk_init.h: 24: CLK_CKDIVR = 0; // Устанавливаем максимальную частоту
      00809A 35 00 50 C6      [ 1]  157 	mov	0x50c6+0, #0x00
                                    158 ;	inc/clk_init.h: 25: CLK_CCOR = 0; // Выключаем CCO.
      00809E 35 00 50 C9      [ 1]  159 	mov	0x50c9+0, #0x00
                                    160 ;	inc/clk_init.h: 26: CLK_HSITRIMR = 0; // Turn off any HSIU trimming.
      0080A2 35 00 50 CC      [ 1]  161 	mov	0x50cc+0, #0x00
                                    162 ;	inc/clk_init.h: 27: CLK_SWIMCCR = 0; // Set SWIM to run at clock / 2.
      0080A6 35 00 50 CD      [ 1]  163 	mov	0x50cd+0, #0x00
                                    164 ;	inc/clk_init.h: 28: CLK_SWR = 0xe1; // Используем HSI в качестве источника тактиров
      0080AA 35 E1 50 C4      [ 1]  165 	mov	0x50c4+0, #0xe1
                                    166 ;	inc/clk_init.h: 29: CLK_SWCR = 0; // Сброс флага переключения генераторов
      0080AE 35 00 50 C5      [ 1]  167 	mov	0x50c5+0, #0x00
                                    168 ;	inc/clk_init.h: 30: CLK_SWCR= CLK_SWCR_SWEN; // Включаем переключение на HSI
      0080B2 35 02 50 C5      [ 1]  169 	mov	0x50c5+0, #0x02
                                    170 ;	inc/clk_init.h: 31: while ((CLK_SWCR&(1<<0)) != 0); // Пауза, пока произойдёт переключение(CLK_SWCR_SWBSY != 0)
      0080B6                        171 00104$:
      0080B6 C6 50 C5         [ 1]  172 	ld	a, 0x50c5
      0080B9 44               [ 1]  173 	srl	a
      0080BA 25 FA            [ 1]  174 	jrc	00104$
                                    175 ;	inc/clk_init.h: 33: }
      0080BC 81               [ 4]  176 	ret
                                    177 ;	inc/gpio_init.h: 1: void GPIO_init(void)
                                    178 ;	-----------------------------------------
                                    179 ;	 function GPIO_init
                                    180 ;	-----------------------------------------
      0080BD                        181 _GPIO_init:
                                    182 ;	inc/gpio_init.h: 4: PA_DDR = 0xFF;                                                        //_______PORT_IN
      0080BD 35 FF 50 02      [ 1]  183 	mov	0x5002+0, #0xff
                                    184 ;	inc/gpio_init.h: 5: PA_CR1 = 0xFF;                                                       //_______DDR________________CR1______________CR2___________FUNCTION  
      0080C1 35 FF 50 03      [ 1]  185 	mov	0x5003+0, #0xff
                                    186 ;	inc/gpio_init.h: 6: PA_CR2 = 0x00;                                                      //_______0__________________0________________0_____________bez podtiyzhki,bez prerbIvanii 
      0080C5 35 00 50 04      [ 1]  187 	mov	0x5004+0, #0x00
                                    188 ;	inc/gpio_init.h: 8: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
      0080C9 35 00 50 07      [ 1]  189 	mov	0x5007+0, #0x00
                                    190 ;	inc/gpio_init.h: 9: PB_CR1 = 0xff;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
      0080CD 35 FF 50 08      [ 1]  191 	mov	0x5008+0, #0xff
                                    192 ;	inc/gpio_init.h: 10: PB_CR2 = 0x00;                                                      //_______PORT_OUT
      0080D1 35 00 50 09      [ 1]  193 	mov	0x5009+0, #0x00
                                    194 ;	inc/gpio_init.h: 12: PC_DDR = 0x00;                                                        //_______1__________________0________________0_____________otkritiy stok
      0080D5 35 00 50 0C      [ 1]  195 	mov	0x500c+0, #0x00
                                    196 ;	inc/gpio_init.h: 13: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
      0080D9 35 FF 50 0D      [ 1]  197 	mov	0x500d+0, #0xff
                                    198 ;	inc/gpio_init.h: 14: PC_CR2 = 0xFF;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
      0080DD 35 FF 50 0E      [ 1]  199 	mov	0x500e+0, #0xff
                                    200 ;	inc/gpio_init.h: 16: PD_DDR = 0xFF;   
      0080E1 35 FF 50 11      [ 1]  201 	mov	0x5011+0, #0xff
                                    202 ;	inc/gpio_init.h: 17: PD_CR1 = 0xFF;  
      0080E5 35 FF 50 12      [ 1]  203 	mov	0x5012+0, #0xff
                                    204 ;	inc/gpio_init.h: 18: PD_CR2 = 0x00; 
      0080E9 35 00 50 13      [ 1]  205 	mov	0x5013+0, #0x00
                                    206 ;	inc/gpio_init.h: 20: PE_DDR = 0xFF;   
      0080ED 35 FF 50 16      [ 1]  207 	mov	0x5016+0, #0xff
                                    208 ;	inc/gpio_init.h: 21: PE_CR1 = 0xFF;  
      0080F1 35 FF 50 17      [ 1]  209 	mov	0x5017+0, #0xff
                                    210 ;	inc/gpio_init.h: 22: PE_CR2 = 0x00; 
      0080F5 35 00 50 18      [ 1]  211 	mov	0x5018+0, #0x00
                                    212 ;	inc/gpio_init.h: 24: PF_DDR = 0xFF;   
      0080F9 35 FF 50 1B      [ 1]  213 	mov	0x501b+0, #0xff
                                    214 ;	inc/gpio_init.h: 25: PF_CR1 = 0xFF;  
      0080FD 35 FF 50 1C      [ 1]  215 	mov	0x501c+0, #0xff
                                    216 ;	inc/gpio_init.h: 26: PF_CR2 = 0x00; 
      008101 35 00 50 1D      [ 1]  217 	mov	0x501d+0, #0x00
                                    218 ;	inc/gpio_init.h: 31: }
      008105 81               [ 4]  219 	ret
                                    220 ;	inc/IR_decoder.h: 9: void IR_dec_init()
                                    221 ;	-----------------------------------------
                                    222 ;	 function IR_dec_init
                                    223 ;	-----------------------------------------
      008106                        224 _IR_dec_init:
                                    225 ;	inc/IR_decoder.h: 11: PB_DDR&=~(1<<7);
      008106 72 1F 50 07      [ 1]  226 	bres	20487, #7
                                    227 ;	inc/IR_decoder.h: 12: }
      00810A 81               [ 4]  228 	ret
                                    229 ;	inc/IR_decoder.h: 13: void DelayMs(int t)
                                    230 ;	-----------------------------------------
                                    231 ;	 function DelayMs
                                    232 ;	-----------------------------------------
      00810B                        233 _DelayMs:
      00810B 52 02            [ 2]  234 	sub	sp, #2
                                    235 ;	inc/IR_decoder.h: 16: for(i=0;i<t;i++)
      00810D 5F               [ 1]  236 	clrw	x
      00810E                        237 00107$:
      00810E 13 05            [ 2]  238 	cpw	x, (0x05, sp)
      008110 2E 13            [ 1]  239 	jrsge	00109$
                                    240 ;	inc/IR_decoder.h: 18: for(s=0;s<5;s++)
      008112 90 AE 00 05      [ 2]  241 	ldw	y, #0x0005
      008116 17 01            [ 2]  242 	ldw	(0x01, sp), y
      008118                        243 00105$:
      008118 16 01            [ 2]  244 	ldw	y, (0x01, sp)
      00811A 90 5A            [ 2]  245 	decw	y
      00811C 17 01            [ 2]  246 	ldw	(0x01, sp), y
      00811E 90 5D            [ 2]  247 	tnzw	y
      008120 26 F6            [ 1]  248 	jrne	00105$
                                    249 ;	inc/IR_decoder.h: 16: for(i=0;i<t;i++)
      008122 5C               [ 1]  250 	incw	x
      008123 20 E9            [ 2]  251 	jra	00107$
      008125                        252 00109$:
                                    253 ;	inc/IR_decoder.h: 22: }
      008125 5B 02            [ 2]  254 	addw	sp, #2
      008127 81               [ 4]  255 	ret
                                    256 ;	inc/IR_decoder.h: 23: static char delta_t(void){
                                    257 ;	-----------------------------------------
                                    258 ;	 function delta_t
                                    259 ;	-----------------------------------------
      008128                        260 _delta_t:
      008128 52 02            [ 2]  261 	sub	sp, #2
                                    262 ;	inc/IR_decoder.h: 26: while(is_0());  // ���� ��������� 1 � �����
      00812A                        263 00101$:
      00812A C6 50 06         [ 1]  264 	ld	a, 0x5006
      00812D 4D               [ 1]  265 	tnz	a
      00812E 2A FA            [ 1]  266 	jrpl	00101$
      008130 A6 0A            [ 1]  267 	ld	a, #0x0a
      008132 6B 02            [ 1]  268 	ld	(0x02, sp), a
      008134                        269 00108$:
                                    270 ;	inc/IR_decoder.h: 27: for( ; i; i--){              // ���� �� ����������!!!
      008134 0D 02            [ 1]  271 	tnz	(0x02, sp)
      008136 27 13            [ 1]  272 	jreq	00106$
                                    273 ;	inc/IR_decoder.h: 28: DelayMs(100);         // ��������� �� 100 ���
      008138 4B 64            [ 1]  274 	push	#0x64
      00813A 4B 00            [ 1]  275 	push	#0x00
      00813C CD 81 0B         [ 4]  276 	call	_DelayMs
      00813F 5B 02            [ 2]  277 	addw	sp, #2
                                    278 ;	inc/IR_decoder.h: 30: if(is_0()) break;       // ���������� ����� ��� 0 �� �����
      008141 C6 50 06         [ 1]  279 	ld	a, 0x5006
      008144 4D               [ 1]  280 	tnz	a
      008145 2A 04            [ 1]  281 	jrpl	00106$
                                    282 ;	inc/IR_decoder.h: 27: for( ; i; i--){              // ���� �� ����������!!!
      008147 0A 02            [ 1]  283 	dec	(0x02, sp)
      008149 20 E9            [ 2]  284 	jra	00108$
      00814B                        285 00106$:
                                    286 ;	inc/IR_decoder.h: 32: return END_100us - i;        // ���������� ��������
      00814B 7B 02            [ 1]  287 	ld	a, (0x02, sp)
      00814D 6B 01            [ 1]  288 	ld	(0x01, sp), a
      00814F A6 0A            [ 1]  289 	ld	a, #0x0a
      008151 10 01            [ 1]  290 	sub	a, (0x01, sp)
                                    291 ;	inc/IR_decoder.h: 33: }
      008153 5B 02            [ 2]  292 	addw	sp, #2
      008155 81               [ 4]  293 	ret
                                    294 ;	inc/IR_decoder.h: 35: int resive_ir(void){
                                    295 ;	-----------------------------------------
                                    296 ;	 function resive_ir
                                    297 ;	-----------------------------------------
      008156                        298 _resive_ir:
      008156 52 03            [ 2]  299 	sub	sp, #3
                                    300 ;	inc/IR_decoder.h: 36: int code = 0;
      008158 5F               [ 1]  301 	clrw	x
                                    302 ;	inc/IR_decoder.h: 40: PD_ODR &= ~(1<<0);
      008159 72 11 50 0F      [ 1]  303 	bres	20495, #0
                                    304 ;	inc/IR_decoder.h: 41: while(is_1());// ������������� � ������� ��������
      00815D                        305 00101$:
      00815D C6 50 06         [ 1]  306 	ld	a, 0x5006
      008160 4D               [ 1]  307 	tnz	a
      008161 2B FA            [ 1]  308 	jrmi	00101$
                                    309 ;	inc/IR_decoder.h: 43: for(i = MAX_BIT_CNT; i; i--){
      008163 A6 24            [ 1]  310 	ld	a, #0x24
      008165 6B 03            [ 1]  311 	ld	(0x03, sp), a
      008167                        312 00112$:
                                    313 ;	inc/IR_decoder.h: 44: code =code<< 1;                  // ������� ��������� ����� ����
      008167 58               [ 2]  314 	sllw	x
                                    315 ;	inc/IR_decoder.h: 45: delta = delta_t();  // �������� ������������ 1 � �����
      008168 89               [ 2]  316 	pushw	x
      008169 CD 81 28         [ 4]  317 	call	_delta_t
      00816C 85               [ 2]  318 	popw	x
      00816D 90 5F            [ 1]  319 	clrw	y
      00816F 90 97            [ 1]  320 	ld	yl, a
      008171 17 01            [ 2]  321 	ldw	(0x01, sp), y
                                    322 ;	inc/IR_decoder.h: 46: if((delta >= END_100us)) break;                   // ���� ������� ����� - ����� ������            
      008173 89               [ 2]  323 	pushw	x
      008174 1E 03            [ 2]  324 	ldw	x, (0x03, sp)
      008176 A3 00 0A         [ 2]  325 	cpw	x, #0x000a
      008179 85               [ 2]  326 	popw	x
      00817A 2E 14            [ 1]  327 	jrsge	00108$
                                    328 ;	inc/IR_decoder.h: 47: if(delta > LOG0_100us) code |= 1;             // ���� ����� 1 - ������� � ��� 1      
      00817C 89               [ 2]  329 	pushw	x
      00817D 1E 03            [ 2]  330 	ldw	x, (0x03, sp)
      00817F A3 00 01         [ 2]  331 	cpw	x, #0x0001
      008182 85               [ 2]  332 	popw	x
      008183 2D 03            [ 1]  333 	jrsle	00113$
      008185 54               [ 2]  334 	srlw	x
      008186 99               [ 1]  335 	scf
      008187 59               [ 2]  336 	rlcw	x
      008188                        337 00113$:
                                    338 ;	inc/IR_decoder.h: 43: for(i = MAX_BIT_CNT; i; i--){
      008188 7B 03            [ 1]  339 	ld	a, (0x03, sp)
      00818A 4A               [ 1]  340 	dec	a
      00818B 6B 03            [ 1]  341 	ld	(0x03, sp), a
      00818D 4D               [ 1]  342 	tnz	a
      00818E 26 D7            [ 1]  343 	jrne	00112$
      008190                        344 00108$:
                                    345 ;	inc/IR_decoder.h: 49: if((code > 0) && (code < 5)) return oldcode;      
      008190 A3 00 00         [ 2]  346 	cpw	x, #0x0000
      008193 2D 0A            [ 1]  347 	jrsle	00110$
      008195 A3 00 05         [ 2]  348 	cpw	x, #0x0005
      008198 2E 05            [ 1]  349 	jrsge	00110$
      00819A CE 00 01         [ 2]  350 	ldw	x, _resive_ir_oldcode_1_20+0
      00819D 20 03            [ 2]  351 	jra	00114$
      00819F                        352 00110$:
                                    353 ;	inc/IR_decoder.h: 50: oldcode = code;      
      00819F CF 00 01         [ 2]  354 	ldw	_resive_ir_oldcode_1_20+0, x
                                    355 ;	inc/IR_decoder.h: 51: return code;                       // ����������, ��� ����������
      0081A2                        356 00114$:
                                    357 ;	inc/IR_decoder.h: 52: } 
      0081A2 5B 03            [ 2]  358 	addw	sp, #3
      0081A4 81               [ 4]  359 	ret
                                    360 ;	main.c: 11: void DelayUs(unsigned int msec)
                                    361 ;	-----------------------------------------
                                    362 ;	 function DelayUs
                                    363 ;	-----------------------------------------
      0081A5                        364 _DelayUs:
                                    365 ;	main.c: 14: for(x=0; x<=msec;x++);
      0081A5 5F               [ 1]  366 	clrw	x
      0081A6                        367 00103$:
      0081A6 5C               [ 1]  368 	incw	x
      0081A7 13 03            [ 2]  369 	cpw	x, (0x03, sp)
      0081A9 23 FB            [ 2]  370 	jrule	00103$
                                    371 ;	main.c: 15: }
      0081AB 81               [ 4]  372 	ret
                                    373 ;	main.c: 17: void delay(int sec)
                                    374 ;	-----------------------------------------
                                    375 ;	 function delay
                                    376 ;	-----------------------------------------
      0081AC                        377 _delay:
                                    378 ;	main.c: 20: for(t=0;t<=sec;t++)
      0081AC 5F               [ 1]  379 	clrw	x
      0081AD                        380 00103$:
      0081AD 13 03            [ 2]  381 	cpw	x, (0x03, sp)
      0081AF 2D 01            [ 1]  382 	jrsle	00116$
      0081B1 81               [ 4]  383 	ret
      0081B2                        384 00116$:
                                    385 ;	main.c: 22: DelayMs(25000);
      0081B2 89               [ 2]  386 	pushw	x
      0081B3 4B A8            [ 1]  387 	push	#0xa8
      0081B5 4B 61            [ 1]  388 	push	#0x61
      0081B7 CD 81 0B         [ 4]  389 	call	_DelayMs
      0081BA 5B 02            [ 2]  390 	addw	sp, #2
      0081BC 4B A8            [ 1]  391 	push	#0xa8
      0081BE 4B 61            [ 1]  392 	push	#0x61
      0081C0 CD 81 0B         [ 4]  393 	call	_DelayMs
      0081C3 5B 02            [ 2]  394 	addw	sp, #2
      0081C5 85               [ 2]  395 	popw	x
                                    396 ;	main.c: 20: for(t=0;t<=sec;t++)
      0081C6 5C               [ 1]  397 	incw	x
      0081C7 20 E4            [ 2]  398 	jra	00103$
                                    399 ;	main.c: 25: }
      0081C9 81               [ 4]  400 	ret
                                    401 ;	main.c: 27: INTERRUPT_HANDLER( TIM2_OVR_UIF, 13)           //обработчик прерывания по переполнению таймера 
                                    402 ;	-----------------------------------------
                                    403 ;	 function TIM2_OVR_UIF
                                    404 ;	-----------------------------------------
      0081CA                        405 _TIM2_OVR_UIF:
                                    406 ;	main.c: 29: if(flag==1) UPR_PIN_ON;                      
      0081CA CE 00 03         [ 2]  407 	ldw	x, _flag+0
      0081CD 5A               [ 2]  408 	decw	x
      0081CE 26 04            [ 1]  409 	jrne	00102$
      0081D0 72 14 50 0F      [ 1]  410 	bset	20495, #2
      0081D4                        411 00102$:
                                    412 ;	main.c: 30: TIM2_SR1&=~(1<<0);
      0081D4 72 11 53 04      [ 1]  413 	bres	21252, #0
                                    414 ;	main.c: 31: DelayUs(200);
      0081D8 4B C8            [ 1]  415 	push	#0xc8
      0081DA 4B 00            [ 1]  416 	push	#0x00
      0081DC CD 81 A5         [ 4]  417 	call	_DelayUs
      0081DF 5B 02            [ 2]  418 	addw	sp, #2
                                    419 ;	main.c: 32: UPR_PIN_OFF; 
      0081E1 72 15 50 0F      [ 1]  420 	bres	20495, #2
                                    421 ;	main.c: 33: }
      0081E5 80               [11]  422 	iret
                                    423 ;	main.c: 35: INTERRUPT_HANDLER( EXTI_PORTC_IRQHandler, 5) //обработчик прерывания датчика перехода нуля
                                    424 ;	-----------------------------------------
                                    425 ;	 function EXTI_PORTC_IRQHandler
                                    426 ;	-----------------------------------------
      0081E6                        427 _EXTI_PORTC_IRQHandler:
                                    428 ;	main.c: 38: TIM2_ARRH=i;           
      0081E6 C6 00 06         [ 1]  429 	ld	a, _i+1
      0081E9 C7 53 0F         [ 1]  430 	ld	0x530f, a
                                    431 ;	main.c: 39: TIM2_ARRL=0x00; 
      0081EC 35 00 53 10      [ 1]  432 	mov	0x5310+0, #0x00
                                    433 ;	main.c: 40: TIM2_CR1|=(1<<0);                       //CEN-запускаем таймер
      0081F0 72 10 53 00      [ 1]  434 	bset	21248, #0
                                    435 ;	main.c: 41: }
      0081F4 80               [11]  436 	iret
                                    437 ;	main.c: 44: int main( void )
                                    438 ;	-----------------------------------------
                                    439 ;	 function main
                                    440 ;	-----------------------------------------
      0081F5                        441 _main:
                                    442 ;	main.c: 48: clk_init_HSE();                                   //инициируем все что нужно
      0081F5 CD 80 64         [ 4]  443 	call	_clk_init_HSE
                                    444 ;	main.c: 49: __asm__("sim");
      0081F8 9B               [ 1]  445 	sim
                                    446 ;	main.c: 50: GPIO_init();
      0081F9 CD 80 BD         [ 4]  447 	call	_GPIO_init
                                    448 ;	main.c: 52: EXTI_CR1|=(1<<4); //PCIS=01
      0081FC 72 18 50 A0      [ 1]  449 	bset	20640, #4
                                    450 ;	main.c: 54: TIM2_PSCR=0x01;
      008200 35 01 53 0E      [ 1]  451 	mov	0x530e+0, #0x01
                                    452 ;	main.c: 55: TIM2_ARRH=0xd6;           
      008204 35 D6 53 0F      [ 1]  453 	mov	0x530f+0, #0xd6
                                    454 ;	main.c: 56: TIM2_ARRL=0x00;
      008208 35 00 53 10      [ 1]  455 	mov	0x5310+0, #0x00
                                    456 ;	main.c: 57: TIM2_CR1|=(1<<3); //OPM
      00820C 72 16 53 00      [ 1]  457 	bset	21248, #3
                                    458 ;	main.c: 58: TIM2_IER|=(1<<0); //UIE
      008210 C6 53 03         [ 1]  459 	ld	a, 0x5303
      008213 AA 01            [ 1]  460 	or	a, #0x01
      008215 C7 53 03         [ 1]  461 	ld	0x5303, a
                                    462 ;	main.c: 60: IR_dec_init();
      008218 CD 81 06         [ 4]  463 	call	_IR_dec_init
                                    464 ;	main.c: 61: __asm__("rim");
      00821B 9A               [ 1]  465 	rim
                                    466 ;	main.c: 63: delay(5);                                         //этот кусок кода-плавное включение света
      00821C 4B 05            [ 1]  467 	push	#0x05
      00821E 4B 00            [ 1]  468 	push	#0x00
      008220 CD 81 AC         [ 4]  469 	call	_delay
      008223 5B 02            [ 2]  470 	addw	sp, #2
                                    471 ;	main.c: 64: for(i=0xd6;i>0x6b;i--)
      008225 AE 00 D6         [ 2]  472 	ldw	x, #0x00d6
      008228 CF 00 05         [ 2]  473 	ldw	_i+0, x
      00822B                        474 00119$:
                                    475 ;	main.c: 66: if(i<0xd2)flag=1;
      00822B CE 00 05         [ 2]  476 	ldw	x, _i+0
      00822E A3 00 D2         [ 2]  477 	cpw	x, #0x00d2
      008231 2E 06            [ 1]  478 	jrsge	00102$
      008233 AE 00 01         [ 2]  479 	ldw	x, #0x0001
      008236 CF 00 03         [ 2]  480 	ldw	_flag+0, x
      008239                        481 00102$:
                                    482 ;	main.c: 67: DelayUs(30000);
      008239 4B 30            [ 1]  483 	push	#0x30
      00823B 4B 75            [ 1]  484 	push	#0x75
      00823D CD 81 A5         [ 4]  485 	call	_DelayUs
      008240 5B 02            [ 2]  486 	addw	sp, #2
                                    487 ;	main.c: 64: for(i=0xd6;i>0x6b;i--)
      008242 CE 00 05         [ 2]  488 	ldw	x, _i+0
      008245 5A               [ 2]  489 	decw	x
      008246 CF 00 05         [ 2]  490 	ldw	_i+0, x
      008249 A3 00 6B         [ 2]  491 	cpw	x, #0x006b
      00824C 2C DD            [ 1]  492 	jrsgt	00119$
                                    493 ;	main.c: 69: i=0x6b;
      00824E AE 00 6B         [ 2]  494 	ldw	x, #0x006b
      008251 CF 00 05         [ 2]  495 	ldw	_i+0, x
                                    496 ;	main.c: 71: while(1)
      008254                        497 00117$:
                                    498 ;	main.c: 75: code =resive_ir();
      008254 CD 81 56         [ 4]  499 	call	_resive_ir
      008257 51               [ 1]  500 	exgw	x, y
                                    501 ;	main.c: 77: if(code==UMENSHENIE)
      008258 90 A3 0C F2      [ 2]  502 	cpw	y, #0x0cf2
      00825C 26 1F            [ 1]  503 	jrne	00109$
                                    504 ;	main.c: 79: i=i+2;                     //увеличеваем значение для регистра предварительной загрузки
      00825E CE 00 05         [ 2]  505 	ldw	x, _i+0
      008261 5C               [ 1]  506 	incw	x
      008262 5C               [ 1]  507 	incw	x
                                    508 ;	main.c: 80: if(i>=0xd4)flag=0;         //если свет выключен то и упровление не нужно
      008263 CF 00 05         [ 2]  509 	ldw	_i+0, x
      008266 A3 00 D4         [ 2]  510 	cpw	x, #0x00d4
      008269 2F 04            [ 1]  511 	jrslt	00105$
      00826B 5F               [ 1]  512 	clrw	x
      00826C CF 00 03         [ 2]  513 	ldw	_flag+0, x
      00826F                        514 00105$:
                                    515 ;	main.c: 81: if(i>=0xd6)i=0xd6;         //если дальше увеличевать то лампа будет маргать т.к. мы залезем в другой полупериод
      00826F CE 00 05         [ 2]  516 	ldw	x, _i+0
      008272 A3 00 D6         [ 2]  517 	cpw	x, #0x00d6
      008275 2F 06            [ 1]  518 	jrslt	00109$
      008277 AE 00 D6         [ 2]  519 	ldw	x, #0x00d6
      00827A CF 00 05         [ 2]  520 	ldw	_i+0, x
      00827D                        521 00109$:
                                    522 ;	main.c: 84: if(code==UVILCHENIE)        //тоже самое только на оборот
      00827D 90 A3 0D F2      [ 2]  523 	cpw	y, #0x0df2
      008281 26 D1            [ 1]  524 	jrne	00117$
                                    525 ;	main.c: 87: i=i-2;
      008283 CE 00 05         [ 2]  526 	ldw	x, _i+0
      008286 5A               [ 2]  527 	decw	x
      008287 5A               [ 2]  528 	decw	x
                                    529 ;	main.c: 88: if(i<0xd6)flag=1;
      008288 CF 00 05         [ 2]  530 	ldw	_i+0, x
      00828B A3 00 D6         [ 2]  531 	cpw	x, #0x00d6
      00828E 2E 06            [ 1]  532 	jrsge	00111$
      008290 AE 00 01         [ 2]  533 	ldw	x, #0x0001
      008293 CF 00 03         [ 2]  534 	ldw	_flag+0, x
      008296                        535 00111$:
                                    536 ;	main.c: 89: if(i<=0x06)i=0x06;
      008296 CE 00 05         [ 2]  537 	ldw	x, _i+0
      008299 A3 00 06         [ 2]  538 	cpw	x, #0x0006
      00829C 2C B6            [ 1]  539 	jrsgt	00117$
      00829E AE 00 06         [ 2]  540 	ldw	x, #0x0006
      0082A1 CF 00 05         [ 2]  541 	ldw	_i+0, x
      0082A4 20 AE            [ 2]  542 	jra	00117$
                                    543 ;	main.c: 97: }
      0082A6 81               [ 4]  544 	ret
                                    545 	.area CODE
                                    546 	.area INITIALIZER
      0082A7                        547 __xinit__flag:
      0082A7 00 00                  548 	.dw #0x0000
      0082A9                        549 __xinit__i:
      0082A9 00 00                  550 	.dw #0x0000
                                    551 	.area CABS (ABS)
