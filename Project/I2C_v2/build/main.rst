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
                                     12 	.globl _i2c_read_arr
                                     13 	.globl _i2c_read
                                     14 	.globl _i2c_write_addr
                                     15 	.globl _i2c_write
                                     16 	.globl _i2c_stop
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
      008018 D6 81 0A         [ 1]   64 	ld	a, (s_INITIALIZER - 1, x)
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
      008004 CC 80 AE         [ 2]   78 	jp	_main
                                     79 ;	return from main will return to caller
                                     80 ;--------------------------------------------------------
                                     81 ; code
                                     82 ;--------------------------------------------------------
                                     83 	.area CODE
                                     84 ;	inc/i2c.h: 4: void i2c_init() {
                                     85 ;	-----------------------------------------
                                     86 ;	 function i2c_init
                                     87 ;	-----------------------------------------
      008024                         88 _i2c_init:
                                     89 ;	inc/i2c.h: 5: I2C_FREQR = (1 << I2C_FREQR_FREQ1);
      008024 35 02 52 12      [ 1]   90 	mov	0x5212+0, #0x02
                                     91 ;	inc/i2c.h: 6: I2C_CCRL = 0x0A; // 100kHz
      008028 35 0A 52 1B      [ 1]   92 	mov	0x521b+0, #0x0a
                                     93 ;	inc/i2c.h: 7: I2C_OARH = (1 << I2C_OARH_ADDMODE); // 7-bit addressing
      00802C 35 80 52 14      [ 1]   94 	mov	0x5214+0, #0x80
                                     95 ;	inc/i2c.h: 8: I2C_CR1 = (1 << I2C_CR1_PE);
      008030 35 01 52 10      [ 1]   96 	mov	0x5210+0, #0x01
                                     97 ;	inc/i2c.h: 9: }
      008034 81               [ 4]   98 	ret
                                     99 ;	inc/i2c.h: 11: void i2c_start() {
                                    100 ;	-----------------------------------------
                                    101 ;	 function i2c_start
                                    102 ;	-----------------------------------------
      008035                        103 _i2c_start:
                                    104 ;	inc/i2c.h: 12: I2C_CR2 |= (1 << I2C_CR2_START);
      008035 72 10 52 11      [ 1]  105 	bset	21009, #0
                                    106 ;	inc/i2c.h: 13: while (!(I2C_SR1 & (1 << I2C_SR1_SB)));
      008039                        107 00101$:
      008039 C6 52 17         [ 1]  108 	ld	a, 0x5217
      00803C 44               [ 1]  109 	srl	a
      00803D 24 FA            [ 1]  110 	jrnc	00101$
                                    111 ;	inc/i2c.h: 14: }
      00803F 81               [ 4]  112 	ret
                                    113 ;	inc/i2c.h: 16: void i2c_stop() {
                                    114 ;	-----------------------------------------
                                    115 ;	 function i2c_stop
                                    116 ;	-----------------------------------------
      008040                        117 _i2c_stop:
                                    118 ;	inc/i2c.h: 17: I2C_CR2 |= (1 << I2C_CR2_STOP);
      008040 72 12 52 11      [ 1]  119 	bset	21009, #1
                                    120 ;	inc/i2c.h: 18: while (I2C_SR3 & (1 << I2C_SR3_MSL));
      008044                        121 00101$:
      008044 C6 52 19         [ 1]  122 	ld	a, 0x5219
      008047 44               [ 1]  123 	srl	a
      008048 25 FA            [ 1]  124 	jrc	00101$
                                    125 ;	inc/i2c.h: 19: }
      00804A 81               [ 4]  126 	ret
                                    127 ;	inc/i2c.h: 21: void i2c_write(uint8_t data) {
                                    128 ;	-----------------------------------------
                                    129 ;	 function i2c_write
                                    130 ;	-----------------------------------------
      00804B                        131 _i2c_write:
                                    132 ;	inc/i2c.h: 22: I2C_DR = data;
      00804B AE 52 16         [ 2]  133 	ldw	x, #0x5216
      00804E 7B 03            [ 1]  134 	ld	a, (0x03, sp)
      008050 F7               [ 1]  135 	ld	(x), a
                                    136 ;	inc/i2c.h: 23: while (!(I2C_SR1 & (1 << I2C_SR1_TXE)));
      008051                        137 00101$:
      008051 C6 52 17         [ 1]  138 	ld	a, 0x5217
      008054 4D               [ 1]  139 	tnz	a
      008055 2A FA            [ 1]  140 	jrpl	00101$
                                    141 ;	inc/i2c.h: 24: }
      008057 81               [ 4]  142 	ret
                                    143 ;	inc/i2c.h: 26: void i2c_write_addr(uint8_t addr) {
                                    144 ;	-----------------------------------------
                                    145 ;	 function i2c_write_addr
                                    146 ;	-----------------------------------------
      008058                        147 _i2c_write_addr:
                                    148 ;	inc/i2c.h: 27: I2C_DR = addr;
      008058 AE 52 16         [ 2]  149 	ldw	x, #0x5216
      00805B 7B 03            [ 1]  150 	ld	a, (0x03, sp)
      00805D F7               [ 1]  151 	ld	(x), a
                                    152 ;	inc/i2c.h: 28: while (!(I2C_SR1 & (1 << I2C_SR1_ADDR)));
      00805E                        153 00101$:
      00805E C6 52 17         [ 1]  154 	ld	a, 0x5217
      008061 A5 02            [ 1]  155 	bcp	a, #0x02
      008063 27 F9            [ 1]  156 	jreq	00101$
                                    157 ;	inc/i2c.h: 29: (void) I2C_SR3; // check BUS_BUSY
      008065 AE 52 19         [ 2]  158 	ldw	x, #0x5219
      008068 F6               [ 1]  159 	ld	a, (x)
                                    160 ;	inc/i2c.h: 30: I2C_CR2 |= (1 << I2C_CR2_ACK);
      008069 72 14 52 11      [ 1]  161 	bset	21009, #2
                                    162 ;	inc/i2c.h: 31: }
      00806D 81               [ 4]  163 	ret
                                    164 ;	inc/i2c.h: 33: uint8_t i2c_read() {
                                    165 ;	-----------------------------------------
                                    166 ;	 function i2c_read
                                    167 ;	-----------------------------------------
      00806E                        168 _i2c_read:
                                    169 ;	inc/i2c.h: 34: I2C_CR2 &= ~(1 << I2C_CR2_ACK);
      00806E 72 15 52 11      [ 1]  170 	bres	21009, #2
                                    171 ;	inc/i2c.h: 35: i2c_stop();
      008072 CD 80 40         [ 4]  172 	call	_i2c_stop
                                    173 ;	inc/i2c.h: 36: while (!(I2C_SR1 & (1 << I2C_SR1_RXNE)));
      008075                        174 00101$:
      008075 C6 52 17         [ 1]  175 	ld	a, 0x5217
      008078 A5 40            [ 1]  176 	bcp	a, #0x40
      00807A 27 F9            [ 1]  177 	jreq	00101$
                                    178 ;	inc/i2c.h: 37: return I2C_DR;
      00807C C6 52 16         [ 1]  179 	ld	a, 0x5216
                                    180 ;	inc/i2c.h: 38: }
      00807F 81               [ 4]  181 	ret
                                    182 ;	inc/i2c.h: 40: void i2c_read_arr(uint8_t *buf, int len) {
                                    183 ;	-----------------------------------------
                                    184 ;	 function i2c_read_arr
                                    185 ;	-----------------------------------------
      008080                        186 _i2c_read_arr:
      008080 52 02            [ 2]  187 	sub	sp, #2
                                    188 ;	inc/i2c.h: 41: while (len-- > 1) {
      008082 1E 05            [ 2]  189 	ldw	x, (0x05, sp)
      008084 16 07            [ 2]  190 	ldw	y, (0x07, sp)
      008086                        191 00104$:
      008086 17 01            [ 2]  192 	ldw	(0x01, sp), y
      008088 90 5A            [ 2]  193 	decw	y
      00808A 89               [ 2]  194 	pushw	x
      00808B 1E 03            [ 2]  195 	ldw	x, (0x03, sp)
      00808D A3 00 01         [ 2]  196 	cpw	x, #0x0001
      008090 85               [ 2]  197 	popw	x
      008091 2D 12            [ 1]  198 	jrsle	00106$
                                    199 ;	inc/i2c.h: 42: I2C_CR2 |= (1 << I2C_CR2_ACK);
      008093 72 14 52 11      [ 1]  200 	bset	21009, #2
                                    201 ;	inc/i2c.h: 43: while (!(I2C_SR1 & (1 << I2C_SR1_RXNE)));
      008097                        202 00101$:
      008097 C6 52 17         [ 1]  203 	ld	a, 0x5217
      00809A A5 40            [ 1]  204 	bcp	a, #0x40
      00809C 27 F9            [ 1]  205 	jreq	00101$
                                    206 ;	inc/i2c.h: 44: *(buf++) = I2C_DR;
      00809E C6 52 16         [ 1]  207 	ld	a, 0x5216
      0080A1 F7               [ 1]  208 	ld	(x), a
      0080A2 5C               [ 1]  209 	incw	x
      0080A3 20 E1            [ 2]  210 	jra	00104$
      0080A5                        211 00106$:
                                    212 ;	inc/i2c.h: 46: *buf = i2c_read();
      0080A5 89               [ 2]  213 	pushw	x
      0080A6 CD 80 6E         [ 4]  214 	call	_i2c_read
      0080A9 85               [ 2]  215 	popw	x
      0080AA F7               [ 1]  216 	ld	(x), a
                                    217 ;	inc/i2c.h: 47: }
      0080AB 5B 02            [ 2]  218 	addw	sp, #2
      0080AD 81               [ 4]  219 	ret
                                    220 ;	main.c: 7: void main(void){
                                    221 ;	-----------------------------------------
                                    222 ;	 function main
                                    223 ;	-----------------------------------------
      0080AE                        224 _main:
                                    225 ;	main.c: 9: CLK_ICKR = 0; // Сбрасываем регистр внутреннего тактирования
      0080AE 35 00 50 C0      [ 1]  226 	mov	0x50c0+0, #0x00
                                    227 ;	main.c: 10: CLK_ICKR|=(1<<0); // Включаем внутренний генератор HSI
      0080B2 72 10 50 C0      [ 1]  228 	bset	20672, #0
                                    229 ;	main.c: 11: CLK_ECKR = 0; // Отключаем внешний генератор
      0080B6 35 00 50 C1      [ 1]  230 	mov	0x50c1+0, #0x00
                                    231 ;	main.c: 12: while ((CLK_ICKR&(1<<1))== 0); // Ждём стабилизации внутреннего генератора
      0080BA                        232 00101$:
      0080BA C6 50 C0         [ 1]  233 	ld	a, 0x50c0
      0080BD A5 02            [ 1]  234 	bcp	a, #0x02
      0080BF 27 F9            [ 1]  235 	jreq	00101$
                                    236 ;	main.c: 13: CLK_CKDIVR = 0; // Устанавливаем максимальную частоту
      0080C1 35 00 50 C6      [ 1]  237 	mov	0x50c6+0, #0x00
                                    238 ;	main.c: 14: CLK_CCOR = 0; // Выключаем CCO.
      0080C5 35 00 50 C9      [ 1]  239 	mov	0x50c9+0, #0x00
                                    240 ;	main.c: 15: CLK_HSITRIMR = 0; // Turn off any HSIU trimming.
      0080C9 35 00 50 CC      [ 1]  241 	mov	0x50cc+0, #0x00
                                    242 ;	main.c: 16: CLK_SWIMCCR = 0; // Set SWIM to run at clock / 2.
      0080CD 35 00 50 CD      [ 1]  243 	mov	0x50cd+0, #0x00
                                    244 ;	main.c: 17: CLK_SWR = 0xe1; // Используем HSI в качестве источника тактиров
      0080D1 35 E1 50 C4      [ 1]  245 	mov	0x50c4+0, #0xe1
                                    246 ;	main.c: 18: CLK_SWCR = 0; // Сброс флага переключения генераторов
      0080D5 35 00 50 C5      [ 1]  247 	mov	0x50c5+0, #0x00
                                    248 ;	main.c: 19: CLK_SWCR = (1<<1); // Включаем переключение на HSI
      0080D9 35 02 50 C5      [ 1]  249 	mov	0x50c5+0, #0x02
                                    250 ;	main.c: 20: while ((CLK_SWCR&(1<<0)) != 0); // Пауза, пока произойдёт переключение(CLK_SWCR_SWBSY != 0)
      0080DD                        251 00104$:
      0080DD C6 50 C5         [ 1]  252 	ld	a, 0x50c5
      0080E0 44               [ 1]  253 	srl	a
      0080E1 25 FA            [ 1]  254 	jrc	00104$
                                    255 ;	main.c: 22: i2c_init();
      0080E3 CD 80 24         [ 4]  256 	call	_i2c_init
                                    257 ;	main.c: 24: while(1){
      0080E6                        258 00111$:
                                    259 ;	main.c: 25: i2c_start();    
      0080E6 CD 80 35         [ 4]  260 	call	_i2c_start
                                    261 ;	main.c: 26: i2c_write_addr(0xA0);
      0080E9 4B A0            [ 1]  262 	push	#0xa0
      0080EB CD 80 58         [ 4]  263 	call	_i2c_write_addr
      0080EE 84               [ 1]  264 	pop	a
                                    265 ;	main.c: 28: i2c_write(0x01);
      0080EF 4B 01            [ 1]  266 	push	#0x01
      0080F1 CD 80 4B         [ 4]  267 	call	_i2c_write
      0080F4 84               [ 1]  268 	pop	a
                                    269 ;	main.c: 30: i2c_write(0x99);
      0080F5 4B 99            [ 1]  270 	push	#0x99
      0080F7 CD 80 4B         [ 4]  271 	call	_i2c_write
      0080FA 84               [ 1]  272 	pop	a
                                    273 ;	main.c: 31: i2c_stop();
      0080FB CD 80 40         [ 4]  274 	call	_i2c_stop
                                    275 ;	main.c: 33: while(t--);
      0080FE AE 13 88         [ 2]  276 	ldw	x, #0x1388
      008101                        277 00107$:
      008101 90 93            [ 1]  278 	ldw	y, x
      008103 5A               [ 2]  279 	decw	x
      008104 90 5D            [ 2]  280 	tnzw	y
      008106 27 DE            [ 1]  281 	jreq	00111$
      008108 20 F7            [ 2]  282 	jra	00107$
                                    283 ;	main.c: 38: }
      00810A 81               [ 4]  284 	ret
                                    285 	.area CODE
                                    286 	.area INITIALIZER
                                    287 	.area CABS (ABS)
