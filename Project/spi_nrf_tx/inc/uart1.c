#include "stm8s.h"
#include "uart1.h"
void uart1_init(){
        PD_DDR&=~(1<<6);  
        PD_DDR|=(1<<5);             
        UART1_CR2|=UART1_CR2_REN;
        UART1_CR2|=UART1_CR2_TEN;  
        UART1_BRR2 = 0x00;             
        UART1_BRR1 = 0x48;            
}
void tx(unsigned char *str){  
    while (1){
        while (!(UART1_SR & UART1_SR_TXE)) {}       
        UART1_DR=*str; 
        if(*str=='\r') break;
        *str++;
    }
} 
void rx(char *str){
    while (*str!='\r'){
        while ((UART1_SR & UART1_SR_RXNE)!=0){
            *str++;
            *str=UART1_DR; 
        }
    }
} 

