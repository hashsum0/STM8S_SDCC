#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
#include "inc/IR_decoder.h"
#define UPR_PIN_ON    PD_ODR|=(1<<2)
#define UPR_PIN_OFF    PD_ODR&=~(1<<2)
#define UVILCHENIE    3570     //Данные цыфры-код кнпки пульта
#define UMENSHENIE    3314
 /******************************************/
int flag=0,i=0;      //флаг разрешения упровления
 /******************************************/
INTERRUPT_HANDLER( TIM2_OVR_UIF, 15)           //обработчик прерывания по переполнению таймера 
{
   if(flag==1) UPR_PIN_ON;                      
   TIM2_SR1&=~(1<<0);                        //UIF-сбрасываем флаг прерывания
}
 /*******************************************/
INTERRUPT_HANDLER( EXTI_PORTB_IRQHandler, 6) //обработчик прерывания датчика перехода нуля
{ 
    UPR_PIN_OFF;
    TIM2_ARRH=i;           
    TIM2_ARRL=0x00; 
    TIM2_CR1|=(1<<0);                       //CEN-запускаем таймер
}

/********************************************/
void DelayUs(unsigned int msec)
{
  unsigned int x;
   for(x=0; x<=msec;x++);
}
void delay(int sec)
{
 int t=0;
  for(t=0;t<=sec;t++)
   {
    DelayMs(25000);
     DelayMs(25000);
   }
}
/********************************************/
int main( void )
{
    int code=0;    //переменная для ИК команд
  /********************************************/
  clk_init_HSE();                                   //инициируем все что нужно
__asm__("sim");
  GPIO_init();
  
  EXTI_CR1|=(1<<2); //PBIS=01
  
  TIM2_PSCR=0x01;
  TIM2_ARRH=0xd6;           
  TIM2_ARRL=0x00;
  TIM2_CR1|=(1<<3); //OPM
  TIM2_IER|=(1<<0); //UIE
  
  IR_dec_init();
__asm__("rim");
  /*******************************************/
delay(5);                                         //этот кусок кода-плавное включение света
for(i=0xd6;i>0x6b;i--)
{
  if(i<0xd2)flag=1;
  DelayUs(20000);
}
  i=0x6b;
  
  /*******************************************/
    while(1)
    {
            
         code =resive_ir();
           
           if(code==UMENSHENIE)
           {
            i=i+2;                     //увеличеваем значение для регистра предварительной загрузки
            if(i>=0xd4)flag=0;         //если свет выключен то и упровление не нужно
            if(i>=0xd6)i=0xd6;         //если дальше увеличевать то лампа будет маргать т.к. мы залезем в другой полупериод
            }
           
           if(code==UVILCHENIE)        //тоже самое только на оборот
           {
             
            i=i-2;
            if(i<0xd6)flag=1;
            if(i<=0x05)i=0x05;
            
           }
          
           
       
        
    }
  /******************************************/ 
}
