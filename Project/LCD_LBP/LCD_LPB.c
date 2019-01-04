#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
#include "inc/LCDv2.h"
#include "inc/ADC.h"
void delay(int t)
{
	int i,s;
	for(i=0;i<t;i++)
	{
		for(s=0;s<1512;s++)
		{
		}
	}
}


void main(void)
{
	unsigned char volts[5];
	unsigned char currient[5];
	float volt=0.0, volt_old=0.0, curr=0.0, curr_old=0.0, k=0.5;// vold=0, vcontl=0,vconth=0;
	int vadc=0,v=0,cadc=0,c=0;
	clk_nit_HSI();
	GPIO_init();
	LCD_init();
	ADC_INIT();
	
    while(1)
    {
	vadc=ADC_read3();
	cadc=ADC_read4();
	
	volt=(k*vadc)+(1-k)*volt_old;
	volt_old=volt;
	
	curr=(k*cadc)+(1-k)*curr_old;
	curr_old=curr;
	
	v=volt*0.0097*6*10;
	volts[0]=(v%1000/100)+48;
	volts[1]=(v%100/10)+48;
	volts[2]='.';
	volts[3]=(v%10)+48;
	volts[4]=0;
	
	c=curr*0.0097*100;
	currient[0]=(c%1000/100)+48;
	currient[1]='.';
	currient[2]=(c%100/10)+48;
	currient[3]=(c%10)+48;
	currient[4]=0;
	
	LCD_puts(0,1,"U=");
	LCD_puts(3,1,volts);
	LCD_puts(0,2,"I=");
	LCD_puts(3,2,currient);
	delay(100);	
	}
}
