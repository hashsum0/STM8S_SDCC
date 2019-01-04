
#define I2C_CR1    *(volatile unsigned char*)0x5210
#define I2C_CR2    *(volatile unsigned char*)0x5211
#define I2C_FREQR  *(volatile unsigned char*)0x5212
#define I2C_OARL   *(volatile unsigned char*)0x5213
#define I2C_OARH   *(volatile unsigned char*)0x5214
#define I2C_DR     *(volatile unsigned char*)0x5216
#define I2C_SR1    *(volatile unsigned char*)0x5217
#define I2C_SR2    *(volatile unsigned char*)0x5218
#define I2C_SR3    *(volatile unsigned char*)0x5219
#define I2C_ITR    *(volatile unsigned char*)0x521A
#define I2C_CCRL   *(volatile unsigned char*)0x521B
#define I2C_CCRH   *(volatile unsigned char*)0x521C
#define I2C_TRISER *(volatile unsigned char*)0x521D
#define I2C_PECR   *(volatile unsigned char*)0x521E

//~ #define *(unsigned char*)0x
//~ #define *(unsigned char*)0x
//~ #define *(unsigned char*)0x
//~ #define *(unsigned char*)0x
//~ #define *(unsigned char*)0x
#define I2C_CR1_PE        (1<<0)
#define I2C_CR1_ENGS      (1<<6)
#define I2C_CR1_NOSTRETCH (1<<7)

#define I2C_CR2_START     (1<<0)
#define I2C_CR2_STOP      (1<<1)
#define I2C_CR2_ACK       (1<<2)
#define I2C_CR2_POS       (1<<3)
#define I2C_CR2_SWRST     (1<<7)

#define I2C_SR1_SB        (1<<0)
#define I2C_SR1_ADDR      (1<<1)
#define I2C_SR1_BTF       (1<<2)
#define I2C_SR1_ADD10     (1<<3)
#define I2C_SR1_STOPF     (1<<4)
#define I2C_SR1_RXNE      (1<<6)
#define I2C_SR1_TXE       (1<<7)

#define I2C_SR2_BERR      (1<<0)
#define I2C_SR2_ARLO      (1<<1)
#define I2C_SR2_AF        (1<<2)
#define I2C_SR2_OVR       (1<<3)
#define I2C_SR2_WUFH      (1<<5)

#define I2C_SR3_MSL       (1<<0)
#define I2C_SR3_BUSY      (1<<1)
#define I2C_SR3_TRA       (1<<2)
#define I2C_SR3_GENCALL   (1<<4)
#define I2C_SR3_DUALF     (1<<7)

#define I2C_ITR_ITERREN   (1<<0)
#define I2C_ITR_ITEVTEN   (1<<1)
#define I2C_ITR_ITBUFEN   (1<<2)
//############################################--init--################################
void i2c_init() {
    I2C_FREQR |= (1 << 1);
    I2C_CCRL = 0x0A; // 100kHz
    I2C_OARH |= (1 << 7); // 7-bit addressing
    I2C_CR1 |= I2C_CR1_PE;
}
//############################################--WRITE--################################
void i2c_write_byte(unsigned int addr_dev, unsigned int addr_mem, unsigned int data){
    int d=0;
       //************************************************************start
    while ((I2C_SR3 & I2C_SR3_BUSY)); 
    I2C_CR2 |= I2C_CR2_START;
    while (!(I2C_SR1 & I2C_SR1_SB));   
    d=I2C_SR3;
//************************************************************write address dev  
    I2C_DR = addr_dev;                    
    while (!(I2C_SR1 & I2C_SR1_ADDR));
    d=I2C_SR3;
    I2C_CR2 |= (1 << I2C_CR2_ACK);
//************************************************************write address mem   
    while (!(I2C_SR1 & I2C_SR1_TXE));
    I2C_DR = addr_mem;
//************************************************************write data   
    while (!(I2C_SR1 & I2C_SR1_TXE));
    I2C_DR = data;
//************************************************************stop    
    while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
    I2C_CR2 |= I2C_CR2_STOP;       
    while (I2C_SR3 & I2C_SR3_MSL);
}
//############################################--READ--#################################
int i2c_read_byte(unsigned int addr_dev,unsigned int addr_mem){
    int d=0;
//************************************************************start
    while ((I2C_SR3 & I2C_SR3_BUSY));
    I2C_CR2 |= I2C_CR2_START;
    while (!(I2C_SR1 & I2C_SR1_SB));  
    d=I2C_SR3;
//************************************************************write address dev  
    I2C_DR = addr_dev;                    
    while (!(I2C_SR1 & I2C_SR1_ADDR));
    d=I2C_SR3;
//************************************************************write address mem 
    while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
    I2C_DR = addr_mem;              
//************************************************************restart
    I2C_CR2 |=I2C_CR2_ACK;
    I2C_CR2 |= I2C_CR2_START;
//************************************************************write address, read dev    
    while (!(I2C_SR1 & I2C_SR1_SB));   
    d=I2C_SR3;
    I2C_DR = addr_dev+1;                    
    while (!(I2C_SR1 & I2C_SR1_ADDR));
    d=I2C_SR3;
//************************************************************read data
    while (!(I2C_SR1 & I2C_SR1_RXNE));
    d=I2C_DR;
    I2C_CR2 &= ~I2C_CR2_ACK;
//************************************************************stop    
    while (!(I2C_SR1 & I2C_SR1_TXE)&&!(I2C_SR1 & I2C_SR1_BTF));
    I2C_CR2 |= I2C_CR2_STOP;       
    while (I2C_SR3 & I2C_SR3_MSL);

    return d;
}
