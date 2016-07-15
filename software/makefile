CFLAGS   = -O2 -Wall -c -s -std=c99 -mbig-endian -mcpu=arm7m -gdwarf-2
GCC_ARM  = arm-elf-gcc
AS_ARM   = arm-elf-as 
LD_ARM   = arm-elf-ld
DUMP_ARM = arm-elf-objdump
SIZE_ARM = arm-elf-size

# $@ = The file name corresponding to the target rule
# $^ = The names of all dependences (list) 
# $< = The name of the first dependence

# Rule format
# target: dependences
#      shell commmands

%.elf: boot.o %.o
	@echo Linking $@...
    # Generates the .elf file
	$(LD_ARM) -Ttext 0 -e start -EB -o $@  $^
    # Generates the .lst file from the .lst file
	$(DUMP_ARM) -S $@ > $(subst .elf,.lst,$@)   
	$(SIZE_ARM) $^ $@
	storm_extractor.exe $@

boot.o: boot.asm
	@echo Assembling boot.asm...
	$(AS_ARM) boot.asm -o boot.o -mbig-endian

%.o: %.c
	@echo Compiling $<
	$(GCC_ARM) $(CFLAGS) $< -o $@
	@echo       
    
clean:
	@echo Cleaning files...
	rm -f *.o
	rm -f *.elf
	rm -f *.lst
	rm -f *.txt
	rm -f *.dat
    