//этот код (был для AVR) я нашел в интернете.

#define LOG0_100us           1
#define LOG1_100us           2
#define END_100us            10
#define is_1()               (PB_IDR&(1<<7))
#define is_0()               (!is_1())
#define MAX_BIT_CNT          36
void IR_dec_init()
{
  PB_DDR&=~(1<<7);
}
void DelayMs(int t)
{
	int i,s;
	for(i=0;i<t;i++)
	{
		for(s=0;s<5;s++)
		{
		}
	}
}
static char delta_t(void){
      char i = END_100us;
 
      while(is_0());  // ждем появления 1 в линии
      for( ; i; i--){              // ждем не бесконечно!!!
            DelayMs(100);         // кусочками по 100 мкс
                       // при этом сбрасываем WDT
            if(is_0()) break;       // прекращаем ждать при 0 на входе
      }
      return END_100us - i;        // возвращаем интервал
}

int resive_ir(void){
      int code = 0;
      char i =0;
      short delta =0;
      static int oldcode = 0;
      PD_ODR &= ~(1<<0);
      while(is_1());// синхронизация с началом импульса
       // ввод не более заданного кол-ва битов
      for(i = MAX_BIT_CNT; i; i--){
            code =code<< 1;                  // готовим очередное место бита
            delta = delta_t();  // измеряем длительность 1 в линии
            if((delta >= END_100us)) break;                   // если слишком долго - конец приема            
            if(delta > LOG0_100us) code |= 1;             // если прием 1 - заносим в бит 1      
      }
      if((code > 0) && (code < 5)) return oldcode;      
      oldcode = code;      
      return code;                       // возвращаем, что накопилось
} 
