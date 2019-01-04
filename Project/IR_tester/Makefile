MCU=stm8
CC=sdcc
CFLAGS=-I inc -DSTM8S103 -c
INC=clk_init.rel
INC+=uart1.rel
INC+=ir_decoder.rel

OBJ=main.rel
TARGET=main

%.rel:	%.c
	$(CC) -m$(MCU)  $(CFLAGS) $(LDFLAGS) $<

%.rel:	inc/%.c
	$(CC) -m$(MCU)  $(CFLAGS) $(LDFLAGS) $<
all:$(OBJ) $(INC)
	$(CC) -m$(MCU) -o $(TARGET).ihx $(OBJ) $(INC)

load:	
	stm8flash -c stlinkv2 -p stm8s003k3 -w main.ihx	

clean:
	@rm -v *.sym *.asm *.lst *.rel *lk *.rst *.cdb *.map

#stm8flash -c stlinkv2 -p stm8s003 -w build/main.ihx
