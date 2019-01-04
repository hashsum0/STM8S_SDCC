#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
#include "inc/uart1.h"
///******************************************************global_variable*/
volatile unsigned int fl=0,c=0,d=0;
volatile unsigned int f[3];

void TIM2_update(void) __interrupt(TIM2_OVR_UIF_IRQ)
{
    
    if(PB_IDR&(1<<7) && fl==0)
    {
        fl=1;
        TIM2_SR1 &= ~TIM_SR1_UIF;
        TIM2_CR1 |= TIM_CR1_CEN;
    }
    else if(PB_IDR&(1<<7) && fl==1)
    {
        fl=2;
        TIM2_SR1 &= ~TIM_SR1_UIF;
    }
    else if((PB_IDR&(1<<7)) && fl==2)
    {
        f[0]|=(1<<c);
        c++;
        TIM2_SR1 &= ~TIM_SR1_UIF;
    }
    else if(!(PB_IDR&(1<<7)) && fl==2)
    {
        f[0]&=~(1<<c);
        c++;
       TIM2_SR1 &= ~TIM_SR1_UIF;
    }
    else TIM2_SR1 &= ~TIM_SR1_UIF;
    //if(c && c<8)PD_ODR|=(1<<1);
    if(c>=8)fl=0,c=0,d=1;
}
///*******************************************************exti_interrupt*/
INTERRUPT_HANDLER(EXTI,4)         
{
    PD_ODR|=(1<<1);
    TIM2_CR1 |= TIM_CR1_CEN;
}

void main(void)
{
    unsigned char data[6];
	clk_init();
	GPIO_init();
    TIM2_PSCR = 5;
    TIM2_ARRH = 0x01;
    TIM2_ARRL = 0x2f;
    TIM2_CR1|=TIM_CR1_OPM; 
    TIM2_IER |= TIM_IER_UIE;
    //~ 00: Падающий фронт и низкий уровень
    //~ 01: только передний край
    //~ 10: только падающая кромка
    //~ 11: Восходящий и опускающийся край
	EXTI_CR1=4;
    uart1_init();
__asm__("rim\n");
while(1)
	{
        if(d)
        {
            //~ data[0]=f[0]+48;
            //~ data[1]=f[0]%100/10+48;
            //~ data[2]=f[0]%10/1+48;
            //~ data[3]=f[0]%1+48;
            //~ data[1]='\n';
            //~ data[2]='\r';
            if(f[0]==41)tx("yes\n\r");
            d=0;
        }
	}
}

//~ ///******************************************************timer_interrupt*/




