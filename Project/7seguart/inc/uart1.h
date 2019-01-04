int x=0;
void uart1_init()
        {
          PD_DDR&=~(1<<6);  
          PD_DDR|=(1<<5);    
          PD_CR1&=~(1<<6);  
          PD_CR2&=~(1<<6);         
           UART1_CR2|=UART1_CR2_REN;
	   UART1_CR2|=UART1_CR2_TEN;  
            UART1_BRR2 = 0x00;             
             UART1_BRR1 = 0x48;            
        }
   void tx(char *str)
        {  
         while (1)
         {
          while (!(UART1_SR & UART1_SR_TXE)) {}       
          UART1_DR=*str; 
          if(*str=='\r') break;
          *str++;
	
         }
        } 
void rx(char *str)
       {
		   char r=0;
          while (r!='\r')
         {
          UART1_SR&=~(1<<5); 
          while ((UART1_SR & UART1_SR_RXNE)==0)         //Æäåì ïîÿâëåíèÿ áàéòà
          {
           
          __asm__("nop\n");
          } 
          r=UART1_DR; 
          
         *str++=r;
         }
	       
       } 
void test()
{
	
	if(x==0)PC_ODR=2;
	if(x==1)PC_ODR=4;
	if(x==2)PC_ODR=8;
	x++;
	if(x>2) x=0;
	}		
