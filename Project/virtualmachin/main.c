#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
#include "inc/ADC.h"
#include "inc/7sig.h"
#define bit_h(reg,bit) reg|=(1<<bit)
#define bit_l(reg,bit) reg&=~(1<<bit)
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
	
	int a=0, pausON=100, pausOFF=100, data_sum=150, seg=0, adc_data=0, oldadc=0, pauseled=0, pauseled2=0, format_data=150, q=0, w=0, f=215, z=50;
	clk_init();
	GPIO_init();
	//ADC_INIT();
	//PD_DDR&=~(1<<6)|(1<<7);
    while(1)
    {
		bit_h(PD_ODR,2);
		delay(100);
		bit_l(PD_ODR,2);
		delay(100);
    //PD_ODR&=~(1<<0);
    ///*********************************************************************/	
	//for(a=0;a<8;a++){
		
		//w=(PD_IDR&((1<<7)|(1<<6)));
	    //if(w==0&&q==64&&f<500) f=f+5, data_sum=f, pauseled=26000;
	    //if(w==0&&q==128&&f>0) f=f-5, data_sum=f, pauseled=26000;
	    //q=w;
	    //w=0;
	    //out7seg(data_sum,seg);
	    //out7seg(data_sum,seg);
	    //out7seg(data_sum,seg);
	    //seg++;
	    //if(seg>2)seg=0;
	    
	    //if(pauseled!=0)pauseled=pauseled-1;
	    //if(pauseled2!=0)pauseled2=pauseled2-1;
	    //if(pauseled==0&&pauseled2==0)data_sum=format_data, pauseled2=10000;
		//}
///*********************************************************************/
	//adc_data=ADC_read();
	//adc_data=adc_data+oldadc;
	//adc_data=adc_data>>1;
	//format_data=adc_data;
	//oldadc=adc_data;
	
	//if(format_data<(f+5))pausON=(f+18)-format_data;
	//if(format_data>(f-1))pausON=0;
	//pausOFF=48-pausON;
///*********************************************************************/	
	//for(a=0;a<pausON;a++){
			//PD_ODR|=(1<<0);
		//w=(PD_IDR&((1<<7)|(1<<6)));
	    //if(w==0&&q==64&&f<500) f=f+5, data_sum=f, pauseled=26000;
	    //if(w==0&&q==128&&f>0) f=f-5, data_sum=f, pauseled=26000;
	    //q=w;
	    //w=0;
	    //out7seg(data_sum,seg);
	    //out7seg(data_sum,seg);
	    //out7seg(data_sum,seg);
	    //seg++;
	    //if(seg>2)seg=0;
	    
	    //if(pauseled!=0)pauseled=pauseled-1;
	    //if(pauseled2!=0)pauseled2=pauseled2-1;
	    //if(pauseled==0&&pauseled2==0)data_sum=format_data, pauseled2=10000;
		//}
///*********************************************************************/		
	//for(a=0;a<pausOFF;a++){
			//PD_ODR&=~(1<<0);
		//w=(PD_IDR&((1<<7)|(1<<6)));
	    //if(w==0&&q==64&&f<500) f=f+5, data_sum=f, pauseled=26000;
	    //if(w==0&&q==128&&f>0) f=f-5, data_sum=f, pauseled=26000;
	    //q=w;
	    //w=0;
	    //out7seg(data_sum,seg);
	    //out7seg(data_sum,seg);
	    //out7seg(data_sum,seg);
	    //seg++;
	    //if(seg>2)seg=0;
	    
	    //if(pauseled!=0)pauseled=pauseled-1;
	    //if(pauseled2!=0)pauseled2=pauseled2-1;
	    //if(pauseled==0&&pauseled2==0)data_sum=format_data, pauseled2=10000;
		//}
///*********************************************************************/	
	        
	}
}
