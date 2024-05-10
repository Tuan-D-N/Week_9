# Compiler
CC = ftn

# Compiler flags
CFLAGS = 

# Source files
SRCS = MonteCarloManyThread.f90

# Object files
TARGET = $(SRCS:.f90=.out)


# Default rule
all: $(TARGET)


%.out: %.f90
	$(CC) $(CFLAGS) $< -o $@

# Clean rule
clean:
	rm -f $(OBJS) $(TARGET)
