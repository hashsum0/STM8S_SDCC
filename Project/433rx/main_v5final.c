#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
#define ext_intrrpt   0 //если 1 то есть внешнее прерывание
#define tim_end       1 //если 1 то таймер закончил счет
#define tim_count     2 //если 1 то таймер считает
#define err_tim_count 3 //если 1 то вовремя счета таймера произошло внешнее прирывание - это ошибка.
#define startbit      4 //если 1 то стартбит получен
#define SetBit(reg,bit) reg |= (1<<bit)
#define ClearBit(reg,bit) reg &=~ (1<<bit)
#define GetBit(reg,bit) reg&(1<<bit)
///******************************************************global_variable*
volatile unsigned char flag=0; //переменная для флагов
///*******************************************************TIM2_interrupt*/
INTERRUPT_HANDLER(TIM2_update,TIM2_OVR_UIF_IRQ){
    SetBit(flag,tim_end);
    TIM2_SR1&=~TIM_SR1_UIF;
}
///*******************************************************exti_interrupt*/
INTERRUPT_HANDLER(EXTI,4){
    SetBit(flag,ext_intrrpt);
}
///*******************************************************main*/
void main(void){
    unsigned char resiver=0;
    unsigned char i=0;
	clk_init();
	GPIO_init();
    TIM2_PSCR = 8;
    TIM2_CR1 |= TIM_CR1_OPM; 
    TIM2_IER |= TIM_IER_UIE;
    EXTI_CR1=4;//00: Падающий фронт и низкий уровень/01: только передний край/10: только падающая кромка/11: Восходящий и опускающийся край
    __asm__("rim\n");
    PD_ODR=0x00;
    while(1){
        
        while(!(GetBit(flag,startbit))){//wait startbit
            if(GetBit(flag,ext_intrrpt)){
                if(!(GetBit(flag,tim_count))){
                    TIM2_ARRH = 0x01;
                    TIM2_ARRL = 0xdf;  
                    TIM2_CR1 |= TIM_CR1_CEN;
                    SetBit(flag,tim_count);
                    ClearBit(flag,ext_intrrpt);            
                }else{
                    SetBit(flag,err_tim_count);
                    ClearBit(flag,ext_intrrpt);
                }
            }
            if(GetBit(flag,tim_end)){
                if(!(GetBit(flag,err_tim_count)) && PB_IDR&(1<<7)){
                    ClearBit(flag,tim_count);
                    ClearBit(flag,tim_end);
                    SetBit(flag,startbit);
                }else{
                    ClearBit(flag,tim_end);
                    ClearBit(flag,err_tim_count);
                    ClearBit(flag,tim_count); 
                }
            }
        }

        while(i<8){//wait startbit
            if(GetBit(flag,ext_intrrpt)){
                if(!(GetBit(flag,tim_count))){
                    TIM2_ARRH = 0x00;
                    TIM2_ARRL = 0xaf;  
                    TIM2_CR1 |= TIM_CR1_CEN;
                    SetBit(flag,tim_count);
                    ClearBit(flag,ext_intrrpt);            
                }else{
                    SetBit(flag,err_tim_count);
                    ClearBit(flag,ext_intrrpt);
                }
            }
            if(GetBit(flag,tim_end)){
                if(!(GetBit(flag,err_tim_count)) && PB_IDR&(1<<7)){
                    resiver|=(1<<i),
                    i++;
                    ClearBit(flag,tim_count);
                    ClearBit(flag,tim_end);
                }else if(!(GetBit(flag,err_tim_count)) && !(PB_IDR&(1<<7))){
                    resiver&=~(1<<i),
                    i++;
                    ClearBit(flag,tim_end);
                    ClearBit(flag,tim_count);
                }else{
                    ClearBit(flag,tim_end);
                    ClearBit(flag,err_tim_count);
                    ClearBit(flag,tim_count); 
                }
            }
        }
        __asm__("sim\n");
        if(i>=8){
            i=0;
            ClearBit(flag,startbit);
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
