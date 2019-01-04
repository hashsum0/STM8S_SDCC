#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
#include "inc/ADC.h"
#include "inc/7sig.h"
#define bit_h(reg,bit) reg|=(1<<bit)     //установка        bit в reg
#define bit_l(reg,bit) reg&=~(1<<bit)    //сброс            bit в reg
#define read_bit(reg,bit) (reg*(1<<bit)) //чтение состояния bit в reg
void delay(int t)
{
	int i,s;
	for(i=0;i<t;i++)
	{
		for(s=0;s<512;s++)
		{
		}
	}
}
int mediana(int* adc)
{
 int t=0,n=0;
 int result[4]={0,0,0,0};
 for(t=0;t<4;t++)
	{
		if(adc[t]<=adc[0])n++;
		if(adc[t]<=adc[1])n++;
		if(adc[t]<=adc[2])n++;
		if(adc[t]<=adc[3])n++;
		if(result[4-n]==0)result[4-n]=adc[t];
		else if(result[4-n+1]==0)result[4-n+1]=adc[t];
		else if(result[4-n+2]==0)result[4-n+2]=adc[t];
		else if(result[4-n+3]==0)result[4-n+3]=adc[t];
		n=0;
	}
 return result[1];		
}
void main(void)
{
/*variable*/
	int counter=123,i=0,n=0,ct=0,fl=0;   //период управления
	int in[4]={0,0,0,0},res=0;  
/*init*/
    Init_HSI();
    GPIO_init();
    ADC_INIT();
  
/*body program*/
	while(1)
	{			  
          in[3]=ADC_read();
          in[2]=ADC_read();
          in[1]=ADC_read();
          in[0]=ADC_read();
          
			res=mediana(in);
		
			if(ct>=20)counter=res,ct=0;
			if(ct<20)ct++;
			out7seg(counter);       
			delay(30);
          
	}
/*end*/	
}
