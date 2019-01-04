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
                                     12 	.globl _SPI_deinit
                                     13 	.globl _SPI_read
                                     14 	.globl _SPI_write
                                     15 	.globl _SPI_init
                                     16 	.globl _rx
                                     17 	.globl _tx
                                     18 	.globl _uart1_init
                                     19 	.globl _GPIO_init
                                     20 	.globl _clk_init
                                     21 ;--------------------------------------------------------
                                     22 ; ram data
                                     23 ;--------------------------------------------------------
                                     24 	.area DATA
                                     25 ;--------------------------------------------------------
                                     26 ; ram data
                                     27 ;--------------------------------------------------------
                                     28 	.area INITIALIZED
                                     29 ;--------------------------------------------------------
                                     30 ; Stack segment in internal ram 
                                     31 ;--------------------------------------------------------
                                     32 	.area	SSEG
      FFFFFF                         33 __start__stack:
      FFFFFF                         34 	.ds	1
                                     35 
                                     36 ;--------------------------------------------------------
                                     37 ; absolute external ram data
                                     38 ;--------------------------------------------------------
                                     39 	.area DABS (ABS)
                                     40 
                                     41 ; default segment ordering for linker
                                     42 	.area HOME
                                     43 	.area GSINIT
                                     44 	.area GSFINAL
                                     45 	.area CONST
                                     46 	.area INITIALIZER
                                     47 	.area CODE
                                     48 
                                     49 ;--------------------------------------------------------
                                     50 ; interrupt vector 
                                     51 ;--------------------------------------------------------
                                     52 	.area HOME
      008000                         53 __interrupt_vect:
      008000 82 00 80 07             54 	int s_GSINIT ; reset
                                     55 ;--------------------------------------------------------
                                     56 ; global & static initialisations
                                     57 ;--------------------------------------------------------
                                     58 	.area HOME
                                     59 	.area GSINIT
                                     60 	.area GSFINAL
                                     61 	.area GSINIT
      008007                         62 __sdcc_gs_init_startup:
      008007                         63 __sdcc_init_data:
                                     64 ; stm8_genXINIT() start
      008007 AE 00 00         [ 2]   65 	ldw x, #l_DATA
      00800A 27 07            [ 1]   66 	jreq	00002$
      00800C                         67 00001$:
      00800C 72 4F 00 00      [ 1]   68 	clr (s_DATA - 1, x)
      008010 5A               [ 2]   69 	decw x
      008011 26 F9            [ 1]   70 	jrne	00001$
      008013                         71 00002$:
      008013 AE 00 00         [ 2]   72 	ldw	x, #l_INITIALIZER
      008016 27 09            [ 1]   73 	jreq	00004$
      008018                         74 00003$:
      008018 D6 80 2B         [ 1]   75 	ld	a, (s_INITIALIZER - 1, x)
      00801B D7 00 00         [ 1]   76 	ld	(s_INITIALIZED - 1, x), a
      00801E 5A               [ 2]   77 	decw	x
      00801F 26 F7            [ 1]   78 	jrne	00003$
      008021                         79 00004$:
                                     80 ; stm8_genXINIT() end
                                     81 	.area GSFINAL
      008021 CC 80 04         [ 2]   82 	jp	__sdcc_program_startup
                                     83 ;--------------------------------------------------------
                                     84 ; Home
                                     85 ;--------------------------------------------------------
                                     86 	.area HOME
                                     87 	.area HOME
      008004                         88 __sdcc_program_startup:
      008004 CC 80 F1         [ 2]   89 	jp	_main
                                     90 ;	return from main will return to caller
                                     91 ;--------------------------------------------------------
                                     92 ; code
                                     93 ;--------------------------------------------------------
                                     94 	.area CODE
                                     95 ;	inc/clk_init.h: 7: void clk_init(void){    
                                     96 ;	-----------------------------------------
                                     97 ;	 function clk_init
                                     98 ;	-----------------------------------------
      00802C                         99 _clk_init:
                                    100 ;	inc/clk_init.h: 8: CLK_ECKR|=CLK_ECKR_HSEEN;            
      00802C 72 10 50 C1      [ 1]  101 	bset	20673, #0
                                    102 ;	inc/clk_init.h: 9: CLK_SWCR|=CLK_SWCR_SWEN;               
      008030 72 12 50 C5      [ 1]  103 	bset	20677, #1
                                    104 ;	inc/clk_init.h: 10: while((CLK_ECKR & CLK_ECKR_HSERDY) == 0) {} 
      008034                        105 00101$:
      008034 C6 50 C1         [ 1]  106 	ld	a, 0x50c1
      008037 A5 02            [ 1]  107 	bcp	a, #0x02
      008039 27 F9            [ 1]  108 	jreq	00101$
                                    109 ;	inc/clk_init.h: 11: CLK_CKDIVR = 0;                    
      00803B 35 00 50 C6      [ 1]  110 	mov	0x50c6+0, #0x00
                                    111 ;	inc/clk_init.h: 12: CLK_SWR = 0xB4;                    
      00803F 35 B4 50 C4      [ 1]  112 	mov	0x50c4+0, #0xb4
                                    113 ;	inc/clk_init.h: 13: while ((CLK_SWCR & CLK_SWCR_SWIF) == 0){}
      008043                        114 00104$:
      008043 C6 50 C5         [ 1]  115 	ld	a, 0x50c5
      008046 A5 08            [ 1]  116 	bcp	a, #0x08
      008048 27 F9            [ 1]  117 	jreq	00104$
                                    118 ;	inc/clk_init.h: 14: CLK_CSSR|=CLK_CSSR_CSSEN;
      00804A 72 10 50 C8      [ 1]  119 	bset	20680, #0
                                    120 ;	inc/clk_init.h: 15: }
      00804E 81               [ 4]  121 	ret
                                    122 ;	inc/gpio_init.h: 10: void GPIO_init(void)
                                    123 ;	-----------------------------------------
                                    124 ;	 function GPIO_init
                                    125 ;	-----------------------------------------
      00804F                        126 _GPIO_init:
                                    127 ;	inc/gpio_init.h: 17: PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
      00804F 35 00 50 07      [ 1]  128 	mov	0x5007+0, #0x00
                                    129 ;	inc/gpio_init.h: 18: PB_CR1 = 0xff;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
      008053 35 FF 50 08      [ 1]  130 	mov	0x5008+0, #0xff
                                    131 ;	inc/gpio_init.h: 19: PB_CR2 = 0xff;                                                      //_______PORT_OUT
      008057 35 FF 50 09      [ 1]  132 	mov	0x5009+0, #0xff
                                    133 ;	inc/gpio_init.h: 21: PC_DDR = 0xff;                                                        //_______1__________________0________________0_____________otkritiy stok
      00805B 35 FF 50 0C      [ 1]  134 	mov	0x500c+0, #0xff
                                    135 ;	inc/gpio_init.h: 22: PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
      00805F 35 FF 50 0D      [ 1]  136 	mov	0x500d+0, #0xff
                                    137 ;	inc/gpio_init.h: 23: PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
      008063 35 00 50 0E      [ 1]  138 	mov	0x500e+0, #0x00
                                    139 ;	inc/gpio_init.h: 25: PD_DDR = 0xFF;   
      008067 35 FF 50 11      [ 1]  140 	mov	0x5011+0, #0xff
                                    141 ;	inc/gpio_init.h: 26: PD_CR1 = 0xFF;  
      00806B 35 FF 50 12      [ 1]  142 	mov	0x5012+0, #0xff
                                    143 ;	inc/gpio_init.h: 27: PD_CR2 = 0x00; 
      00806F 35 00 50 13      [ 1]  144 	mov	0x5013+0, #0x00
                                    145 ;	inc/gpio_init.h: 40: }
      008073 81               [ 4]  146 	ret
                                    147 ;	inc/uart1.h: 1: void uart1_init()
                                    148 ;	-----------------------------------------
                                    149 ;	 function uart1_init
                                    150 ;	-----------------------------------------
      008074                        151 _uart1_init:
                                    152 ;	inc/uart1.h: 3: PD_DDR&=~(1<<6);  
      008074 72 1D 50 11      [ 1]  153 	bres	20497, #6
                                    154 ;	inc/uart1.h: 4: PD_DDR|=(1<<5);             
      008078 72 1A 50 11      [ 1]  155 	bset	20497, #5
                                    156 ;	inc/uart1.h: 5: UART1_CR2|=UART1_CR2_REN;
      00807C 72 14 52 35      [ 1]  157 	bset	21045, #2
                                    158 ;	inc/uart1.h: 6: UART1_CR2|=UART1_CR2_TEN;  
      008080 72 16 52 35      [ 1]  159 	bset	21045, #3
                                    160 ;	inc/uart1.h: 7: UART1_BRR2 = 0x00;             
      008084 35 00 52 33      [ 1]  161 	mov	0x5233+0, #0x00
                                    162 ;	inc/uart1.h: 8: UART1_BRR1 = 0x48;            
      008088 35 48 52 32      [ 1]  163 	mov	0x5232+0, #0x48
                                    164 ;	inc/uart1.h: 9: }
      00808C 81               [ 4]  165 	ret
                                    166 ;	inc/uart1.h: 10: void tx(char *str)
                                    167 ;	-----------------------------------------
                                    168 ;	 function tx
                                    169 ;	-----------------------------------------
      00808D                        170 _tx:
                                    171 ;	inc/uart1.h: 14: while (!(UART1_SR & UART1_SR_TXE)) {}       
      00808D 1E 03            [ 2]  172 	ldw	x, (0x03, sp)
      00808F                        173 00101$:
      00808F C6 52 30         [ 1]  174 	ld	a, 0x5230
      008092 2A FB            [ 1]  175 	jrpl	00101$
                                    176 ;	inc/uart1.h: 15: UART1_DR=*str; 
      008094 F6               [ 1]  177 	ld	a, (x)
      008095 C7 52 31         [ 1]  178 	ld	0x5231, a
                                    179 ;	inc/uart1.h: 16: if(*str=='\r') break;
      008098 F6               [ 1]  180 	ld	a, (x)
      008099 A1 0D            [ 1]  181 	cp	a, #0x0d
      00809B 26 01            [ 1]  182 	jrne	00129$
      00809D 81               [ 4]  183 	ret
      00809E                        184 00129$:
                                    185 ;	inc/uart1.h: 17: *str++;
      00809E 5C               [ 1]  186 	incw	x
      00809F 20 EE            [ 2]  187 	jra	00101$
                                    188 ;	inc/uart1.h: 20: } 
      0080A1 81               [ 4]  189 	ret
                                    190 ;	inc/uart1.h: 21: void rx(char *str)
                                    191 ;	-----------------------------------------
                                    192 ;	 function rx
                                    193 ;	-----------------------------------------
      0080A2                        194 _rx:
                                    195 ;	inc/uart1.h: 23: while (*str!='\r')
      0080A2                        196 00104$:
      0080A2 1E 03            [ 2]  197 	ldw	x, (0x03, sp)
      0080A4 F6               [ 1]  198 	ld	a, (x)
      0080A5 A1 0D            [ 1]  199 	cp	a, #0x0d
      0080A7 26 01            [ 1]  200 	jrne	00129$
      0080A9 81               [ 4]  201 	ret
      0080AA                        202 00129$:
                                    203 ;	inc/uart1.h: 26: while ((UART1_SR & UART1_SR_RXNE)!=0)         //Æäåì ïîÿâëåíèÿ áàéòà
      0080AA                        204 00101$:
      0080AA C6 52 30         [ 1]  205 	ld	a, 0x5230
      0080AD A5 20            [ 1]  206 	bcp	a, #0x20
      0080AF 27 F1            [ 1]  207 	jreq	00104$
                                    208 ;	inc/uart1.h: 28: *str++;
      0080B1 5C               [ 1]  209 	incw	x
      0080B2 1F 03            [ 2]  210 	ldw	(0x03, sp), x
                                    211 ;	inc/uart1.h: 29: *str=UART1_DR; 
      0080B4 C6 52 31         [ 1]  212 	ld	a, 0x5231
      0080B7 F7               [ 1]  213 	ld	(x), a
      0080B8 20 F0            [ 2]  214 	jra	00101$
                                    215 ;	inc/uart1.h: 32: } 
      0080BA 81               [ 4]  216 	ret
                                    217 ;	inc/spi_slave.h: 1: void SPI_init() {
                                    218 ;	-----------------------------------------
                                    219 ;	 function SPI_init
                                    220 ;	-----------------------------------------
      0080BB                        221 _SPI_init:
                                    222 ;	inc/spi_slave.h: 3: SPI_CR1 = SPI_CR1_SPE ;
      0080BB 35 40 52 00      [ 1]  223 	mov	0x5200+0, #0x40
                                    224 ;	inc/spi_slave.h: 4: }
      0080BF 81               [ 4]  225 	ret
                                    226 ;	inc/spi_slave.h: 6: void SPI_write(int data) {
                                    227 ;	-----------------------------------------
                                    228 ;	 function SPI_write
                                    229 ;	-----------------------------------------
      0080C0                        230 _SPI_write:
                                    231 ;	inc/spi_slave.h: 7: SPI_DR = data;
      0080C0 7B 04            [ 1]  232 	ld	a, (0x04, sp)
      0080C2 C7 52 04         [ 1]  233 	ld	0x5204, a
                                    234 ;	inc/spi_slave.h: 8: while (!(SPI_SR & SPI_SR_TXE));
      0080C5                        235 00101$:
      0080C5 C6 52 03         [ 1]  236 	ld	a, 0x5203
      0080C8 A5 02            [ 1]  237 	bcp	a, #0x02
      0080CA 27 F9            [ 1]  238 	jreq	00101$
                                    239 ;	inc/spi_slave.h: 9: }
      0080CC 81               [ 4]  240 	ret
                                    241 ;	inc/spi_slave.h: 10: int SPI_read() {
                                    242 ;	-----------------------------------------
                                    243 ;	 function SPI_read
                                    244 ;	-----------------------------------------
      0080CD                        245 _SPI_read:
                                    246 ;	inc/spi_slave.h: 11: while (!(SPI_SR & SPI_SR_RXNE));
      0080CD                        247 00101$:
      0080CD C6 52 03         [ 1]  248 	ld	a, 0x5203
      0080D0 44               [ 1]  249 	srl	a
      0080D1 24 FA            [ 1]  250 	jrnc	00101$
                                    251 ;	inc/spi_slave.h: 12: return SPI_DR;
      0080D3 C6 52 04         [ 1]  252 	ld	a, 0x5204
      0080D6 5F               [ 1]  253 	clrw	x
      0080D7 97               [ 1]  254 	ld	xl, a
                                    255 ;	inc/spi_slave.h: 13: }
      0080D8 81               [ 4]  256 	ret
                                    257 ;	inc/spi_slave.h: 14: void SPI_deinit() {
                                    258 ;	-----------------------------------------
                                    259 ;	 function SPI_deinit
                                    260 ;	-----------------------------------------
      0080D9                        261 _SPI_deinit:
                                    262 ;	inc/spi_slave.h: 15: while (!(SPI_SR & SPI_SR_RXNE));
      0080D9                        263 00101$:
      0080D9 C6 52 03         [ 1]  264 	ld	a, 0x5203
      0080DC 97               [ 1]  265 	ld	xl, a
      0080DD 44               [ 1]  266 	srl	a
      0080DE 24 F9            [ 1]  267 	jrnc	00101$
                                    268 ;	inc/spi_slave.h: 16: while (!(SPI_SR & SPI_SR_TXE));
      0080E0 9F               [ 1]  269 	ld	a, xl
      0080E1 A4 02            [ 1]  270 	and	a, #0x02
      0080E3                        271 00104$:
      0080E3 4D               [ 1]  272 	tnz	a
      0080E4 27 FD            [ 1]  273 	jreq	00104$
                                    274 ;	inc/spi_slave.h: 17: while ((SPI_SR & SPI_SR_BSY));
      0080E6 9F               [ 1]  275 	ld	a, xl
      0080E7 A4 80            [ 1]  276 	and	a, #0x80
      0080E9                        277 00107$:
      0080E9 4D               [ 1]  278 	tnz	a
      0080EA 26 FD            [ 1]  279 	jrne	00107$
                                    280 ;	inc/spi_slave.h: 18: SPI_CR1 &=~ SPI_CR1_SPE;
      0080EC 72 1D 52 00      [ 1]  281 	bres	20992, #6
                                    282 ;	inc/spi_slave.h: 19: }
      0080F0 81               [ 4]  283 	ret
                                    284 ;	main.c: 9: void main(void)
                                    285 ;	-----------------------------------------
                                    286 ;	 function main
                                    287 ;	-----------------------------------------
      0080F1                        288 _main:
                                    289 ;	main.c: 12: clk_init();
      0080F1 CD 80 2C         [ 4]  290 	call	_clk_init
                                    291 ;	main.c: 13: uart1_init();
      0080F4 CD 80 74         [ 4]  292 	call	_uart1_init
                                    293 ;	main.c: 14: SPI_init();
      0080F7 CD 80 BB         [ 4]  294 	call	_SPI_init
                                    295 ;	main.c: 15: tx("start\n\r");
      0080FA 4B 24            [ 1]  296 	push	#<___str_0
      0080FC 4B 80            [ 1]  297 	push	#(___str_0 >> 8)
      0080FE CD 80 8D         [ 4]  298 	call	_tx
      008101 5B 02            [ 2]  299 	addw	sp, #2
                                    300 ;	main.c: 17: while (1) {
      008103                        301 00105$:
                                    302 ;	main.c: 19: data=SPI_read();
      008103 CD 80 CD         [ 4]  303 	call	_SPI_read
                                    304 ;	main.c: 20: while (!(UART1_SR & UART1_SR_TXE)) {}
      008106                        305 00101$:
      008106 C6 52 30         [ 1]  306 	ld	a, 0x5230
      008109 2A FB            [ 1]  307 	jrpl	00101$
                                    308 ;	main.c: 21: UART1_DR=data;
      00810B 9F               [ 1]  309 	ld	a, xl
      00810C C7 52 31         [ 1]  310 	ld	0x5231, a
                                    311 ;	main.c: 22: SPI_write(data+1);
      00810F 5C               [ 1]  312 	incw	x
      008110 89               [ 2]  313 	pushw	x
      008111 CD 80 C0         [ 4]  314 	call	_SPI_write
      008114 5B 02            [ 2]  315 	addw	sp, #2
      008116 20 EB            [ 2]  316 	jra	00105$
                                    317 ;	main.c: 24: }
      008118 81               [ 4]  318 	ret
                                    319 	.area CODE
                                    320 	.area CONST
      008024                        321 ___str_0:
      008024 73 74 61 72 74         322 	.ascii "start"
      008029 0A                     323 	.db 0x0a
      00802A 0D                     324 	.db 0x0d
      00802B 00                     325 	.db 0x00
                                    326 	.area INITIALIZER
                                    327 	.area CABS (ABS)
