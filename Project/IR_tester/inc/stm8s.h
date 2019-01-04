#ifndef STM8S_H
#define STM8S_H

#define _SFR_(addr)  (*(volatile unsigned char*)(addr))
//port A
#define PA_ODR        _SFR_(0x5000)              
#define PA_IDR        _SFR_(0x5001)   
#define PA_DDR        _SFR_(0x5002)   
#define PA_CR1        _SFR_(0x5003)   
#define PA_CR2        _SFR_(0x5004)
//port B
#define PB_ODR        _SFR_(0x5005)   
#define PB_IDR        _SFR_(0x5006)   
#define PB_DDR        _SFR_(0x5007)   
#define PB_CR1        _SFR_(0x5008)   
#define PB_CR2        _SFR_(0x5009)
//port C
#define PC_ODR        _SFR_(0x500A)   
#define PC_IDR        _SFR_(0x500B)   
#define PC_DDR        _SFR_(0x500C)   
#define PC_CR1        _SFR_(0x500D)   
#define PC_CR2        _SFR_(0x500E)
//port D
#define PD_ODR        _SFR_(0x500F)   
#define PD_IDR        _SFR_(0x5010)   
#define PD_DDR        _SFR_(0x5011)   
#define PD_CR1        _SFR_(0x5012)   
#define PD_CR2        _SFR_(0x5013) 
//port E
#define PE_ODR        _SFR_(0x5014)   
#define PE_IDR        _SFR_(0x5015)   
#define PE_DDR        _SFR_(0x5016)   
#define PE_CR1        _SFR_(0x5017)   
#define PE_CR2        _SFR_(0x5018)
//port F
#define PF_ODR        _SFR_(0x5019)   
#define PF_IDR        _SFR_(0x501A)   
#define PF_DDR        _SFR_(0x501B)   
#define PF_CR1        _SFR_(0x501C)   
#define PF_CR2        _SFR_(0x501D)
//FLASH
#define FLASH_CR1     _SFR_(0x505A)       
#define FLASH_CR2     _SFR_(0x505B)       
#define FLASH_NCR2    _SFR_(0x505C)       
#define FLASH_FPR     _SFR_(0x505D)       
#define FLASH_NFPR    _SFR_(0x505E)        
#define FLASH_IAPSR   _SFR_(0x505F)        
#define FLASH_PUKR    _SFR_(0x5062)        
#define FLASH_DUKR    _SFR_(0x5064)
//EXTI
#define EXTI_CR1      _SFR_(0x50A0)     
#define EXTI_CR2      _SFR_(0x50A1) 

#define RST_SR        _SFR_(0x50B3) 
//CLK
#define CLK_ICKR      _SFR_(0x50C0)     
#define CLK_ECKR      _SFR_(0x50C1)     
#define CLK_CMSR      _SFR_(0x50C3)     
#define CLK_SWR       _SFR_(0x50C4)     
#define CLK_SWCR      _SFR_(0x50C5)     
#define CLK_CKDIVR    _SFR_(0x50C6)        
#define CLK_PCKENR1   _SFR_(0x50C7)        
#define CLK_CSSR      _SFR_(0x50C8)      
#define CLK_CCOR      _SFR_(0x50C9)      
#define CLK_PCKENR2   _SFR_(0x50CA)        
#define CLK_HSITRIMR  _SFR_(0x50CC)         
#define CLK_SWIMCCR   _SFR_(0x50CD)
//WATCH_DOG
#define WWDG_CR       _SFR_(0x50D1)    
#define WWDG_WR       _SFR_(0x50D2) 

#define IWDG_KR       _SFR_(0x50E0)    
#define IWDG_PR       _SFR_(0x50E1)    
#define IWDG_RLR      _SFR_(0x50E2)

#define AWU_CSR1      _SFR_(0x50F0)     
#define AWU_APR       _SFR_(0x50F1)     
#define AWU_TBR       _SFR_(0x50F2) 

#define BEEP_CSR      _SFR_(0x50F3)
//SPI
#define SPI_CR1       _SFR_(0x5200)    
#define SPI_CR2       _SFR_(0x5201)    
#define SPI_ICR       _SFR_(0x5202)    
#define SPI_SR        _SFR_(0x5203)    
#define SPI_DR        _SFR_(0x5204)    
#define SPI_CRCPR     _SFR_(0x5205)       
#define SPI_RXCRCR    _SFR_(0x5206)       
#define SPI_TXCRCR    _SFR_(0x5207)
//I2C
#define I2C_CR1       _SFR_(0x5210)    
#define I2C_CR2       _SFR_(0x5211)    
#define I2C_FREQR     _SFR_(0x5212)      
#define I2C_OARL      _SFR_(0x5213)      
#define I2C_OARH      _SFR_(0x5214)      
#define I2C_DR        _SFR_(0x5216)   
#define I2C_SR1       _SFR_(0x5217)    
#define I2C_SR2       _SFR_(0x5218)    
#define I2C_SR3       _SFR_(0x5219)    
#define I2C_ITR       _SFR_(0x521A)    
#define I2C_CCRL      _SFR_(0x521B)     
#define I2C_CCRH      _SFR_(0x521C)     
#define I2C_TRISER    _SFR_(0x521D)       
#define I2C_PECR      _SFR_(0x521E)
//UART
#define UART1_SR      _SFR_(0x5230)     
#define UART1_DR      _SFR_(0x5231)     
#define UART1_BRR1    _SFR_(0x5232)       
#define UART1_BRR2    _SFR_(0x5233)       
#define UART1_CR1     _SFR_(0x5234)       
#define UART1_CR2     _SFR_(0x5235)       
#define UART1_CR3     _SFR_(0x5236)       
#define UART1_CR4     _SFR_(0x5237)       
#define UART1_CR5     _SFR_(0x5238)       
#define UART1_GTR     _SFR_(0x5239)       
#define UART1_PSCR    _SFR_(0x523A)
//TIM1
#define TIM1_CR1      _SFR_(0x5250)      
#define TIM1_CR2      _SFR_(0x5251)      
#define TIM1_SMCR     _SFR_(0x5252)      
#define TIM1_ETR      _SFR_(0x5253)      
#define TIM1_IER      _SFR_(0x5254)      
#define TIM1_SR1      _SFR_(0x5255)      
#define TIM1_SR2      _SFR_(0x5256)      
#define TIM1_EGR      _SFR_(0x5257)      
#define TIM1_CCMR1    _SFR_(0x5258)       
#define TIM1_CCMR2    _SFR_(0x5259)       
#define TIM1_CCMR3    _SFR_(0x525A)       
#define TIM1_CCMR4    _SFR_(0x525B)       
#define TIM1_CCER1    _SFR_(0x525C)       
#define TIM1_CCER2    _SFR_(0x525D)       
#define TIM1_CNTRH    _SFR_(0x525E)       
#define TIM1_CNTRL    _SFR_(0x525F)       
#define TIM1_PSCRH    _SFR_(0x5260)       
#define TIM1_PSCRL    _SFR_(0x5261)       
#define TIM1_ARRH     _SFR_(0x5262)       
#define TIM1_ARRL     _SFR_(0x5263)       
#define TIM1_RCR      _SFR_(0x5264)     
#define TIM1_CCR1H    _SFR_(0x5265)       
#define TIM1_CCR1L    _SFR_(0x5266)       
#define TIM1_CCR2H    _SFR_(0x5267)       
#define TIM1_CCR2L    _SFR_(0x5268)       
#define TIM1_CCR3H    _SFR_(0x5269)       
#define TIM1_CCR3L    _SFR_(0x526A)       
#define TIM1_CCR4H    _SFR_(0x526B)       
#define TIM1_CCR4L    _SFR_(0x526C)       
#define TIM1_BKR      _SFR_(0x526D)      
#define TIM1_DTR      _SFR_(0x526E)      
#define TIM1_OISR     _SFR_(0x526F)
//TIM2
#define TIM2_CR1      _SFR_(0x5300)      
#define TIM2_IER      _SFR_(0x5303)      
#define TIM2_SR1      _SFR_(0x5304)      
#define TIM2_SR2      _SFR_(0x5305)      
#define TIM2_EGR      _SFR_(0x5306)      
#define TIM2_CCMR1    _SFR_(0x5307)       
#define TIM2_CCMR2    _SFR_(0x5308)       
#define TIM2_CCMR3    _SFR_(0x5309)       
#define TIM2_CCER1    _SFR_(0x530A)       
#define TIM2_CCER2    _SFR_(0x530B)       
#define TIM2_CNTRH    _SFR_(0x530C)       
#define TIM2_CNTRL    _SFR_(0x530D)       
#define TIM2_PSCR     _SFR_(0x530E)       
#define TIM2_ARRH     _SFR_(0x530F)       
#define TIM2_ARRL     _SFR_(0x5310)       
#define TIM2_CCR1H    _SFR_(0x5311)       
#define TIM2_CCR1L    _SFR_(0x5312)       
#define TIM2_CCR2H    _SFR_(0x5313)       
#define TIM2_CCR2L    _SFR_(0x5314)       
#define TIM2_CCR3H    _SFR_(0x5315)       
#define TIM2_CCR3L    _SFR_(0x5316)
//TIM4
#define TIM4_CR1      _SFR_(0x5340)     
#define TIM4_IER      _SFR_(0x5343)     
#define TIM4_SR       _SFR_(0x5344)     
#define TIM4_EGR      _SFR_(0x5345)     
#define TIM4_CNTR     _SFR_(0x5346)      
#define TIM4_PSCR     _SFR_(0x5347)      
#define TIM4_ARR      _SFR_(0x5348)
//ADC
#define ADC_DBxR      _SFR_(0x53E0)      
#define ADC_CSR       _SFR_(0x5400)    
#define ADC_CR1       _SFR_(0x5401)    
#define ADC_CR2       _SFR_(0x5402)    
#define ADC_CR3       _SFR_(0x5403)    
#define ADC_DRH       _SFR_(0x5404)    
#define ADC_DRL       _SFR_(0x5405)    
#define ADC_TDRH      _SFR_(0x5406)     
#define ADC_TDRL      _SFR_(0x5407)     
#define ADC_HTRH      _SFR_(0x5408)     
#define ADC_HTRL      _SFR_(0x5409)     
#define ADC_LTRH      _SFR_(0x540A)     
#define ADC_LTRL      _SFR_(0x540B)     
#define ADC_AWSRH     _SFR_(0x540C)      
#define ADC_AWSRL     _SFR_(0x540D)      
#define ADC_AWCRH     _SFR_(0x540E)      
#define ADC_AWCRL     _SFR_(0x540F)      

#endif /* STM8S_H */
