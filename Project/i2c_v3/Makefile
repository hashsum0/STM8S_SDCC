CC=sdcc
CFLAGS=-mstm8 
INCLUDEPATH=inc/
SOURCE=main
OUTPUT_DIR=build/

all:
	mkdir -p build/
	$(CC) $(CFLAGS) -I $(INCLUDEPATH) -o build/$(SOURCE).ihx $(SOURCE).c 
	packihx build/$(SOURCE).ihx > build/$(SOURCE).hex
load:	
	stm8flash -c stlinkv2 -p stm8s003k3 -w build/main.ihx	

clean:
	rm -Rrf $(OUTPUT_DIR)

#stm8flash -c stlinkv2 -p stm8s003f3 -w build/main.ihx
