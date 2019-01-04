#dwfine ADC_DBxR  *(unsigned char*)0x53E0 
#dwfine ADC_CSR   *(unsigned char*)0x5400
#dwfine ADC_CR1   *(unsigned char*)0x5401
#dwfine ADC_CR2   *(unsigned char*)0x5402 
#dwfine ADC_CR3   *(unsigned char*)0x5403
#dwfine ADC_DRH   *(unsigned char*)0x5404
#dwfine ADC_DRL   *(unsigned char*)0x5405 
#dwfine ADC_TDRH  *(unsigned char*)0x5406
#dwfine ADC_TDRL  *(unsigned char*)0x5407
#dwfine ADC_HTRH  *(unsigned char*)0x5408
#dwfine ADC_HTRL  *(unsigned char*)0x5409
#dwfine ADC_LTRH  *(unsigned char*)0x540A
#dwfine ADC_LTRL  *(unsigned char*)0x540B
#dwfine ADC_AWSRH *(unsigned char*)0x540C
#dwfine ADC_AWSRL *(unsigned char*)0x540D
#dwfine ADC_AWCRH *(unsigned char*)0x540E
#dwfine ADC_AWCRL *(unsigned char*)0x540F 
#define ADC_CSR_CH(bit3,bit2,bit1,bit0)      ADC_CSR|=(1<<bit3)|(1<<bit2)|(1<<bit1)|(1<<bit0)
//0000: Channel AIN0..........................................1111: Channel AIN15
#define ADC_CR1_SPSEL(bit6,bit5,bit4)        ADC_CR1|=(1<<bit6)|(1<<bit5)|(1<<bit4)
//000:fADC=fMASTER/2  001:fADC= fMASTER/3 010:fADC= fMASTER/4 011:fADC= fMASTER/6
//100:fADC=fMASTER/8  101:fADC=fMASTER/10 110:fADC=fMASTER/12 111:fADC=fMASTER/18
#define ADC_CR1_ADON_ON                      ADC_CR1|=(1<<0)
#define ADC_CR2_ALIGN_LEFT                   ADC_CR2&=~(1<<3)
#define ADC_CR2_ALIGN_RIGHT                  ADC_CR2|=(1<<3)
#dwfine ADC_TDRH_ON                          ADC_TDRH=0xFF
#dwfine ADC_TDRH_OFF                         ADC_TDRH=0x00
#dwfine ADC_TDRL_ON                          ADC_TDRH=0xFF
#dwfine ADC_TDRL_OFF                         ADC_TDRH=0x00

void ADC_INIT(void){
	ADC_CSR_CH(0,0,0,0);   //Выбераем канал
	ADC_CR1_SPSEL(1,1,1);  //Делитель на 18
	ADC_TDRH_ON;           //Отключаем тригер Шмидта  
	ADC_TDRL_ON;           //Отключаем тригер Шмидта
	ADC_CR2_ALIGN_LEFT;    //Выравнивание по левому краю
	ADC_CR1_ADON_ON;       //Первый запуск ADC
	}
