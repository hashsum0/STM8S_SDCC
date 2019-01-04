
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



