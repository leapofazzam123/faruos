# This is the name that our final kernel executable will have.
# Change as needed.
KERNEL  := kernel.elf
VERSION := dev-$(shell git rev-parse HEAD)
 
# It is highly recommended to use a custom built cross toolchain to build a kernel.
# We are only using "cc" as a placeholder here. It may work by using
# the host system's toolchain, but this is not guaranteed.
CC = clang -fuse-ld=lld
 
# Likewise, "ld" here is just a placeholder and your mileage may vary if using the
# host's "ld".
LD = ld.lld
 
# User controllable CFLAGS.
CFLAGS = -Wall -Wextra -g -O0 -pipe
 
# User controllable linker flags. We set none by default.
LDFLAGS =
 
# Internal C flags that should not be changed by the user.
INTERNALCFLAGS  :=                  \
	-DFARUOS_VERSION='"$(VERSION)"' \
	-D__is_kernel                   \
	-I../include                    \
	-std=gnu11                      \
	-ffreestanding                  \
	-fno-stack-protector            \
	-fno-omit-frame-pointer         \
	-fno-pic -fpie                  \
	-mabi=sysv                      \
	-mno-80387                      \
	-mno-mmx                        \
	-mno-3dnow                      \
	-mno-sse                        \
	-mno-sse2                       \
	-mno-red-zone                   \
	-z muldefs
 
# Internal linker flags that should not be changed by the user.
INTERNALLDFLAGS :=         \
	-Tlinker.ld            \
	-nostdlib              \
	-zmax-page-size=0x1000 \
	-static                \
	-pie                   \
	--no-dynamic-linker    \
	-ztext                 \
	-z muldefs
 
# Use find to glob all *.c files in the directory and extract the object names.
CFILES        := $(shell find ./ -type f -name '*.c')
ASMFILES      := $(shell find ./ -type f -name '*.s')
SSFNFILES     := $(shell find ./ -type f -name '*.sfn')
LIBC_CFILES   := $(shell find ../libc/ -type f -name '*.c')
LIBC_ASMFILES := $(shell find ../libc/ -type f -name '*.s')
OBJ           := $(addprefix ../../build/kernel/,$(notdir $(CFILES:.c=.o)))
ASMOBJ        := $(addprefix ../../build/kernel/,$(notdir $(ASMFILES:.s=.s.o)))
SSFNOBJ       := $(addprefix ../../build/kernel/,$(notdir $(SSFNFILES:.sfn=.sfn.o)))
LIBC_OBJ      := $(addprefix ../../build/libc/,$(LIBC_CFILES:.c=.libk.o))
LIBC_ASMOBJ   := $(addprefix ../../build/libc/,$(LIBC_ASMFILES:.s=.s.o))
 
# Targets that do not actually build a file of the same name.
.PHONY: all clean
 
# Default target.
all: $(shell if [ ! -d "../../build" ] || [ ! -d "../../build/kernel" ]; \
	 then mkdir -p ../../build/kernel; \
	 fi;) \
	$(KERNEL)
 
# Link rules for the final kernel executable.
$(KERNEL): $(ASMOBJ) $(OBJ) $(SSFNOBJ)
	$(LD) $(OBJ) $(ASMOBJ) $(SSFNOBJ) ../../build/libc/libc.a ../../build/libc/libk.a ../libgcc.a $(LDFLAGS) $(INTERNALLDFLAGS) -o ../../build/kernel/$@ 
 
# Compilation rules for *.c files.
../../build/kernel/%.o: %.c
	$(CC) $(CFLAGS) -target x86_64-none-elf $(INTERNALCFLAGS) -c $< -o $@

# Compilation rules for *.c files.
../../build/kernel/%.s.o: %.s
	#$(CC) $(CFLAGS) -target x86_64-none-elf $(INTERNALCFLAGS) -c $< -o $@
	nasm -felf64 $< -o $@

# Compilation rules for *.c files.
../../build/kernel/%.sfn.o: %.sfn
	#$(CC) $(CFLAGS) -target x86_64-none-elf $(INTERNALCFLAGS) -c $< -o $@
	llvm-objcopy -I binary -O elf64-x86-64 $< $@

# Remove object files and the final executable.
clean:
	rm -rf ../../build/kernel
