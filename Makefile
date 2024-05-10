# Compiler
CC = ftn

# Compiler flags
CFLAGS = 

# Source files
SRCS = MonteCarlo1Thread.f90 MonteCarloManyThread.f90 hello.f90

# Object files
TARGET = $(SRCS:.f90=.out)


# Default rule
all: $(TARGET)


%.out: %.f90
	$(CC) $(CFLAGS) -c $< -o $@

# Clean rule
clean:
	rm -f $(OBJS) $(TARGET)
