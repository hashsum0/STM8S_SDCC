#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
#define out_set_bit PD_ODR|=(1<<4)
#define out_cli_bit PD_ODR&=~(1<<4)
//#include "inc/uart1.h"
//~ volatile unsigned int fl=0;
//~ ///******************************************************timer_interrupt*/
INTERRUPT_HANDLER(TIM2_update,TIM2_OVR_UIF_IRQ)
{
    TIM2_SR1 &= ~TIM_SR1_UIF;
}
void tim_wait(unsigned char reg_h, unsigned char reg_l)
{
        TIM2_ARRH = reg_h;
        TIM2_ARRL = reg_l;
        TIM2_CR1 |= TIM_CR1_CEN;
        __asm__("wfi\n");
}
void tx_set_bit()
{
        out_set_bit;
        tim_wait(0x00,0x40);//0x00,0x0f
        out_cli_bit;
        tim_wait(0x00,0x20);//0x00,0x08
}
void tx_cli_bit()
{
        out_set_bit;
        tim_wait(0x00,0x20);//0x00,0x08
        out_cli_bit;
        tim_wait(0x00,0x20);//0x00,0x08
}
void tx_start_bit()
{
            out_set_bit;
            tim_wait(0x00,0x80);//0x00,0x47
            out_cli_bit;
            tim_wait(0x00,0x20);//0x00,0x08
}
void tx_stop_bit()
{
            out_cli_bit;
            tim_wait(0x00,0x80);
}
void send_byte(unsigned char data)
{
    int i;
        tx_start_bit();
        for(i=0;i<=7;i++)
        {
            if(data&(1<<i))tx_set_bit();
            else tx_cli_bit();
        }
        tx_stop_bit();
}
void main(void)
{
	clk_init();
	GPIO_init();
    TIM2_PSCR = 10;
    TIM2_CR1|=TIM_CR1_OPM; 
    TIM2_IER |= TIM_IER_UIE;

    while(1)
    {
        if(!(PC_IDR&(1<<3))){
            send_byte('A');
        }
        if(!(PC_IDR&(1<<4))){
            send_byte('B');
        }
        if(!(PC_IDR&(1<<5))){
            send_byte('C');
        }
        if(!(PC_IDR&(1<<6))){
            send_byte('D');
        }
        //send_byte('D');
    }
}
