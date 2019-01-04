#define TIM3_CR1 *(unsigned char*)0x5320
#define TIM3_CCMR2 *(unsigned char*)0x5326
#define TIM3_CCER1 *(unsigned char*)0x5327
#define TIM3_PSCR *(unsigned char*)0x532A
#define TIM3_ARRH *(unsigned char*)0x532B
#define TIM3_ARRL *(unsigned char*)0x532C
#define TIM3_CCR2H *(unsigned char*)0x532F
#define TIM3_CCR2L *(unsigned char*)0x5330


void TIM3_CH2_init()
{
     TIM3_PSCR=0x02;             //HSE/ 1 = f Hz
     TIM3_ARRH=0xff;             //Frequency H
     TIM3_ARRL=0x00;             //Frequency L	
     TIM3_CCR2H = 0x00;          //Skvazhnost''
     TIM3_CCR2L = 0x00;          //CCRx
     TIM3_CCER1|=(1<<4);      //signal out enable(1<<0)or(1<<4)
     TIM3_CCER1&=~(1<<5);      //polare 0-H,1-L(1<<1)or(1<<5)
     TIM3_CCMR2|=(1<<6)|(1<<5);        //110 (PWM mode 1) or 111 (PWM mode 2)
     TIM3_CCMR2&=~(1<<4);  
     TIM3_CR1|=(1<<0);             //enable   
}



void TIM3_CH2_PWM(int t,int z)
{
  TIM3_CCR2H=t;      //CCR2L    FOR CH2//CCR1H    FOR CH1 
  TIM3_CCR2L=z;      //CCR2L    FOR CH2//CCR1L    FOR CH1  
}
//*********************************************************************************************************
