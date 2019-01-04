
#define segA   PC_ODR&=~(1<<1)
#define segB   PC_ODR&=~(1<<2) 
#define segC   PC_ODR&=~(1<<3) 
#define segD   PC_ODR&=~(1<<5) 
#define segE   PC_ODR&=~(1<<4) 
#define segF   PC_ODR&=~(1<<7) 
#define segG   PC_ODR&=~(1<<6) 
int q=0;

void out7seg(volatile int t)
{
	int num=0;
    PC_ODR=0xff;
	   PD_ODR|=(1<<3)|(1<<1)|(1<<2);
	   
	   if(q==0) num=(t%1000/100),PD_ODR&=~(1<<1);
	   if(q==1) num=(t%100/10),PD_ODR&=~(1<<2);
	   if(q==2) num=(t%10),PD_ODR&=~(1<<3);
	   q++;
	   if(q>2) q=0;
	   switch (num)
	   {
		 case 0:   
		       segA,segB,segC,segD,segE,segF;
		       break;
		 case 1:   
		       segB,segC;
		       break;
		 case 2:   
		       segA,segB,segG,segD,segE;
		       break;
		 case 3:   
		       segA,segB,segC,segD,segG;
		       break;
		 case 4:   
		       segF,segB,segG,segC;
		       break;
		 case 5:   
		       segA,segC,segD,segF,segG;
		       break;
		 case 6:   
		       segA,segC,segD,segE,segF,segG;
		       break;
		 case 7:   
		       segA,segB,segC;
		       break;
		 case 8:   
		       segA,segB,segC,segD,segE,segF,segG;
		       break;
		 case 9:   
		       segA,segB,segC,segD,segF,segG;
		       break;
		 default : 
		         break;
	   }

}
