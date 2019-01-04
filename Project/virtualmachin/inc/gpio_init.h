//#include "int/gpio_init.h"
void GPIO_init(void)
{
  
  PA_DDR = 0xFF;                                                        //_______PORT_IN
   PA_CR1 = 0xFF;                                                       //_______DDR________________CR1______________CR2___________FUNCTION  
    PA_CR2 = 0x00;                                                      //_______0__________________0________________0_____________bez podtiyzhki,bez prerbIvanii 
                                                                        //_______0__________________1________________0_____________c podtiyzhkoi,bez prerbIvanii
  PB_DDR = 0x00;                                                        //_______0__________________0________________1_____________bez podtiyzhki,c prerbIvaniem 
   PB_CR1 = 0x00;                                                       //_______0__________________1________________1_____________c podtiyzhki,c prerbIvanii
    PB_CR2 = 0x00;                                                      //_______PORT_OUT
                                                                        //_______DDR________________CR1______________CR2___________FUNCTION
  PC_DDR = 0xFF;                                                        //_______1__________________0________________0_____________otkritiy stok
   PC_CR1 = 0xFF;                                                       //_______1__________________1________________0_____________dvuhtakthiy vihod
    PC_CR2 = 0x00;                                                      //_______1__________________X________________1_____________skorost' do 10MHz
                                                                        //_______1__________________X _______________1_____________real'niy otkritiy stok
  PD_DDR = 0x3F;   
   PD_CR1 = 0xFF;  
    PD_CR2 = 0x00; 
  
  PE_DDR = 0xFF;   
   PE_CR1 = 0xFF;  
    PE_CR2 = 0x00; 
  
  PF_DDR = 0xFF;   
   PF_CR1 = 0xFF;  
    PF_CR2 = 0x00; 
  
  PG_DDR = 0xFF;   
   PG_CR1 = 0xFF;  
   PG_CR2 = 0x00; 
}


















