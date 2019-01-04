#include "inc/stm8s.h"
#include "inc/clk_init.h"
#include "inc/gpio_init.h"
#include "inc/uart1.h"
#include "inc/7sig.h"
//int x=0;
void delay(int t)
{
	int i,s;
	for(i=0;i<t;i++)
	{
		for(s=0;s<1512;s++)
		{
		}
	}
}
	
void main(void)
{

	int z=0,q=0,w=0,cont=0;
	clk_init();
	GPIO_init();

    while(1)
    {
			if(cont==48)
			{
		      w=(PD_IDR&((1<<7)|(1<<6)));
	          if(w==192&&q==64&&z<500) z++;
	          if(w==192&&q==128&&z>0) z--;
	          q=w;
	          w=0;
		     }
		     if(cont<=48)cont++;
		     if(cont>48)cont=0;
     		 if(cont==48)out7seg(z);
	}
}
