TARGET = main
MCU = cortex-m3

CC = arm-none-eabi-gcc
AS = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
SIZE = arm-none-eabi-size

CFLAGS = -mcpu=$(MCU) -mthumb -Wall -O0 -ffreestanding -nostdlib
LDFLAGS = -T linker.ld -nostdlib

all: $(TARGET).bin

$(TARGET).elf: startup_stm32f103.s main.c
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@
	$(SIZE) $@

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

clean:
	del *.o *.elf *.bin
