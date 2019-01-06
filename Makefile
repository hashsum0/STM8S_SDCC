MCU=stm8
CC=sdcc
CFLAGS=-I inc -DSTM8S103 -c
VPATH=inc
SRC=main.c
SRC+=clk_init.c
OBJ=$(SRC:.c=.rel)
TARGET=main

%.rel:	%.c
	$(CC) -m$(MCU)  $(CFLAGS) $(LDFLAGS) $<

all: $(SRC) $(OBJ)
	$(CC) -m$(MCU) -o $(TARGET).ihx $(OBJ)

load:	
	stm8flash -c stlinkv2 -p stm8s003 -w build/main.ihx	

clean:
	@rm -v *.sym *.asm *.lst *.rel *lk *.rst *.cdb *.map	
