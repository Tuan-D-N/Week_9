# Compiler
CC = ftn

# Compiler flags
CFLAGS = 

# Source files
SRCS = MonteCarlo1Thread.f90

# Object files
TARGET = $(SRCS:.f90=.out)

# Executable name
TARGET = MonteCarlo1Thread

# Default rule
all: $(TARGET)


%.out: %.f90
	$(CC) $(CFLAGS) -c $< -o $@

# Clean rule
clean:
	rm -f $(OBJS) $(TARGET)
