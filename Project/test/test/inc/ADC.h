
#define ADC_CSR   *(unsigned char*)0x5400
#define ADC_CR1   *(unsigned char*)0x5401
#define ADC_CR2   *(unsigned char*)0x5402 
#define ADC_CR3   *(unsigned char*)0x5403
#define ADC_DRH   *(unsigned char*)0x5404
#define ADC_DRL   *(unsigned char*)0x5405 
#define ADC_TDRH  *(unsigned char*)0x5406
#define ADC_TDRL  *(unsigned char*)0x5407
#define ADC_HTRH  *(unsigned char*)0x5408
#define ADC_HTRL  *(unsigned char*)0x5409
#define ADC_LTRH  *(unsigned char*)0x540A
#define ADC_LTRL  *(unsigned char*)0x540B
#define ADC_AWSRH *(unsigned char*)0x540C
#define ADC_AWSRL *(unsigned char*)0x540D
#define ADC_AWCRH *(unsigned char*)0x540E
#define ADC_AWCRL *(unsigned char*)0x540F
#define ADC_CSR_CH0      ADC_CSR&=~((1<<3)|(1<<2)|(1<<1)|(1<<0)) 
#define ADC_CSR_CH1      ADC_CSR|=(1<<0)
#define ADC_CSR_CH2      ADC_CSR|=(1<<1)
#define ADC_CSR_CH3      ADC_CSR|=(1<<1)|(1<<0)
#define ADC_CSR_CH4      ADC_CSR|=(1<<2)
#define ADC_CSR_CH5      ADC_CSR|=(1<<2)|(1<<0)
#define ADC_CSR_CH6      ADC_CSR|=(1<<2)|(1<<1)
#define ADC_CSR_CH7      ADC_CSR|=(1<<2)|(1<<1)|(1<<0)
#define ADC_CSR_CH8      ADC_CSR|=(1<<3)
#define ADC_CSR_CH9      ADC_CSR|=(1<<3)|(1<<0)
#define ADC_CSR_CH10     ADC_CSR|=(1<<3)|(1<<1)
#define ADC_CSR_CH11     ADC_CSR|=(1<<3)|(1<<1)|(1<<0)
#define ADC_CSR_CH12     ADC_CSR|=(1<<3)|(1<<2)
#define ADC_CSR_CH13     ADC_CSR|=(1<<3)|(1<<2)|(1<<0)
#define ADC_CSR_CH14     ADC_CSR|=(1<<3)|(1<<2)|(1<<1)
#define ADC_CSR_CH15     ADC_CSR|=(1<<3)|(1<<2)|(1<<1)|(1<<0)

#define ADC_CR1_SPSEL2      ADC_CR1&=~((1<<6)|(1<<5)|(1<<4))
#define ADC_CR1_SPSEL3       ADC_CR1|=(1<<4)
#define ADC_CR1_SPSEL4       ADC_CR1|=(1<<5)
#define ADC_CR1_SPSEL6       ADC_CR1|=(1<<5)|(1<<4)
#define ADC_CR1_SPSEL8       ADC_CR1|=(1<<6)
#define ADC_CR1_SPSEL10      ADC_CR1|=(1<<6)|(1<<4)
#define ADC_CR1_SPSEL12      ADC_CR1|=(1<<6)|(1<<5)
#define ADC_CR1_SPSEL18      ADC_CR1|=(1<<6)|(1<<5)|(1<<4)

#define ADC_CR1_ADON_ON                      ADC_CR1|=(1<<0)
#define ADC_CR2_ALIGN_LEFT                   ADC_CR2&=~(1<<3)
#define ADC_CR2_ALIGN_RIGHT                  ADC_CR2|=(1<<3)
#define ADC_TDRH_DIS(bit)                    ADC_TDRH|=(1<<bit)  //8-15
#define ADC_TDRL_DIS(bit)                    ADC_TDRL|=(1<<bit)  //0-7


void ADC_INIT(void){
	ADC_CSR_CH0;           //Выбераем канал
	ADC_CR1_SPSEL8;  //Делитель на 18            
	ADC_TDRL_DIS(0);       //Отключаем тригер Шмидта
	ADC_CR2_ALIGN_LEFT;    //Выравнивание по левому краю
	ADC_CR1_ADON_ON;       //Первый запуск ADC
	}
int ADC_read(void){
	int datah=0, datal=0, data=0, t=0;
	ADC_CR1_ADON_ON;
	for(t=0;t<64;t++){
		__asm__("nop\n");
	}
	data=ADC_DRH;
	return data;
	}
