# Compiler
CC = ftn

# Compiler flags
CFLAGS = 

# Source files
SRCS = MonteCarlo.f90

# Object files
OBJS = $(SRCS:.c=.o)

# Executable name
TARGET = SoftwareRun

# Default rule
all: $(TARGET)

# Rule to build the executable
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Rule to compile source files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Clean rule
clean:
	rm -f $(OBJS) $(TARGET)
