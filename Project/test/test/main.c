#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
#include "inc/ADC.h"
#include "inc/7sig.h"
void delay(int t)
{
	int i,s;
	for(i=0;i<t;i++)
	{
		for(s=0;s<1512;s++)
		{
			__asm__("nop\n");
		}
	}
}

void main(void)
{
	int f=150,w=0,s=0,t=0,q=0,counter=0,ironON=200,ironOFF=55,format_data=0,oldadc=0,adc_data=0;
	clk_init();
	gpio_init();
	ADC_INIT();
    while(1)
    {
	if(counter<=32) counter++;
	if(counter>32) counter=0;
	if((counter&(1<<2))!=0)
	 {
	  out7seg(format_data,t);
      w=(PD_IDR&((1<<7)|(1<<6)));
      if(w==128&&q==192&&f<500)   f=f+1;
	  if(w==64&&q==192&&f>0)    f=f-1;
	  q=w;
	  w=0;
	   if(t<=2)t++;
	   if(t>2)t=0;
	   
      }	
      if(counter==8||counter==16||counter==24)
	 {
	  //******************ON***************
	   if(ironON!=0)
	   {
		   PD_ODR|=(1<<0);
		   --ironON;
	   }
	   //*******************OFF*************
	    if(ironON==0&&ironOFF!=0)
	   {
		   PD_ODR&=~(1<<0);
		   --ironOFF;
	   }
	   //*******************WRITE****************
	   if(ironON==0&&ironOFF==0)
	   {
		   adc_data=ADC_read();
	       adc_data=adc_data+oldadc;
	       adc_data=adc_data>>1;
	       format_data=adc_data;
	       oldadc=adc_data;

		 ironON=f-format_data;
		 if(ironON>120)ironON=120;
		 if(ironON<0)ironON=0;
		 ironOFF=128-ironON;
	   }
	   //***********************************
      }	
	}
}
