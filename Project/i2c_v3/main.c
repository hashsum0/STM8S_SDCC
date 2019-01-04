
#include "inc/stm8s.h"

#include "inc/i2c.h"

//############################################--MAIN--#################################
void main(void){
    int data=0,t=0;            //for clear
CLK_ICKR = 0; // Сбрасываем регистр внутреннего тактирования
CLK_ICKR|=(1<<0); // Включаем внутренний генератор HSI
CLK_ECKR = 0; // Отключаем внешний генератор
while ((CLK_ICKR&(1<<1))== 0); // Ждём стабилизации внутреннего генератора
CLK_CKDIVR = 0; // Устанавливаем максимальную частоту
CLK_CCOR = 0; // Выключаем CCO.
CLK_HSITRIMR = 0; // Turn off any HSIU trimming.
CLK_SWIMCCR = 0; // Set SWIM to run at clock / 2.
CLK_SWR = 0xe1; // Используем HSI в качестве источника тактиров
CLK_SWCR = 0; // Сброс флага переключения генераторов
CLK_SWCR = (1<<1); // Включаем переключение на HSI
while ((CLK_SWCR&(1<<0)) != 0); // Пауза, пока произойдёт переключение(CLK_SWCR_SWBSY != 0)
PC_DDR=0xFF;
PC_CR1=0xFF;
PC_ODR=0x00;
i2c_init();

while(1){
i2c_start();    
i2c_write_addr_dev(0xA0);
i2c_write_addr_mem(0x01);
i2c_write_data(0xcc);
i2c_stop();
t=5000;
while(t--);
i2c_start();
i2c_write_addr_dev(0xA0);
i2c_write_addr_mem(0x01);
data=i2c_read(0xA0);
PC_ODR=data;
}

//END
}

