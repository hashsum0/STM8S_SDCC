#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
#include "inc/uart1.h"
///******************************************************global_variable*
volatile unsigned char resiver;
volatile unsigned int i=0,flag=0;
///*******************************************************TIM2_interrupt*/
INTERRUPT_HANDLER(TIM2_update,TIM2_OVR_UIF_IRQ)
{
    if(flag==0 && PB_IDR&(1<<7))flag=1;
    else if(flag==1 && PB_IDR&(1<<7))resiver|=(1<<i),i++;
    else if(flag==1 && !(PB_IDR&(1<<7)))resiver&=~(1<<i),i++;
    TIM2_SR1&=~TIM_SR1_UIF;
}
///*******************************************************exti_interrupt*/
INTERRUPT_HANDLER(EXTI,4)         
{
    TIM2_ARRH = 0x00;
    if(flag==0)TIM2_ARRL = 0xff;//880uS
    else if(flag==1)TIM2_ARRL = 0xaf;//880uS
    TIM2_CR1 |= TIM_CR1_CEN;
}
///*******************************************************main*/
void main(void)
{
	clk_init();
	GPIO_init();
    TIM2_PSCR = 8;
    TIM2_CR1 |= TIM_CR1_OPM; 
    TIM2_IER |= TIM_IER_UIE;
    EXTI_CR1=4;//00: Падающий фронт и низкий уровень/01: только передний край/10: только падающая кромка/11: Восходящий и опускающийся край
	uart1_init();
__asm__("rim\n");
while(1)
	{
      if(i>=8)i=0,flag=0;
      if(resiver=='D')PD_ODR&=~(1<<0);
      else PD_ODR|=(1<<0);
    }
	
}
