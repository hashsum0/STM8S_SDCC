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
		for(s=0;s<32;s++)
		{
		}
	}
}

void main(void)
{
/*variable*/

	int vzd=5,Kvzd=18,count=0,w=0,q=0;
	int ustavka=280;								
	int lcd=0;								
	int period=0;								
	int adc_data=0;								
	float result=0.0,oldresult=0.0,k=0.2,Nresult=0.0;							

/*init*/
    Init_HSI();
    GPIO_init();
    ADC_INIT();
  
/*body program*/
while(1)
{
			PC_ODR=0x00;
			PG_ODR=0x00;
			PD_ODR&=~((1<<4) |(1<<3)|(1<<2));
			delay(32);
			adc_data=ADC_read();						
			result=(k*adc_data)+(1-k)*oldresult;
			oldresult=result;
			Nresult=result+((ustavka>>1)-23);
			vzd=(ustavka-Nresult)*4+16;
			if(vzd>100)vzd=100;
			if(vzd<4)vzd=4;
			if(count<=0)count=24,lcd=Nresult; 
			
			
			bit_h(PE_ODR,0);
			for(period=0;period<100;period++)
				{
					if(period==vzd)bit_l(PE_ODR,0);
					if(period==20||period==60||period==100||period==140||period==180||period==220)out7seg(lcd);
					delay(2);
					w=(PD_IDR&((1<<7)|(1<<6)));
					if(w==0&&q==64&&ustavka<500) ustavka=ustavka+5,count=400,lcd=ustavka;
					if(w==0&&q==128&&ustavka>200) ustavka=ustavka-5,count=400,lcd=ustavka;
					q=w;
				}
				bit_l(PE_ODR,0);
				count--;
}

/*end*/	
}
