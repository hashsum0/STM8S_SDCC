#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
#include "inc/i2c.h"


void main(void){
    int d=0;            //for clear
    clk_init_HSI(); //16MHz

    I2C_CR1&=~I2C_CR1_PE; //disable I2C
    I2C_FREQR = 0x10; //16MHz
//    I2C_OARH&=~(1<<7);
    I2C_OARH|=(1<<6);
    I2C_CCRL = 0x50; //100kHz
    I2C_CCRH = 0x00;
    I2C_TRISER|=0x11;
//    I2C_CR2|=I2C_CR2_POS ;
    I2C_CR1|= I2C_CR1_PE; //On
PC_DDR = 0xFF;                                                    
   PC_CR1 = 0xFF;                                                      
    PC_CR2 = 0x00;
write(1){

   //************************************************************start
    while ((I2C_SR3 & I2C_SR3_BUSY)); 
    I2C_CR2 |= I2C_CR2_START;
    
    while (!(I2C_SR1 & I2C_SR1_SB));  
    d=I2C_SR1;                        
    d=I2C_SR3;
    //I2C_SR3|=I2C_SR3_MSL;
//************************************************************write address dev  
    I2C_DR = 0xa0;                    
    while (!(I2C_SR1 & I2C_SR1_ADDR));
    
    d=I2C_SR1;                        
    d=I2C_SR3;
    I2C_CR2 |= (1 << I2C_CR2_ACK);
//************************************************************write address mem   
    I2C_SR3|=I2C_SR3_MSL;
    while (!(I2C_SR1 & I2C_SR1_TXE));
    I2C_DR = 0x01;                   
    d=I2C_SR1;
//************************************************************write data   
    while (!(I2C_SR1 & I2C_SR1_TXE));
    I2C_DR = 0x03;                  
    d=I2C_SR1;
//************************************************************stop    
    d=20000;   
while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
    I2C_CR2 |= I2C_CR2_STOP;       
    while (I2C_SR3 & I2C_SR3_MSL);
while (d--);

}
read{
//************************************************************start
    while ((I2C_SR3 & I2C_SR3_BUSY));
    I2C_CR2 |= I2C_CR2_START;
    while (!(I2C_SR1 & I2C_SR1_SB));  
    d=I2C_SR1;                        
    d=I2C_SR3;
//************************************************************write address dev  
    I2C_DR = 0xa0;                    
    while (!(I2C_SR1 & I2C_SR1_ADDR));
    d=I2C_SR1;                        
    d=I2C_SR3;
//************************************************************write address mem 
    I2C_SR3|=I2C_SR3_MSL;
    while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
    I2C_DR = 0x01;                   
    d=I2C_SR1;
//************************************************************restart
    I2C_CR2 |=I2C_CR2_ACK;
    I2C_CR2 |= I2C_CR2_START;
//************************************************************write address, read dev    
    while (!(I2C_SR1 & I2C_SR1_SB));  
    d=I2C_SR1;                        
    d=I2C_SR3;
    I2C_DR = 0xa1;                    
    while (!(I2C_SR1 & I2C_SR1_ADDR));
    d=I2C_SR1;                        
    d=I2C_SR3;
//************************************************************read data
    I2C_SR3|=I2C_SR3_MSL;     
    I2C_CR2 &= ~I2C_CR2_ACK;
    while (!(I2C_SR1 & I2C_SR1_RXNE));
    d=I2C_DR;
    PC_ODR=d<<2;
//************************************************************stop    
while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
    I2C_CR2 |= I2C_CR2_STOP;       
    while (I2C_SR3 & I2C_SR3_MSL);
}
//END
}
