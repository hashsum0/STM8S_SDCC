void i2c_init() {
    /* Disable I2C */
    I2C_CR1 &= ~I2C_CR1_PE;
    I2C_FREQR = 16;
    /* Configure I2C clock */
   // Freq(Hz)/(Freq_I2C(Hz)*2)=CCRH_CCRL(hex)-->
   //-->16000000/(100000*2)=80-->
   //-->CCRH=00000000(0x00)-->CCRL=01010000(0x50)
    I2C_CCRH = I2C_CCRH_16MHZ_STD_100;// 0x00 
    I2C_CCRL = I2C_CCRL_16MHZ_STD_100; // 0x50
    /*Standard I2C mode max rise time = 1000ns
 * I2C_FREQR = 16 (MHz) => tMASTER = 1/16 = 62.5 ns
 * TRISER = (1000/62.5) + 1 = floor(16) + 1 = 17(0x11)*/
    I2C_TRISER = I2C_TRISER_16MHZ_STD_100; // 0x11

    /* Must always be written as 1 */
    I2C_OARH |= I2C_OARH_ADDCONF;
    /* 7-bit slave address */
    I2C_OARH &= ~I2C_OARH_ADDMODE;

    /* Enable I2C interrupts */
    //I2C_ITR |= (I2C_ITR_ITBUFEN|I2C_ITR_ITERREN|I2C_ITR_ITEVTEN);

    I2C_CR2 |= I2C_CR2_ACK;

    /* Configuration ready, re-enable I2C */
    I2C_CR1 |= I2C_CR1_PE;
   // interrupts();
}

void i2c_write_cmd(i2c_cmd_t *cmd) {
    cmd->mode = I2C_WRITE;
    cmd->di = 0;
    _i2c_cmd_p = cmd;
    _i2c_tx_complete = 0;
    _i2c_error = 0;
    /* Switch to master mode. */
    I2C_CR2 |= I2C_CR2_START;
}

void i2c_read_cmd(i2c_cmd_t *cmd) {
    cmd->mode = I2C_READ;
    cmd->di = 0;
    _i2c_cmd_p = cmd;
    _i2c_rx_complete = 0;
    _i2c_error = 0;
    /* Switch to master mode. */
    I2C_CR2 |= I2C_CR2_ACK;
    I2C_CR2 |= I2C_CR2_START;
}
