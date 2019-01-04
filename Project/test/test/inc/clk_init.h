#define CLK_ECKR_HSEEN  (1<<0)
#define CLK_SWCR_SWEN   (1<<1)
#define CLK_ECKR_HSERDY (1<<1)
#define CLK_SWCR_SWIF   (1<<3)
#define CLK_CSSR_CSSEN  (1<<0)

void clk_init(void){    
    CLK_ECKR|=CLK_ECKR_HSEEN;            
    CLK_SWCR|=CLK_SWCR_SWEN;               
    while((CLK_ECKR & CLK_ECKR_HSERDY) == 0) {} 
    CLK_CKDIVR = 0;                    
    CLK_SWR = 0xB4;                    
    while ((CLK_SWCR & CLK_SWCR_SWIF) == 0){}
    CLK_CSSR|=CLK_CSSR_CSSEN;
}
