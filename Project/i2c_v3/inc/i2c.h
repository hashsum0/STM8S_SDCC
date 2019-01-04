//#############################################################################
//                          I2C
//#############################################################################
#define I2C_CR1_PE               0
       
#define I2C_CR2_ACK              2
#define I2C_CR2_STOP             1
#define I2C_CR2_START            0

#define I2C_OARH_ADDCONF         6
#define I2C_OARH_ADDMODE         7

#define I2C_SR1_SB               0
#define I2C_SR1_ADDR             1
#define I2C_SR1_BTF              2
#define I2C_SR1_RXNE             6
#define I2C_SR1_TXE              7

#define I2C_SR3_MSL              0
#define I2C_SR3_BUSY             1

#define I2C_CCRL_16MHZ_STD_100   0x50
#define I2C_CCRH_16MHZ_STD_100   0x00
#define I2C_TRISER_16MHZ_STD_100 0x0B
#define F_MASTER                 0x10



void i2c_init() {
    /* Disable I2C */
    cli(I2C_CR1,I2C_CR1_PE);
    I2C_FREQR = F_MASTER;
                                           // Configure I2C clock
                                           // Freq(Hz)/(Freq_I2C(Hz)*2)=CCRH_CCRL(hex)-->
                                           //-->16000000/(100000*2)=80-->
                                           //-->CCRH=00000000(0x00)-->CCRL=01010000(0x50)
                                           
    I2C_CCRH = I2C_CCRH_16MHZ_STD_100;     // 0x00 
    I2C_CCRL = I2C_CCRL_16MHZ_STD_100;     // 0x50
    
                                           //Standard I2C mode max rise time = 1000ns
                                           //I2C_FREQR = 16 (MHz) => tMASTER = 1/16 = 62.5 ns
                                           //TRISER = (1000/62.5) + 1 = floor(16) + 1 = 17(0x11)
                                           
    I2C_TRISER = I2C_TRISER_16MHZ_STD_100; // 0x11
    set(I2C_OARH,I2C_OARH_ADDCONF);          //Must always be written as 1 
    cli(I2C_OARH,I2C_OARH_ADDMODE);         // 7-bit slave address
    set(I2C_CR1,I2C_CR1_PE);

}
//***********************************************************************************************
void i2c_start() {
    set(I2C_CR2,I2C_CR2_ACK);
    while(check(I2C_SR3, I2C_SR3_BUSY));
    set(I2C_CR2,I2C_CR2_START);
    while(!check(I2C_SR1, I2C_SR1_SB));
    //I2C_SR1;
}
//***********************************************************************************************
void i2c_write_addr_dev(unsigned char d_addr) {
    
    I2C_DR = d_addr;
    while (!check(I2C_SR1, I2C_SR1_ADDR));
    I2C_SR3;
}
//***********************************************************************************************
void i2c_write_addr_mem(unsigned char m_addr) {
    
    I2C_DR = m_addr;
    while (!check(I2C_SR1, I2C_SR1_TXE));
    I2C_SR3;
}
//***********************************************************************************************
void i2c_write_data(unsigned char data) {
    
    I2C_DR = data;
    while (!check(I2C_SR1, I2C_SR1_TXE));
    I2C_SR3;
}
//***********************************************************************************************
unsigned char i2c_read(unsigned char addr) {
    //restart
    set(I2C_CR2,I2C_CR2_START);
    while(!check(I2C_SR1, I2C_SR1_SB));
    I2C_SR1;
    //send addres
    I2C_DR = addr+1;
    while (!check(I2C_SR1,I2C_SR1_ADDR));
    I2C_SR3;
    //stop
    cli(I2C_CR2,I2C_CR2_ACK);
    set(I2C_CR2,I2C_CR2_STOP);
    //read
    while (!check(I2C_SR1,I2C_SR1_RXNE));
    return I2C_DR;
}
//***********************************************************************************************
void i2c_stop() {
    set(I2C_CR2,I2C_CR2_STOP);
    while (check(I2C_SR3,I2C_SR3_MSL));
}
