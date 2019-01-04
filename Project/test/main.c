#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
#include "inc/uart1.h"
//#include "inc/ADC.h"
void delay(int t)
{
	int i,s;
	for(i=0;i<t;i++)
	{
		for(s=0;s<512;s++)
		{
		}
	}
}

void main(void){
    int i=0;
	Init_HSE();
	//clk_init();
	gpio_init();
    uart1_init();
    while(1){
        tx("test\n\r");
        delay(2000);
        
    }
}
