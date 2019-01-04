#define CLK_ECKR_HSEEN  (1<<0)
#define CLK_SWCR_SWEN   (1<<1)
#define CLK_ECKR_HSERDY (1<<1)
#define CLK_SWCR_SWIF   (1<<3)
#define CLK_CSSR_CSSEN  (1<<0)

void clk_init_HSE(void){    
    CLK_ECKR|=CLK_ECKR_HSEEN;            
    CLK_SWCR|=CLK_SWCR_SWEN;               
    while((CLK_ECKR & CLK_ECKR_HSERDY) == 0) {} 
    CLK_CKDIVR = 0;                    
    CLK_SWR = 0xB4;                    
    while ((CLK_SWCR & CLK_SWCR_SWIF) == 0){}
    CLK_CSSR|=CLK_CSSR_CSSEN;
    CLK_CCOR|=(1<<2)|(1<<0);
}

void clk_init_HSI()
{
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
CLK_SWCR= CLK_SWCR_SWEN; // Включаем переключение на HSI
while ((CLK_SWCR&(1<<0)) != 0); // Пауза, пока произойдёт переключение(CLK_SWCR_SWBSY != 0)
//CLK_CCOR|=(1<<0);
}
