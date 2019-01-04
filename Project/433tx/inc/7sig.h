#define SEGPORT PC_ODR
#define NSEGPORT PD_ODR
#define segA    (1<<1)
#define segB    (1<<2) 
#define segC    (1<<3) 
#define segD    (1<<5) 
#define segE    (1<<4) 
#define segF    (1<<7) 
#define segG    (1<<6) 
#define segDP   (1<<0) 
#define nseg(i)  if(i==0)NSEGPORT&=~(1<<3); if(i==1)NSEGPORT&=~(1<<1); if(i==2)NSEGPORT&=~(1<<2);  
#define num0  (segA|segB|segC|segD|segE|segF)
#define num1  (segB|segC)
#define num2  (segA|segB|segG|segD|segE)
#define num3  (segA|segB|segC|segD|segG)
#define num4  (segB|segC|segG|segF)
#define num5  (segA|segG|segC|segD|segF)
#define num6  (segA|segG|segC|segD|segE|segF)
#define num7  (segA|segB|segC)
#define num8  (segA|segB|segC|segD|segE|segF|segG)
#define num9  (segA|segB|segC|segD|segG|segF)

void out7seg(volatile int t,volatile int q)
{
 //int q=0,w=0,r=0;
 
 unsigned int x[10]={num0, num1, num2, num3, num4, num5, num6, num7, num8, num9};
 
//  while(w!=6)
//  {
//	  for(q=0;q<3;q++)
//	  {
	   SEGPORT=0xff;
	   NSEGPORT|=(1<<3)|(1<<1)|(1<<2);
	   nseg(q);
	   if(q==0) SEGPORT&=~(x[t%1000/100]);
	   if(q==1) SEGPORT&=~(x[t%100/10]);
	   if(q==2) SEGPORT&=~(x[t%10]);
//	   for(r=0;r<2560;r++)
//	   {
//	   }
	   
//      }
 //    w++; 
 // }
}
