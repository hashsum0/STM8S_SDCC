#include "inc/stm8s.h"
#include "inc/clk_init.h"

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
INTERRUPT_HANDLER(EXTI1,4)
{
	
        PD_ODR=!PD_ODR&(1<<0);
		
		
}

void main(void)
{
	clk_init();
	PB_DDR = 0x00;          
    PB_CR1 = 0xff;          
    PB_CR2 = 0xff;
	PD_DDR = 0xFF;   
    PD_CR1 = 0xFF;  
    PD_CR2 = 0x00;
    PD_ODR=0x00; 
    EXTI_CR1;
  __asm__("rim\n");
    while(1)
    {
	
	PD_ODR|=(1<<1);
	delay(500);		
	PD_ODR&=~(1<<1);
	delay(500);	
	}
}
