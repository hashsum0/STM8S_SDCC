#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
#include "inc/i2c.h"

//############################################--MAIN--#################################
void main(void){
    int data=0,t=0;            //for clear
    clk_init_HSI(); //16MHz
    i2c_init();

    PC_DDR = 0xFF;                                                    
    PC_CR1 = 0xFF;                                                      
    PC_CR2 = 0x00;
while(1){
i2c_write_byte(0xA0, 0x01, 0x0C);
t=25000;
while(t--);
data=i2c_read_byte(0xA0,0x01);
PC_ODR =0;
PC_ODR =data;
t=25000;
while(t--);
}

//END
}

