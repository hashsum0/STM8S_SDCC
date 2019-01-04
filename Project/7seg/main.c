#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
#include "inc/7sig.h"
///******************************************************global_variable*/
//volatile unsigned int f,d,q;
///******************************************************timer_interrupt*/
//INTERRUPT_HANDLER(TIM2_OVR_UIF,13)         
//{


   //TIM2_SR1&=~TIM_SR1_UIF; 
                         
   //out7seg(f,d);
  //TIM2_ARRH=0x60;           
  //TIM2_ARRL=0x00;
  //if((d++)>2)d=0;
  //TIM2_CR1|=TIM_CR1_CEN; 
//}
///*******************************************************exti_interrupt*/
//INTERRUPT_HANDLER(EXTI,4)         
//{
//int w=0,s;

   //w=(PB_IDR&((1<<0)|(1<<1)));
	  //__asm__("sim\n");
	  //if(w==0&&q==2&&f<998) f=f+1;
	  //if(w==0&&q==1&&f>0) f=f-1;
	  //q=w;
	  //w=0;
	  //for(s=0;s<512;s++)
		//{
		//}
	  //__asm__("rim\n");
	  
//}
///***********************************************************timer_init*/
//void TIME_init(void)
//{
  //TIM2_PSCR=0x01;         
  //TIM2_ARRH=0xff;           
  //TIM2_ARRL=0x00;
  //TIM2_CR1|=TIM_CR1_OPM;     
  //TIM2_IER|=TIM_IER_UIE;     
//}
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

/*****************************************************************main*/

void main(void)
{
	int f=0,d=0,w=0,q=0,fl1=0,fl2=0,fl3=0,fl4=0,fl5=0,fl6=0,fl7=0;
	unsigned int os[3]={0,0,0};
	long b=0;
	clk_init();
//__asm__("sim\n");
	GPIO_init();
	//TIME_init();
	//EXTI_CR1=8;
//__asm__("rim\n");
d=0;
//TIM2_CR1|=TIM_CR1_CEN; 

   while(1)
	{
		
		
		if((b&(1<<5))!=0&&fl1==0)
		{
		w=(PB_IDR&((1<<0)|(1<<1)));
	    if(w==0&&q==2&&f<998) f=f+1;
	    if(w==0&&q==1&&f>0) f=f-1;
	    q=w;
	    w=0;
	    fl1=1;
       }
       else if((b&(1<<5))==0&&fl1==1)fl1=0;
       
		if((b&(1<<6))!=0&&fl2==0)
		{
			out7seg(f,d);
			 if((d++)>2)d=0;
			  fl2=1;
		}
		else if((b&(1<<6))==0&&fl2==1)fl2=0;
		
		if((b&((1<<13)|(1<<14)|(1<<15)))!=0&&fl3==0)PD_ODR^=(1<<0),fl3=1;
		else if((b&((1<<13)|(1<<14)|(1<<15)))==0&&fl3==1)fl3=0;
		
		if((b&(1<<14))!=0&&fl4==0)PD_ODR^=(1<<4),fl4=1;
		else if((b&(1<<14))==0&&fl4==1)fl4=0;
		
		if((b&(1<<13))!=0&&fl5==0)PD_ODR^=(1<<5),fl5=1;
		else if((b&(1<<13))==0&&fl5==1)fl5=0;
		
		if((b&(1<<12))!=0&&fl6==0)PD_ODR^=(1<<6),fl6=1;
		else if((b&(1<<12))==0&&fl6==1)fl6=0;
		
		if((b&(1<<11))!=0&&fl7==0)PD_ODR^=(1<<7),fl7=1;
		else if((b&(1<<11))==0&&fl7==1)fl7=0;
		
		if((b++)==65535)b=0;
		//delay(2);
		//PD_OUT0=0;
		//delay(100);
		//a=PD_IN0;
		//if(a==0)PORTB=0xF0;
		//else PORTB=0x0F;
	}
}
