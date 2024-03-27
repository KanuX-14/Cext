# Set terminal colours
ESCAPE        := \033
RED           := $(ESCAPE)[31m
BOLD_RED      := $(ESCAPE)[1;31m
GREEN         := $(ESCAPE)[32m
BOLD_GREEN    := $(ESCAPE)[1;32m
YELLOW        := $(ESCAPE)[33m
BOLD_YELLOW   := $(ESCAPE)[1;33m
BLUE          := $(ESCAPE)[34m
BOLD_BLUE     := $(ESCAPE)[1;34m
PURPLE        := $(ESCAPE)[35m
BOLD_PURPLE   := $(ESCAPE)[1;35m
CYAN          := $(ESCAPE)[36m
BOLD_CYAN     := $(ESCAPE)[1;36m
RESET_COLOUR  := $(ESCAPE)[0m

AR=/usr/bin/ar

SRC = $(wildcard src/*.c) $(wildcard src/*/*.c)
OBJ = $(addprefix obj/,$(notdir $(SRC:.c=.o)))

CFLAGS = -I ./include -Wall -Werror -Wno-unused
LFLAGS = -lSDL2 -lSDL2_mixer -lSDL2_net -shared

# Parse different arguments for given C compilers
ifeq ($(CC),gcc)
	CFLAGS += -std=gnu99
else
	CFLAGS += -std=c99
endif

PLATFORM = $(shell uname)

# Linux
ifeq ($(findstring Linux,$(PLATFORM)),Linux)
	DYNAMIC = libcorange.so
	STATIC = libcorange.a
	CFLAGS += -fPIC
	LFLAGS += -lGL
endif

# Apple
ifeq ($(findstring Darwin,$(PLATFORM)),Darwin)
	DYNAMIC = libcorange.so
	STATIC = libcorange.a
	CFLAGS += -fPIC
	LFLAGS += -framework OpenGL
endif

# DOS/Windows
ifeq ($(findstring MINGW,$(PLATFORM)),MINGW)
	DYNAMIC = corange.dll
	STATIC = libcorange.a
	LFLAGS = -lmingw32 -lopengl32 -lSDL2main -lSDL2 -lSDL2_mixer -lSDL2_net -shared
	OBJ += corange.res
endif

# Give debug all the power while release is shrinked
ifdef NDEBUG
	CFLAGS += -g
	LFLAGS += -g
else
	CFLAGS += -O3
endif

all: $(DYNAMIC) $(STATIC)

$(DYNAMIC): $(OBJ)
	$(CC) $(OBJ) $(LFLAGS) -o $@
	
$(STATIC): $(OBJ)
	$(AR) rcs $@ $(OBJ)
	
obj/%.o: src/%.c | obj
	$(CC) $< -c $(CFLAGS) -o $@

obj/%.o: src/*/%.c | obj
	$(CC) $< -c $(CFLAGS) -o $@
	
obj:
	mkdir obj
	
corange.res: corange.rc
	windres $< -O coff -o $@

# Remove anything that is not related to the base project
clean:
	@rm -v $(OBJ) $(STATIC) $(DYNAMIC) 2>/dev/null; true
	@rm -rv ./obj
  
install_unix: $(STATIC)
	cp $(STATIC) /usr/local/lib/$(STATIC)
  
install_win32: $(STATIC)
	cp $(STATIC) C:/MinGW/lib/$(STATIC)
  
install_win64: $(STATIC) $(DYNAMIC)
	cp $(STATIC) C:/MinGW64/x86_64-w64-mingw32/lib/$(STATIC)
	cp $(DYNAMIC) C:/MinGW64/x86_64-w64-mingw32/bin/$(DYNAMIC)

# For the lost developers
help:
	@printf "Cext v0.1 - C game engine focused on performance, fork of Corange.\n\n"
	@printf "The $(BOLD_GREEN)Makefile$(RESET_COLOUR) can handle the following arguments:\n"
	@printf "  all - Compile the engine.\n"
	@printf "  install_$(BOLD_BLUE)unix$(RESET_COLOUR) - Install the library to UNIX systems.\n"
	@printf "  install_$(BOLD_BLUE)win32$(RESET_COLOUR) - Install the library to DOS/Windows (32-bits) systems.\n"
	@printf "  install_$(BOLD_BLUE)win64$(RESET_COLOUR) - Install the library to DOS/Windows (64-bits) systems.\n"
	@printf "  clean - Remove any remaining files."
	@printf "\n\nExample:\n"
	@printf "  $(BOLD_BLUE)\x23 Unix (\x24 means user | \x23 means root)$(RESET_COLOUR)\n"
	@printf "    \x24 make all -j2\n"
	@printf "    \x23 make install_unix\n"
	@printf "  $(BOLD_BLUE)# DOS/Windows$(RESET_COLOUR)\n"
	@printf "    \x3E make all -j2 && make install_win32\n"
