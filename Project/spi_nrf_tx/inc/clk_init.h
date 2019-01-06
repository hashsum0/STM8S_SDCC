#ifndef __CLK_INIT_H
#define __CLK_INIT_H

#define CLK_ECKR_HSEEN  (1<<0)
#define CLK_SWCR_SWEN   (1<<1)
#define CLK_ECKR_HSERDY (1<<1)
#define CLK_SWCR_SWIF   (1<<3)
#define CLK_CSSR_CSSEN  (1<<0)

void Init_HSE();
void Init_HSI();
#endif /*__CLK_INIT_H*/
