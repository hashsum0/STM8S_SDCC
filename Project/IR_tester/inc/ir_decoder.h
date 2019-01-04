#ifndef IR_DECODER_H
#define IR_DECODER_H

#define LOG0_100us           1
#define LOG1_100us           2
#define END_100us            10
#define is_1()               (PB_IDR&(1<<7))
#define is_0()               (!is_1())
#define MAX_BIT_CNT          36

void IR_dec_init();

void DelayMs(int t);

static char delta_t(void);

int resive_ir(void); 

#endif /* IR_DECODER_H */
