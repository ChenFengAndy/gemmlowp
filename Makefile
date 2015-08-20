CC=/home/fchen7/gcc-linaro-aarch64-linux-gnu-4.9-2014.08_linux/bin/aarch64-linux-gnu-gcc
CXX=/home/fchen7/gcc-linaro-aarch64-linux-gnu-4.9-2014.08_linux/bin/aarch64-linux-gnu-g++
RM=rm -f

.PRECIOUS: %.cdat

CPPFLAGS += -mcpu=cortex-a53+simd --std=c++11 -Wall -Wextra -pedantic -fPIE -pie $(NEON_FLAGS) -I . -I .. -Wno-unused-variable -Wno-unused-parameter 
LIBS = -latomic -lstdc++ -lm -lpthread 



LIBSRCS := $(shell find ./eight_bit_int_gemm -name '*.cc' -not -name '._*' )
LIBOBJS := $(subst .cc,.o,$(LIBSRCS))
$(warning ${LIBSRCS})

all:feature-test benchmark

feature-test: test/test.o  test/test_data.o $(LIBOBJS) 
	$(CC) -static  $^ -o $@  $(LIBS)
benchmark: test/benchmark.o $(LIBOBJS) 
	$(CC) -static  $^ -o $@  $(LIBS)
%.o: %.cc
	$(CXX) $(CPPFLAGS) -fPIC -c $< -o $(basename $@).o

clean:
	find . -iname "*.o" -exec rm '{}' ';'
