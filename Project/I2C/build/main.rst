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
                                     12 	.globl _i2c_read_byte
                                     13 	.globl _i2c_write_byte
                                     14 	.globl _i2c_init
                                     15 	.globl _GPIO_init
                                     16 	.globl _clk_init_HSI
                                     17 	.globl _clk_init_HSE
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
                                     37 ;--------------------------------------------------------
                                     38 ; interrupt vector 
                                     39 ;--------------------------------------------------------
                                     40 	.area HOME
      008000                         41 __interrupt_vect:
      008000 82 00 80 07             42 	int s_GSINIT ; reset
                                     43 ;--------------------------------------------------------
                                     44 ; global & static initialisations
                                     45 ;--------------------------------------------------------
                                     46 	.area HOME
                                     47 	.area GSINIT
                                     48 	.area GSFINAL
                                     49 	.area GSINIT
      008007                         50 __sdcc_gs_init_startup:
      008007                         51 __sdcc_init_data:
                                     52 ; stm8_genXINIT() start
      008007 AE 00 00         [ 2]   53 	ldw x, #l_DATA
      00800A 27 07            [ 1]   54 	jreq	00002$
      00800C                         55 00001$:
      00800C 72 4F 00 00      [ 1]   56 	clr (s_DATA - 1, x)
      008010 5A               [ 2]   57 	decw x
      008011 26 F9            [ 1]   58 	jrne	00001$
      008013                         59 00002$:
      008013 AE 00 00         [ 2]   60 	ldw	x, #l_INITIALIZER
      008016 27 09            [ 1]   61 	jreq	00004$
      008018                         62 00003$:
      008018 D6 81 FA         [ 1]   63 	ld	a, (s_INITIALIZER - 1, x)
      00801B D7 00 00         [ 1]   64 	ld	(s_INITIALIZED - 1, x), a
      00801E 5A               [ 2]   65 	decw	x
      00801F 26 F7            [ 1]   66 	jrne	00003$
      008021                         67 00004$:
                                     68 ; stm8_genXINIT() end
                                     69 	.area GSFINAL
      008021 CC 80 04         [ 2]   70 	jp	__sdcc_program_startup
                                     71 ;--------------------------------------------------------
                                     72 ; Home
                                     73 ;--------------------------------------------------------
                                     74 	.area HOME
                                     75 	.area HOME
      008004                         76 __sdcc_program_startup:
      008004 CC 81 AC         [ 2]   77 	jp	_main
                                     78 ;	return from main will return to caller
                                     79 ;--------------------------------------------------------
                                     80 ; code
                                     81 ;--------------------------------------------------------
                                     82 	.area CODE
                                     83 ;	inc/clk_init.h: 7: void clk_init_HSE(void){    
                                     84 ;	-----------------------------------------
                                     85 ;	 function clk_init_HSE
                                     86 ;	-----------------------------------------
      008024                         87 _clk_init_HSE:
                                     88 ;	inc/clk_init.h: 8: CLK_ECKR|=CLK_ECKR_HSEEN;            
      008024 72 10 50 C1      [ 1]   89 	bset	20673, #0
                                     90 ;	inc/clk_init.h: 9: CLK_SWCR|=CLK_SWCR_SWEN;               
      008028 72 12 50 C5      [ 1]   91 	bset	20677, #1
                                     92 ;	inc/clk_init.h: 10: while((CLK_ECKR & CLK_ECKR_HSERDY) == 0) {} 
      00802C                         93 00101$:
      00802C C6 50 C1         [ 1]   94 	ld	a, 0x50c1
      00802F A5 02            [ 1]   95 	bcp	a, #0x02
      008031 27 F9            [ 1]   96 	jreq	00101$
                                     97 ;	inc/clk_init.h: 11: CLK_CKDIVR = 0;                    
      008033 35 00 50 C6      [ 1]   98 	mov	0x50c6+0, #0x00
                                     99 ;	inc/clk_init.h: 12: CLK_SWR = 0xB4;                    
      008037 35 B4 50 C4      [ 1]  100 	mov	0x50c4+0, #0xb4
                                    101 ;	inc/clk_init.h: 13: while ((CLK_SWCR & CLK_SWCR_SWIF) == 0){}
      00803B                        102 00104$:
      00803B C6 50 C5         [ 1]  103 	ld	a, 0x50c5
      00803E A5 08            [ 1]  104 	bcp	a, #0x08
      008040 27 F9            [ 1]  105 	jreq	00104$
                                    106 ;	inc/clk_init.h: 14: CLK_CSSR|=CLK_CSSR_CSSEN;
      008042 72 10 50 C8      [ 1]  107 	bset	20680, #0
                                    108 ;	inc/clk_init.h: 16: }
      008046 81               [ 4]  109 	ret
                                    110 ;	inc/clk_init.h: 18: void clk_init_HSI()
                                    111 ;	-----------------------------------------
                                    112 ;	 function clk_init_HSI
                                    113 ;	-----------------------------------------
      008047                        114 _clk_init_HSI:
                                    115 ;	inc/clk_init.h: 20: CLK_ICKR = 0; // Сбрасываем регистр внутреннего тактирования
      008047 35 00 50 C0      [ 1]  116 	mov	0x50c0+0, #0x00
                                    117 ;	inc/clk_init.h: 21: CLK_ICKR|=(1<<0); // Включаем внутренний генератор HSI
      00804B 72 10 50 C0      [ 1]  118 	bset	20672, #0
                                    119 ;	inc/clk_init.h: 22: CLK_ECKR = 0; // Отключаем внешний генератор
      00804F 35 00 50 C1      [ 1]  120 	mov	0x50c1+0, #0x00
                                    121 ;	inc/clk_init.h: 23: while ((CLK_ICKR&(1<<1))== 0); // Ждём стабилизации внутреннего генератора
      008053                        122 00101$:
      008053 C6 50 C0         [ 1]  123 	ld	a, 0x50c0
      008056 A5 02            [ 1]  124 	bcp	a, #0x02
      008058 27 F9            [ 1]  125 	jreq	00101$
                                    126 ;	inc/clk_init.h: 24: CLK_CKDIVR = 0; // Устанавливаем максимальную частоту
      00805A 35 00 50 C6      [ 1]  127 	mov	0x50c6+0, #0x00
                                    128 ;	inc/clk_init.h: 25: CLK_CCOR = 0; // Выключаем CCO.
      00805E 35 00 50 C9      [ 1]  129 	mov	0x50c9+0, #0x00
                                    130 ;	inc/clk_init.h: 26: CLK_HSITRIMR = 0; // Turn off any HSIU trimming.
      008062 35 00 50 CC      [ 1]  131 	mov	0x50cc+0, #0x00
                                    132 ;	inc/clk_init.h: 27: CLK_SWIMCCR = 0; // Set SWIM to run at clock / 2.
      008066 35 00 50 CD      [ 1]  133 	mov	0x50cd+0, #0x00
                                    134 ;	inc/clk_init.h: 28: CLK_SWR = 0xe1; // Используем HSI в качестве источника тактиров
      00806A 35 E1 50 C4      [ 1]  135 	mov	0x50c4+0, #0xe1
                                    136 ;	inc/clk_init.h: 29: CLK_SWCR = 0; // Сброс флага переключения генераторов
      00806E 35 00 50 C5      [ 1]  137 	mov	0x50c5+0, #0x00
                                    138 ;	inc/clk_init.h: 30: CLK_SWCR= CLK_SWCR_SWEN; // Включаем переключение на HSI
      008072 35 02 50 C5      [ 1]  139 	mov	0x50c5+0, #0x02
                                    140 ;	inc/clk_init.h: 31: while ((CLK_SWCR&(1<<0)) != 0); // Пауза, пока произойдёт переключение(CLK_SWCR_SWBSY != 0)
      008076                        141 00104$:
      008076 C6 50 C5         [ 1]  142 	ld	a, 0x50c5
      008079 44               [ 1]  143 	srl	a
      00807A 25 FA            [ 1]  144 	jrc	00104$
                                    145 ;	inc/clk_init.h: 33: }
      00807C 81               [ 4]  146 	ret
                                    147 ;	inc/gpio_init.h: 1: void GPIO_init(void)
                                    148 ;	-----------------------------------------
                                    149 ;	 function GPIO_init
                                    150 ;	-----------------------------------------
      00807D                        151 _GPIO_init:
                                    152 ;	inc/gpio_init.h: 4: PA_DDR = 0xFF;                                                        //_______PORT_IN
      00807D 35 FF 50 02      [ 1]  153 	mov	0x5002+0, #0xff
                                    154 ;	inc/gpio_init.h: 5: PA_CR1 = 0xFF;                                                       //_______DDR________________CR1______________CR2___________FUNCTION  
      008081 35 FF 50 03      [ 1]  155 	mov	0x5003+0, #0xff
                                    156 ;	inc/gpio_init.h: 6: PA_CR2 = 0x00;                                                      //_______0__________________0________________0_____________bez podtiyzhki,bez prerbIvanii 
      008085 35 00 50 04      [ 1]  157 	mov	0x5004+0, #0x00
                                    158 ;	inc/gpio_init.h: 8: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
      008089 35 00 50 07      [ 1]  159 	mov	0x5007+0, #0x00
                                    160 ;	inc/gpio_init.h: 9: PB_CR1 = 0xff;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
      00808D 35 FF 50 08      [ 1]  161 	mov	0x5008+0, #0xff
                                    162 ;	inc/gpio_init.h: 10: PB_CR2 = 0x00;                                                      //_______PORT_OUT
      008091 35 00 50 09      [ 1]  163 	mov	0x5009+0, #0x00
                                    164 ;	inc/gpio_init.h: 12: PC_DDR = 0xFF;                                                        //_______1__________________0________________0_____________otkritiy stok
      008095 35 FF 50 0C      [ 1]  165 	mov	0x500c+0, #0xff
                                    166 ;	inc/gpio_init.h: 13: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
      008099 35 FF 50 0D      [ 1]  167 	mov	0x500d+0, #0xff
                                    168 ;	inc/gpio_init.h: 14: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
      00809D 35 00 50 0E      [ 1]  169 	mov	0x500e+0, #0x00
                                    170 ;	inc/gpio_init.h: 16: PD_DDR = 0xFF;   
      0080A1 35 FF 50 11      [ 1]  171 	mov	0x5011+0, #0xff
                                    172 ;	inc/gpio_init.h: 17: PD_CR1 = 0xFF;  
      0080A5 35 FF 50 12      [ 1]  173 	mov	0x5012+0, #0xff
                                    174 ;	inc/gpio_init.h: 18: PD_CR2 = 0x00; 
      0080A9 35 00 50 13      [ 1]  175 	mov	0x5013+0, #0x00
                                    176 ;	inc/gpio_init.h: 20: PE_DDR = 0xFF;   
      0080AD 35 FF 50 16      [ 1]  177 	mov	0x5016+0, #0xff
                                    178 ;	inc/gpio_init.h: 21: PE_CR1 = 0xFF;  
      0080B1 35 FF 50 17      [ 1]  179 	mov	0x5017+0, #0xff
                                    180 ;	inc/gpio_init.h: 22: PE_CR2 = 0x00; 
      0080B5 35 00 50 18      [ 1]  181 	mov	0x5018+0, #0x00
                                    182 ;	inc/gpio_init.h: 24: PF_DDR = 0xFF;   
      0080B9 35 FF 50 1B      [ 1]  183 	mov	0x501b+0, #0xff
                                    184 ;	inc/gpio_init.h: 25: PF_CR1 = 0xFF;  
      0080BD 35 FF 50 1C      [ 1]  185 	mov	0x501c+0, #0xff
                                    186 ;	inc/gpio_init.h: 26: PF_CR2 = 0x00; 
      0080C1 35 00 50 1D      [ 1]  187 	mov	0x501d+0, #0x00
                                    188 ;	inc/gpio_init.h: 31: }
      0080C5 81               [ 4]  189 	ret
                                    190 ;	inc/i2c.h: 56: void i2c_init() {
                                    191 ;	-----------------------------------------
                                    192 ;	 function i2c_init
                                    193 ;	-----------------------------------------
      0080C6                        194 _i2c_init:
                                    195 ;	inc/i2c.h: 57: I2C_FREQR |= (1 << 1);
      0080C6 72 12 52 12      [ 1]  196 	bset	21010, #1
                                    197 ;	inc/i2c.h: 58: I2C_CCRL = 0x0A; // 100kHz
      0080CA 35 0A 52 1B      [ 1]  198 	mov	0x521b+0, #0x0a
                                    199 ;	inc/i2c.h: 59: I2C_OARH |= (1 << 7); // 7-bit addressing
      0080CE 72 1E 52 14      [ 1]  200 	bset	21012, #7
                                    201 ;	inc/i2c.h: 60: I2C_CR1 |= I2C_CR1_PE;
      0080D2 72 10 52 10      [ 1]  202 	bset	21008, #0
                                    203 ;	inc/i2c.h: 61: }
      0080D6 81               [ 4]  204 	ret
                                    205 ;	inc/i2c.h: 63: void i2c_write_byte(unsigned int addr_dev, unsigned int addr_mem, unsigned int data){
                                    206 ;	-----------------------------------------
                                    207 ;	 function i2c_write_byte
                                    208 ;	-----------------------------------------
      0080D7                        209 _i2c_write_byte:
                                    210 ;	inc/i2c.h: 66: while ((I2C_SR3 & I2C_SR3_BUSY)); 
      0080D7                        211 00101$:
      0080D7 C6 52 19         [ 1]  212 	ld	a, 0x5219
      0080DA A5 02            [ 1]  213 	bcp	a, #0x02
      0080DC 26 F9            [ 1]  214 	jrne	00101$
                                    215 ;	inc/i2c.h: 67: I2C_CR2 |= I2C_CR2_START;
      0080DE 72 10 52 11      [ 1]  216 	bset	21009, #0
                                    217 ;	inc/i2c.h: 68: while (!(I2C_SR1 & I2C_SR1_SB));   
      0080E2                        218 00104$:
      0080E2 C6 52 17         [ 1]  219 	ld	a, 0x5217
      0080E5 44               [ 1]  220 	srl	a
      0080E6 24 FA            [ 1]  221 	jrnc	00104$
                                    222 ;	inc/i2c.h: 69: d=I2C_SR3;
      0080E8 AE 52 19         [ 2]  223 	ldw	x, #0x5219
      0080EB F6               [ 1]  224 	ld	a, (x)
                                    225 ;	inc/i2c.h: 71: I2C_DR = addr_dev;                    
      0080EC 7B 04            [ 1]  226 	ld	a, (0x04, sp)
      0080EE C7 52 16         [ 1]  227 	ld	0x5216, a
                                    228 ;	inc/i2c.h: 72: while (!(I2C_SR1 & I2C_SR1_ADDR));
      0080F1                        229 00107$:
      0080F1 C6 52 17         [ 1]  230 	ld	a, 0x5217
      0080F4 A5 02            [ 1]  231 	bcp	a, #0x02
      0080F6 27 F9            [ 1]  232 	jreq	00107$
                                    233 ;	inc/i2c.h: 73: d=I2C_SR3;
      0080F8 AE 52 19         [ 2]  234 	ldw	x, #0x5219
      0080FB F6               [ 1]  235 	ld	a, (x)
                                    236 ;	inc/i2c.h: 74: I2C_CR2 |= (1 << I2C_CR2_ACK);
      0080FC 72 18 52 11      [ 1]  237 	bset	21009, #4
                                    238 ;	inc/i2c.h: 76: while (!(I2C_SR1 & I2C_SR1_TXE));
      008100                        239 00110$:
      008100 C6 52 17         [ 1]  240 	ld	a, 0x5217
      008103 4D               [ 1]  241 	tnz	a
      008104 2A FA            [ 1]  242 	jrpl	00110$
                                    243 ;	inc/i2c.h: 77: I2C_DR = addr_mem;
      008106 7B 06            [ 1]  244 	ld	a, (0x06, sp)
      008108 C7 52 16         [ 1]  245 	ld	0x5216, a
                                    246 ;	inc/i2c.h: 79: while (!(I2C_SR1 & I2C_SR1_TXE));
      00810B                        247 00113$:
      00810B C6 52 17         [ 1]  248 	ld	a, 0x5217
      00810E 4D               [ 1]  249 	tnz	a
      00810F 2A FA            [ 1]  250 	jrpl	00113$
                                    251 ;	inc/i2c.h: 80: I2C_DR = data;
      008111 7B 08            [ 1]  252 	ld	a, (0x08, sp)
      008113 C7 52 16         [ 1]  253 	ld	0x5216, a
                                    254 ;	inc/i2c.h: 82: while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
      008116                        255 00117$:
                                    256 ;	inc/i2c.h: 68: while (!(I2C_SR1 & I2C_SR1_SB));   
      008116 C6 52 17         [ 1]  257 	ld	a, 0x5217
                                    258 ;	inc/i2c.h: 82: while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
      008119 4D               [ 1]  259 	tnz	a
      00811A 2B 04            [ 1]  260 	jrmi	00119$
      00811C A5 04            [ 1]  261 	bcp	a, #0x04
      00811E 27 F6            [ 1]  262 	jreq	00117$
      008120                        263 00119$:
                                    264 ;	inc/i2c.h: 83: I2C_CR2 |= I2C_CR2_STOP;       
      008120 72 12 52 11      [ 1]  265 	bset	21009, #1
                                    266 ;	inc/i2c.h: 84: while (I2C_SR3 & I2C_SR3_MSL);
      008124                        267 00120$:
      008124 C6 52 19         [ 1]  268 	ld	a, 0x5219
      008127 44               [ 1]  269 	srl	a
      008128 25 FA            [ 1]  270 	jrc	00120$
                                    271 ;	inc/i2c.h: 85: }
      00812A 81               [ 4]  272 	ret
                                    273 ;	inc/i2c.h: 87: int i2c_read_byte(unsigned int addr_dev,unsigned int addr_mem){
                                    274 ;	-----------------------------------------
                                    275 ;	 function i2c_read_byte
                                    276 ;	-----------------------------------------
      00812B                        277 _i2c_read_byte:
                                    278 ;	inc/i2c.h: 90: while ((I2C_SR3 & I2C_SR3_BUSY));
      00812B                        279 00101$:
      00812B C6 52 19         [ 1]  280 	ld	a, 0x5219
      00812E A5 02            [ 1]  281 	bcp	a, #0x02
      008130 26 F9            [ 1]  282 	jrne	00101$
                                    283 ;	inc/i2c.h: 91: I2C_CR2 |= I2C_CR2_START;
      008132 72 10 52 11      [ 1]  284 	bset	21009, #0
                                    285 ;	inc/i2c.h: 92: while (!(I2C_SR1 & I2C_SR1_SB));  
      008136                        286 00104$:
      008136 C6 52 17         [ 1]  287 	ld	a, 0x5217
      008139 44               [ 1]  288 	srl	a
      00813A 24 FA            [ 1]  289 	jrnc	00104$
                                    290 ;	inc/i2c.h: 93: d=I2C_SR3;
      00813C AE 52 19         [ 2]  291 	ldw	x, #0x5219
      00813F F6               [ 1]  292 	ld	a, (x)
                                    293 ;	inc/i2c.h: 95: I2C_DR = addr_dev;                    
      008140 7B 04            [ 1]  294 	ld	a, (0x04, sp)
      008142 90 97            [ 1]  295 	ld	yl, a
      008144 AE 52 16         [ 2]  296 	ldw	x, #0x5216
      008147 90 9F            [ 1]  297 	ld	a, yl
      008149 F7               [ 1]  298 	ld	(x), a
                                    299 ;	inc/i2c.h: 96: while (!(I2C_SR1 & I2C_SR1_ADDR));
      00814A                        300 00107$:
      00814A C6 52 17         [ 1]  301 	ld	a, 0x5217
      00814D A5 02            [ 1]  302 	bcp	a, #0x02
      00814F 27 F9            [ 1]  303 	jreq	00107$
                                    304 ;	inc/i2c.h: 97: d=I2C_SR3;
      008151 AE 52 19         [ 2]  305 	ldw	x, #0x5219
      008154 F6               [ 1]  306 	ld	a, (x)
                                    307 ;	inc/i2c.h: 99: while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
      008155                        308 00111$:
                                    309 ;	inc/i2c.h: 92: while (!(I2C_SR1 & I2C_SR1_SB));  
      008155 C6 52 17         [ 1]  310 	ld	a, 0x5217
                                    311 ;	inc/i2c.h: 99: while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
      008158 4D               [ 1]  312 	tnz	a
      008159 2B 04            [ 1]  313 	jrmi	00113$
      00815B A5 04            [ 1]  314 	bcp	a, #0x04
      00815D 27 F6            [ 1]  315 	jreq	00111$
      00815F                        316 00113$:
                                    317 ;	inc/i2c.h: 100: I2C_DR = addr_mem;              
      00815F 7B 06            [ 1]  318 	ld	a, (0x06, sp)
      008161 C7 52 16         [ 1]  319 	ld	0x5216, a
                                    320 ;	inc/i2c.h: 102: I2C_CR2 |=I2C_CR2_ACK;
      008164 72 14 52 11      [ 1]  321 	bset	21009, #2
                                    322 ;	inc/i2c.h: 103: I2C_CR2 |= I2C_CR2_START;
      008168 72 10 52 11      [ 1]  323 	bset	21009, #0
                                    324 ;	inc/i2c.h: 105: while (!(I2C_SR1 & I2C_SR1_SB));   
      00816C                        325 00114$:
      00816C C6 52 17         [ 1]  326 	ld	a, 0x5217
      00816F 44               [ 1]  327 	srl	a
      008170 24 FA            [ 1]  328 	jrnc	00114$
                                    329 ;	inc/i2c.h: 106: d=I2C_SR3;
      008172 AE 52 19         [ 2]  330 	ldw	x, #0x5219
      008175 F6               [ 1]  331 	ld	a, (x)
                                    332 ;	inc/i2c.h: 107: I2C_DR = addr_dev+1;                    
      008176 90 9F            [ 1]  333 	ld	a, yl
      008178 4C               [ 1]  334 	inc	a
      008179 C7 52 16         [ 1]  335 	ld	0x5216, a
                                    336 ;	inc/i2c.h: 108: while (!(I2C_SR1 & I2C_SR1_ADDR));
      00817C                        337 00117$:
      00817C C6 52 17         [ 1]  338 	ld	a, 0x5217
      00817F A5 02            [ 1]  339 	bcp	a, #0x02
      008181 27 F9            [ 1]  340 	jreq	00117$
                                    341 ;	inc/i2c.h: 109: d=I2C_SR3;
      008183 AE 52 19         [ 2]  342 	ldw	x, #0x5219
      008186 F6               [ 1]  343 	ld	a, (x)
                                    344 ;	inc/i2c.h: 111: while (!(I2C_SR1 & I2C_SR1_RXNE));
      008187                        345 00120$:
      008187 C6 52 17         [ 1]  346 	ld	a, 0x5217
      00818A A5 40            [ 1]  347 	bcp	a, #0x40
      00818C 27 F9            [ 1]  348 	jreq	00120$
                                    349 ;	inc/i2c.h: 112: d=I2C_DR;
      00818E C6 52 16         [ 1]  350 	ld	a, 0x5216
      008191 5F               [ 1]  351 	clrw	x
      008192 97               [ 1]  352 	ld	xl, a
                                    353 ;	inc/i2c.h: 113: I2C_CR2 &= ~I2C_CR2_ACK;
      008193 72 15 52 11      [ 1]  354 	bres	21009, #2
                                    355 ;	inc/i2c.h: 115: while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
      008197                        356 00124$:
                                    357 ;	inc/i2c.h: 92: while (!(I2C_SR1 & I2C_SR1_SB));  
      008197 C6 52 17         [ 1]  358 	ld	a, 0x5217
                                    359 ;	inc/i2c.h: 115: while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
      00819A 4D               [ 1]  360 	tnz	a
      00819B 2B 04            [ 1]  361 	jrmi	00126$
      00819D A5 04            [ 1]  362 	bcp	a, #0x04
      00819F 27 F6            [ 1]  363 	jreq	00124$
      0081A1                        364 00126$:
                                    365 ;	inc/i2c.h: 116: I2C_CR2 |= I2C_CR2_STOP;       
      0081A1 72 12 52 11      [ 1]  366 	bset	21009, #1
                                    367 ;	inc/i2c.h: 117: while (I2C_SR3 & I2C_SR3_MSL);
      0081A5                        368 00127$:
      0081A5 C6 52 19         [ 1]  369 	ld	a, 0x5219
      0081A8 44               [ 1]  370 	srl	a
      0081A9 25 FA            [ 1]  371 	jrc	00127$
                                    372 ;	inc/i2c.h: 119: return d;
                                    373 ;	inc/i2c.h: 120: }
      0081AB 81               [ 4]  374 	ret
                                    375 ;	main.c: 7: void main(void){
                                    376 ;	-----------------------------------------
                                    377 ;	 function main
                                    378 ;	-----------------------------------------
      0081AC                        379 _main:
                                    380 ;	main.c: 9: clk_init_HSI(); //16MHz
      0081AC CD 80 47         [ 4]  381 	call	_clk_init_HSI
                                    382 ;	main.c: 10: i2c_init();
      0081AF CD 80 C6         [ 4]  383 	call	_i2c_init
                                    384 ;	main.c: 12: PC_DDR = 0xFF;                                                    
      0081B2 35 FF 50 0C      [ 1]  385 	mov	0x500c+0, #0xff
                                    386 ;	main.c: 13: PC_CR1 = 0xFF;                                                      
      0081B6 35 FF 50 0D      [ 1]  387 	mov	0x500d+0, #0xff
                                    388 ;	main.c: 14: PC_CR2 = 0x00;
      0081BA 35 00 50 0E      [ 1]  389 	mov	0x500e+0, #0x00
                                    390 ;	main.c: 15: while(1){
      0081BE                        391 00108$:
                                    392 ;	main.c: 16: i2c_write_byte(0xA0, 0x01, 0x0C);
      0081BE 4B 0C            [ 1]  393 	push	#0x0c
      0081C0 4B 00            [ 1]  394 	push	#0x00
      0081C2 4B 01            [ 1]  395 	push	#0x01
      0081C4 4B 00            [ 1]  396 	push	#0x00
      0081C6 4B A0            [ 1]  397 	push	#0xa0
      0081C8 4B 00            [ 1]  398 	push	#0x00
      0081CA CD 80 D7         [ 4]  399 	call	_i2c_write_byte
      0081CD 5B 06            [ 2]  400 	addw	sp, #6
                                    401 ;	main.c: 18: while(t--);
      0081CF AE 61 A8         [ 2]  402 	ldw	x, #0x61a8
      0081D2                        403 00101$:
      0081D2 90 93            [ 1]  404 	ldw	y, x
      0081D4 5A               [ 2]  405 	decw	x
      0081D5 90 5D            [ 2]  406 	tnzw	y
      0081D7 26 F9            [ 1]  407 	jrne	00101$
                                    408 ;	main.c: 19: data=i2c_read_byte(0xA0,0x01);
      0081D9 4B 01            [ 1]  409 	push	#0x01
      0081DB 4B 00            [ 1]  410 	push	#0x00
      0081DD 4B A0            [ 1]  411 	push	#0xa0
      0081DF 4B 00            [ 1]  412 	push	#0x00
      0081E1 CD 81 2B         [ 4]  413 	call	_i2c_read_byte
      0081E4 5B 04            [ 2]  414 	addw	sp, #4
      0081E6 9F               [ 1]  415 	ld	a, xl
                                    416 ;	main.c: 20: PC_ODR =0;
      0081E7 35 00 50 0A      [ 1]  417 	mov	0x500a+0, #0x00
                                    418 ;	main.c: 21: PC_ODR =data;
      0081EB C7 50 0A         [ 1]  419 	ld	0x500a, a
                                    420 ;	main.c: 23: while(t--);
      0081EE AE 61 A8         [ 2]  421 	ldw	x, #0x61a8
      0081F1                        422 00104$:
      0081F1 90 93            [ 1]  423 	ldw	y, x
      0081F3 5A               [ 2]  424 	decw	x
      0081F4 90 5D            [ 2]  425 	tnzw	y
      0081F6 27 C6            [ 1]  426 	jreq	00108$
      0081F8 20 F7            [ 2]  427 	jra	00104$
                                    428 ;	main.c: 27: }
      0081FA 81               [ 4]  429 	ret
                                    430 	.area CODE
                                    431 	.area INITIALIZER
                                    432 	.area CABS (ABS)
