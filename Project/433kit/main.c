#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
///******************************************************global_variable*
volatile unsigned char timer=0;
///*******************************************************TIM2_interrupt*/
INTERRUPT_HANDLER(TIM2_update,TIM2_OVR_UIF_IRQ)
{
    timer=1;
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
    unsigned char i=0;
    unsigned int t=0;
    unsigned char startrx=0;
	clk_init();
	GPIO_init();
    TIM2_PSCR = 8;
    TIM2_ARRH = 0x00;
    TIM2_ARRL = 0xff;//880uS
    TIM2_CR1 |= TIM_CR1_OPM; 
    TIM2_IER |= TIM_IER_UIE;
    EXTI_CR1=4;//00: Падающий фронт и низкий уровень/01: только передний край/10: только падающая кромка/11: Восходящий и опускающийся край
    __asm__("rim\n");
    PD_ODR=0x00;
    while(1)
        {
            while(!(timer)){
            PD_ODR^=(1<<7),t=0;
               
            }
            
            timer=0;
            TIM2_ARRH = 0x00;
            
            if(PB_IDR&(1<<7) && !startrx)
                startrx=1,
                TIM2_ARRL = 0xaf;
            else if(PB_IDR&(1<<7) && startrx)
                resiver|=(1<<i),
                i++;
            else if(!(PB_IDR&(1<<7)) && startrx)
                resiver&=~(1<<i),
                i++;
            
            if(i>=8){
                i=0;
                startrx=0;
                TIM2_ARRL = 0xff;
                if(resiver=='D')
                    PD_ODR=0x01;
                else if(resiver=='A')
                    PD_ODR=0x10;
                else if(resiver=='B')
                    PD_ODR=0x04;
                else if(resiver=='C')
                    PD_ODR=0x08;
            }
        }
}
