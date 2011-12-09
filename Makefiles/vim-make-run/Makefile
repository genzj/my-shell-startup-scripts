# Allow only objects with source files in current folder
c_objs := $(patsubst %.c, %, $(wildcard *.c)) 
cpp_objs := $(patsubst %.cpp, %, $(wildcard *.cpp))
legal_objs := $(c_objs) 
legal_objs += $(cpp_objs)

# Default target, show some warning message
.PHONY: warning
warning % :
	@echo "Usage: make object"
	@echo "   or: make run_object"
	@echo "   or: make clean_object"
	@echo "\n"
	@echo "Object can be one of $(patsubst %, \n\t%, $(sort $(legal_objs)))" >&2

.PHONY: print_objs 
print_objs:
	@echo "$(sort $(legal_objs))" 

# Set gcc as default C compiler
CC = gcc

# Open warning outputs by default
override CFLAGS += -Wall -O3

# Also enable effective C++ suggested warnings
override CXXFLAGS += -Wall -Weffc++ -O3

$(addprefix run_, $(legal_objs)) : run_% : %
	./$<

.PHONY: clean_%
clean_% :
	-rm ./$*
	-rm ./$*.o

$(c_objs) : % : %.c
	$(CC) $(CFLAGS) -o $@ $<

$(cpp_objs) : % : %.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

