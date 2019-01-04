#include "stm8s.h"
#include "ir_decoder.h"
void IR_dec_init()
{
  PB_DDR&=~(1<<7);
  PB_CR1|=(1<<7);
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
 
      while(is_0());  // æäåì ïîÿâëåíèÿ 1 â ëèíèè
      for( ; i; i--){              // æäåì íå áåñêîíå÷íî!!!
            DelayMs(100);         // êóñî÷êàìè ïî 100 ìêñ
                       // ïðè ýòîì ñáðàñûâàåì WDT
            if(is_0()) break;       // ïðåêðàùàåì æäàòü ïðè 0 íà âõîäå
      }
      return END_100us - i;        // âîçâðàùàåì èíòåðâàë
}

int resive_ir(void){
      int code = 0;
      char i =0;
      short delta =0;
      static int oldcode = 0;
      PD_ODR &= ~(1<<0);
      while(is_1());// ñèíõðîíèçàöèÿ ñ íà÷àëîì èìïóëüñà
       // ââîä íå áîëåå çàäàííîãî êîë-âà áèòîâ
      for(i = MAX_BIT_CNT; i; i--){
            code =code<< 1;                  // ãîòîâèì î÷åðåäíîå ìåñòî áèòà
            delta = delta_t();  // èçìåðÿåì äëèòåëüíîñòü 1 â ëèíèè
            if((delta >= END_100us)) break;                   // åñëè ñëèøêîì äîëãî - êîíåö ïðèåìà            
            if(delta > LOG0_100us) code |= 1;             // åñëè ïðèåì 1 - çàíîñèì â áèò 1      
      }
      if((code > 0) && (code < 5)) return oldcode;      
      oldcode = code;      
      return code;                       // âîçâðàùàåì, ÷òî íàêîïèëîñü
} 
