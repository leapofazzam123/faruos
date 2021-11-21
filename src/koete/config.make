LIBKOETE := $(BUILDDIR)/koete/libkoete.a

KOETE_CFILES := $(shell find $(SRCDIR)/koete -name *.c)
KOETE_ASMFILES := $(shell find $(SRCDIR)/koete -name *.s)
KOETE_OBJ := $(patsubst $(SRCDIR)/%, $(BUILDDIR)/%, $(KOETE_CFILES:.c=.o))
KOETE_ASMOBJ := $(patsubst $(SRCDIR)/%, $(BUILDDIR)/%, $(KOETE_ASMFILES:.s=.s.o))

koete: $(LIBKOETE)

$(LIBKOETE): $(KOETE_OBJ) $(KOETE_ASMOBJ)
	@echo "[AR]\t\t$(@:$(dirname $(LIBKOETE))/%=%)"
	@$(AR) rcs $@ $(KOETE_OBJ) $(KOETE_ASMOBJ)
	@ln -fs $@ $(@:libkoete.a=libc.a)

$(BUILDDIR)/koete/%.o: $(SRCDIR)/koete/%.c
	@echo "[CC]\t\t$<"
	@$(CC) $(CFLAGS) $(CHARDFLAGS) -c $< -o $@

$(BUILDDIR)/koete/%.s.o: $(SRCDIR)/koete/%.s
	@echo "[AS]\t\t$<"
	@$(AS) -felf64 -g -F dwarf $< -o $@

clean-koete:
	@rm -rf $(BUILDDIR)/koete