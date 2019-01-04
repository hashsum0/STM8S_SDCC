
#define PORTData PC_ODR
#define lcden1 (PD_ODR|=(1<<5))
#define lcden0 (PD_ODR&=~(1<<5))
#define lcdrs1 (PD_ODR|=(1<<6))
#define lcdrs0 (PD_ODR&=~(1<<6))
 #define LCD_clear() LCD_command(0x1)	/* Clear display LCD */
 #define LCD_origin() LCD_command(0x2)	/* Set to origin LCD */
 #define LCD_row1() LCD_command(0x80)	/* Begin at Line 1 */
 #define LCD_row2() LCD_command(0xC0)   /* Begin at Line 2 */
 #define min 5
/***************************************************
 * Prototype(s)                                    *
 ***************************************************/

void LCD_enable(void);
void LCD_command(unsigned char command);
char LCD_putc(char tc);
void LCD_puts(int x,int y,unsigned char *lcd_string);
void shiftL(char i);
void shiftR(char i);
void LCD_init(void);
/***************************************************
 * Sources                                         *
 ***************************************************/
void _delay_ms(int t)
{
	int i,s;
	for(i=0;i<t;i++)
	{
		for(s=0;s<1512;s++)
		{
		}
	}
}

void LCD_enable(void)
{
    lcden0; /* Clear bit P2.4 */
    _delay_ms(min);
    lcden1; /* Set bit P2.4 */
}

void LCD_command(unsigned char command)
{	
    lcdrs0; /* Clear bit P2.5 */
    PORTData = (PORTData & 0x0f)|(command & 0xf0);
    LCD_enable();
    PORTData = (PORTData & 0x0f)|((command | 0xf0)<<4);
    LCD_enable();
     _delay_ms(min);
}

char LCD_putc(char tc){//??????? ?????? ????????. ???????
 switch (tc){
 case 'À': tc=0x41; break;  
 case 'Á': tc=0xA0; break;
 case 'Â': tc=0x42; break;
 case 'Ã': tc=0xA1; break;
 case 'Ä': tc=0xE0; break;
 case 'Å': tc=0x45; break;
 case '¨': tc=0xA2; break;
 case 'Æ': tc=0xA3; break;
 case 'Ç': tc=0xA4; break;
 case 'È': tc=0xA5; break;
 case 'É': tc=0xA6; break;
 case 'Ê': tc=0x4B; break;
 case 'Ë': tc=0xA7; break;
 case 'Ì': tc=0x4D; break;
 case 'Í': tc=0x48; break;
 case 'Î': tc=0x4F; break;
 case 'Ï': tc=0xA8; break;
 case 'Ð': tc=0x50; break;
 case 'Ñ': tc=0x43; break;
 case 'Ò': tc=0x54; break;
 case 'Ó': tc=0xA9; break;
 case 'Ô': tc=0xAA; break;
 case 'Õ': tc=0x58; break;
 case 'Ö': tc=0xE1; break;
 case '×': tc=0xAB; break;
 case 'Ø': tc=0xAC; break;
 case 'Ù': tc=0xE2; break;
 case 'Ü': tc=0xC4; break;
 case 'Ú': tc=0xAD; break;
 case 'Û': tc=0xAE; break;
 case 'Ý': tc=0xAF; break;
 case 'Þ': tc=0xB0; break;
 case 'ß': tc=0xB1; break;
 case 'à': tc=0x61; break;
 case 'á': tc=0xB2; break;
 case 'â': tc=0xB3; break;
 case 'ã': tc=0xB4; break;
 case 'ä': tc=0xE3; break;
 case 'å': tc=0x65; break;
 case '¸': tc=0xB5; break;
 case 'æ': tc=0xB6; break;
 case 'ç': tc=0xB7; break;
 case 'è': tc=0xB8; break;
 case 'é': tc=0xB9; break;
 case 'ê': tc=0xBA; break;
 case 'ë': tc=0xBB; break;
 case 'ì': tc=0xBC; break;
 case 'í': tc=0xBD; break;
 case 'î': tc=0x6F; break;
 case 'ï': tc=0xBE; break;
 case 'ð': tc=0x70; break;
 case 'ñ': tc=0x63; break;
 case 'ò': tc=0xBF; break;
 case 'ó': tc=0x79; break;
 case 'ô': tc=0xE4; break;
 case 'õ': tc=0x78; break;
 case 'ö': tc=0xE5; break;
 case '÷': tc=0xC0; break;
 case 'ø': tc=0xC1; break;
 case 'ù': tc=0xE6; break;
 case 'ú': tc=0xC2; break;
 case 'û': tc=0xC3; break;
 case 'ü': tc=0xC4; break;
 case 'ý': tc=0xC5; break;
 case 'þ': tc=0xC6; break;
 case 'ÿ': tc=0xC7; break;
 }
    lcdrs1;
    PORTData = (PORTData & 0x0f)|(tc & 0xf0);
    LCD_enable();
    PORTData = (PORTData & 0x0f)|((tc | 0xf0)<<4);
    LCD_enable();
 return 0;
 }

void LCD_puts(int x,int y,unsigned char *lcd_string)
{
	if(x==0 && y==1)LCD_command(0x80);
	if(x==0 && y==2)LCD_command(0xC0);
	if(x!=0 && y==1)LCD_command(128+x);
	if(x!=0 && y==2)LCD_command(192+x);
	if(y!=2 && y!=1)return;
	while (*lcd_string) 
	{
		LCD_putc(*lcd_string++);
	}
}

void LCD_init(void)
{
    lcden1;
    lcdrs0;   
    LCD_command(0x33);
    LCD_command(0x32);
    LCD_command(0x28);
    LCD_command(0x0C);
    LCD_command(0x06);
    LCD_command(0x01); /* Clear */
     _delay_ms(min);
}
void shiftL(char i)
{
int t;
for(t=0;t<i;t++)
{
LCD_command(0x1C);
 _delay_ms(150);
}
}
void shiftR(char i)
{
int t;
for(t=0;t<i;t++)
{
LCD_command(0x18);
 _delay_ms(150);
}
}



