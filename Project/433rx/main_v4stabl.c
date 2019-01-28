#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
///******************************************************global_variable*
volatile unsigned char timer=0, ext_intrrpt=0;
///*******************************************************TIM2_interrupt*/
INTERRUPT_HANDLER(TIM2_update,TIM2_OVR_UIF_IRQ){
    timer=1;
    TIM2_SR1&=~TIM_SR1_UIF;
}
///*******************************************************exti_interrupt*/
INTERRUPT_HANDLER(EXTI,4){

    ext_intrrpt=1;

}
///*******************************************************main*/
void main(void){
    unsigned char resiver=0;
    unsigned char i=0;
    unsigned char err_sig=0;//если 0 во время счета таймера внешних прирываний небыло
    unsigned char tim_wait=0;//если 1, таймер запущен, если 0 таймер не тикает.
    unsigned char startbit=0;
	clk_init();
	GPIO_init();
    TIM2_PSCR = 8;
    TIM2_CR1 |= TIM_CR1_OPM; 
    TIM2_IER |= TIM_IER_UIE;
    EXTI_CR1=4;//00: Падающий фронт и низкий уровень/01: только передний край/10: только падающая кромка/11: Восходящий и опускающийся край
    __asm__("rim\n");
    PD_ODR=0x00;
    while(1){
        
        while(!startbit){//wait startbit
            if(ext_intrrpt==1 && tim_wait==0){
                TIM2_ARRH = 0x01;
                TIM2_ARRL = 0xdf;  
                TIM2_CR1 |= TIM_CR1_CEN;
                tim_wait=1;
                ext_intrrpt=0;
            }else if(ext_intrrpt==1 && tim_wait==1){
                err_sig=1;
                ext_intrrpt=0;
            }
            if(timer==1 && err_sig==0 && PB_IDR&(1<<7)){
                tim_wait=0;
                timer=0;
                startbit=1;
            }else if(timer==1 && err_sig==1){
                timer=0;
                err_sig=0;
                tim_wait=0;
            }
        }
        
        while(i<8){
            if(ext_intrrpt==1 && tim_wait==0){
                TIM2_ARRH = 0x00;
                TIM2_ARRL = 0xaf;  
                TIM2_CR1 |= TIM_CR1_CEN;
                tim_wait=1;
                ext_intrrpt=0;
            }else if(ext_intrrpt==1 && tim_wait==1){
                err_sig=1;
                ext_intrrpt=0;
            }
            if(timer==1 && err_sig==0 && PB_IDR&(1<<7)){
                resiver|=(1<<i),
                i++;
                tim_wait=0;
                timer=0;
            }else if(timer==1 && err_sig==1){
                timer=0;
                err_sig=0;
                tim_wait=0;
            }else if(timer==1 && err_sig==0 && !(PB_IDR&(1<<7))){
                resiver&=~(1<<i),
                i++;
                timer=0;
                tim_wait=0;
            }
        }
        __asm__("sim\n");
        if(i>=8){
            i=0;
            startbit=0;
            if(resiver=='D'){
                PD_ODR=0x01;
            }else if(resiver=='A'){
                PD_ODR=0x10;
            }else if(resiver=='B'){
                PD_ODR=0x04;
            }else if(resiver=='C'){
                PD_ODR=0x08;
            }
        }
        __asm__("rim\n");
    }
}
