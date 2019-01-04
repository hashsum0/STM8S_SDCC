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
	float volt=0.0, volt_old=0.0, k=0.1;// vold=0, vcontl=0,vconth=0;
	int vadc=0,v=0,cadc=0,count=0;
	clk_init_HSI();
	GPIO_init();
	LCD_init();
	ADC_INIT();
	
    while(1)
    {
	vadc=ADC_read0();
	
	volt=(k*vadc)+(1-k)*volt_old;
	volt_old=volt;
	
	v=volt*0.0097*6*10;
	volts[0]=(v%1000/100)+48;
	volts[1]=(v%100/10)+48;
	volts[2]='.';
	volts[3]=(v%10)+48;
	volts[4]=0;
	
	if(count>=50){
		count=0;
	LCD_puts(0,1,"U=");
	LCD_puts(3,1,volts);
	}
	count++;	
	}
}
