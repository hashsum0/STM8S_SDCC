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
                                     12 	.globl _i2c_stop
                                     13 	.globl _i2c_read
                                     14 	.globl _i2c_write_data
                                     15 	.globl _i2c_write_addr_mem
                                     16 	.globl _i2c_write_addr_dev
                                     17 	.globl _i2c_start
                                     18 	.globl _i2c_init
                                     19 ;--------------------------------------------------------
                                     20 ; ram data
                                     21 ;--------------------------------------------------------
                                     22 	.area DATA
                                     23 ;--------------------------------------------------------
                                     24 ; ram data
                                     25 ;--------------------------------------------------------
                                     26 	.area INITIALIZED
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
                                     38 ;--------------------------------------------------------
                                     39 ; interrupt vector 
                                     40 ;--------------------------------------------------------
                                     41 	.area HOME
      008000                         42 __interrupt_vect:
      008000 82 00 80 07             43 	int s_GSINIT ; reset
                                     44 ;--------------------------------------------------------
                                     45 ; global & static initialisations
                                     46 ;--------------------------------------------------------
                                     47 	.area HOME
                                     48 	.area GSINIT
                                     49 	.area GSFINAL
                                     50 	.area GSINIT
      008007                         51 __sdcc_gs_init_startup:
      008007                         52 __sdcc_init_data:
                                     53 ; stm8_genXINIT() start
      008007 AE 00 00         [ 2]   54 	ldw x, #l_DATA
      00800A 27 07            [ 1]   55 	jreq	00002$
      00800C                         56 00001$:
      00800C 72 4F 00 00      [ 1]   57 	clr (s_DATA - 1, x)
      008010 5A               [ 2]   58 	decw x
      008011 26 F9            [ 1]   59 	jrne	00001$
      008013                         60 00002$:
      008013 AE 00 00         [ 2]   61 	ldw	x, #l_INITIALIZER
      008016 27 09            [ 1]   62 	jreq	00004$
      008018                         63 00003$:
      008018 D6 81 4C         [ 1]   64 	ld	a, (s_INITIALIZER - 1, x)
      00801B D7 00 00         [ 1]   65 	ld	(s_INITIALIZED - 1, x), a
      00801E 5A               [ 2]   66 	decw	x
      00801F 26 F7            [ 1]   67 	jrne	00003$
      008021                         68 00004$:
                                     69 ; stm8_genXINIT() end
                                     70 	.area GSFINAL
      008021 CC 80 04         [ 2]   71 	jp	__sdcc_program_startup
                                     72 ;--------------------------------------------------------
                                     73 ; Home
                                     74 ;--------------------------------------------------------
                                     75 	.area HOME
                                     76 	.area HOME
      008004                         77 __sdcc_program_startup:
      008004 CC 80 C8         [ 2]   78 	jp	_main
                                     79 ;	return from main will return to caller
                                     80 ;--------------------------------------------------------
                                     81 ; code
                                     82 ;--------------------------------------------------------
                                     83 	.area CODE
                                     84 ;	inc/i2c.h: 29: void i2c_init() {
                                     85 ;	-----------------------------------------
                                     86 ;	 function i2c_init
                                     87 ;	-----------------------------------------
      008024                         88 _i2c_init:
                                     89 ;	inc/i2c.h: 31: cli(I2C_CR1,I2C_CR1_PE);
      008024 72 11 52 10      [ 1]   90 	bres	21008, #0
                                     91 ;	inc/i2c.h: 32: I2C_FREQR = F_MASTER;
      008028 35 10 52 12      [ 1]   92 	mov	0x5212+0, #0x10
                                     93 ;	inc/i2c.h: 38: I2C_CCRH = I2C_CCRH_16MHZ_STD_100;     // 0x00 
      00802C 35 00 52 1C      [ 1]   94 	mov	0x521c+0, #0x00
                                     95 ;	inc/i2c.h: 39: I2C_CCRL = I2C_CCRL_16MHZ_STD_100;     // 0x50
      008030 35 50 52 1B      [ 1]   96 	mov	0x521b+0, #0x50
                                     97 ;	inc/i2c.h: 45: I2C_TRISER = I2C_TRISER_16MHZ_STD_100; // 0x11
      008034 35 0B 52 1D      [ 1]   98 	mov	0x521d+0, #0x0b
                                     99 ;	inc/i2c.h: 46: set(I2C_OARH,I2C_OARH_ADDCONF);          //Must always be written as 1 
      008038 72 1C 52 14      [ 1]  100 	bset	21012, #6
                                    101 ;	inc/i2c.h: 47: cli(I2C_OARH,I2C_OARH_ADDMODE);         // 7-bit slave address
      00803C 72 1F 52 14      [ 1]  102 	bres	21012, #7
                                    103 ;	inc/i2c.h: 48: set(I2C_CR1,I2C_CR1_PE);
      008040 72 10 52 10      [ 1]  104 	bset	21008, #0
                                    105 ;	inc/i2c.h: 50: }
      008044 81               [ 4]  106 	ret
                                    107 ;	inc/i2c.h: 52: void i2c_start() {
                                    108 ;	-----------------------------------------
                                    109 ;	 function i2c_start
                                    110 ;	-----------------------------------------
      008045                        111 _i2c_start:
                                    112 ;	inc/i2c.h: 53: set(I2C_CR2,I2C_CR2_ACK);
      008045 72 14 52 11      [ 1]  113 	bset	21009, #2
                                    114 ;	inc/i2c.h: 54: while(check(I2C_SR3, I2C_SR3_BUSY));
      008049                        115 00101$:
      008049 C6 52 19         [ 1]  116 	ld	a, 0x5219
      00804C A5 02            [ 1]  117 	bcp	a, #0x02
      00804E 26 F9            [ 1]  118 	jrne	00101$
                                    119 ;	inc/i2c.h: 55: set(I2C_CR2,I2C_CR2_START);
      008050 72 10 52 11      [ 1]  120 	bset	21009, #0
                                    121 ;	inc/i2c.h: 56: while(!check(I2C_SR1, I2C_SR1_SB));
      008054                        122 00104$:
      008054 C6 52 17         [ 1]  123 	ld	a, 0x5217
      008057 44               [ 1]  124 	srl	a
      008058 24 FA            [ 1]  125 	jrnc	00104$
                                    126 ;	inc/i2c.h: 58: }
      00805A 81               [ 4]  127 	ret
                                    128 ;	inc/i2c.h: 60: void i2c_write_addr_dev(unsigned char d_addr) {
                                    129 ;	-----------------------------------------
                                    130 ;	 function i2c_write_addr_dev
                                    131 ;	-----------------------------------------
      00805B                        132 _i2c_write_addr_dev:
                                    133 ;	inc/i2c.h: 62: I2C_DR = d_addr;
      00805B AE 52 16         [ 2]  134 	ldw	x, #0x5216
      00805E 7B 03            [ 1]  135 	ld	a, (0x03, sp)
      008060 F7               [ 1]  136 	ld	(x), a
                                    137 ;	inc/i2c.h: 63: while (!check(I2C_SR1, I2C_SR1_ADDR));
      008061                        138 00101$:
      008061 C6 52 17         [ 1]  139 	ld	a, 0x5217
      008064 A5 02            [ 1]  140 	bcp	a, #0x02
      008066 27 F9            [ 1]  141 	jreq	00101$
                                    142 ;	inc/i2c.h: 64: I2C_SR3;
      008068 AE 52 19         [ 2]  143 	ldw	x, #0x5219
      00806B F6               [ 1]  144 	ld	a, (x)
                                    145 ;	inc/i2c.h: 65: }
      00806C 81               [ 4]  146 	ret
                                    147 ;	inc/i2c.h: 67: void i2c_write_addr_mem(unsigned char m_addr) {
                                    148 ;	-----------------------------------------
                                    149 ;	 function i2c_write_addr_mem
                                    150 ;	-----------------------------------------
      00806D                        151 _i2c_write_addr_mem:
                                    152 ;	inc/i2c.h: 69: I2C_DR = m_addr;
      00806D AE 52 16         [ 2]  153 	ldw	x, #0x5216
      008070 7B 03            [ 1]  154 	ld	a, (0x03, sp)
      008072 F7               [ 1]  155 	ld	(x), a
                                    156 ;	inc/i2c.h: 70: while (!check(I2C_SR1, I2C_SR1_TXE));
      008073                        157 00101$:
      008073 C6 52 17         [ 1]  158 	ld	a, 0x5217
      008076 4D               [ 1]  159 	tnz	a
      008077 2A FA            [ 1]  160 	jrpl	00101$
                                    161 ;	inc/i2c.h: 71: I2C_SR3;
      008079 AE 52 19         [ 2]  162 	ldw	x, #0x5219
      00807C F6               [ 1]  163 	ld	a, (x)
                                    164 ;	inc/i2c.h: 72: }
      00807D 81               [ 4]  165 	ret
                                    166 ;	inc/i2c.h: 74: void i2c_write_data(unsigned char data) {
                                    167 ;	-----------------------------------------
                                    168 ;	 function i2c_write_data
                                    169 ;	-----------------------------------------
      00807E                        170 _i2c_write_data:
                                    171 ;	inc/i2c.h: 76: I2C_DR = data;
      00807E AE 52 16         [ 2]  172 	ldw	x, #0x5216
      008081 7B 03            [ 1]  173 	ld	a, (0x03, sp)
      008083 F7               [ 1]  174 	ld	(x), a
                                    175 ;	inc/i2c.h: 77: while (!check(I2C_SR1, I2C_SR1_TXE));
      008084                        176 00101$:
      008084 C6 52 17         [ 1]  177 	ld	a, 0x5217
      008087 4D               [ 1]  178 	tnz	a
      008088 2A FA            [ 1]  179 	jrpl	00101$
                                    180 ;	inc/i2c.h: 78: I2C_SR3;
      00808A AE 52 19         [ 2]  181 	ldw	x, #0x5219
      00808D F6               [ 1]  182 	ld	a, (x)
                                    183 ;	inc/i2c.h: 79: }
      00808E 81               [ 4]  184 	ret
                                    185 ;	inc/i2c.h: 81: unsigned char i2c_read(unsigned char addr) {
                                    186 ;	-----------------------------------------
                                    187 ;	 function i2c_read
                                    188 ;	-----------------------------------------
      00808F                        189 _i2c_read:
                                    190 ;	inc/i2c.h: 83: set(I2C_CR2,I2C_CR2_START);
      00808F 72 10 52 11      [ 1]  191 	bset	21009, #0
                                    192 ;	inc/i2c.h: 84: while(!check(I2C_SR1, I2C_SR1_SB));
      008093                        193 00101$:
      008093 C6 52 17         [ 1]  194 	ld	a, 0x5217
      008096 44               [ 1]  195 	srl	a
      008097 24 FA            [ 1]  196 	jrnc	00101$
                                    197 ;	inc/i2c.h: 87: I2C_DR = addr+1;
      008099 7B 03            [ 1]  198 	ld	a, (0x03, sp)
      00809B 4C               [ 1]  199 	inc	a
      00809C C7 52 16         [ 1]  200 	ld	0x5216, a
                                    201 ;	inc/i2c.h: 88: while (!check(I2C_SR1,I2C_SR1_ADDR));
      00809F                        202 00104$:
      00809F C6 52 17         [ 1]  203 	ld	a, 0x5217
      0080A2 A5 02            [ 1]  204 	bcp	a, #0x02
      0080A4 27 F9            [ 1]  205 	jreq	00104$
                                    206 ;	inc/i2c.h: 89: I2C_SR3;
      0080A6 AE 52 19         [ 2]  207 	ldw	x, #0x5219
      0080A9 F6               [ 1]  208 	ld	a, (x)
                                    209 ;	inc/i2c.h: 91: cli(I2C_CR2,I2C_CR2_ACK);
      0080AA 72 15 52 11      [ 1]  210 	bres	21009, #2
                                    211 ;	inc/i2c.h: 92: set(I2C_CR2,I2C_CR2_STOP);
      0080AE 72 12 52 11      [ 1]  212 	bset	21009, #1
                                    213 ;	inc/i2c.h: 94: while (!check(I2C_SR1,I2C_SR1_RXNE));
      0080B2                        214 00107$:
      0080B2 C6 52 17         [ 1]  215 	ld	a, 0x5217
      0080B5 A5 40            [ 1]  216 	bcp	a, #0x40
      0080B7 27 F9            [ 1]  217 	jreq	00107$
                                    218 ;	inc/i2c.h: 95: return I2C_DR;
      0080B9 C6 52 16         [ 1]  219 	ld	a, 0x5216
                                    220 ;	inc/i2c.h: 96: }
      0080BC 81               [ 4]  221 	ret
                                    222 ;	inc/i2c.h: 98: void i2c_stop() {
                                    223 ;	-----------------------------------------
                                    224 ;	 function i2c_stop
                                    225 ;	-----------------------------------------
      0080BD                        226 _i2c_stop:
                                    227 ;	inc/i2c.h: 99: set(I2C_CR2,I2C_CR2_STOP);
      0080BD 72 12 52 11      [ 1]  228 	bset	21009, #1
                                    229 ;	inc/i2c.h: 100: while (check(I2C_SR3,I2C_SR3_MSL));
      0080C1                        230 00101$:
      0080C1 C6 52 19         [ 1]  231 	ld	a, 0x5219
      0080C4 44               [ 1]  232 	srl	a
      0080C5 25 FA            [ 1]  233 	jrc	00101$
                                    234 ;	inc/i2c.h: 101: }
      0080C7 81               [ 4]  235 	ret
                                    236 ;	main.c: 7: void main(void){
                                    237 ;	-----------------------------------------
                                    238 ;	 function main
                                    239 ;	-----------------------------------------
      0080C8                        240 _main:
                                    241 ;	main.c: 9: CLK_ICKR = 0; // Сбрасываем регистр внутреннего тактирования
      0080C8 35 00 50 C0      [ 1]  242 	mov	0x50c0+0, #0x00
                                    243 ;	main.c: 10: CLK_ICKR|=(1<<0); // Включаем внутренний генератор HSI
      0080CC 72 10 50 C0      [ 1]  244 	bset	20672, #0
                                    245 ;	main.c: 11: CLK_ECKR = 0; // Отключаем внешний генератор
      0080D0 35 00 50 C1      [ 1]  246 	mov	0x50c1+0, #0x00
                                    247 ;	main.c: 12: while ((CLK_ICKR&(1<<1))== 0); // Ждём стабилизации внутреннего генератора
      0080D4                        248 00101$:
      0080D4 C6 50 C0         [ 1]  249 	ld	a, 0x50c0
      0080D7 A5 02            [ 1]  250 	bcp	a, #0x02
      0080D9 27 F9            [ 1]  251 	jreq	00101$
                                    252 ;	main.c: 13: CLK_CKDIVR = 0; // Устанавливаем максимальную частоту
      0080DB 35 00 50 C6      [ 1]  253 	mov	0x50c6+0, #0x00
                                    254 ;	main.c: 14: CLK_CCOR = 0; // Выключаем CCO.
      0080DF 35 00 50 C9      [ 1]  255 	mov	0x50c9+0, #0x00
                                    256 ;	main.c: 15: CLK_HSITRIMR = 0; // Turn off any HSIU trimming.
      0080E3 35 00 50 CC      [ 1]  257 	mov	0x50cc+0, #0x00
                                    258 ;	main.c: 16: CLK_SWIMCCR = 0; // Set SWIM to run at clock / 2.
      0080E7 35 00 50 CD      [ 1]  259 	mov	0x50cd+0, #0x00
                                    260 ;	main.c: 17: CLK_SWR = 0xe1; // Используем HSI в качестве источника тактиров
      0080EB 35 E1 50 C4      [ 1]  261 	mov	0x50c4+0, #0xe1
                                    262 ;	main.c: 18: CLK_SWCR = 0; // Сброс флага переключения генераторов
      0080EF 35 00 50 C5      [ 1]  263 	mov	0x50c5+0, #0x00
                                    264 ;	main.c: 19: CLK_SWCR = (1<<1); // Включаем переключение на HSI
      0080F3 35 02 50 C5      [ 1]  265 	mov	0x50c5+0, #0x02
                                    266 ;	main.c: 20: while ((CLK_SWCR&(1<<0)) != 0); // Пауза, пока произойдёт переключение(CLK_SWCR_SWBSY != 0)
      0080F7                        267 00104$:
      0080F7 C6 50 C5         [ 1]  268 	ld	a, 0x50c5
      0080FA 44               [ 1]  269 	srl	a
      0080FB 25 FA            [ 1]  270 	jrc	00104$
                                    271 ;	main.c: 21: PC_DDR=0xFF;
      0080FD 35 FF 50 0C      [ 1]  272 	mov	0x500c+0, #0xff
                                    273 ;	main.c: 22: PC_CR1=0xFF;
      008101 35 FF 50 0D      [ 1]  274 	mov	0x500d+0, #0xff
                                    275 ;	main.c: 23: PC_ODR=0x00;
      008105 35 00 50 0A      [ 1]  276 	mov	0x500a+0, #0x00
                                    277 ;	main.c: 24: i2c_init();
      008109 CD 80 24         [ 4]  278 	call	_i2c_init
                                    279 ;	main.c: 26: while(1){
      00810C                        280 00111$:
                                    281 ;	main.c: 27: i2c_start();    
      00810C CD 80 45         [ 4]  282 	call	_i2c_start
                                    283 ;	main.c: 28: i2c_write_addr_dev(0xA0);
      00810F 4B A0            [ 1]  284 	push	#0xa0
      008111 CD 80 5B         [ 4]  285 	call	_i2c_write_addr_dev
      008114 84               [ 1]  286 	pop	a
                                    287 ;	main.c: 29: i2c_write_addr_mem(0x01);
      008115 4B 01            [ 1]  288 	push	#0x01
      008117 CD 80 6D         [ 4]  289 	call	_i2c_write_addr_mem
      00811A 84               [ 1]  290 	pop	a
                                    291 ;	main.c: 30: i2c_write_data(0xcc);
      00811B 4B CC            [ 1]  292 	push	#0xcc
      00811D CD 80 7E         [ 4]  293 	call	_i2c_write_data
      008120 84               [ 1]  294 	pop	a
                                    295 ;	main.c: 31: i2c_stop();
      008121 CD 80 BD         [ 4]  296 	call	_i2c_stop
                                    297 ;	main.c: 33: while(t--);
      008124 AE 13 88         [ 2]  298 	ldw	x, #0x1388
      008127                        299 00107$:
      008127 90 93            [ 1]  300 	ldw	y, x
      008129 5A               [ 2]  301 	decw	x
      00812A 90 5D            [ 2]  302 	tnzw	y
      00812C 26 F9            [ 1]  303 	jrne	00107$
                                    304 ;	main.c: 34: i2c_start();
      00812E CD 80 45         [ 4]  305 	call	_i2c_start
                                    306 ;	main.c: 35: i2c_write_addr_dev(0xA0);
      008131 4B A0            [ 1]  307 	push	#0xa0
      008133 CD 80 5B         [ 4]  308 	call	_i2c_write_addr_dev
      008136 84               [ 1]  309 	pop	a
                                    310 ;	main.c: 36: i2c_write_addr_mem(0x01);
      008137 4B 01            [ 1]  311 	push	#0x01
      008139 CD 80 6D         [ 4]  312 	call	_i2c_write_addr_mem
      00813C 84               [ 1]  313 	pop	a
                                    314 ;	main.c: 37: data=i2c_read(0xA0);
      00813D 4B A0            [ 1]  315 	push	#0xa0
      00813F CD 80 8F         [ 4]  316 	call	_i2c_read
      008142 5B 01            [ 2]  317 	addw	sp, #1
      008144 41               [ 1]  318 	exg	a, xl
      008145 4F               [ 1]  319 	clr	a
      008146 41               [ 1]  320 	exg	a, xl
                                    321 ;	main.c: 38: PC_ODR=data;
      008147 C7 50 0A         [ 1]  322 	ld	0x500a, a
      00814A 20 C0            [ 2]  323 	jra	00111$
                                    324 ;	main.c: 42: }
      00814C 81               [ 4]  325 	ret
                                    326 	.area CODE
                                    327 	.area INITIALIZER
                                    328 	.area CABS (ABS)
