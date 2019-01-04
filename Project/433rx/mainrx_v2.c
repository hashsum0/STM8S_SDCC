#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
///******************************************************global_variable*
volatile unsigned int timer_flag=0;
///*******************************************************TIM2_interrupt*/
INTERRUPT_HANDLER(TIM2_update,TIM2_OVR_UIF_IRQ)
{
    timer_flag=1;
   
    TIM2_SR1&=~TIM_SR1_UIF;
     
}
///*******************************************************exti_interrupt*/
INTERRUPT_HANDLER(EXTI,4)         
{
   
    TIM2_CR1 |= TIM_CR1_CEN;
}
///*******************************************************main*/
void main(void)
{
    unsigned char resiver=0;
    unsigned int start_flag=0, i=0;
	clk_init();
	GPIO_init();
    TIM2_PSCR = 8;
    TIM2_ARRH = 0x00;
    TIM2_ARRL = 0xff;//880uS
    TIM2_CR1 |= TIM_CR1_OPM; 
    TIM2_IER |= TIM_IER_UIE;
    EXTI_CR1=4;//00: Падающий фронт и низкий уровень/01: только передний край/10: только падающая кромка/11: Восходящий и опускающийся край
    __asm__("rim\n");
    while(1)
        {
            while(!timer_flag);
            
            timer_flag=0;
            TIM2_ARRH = 0x00;
            
            if(PB_IDR&(1<<7) && !start_flag)start_flag=1,TIM2_ARRL = 0xaf;
            else if(PB_IDR&(1<<7) && start_flag)resiver|=(1<<i), i++;
            else if(!(PB_IDR&(1<<7)) && start_flag)resiver&=~(1<<i), i++;
            
            if(i>=8){
                i=start_flag=0;
                TIM2_ARRL = 0xff;
                if(resiver=='D')PD_ODR^=(1<<0);
            }
        }
}
