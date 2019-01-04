#include "stm8s.h"
#include "clk_init.h"
#include "uart1.h"
#include "ir_decoder.h"
void delay(int t){
    int i=0, z=0;
    for(i=0;i<t;i++){
        for(z=0;z<1512;z++)__asm__("nop");
    }
}
int main( void )
{
    int code=0;    //переменная для ИК команд
    unsigned char q[5];
  /********************************************/
    clk_init_HSE();                                   //инициируем все что нужно
    uart1_init();
    IR_dec_init();
    while(1){
        
    code =resive_ir();
   
    q[0]=48+(code%10000/1000);
    q[1]=48+(code%1000/100);
    q[2]=48+(code%100/10);
    q[3]=48+(code%10);
    q[4]='\n';
    tx(q);
    delay(100);
    }

  /******************************************/ 
}
