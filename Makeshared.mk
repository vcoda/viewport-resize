CC=g++
GLSLC=$(VULKAN_SDK)/bin/glslangValidator

PLATFORM=VK_USE_PLATFORM_XCB_KHR

FRAMEWORK=../framework
DEPS=../third-party
MAGMA=$(DEPS)/magma
BOOST_PFR_DIR=$(MAGMA)/src/third-party/pfr

INCLUDE_DIR=-I$(VULKAN_SDK)/include -I$(DEPS) -I$(BOOST_PFR_DIR)/include -I$(DEPS)/rapid
LIB_DIR=-L$(VULKAN_SDK)/lib -L$(DEPS)/magma

BASE_CFLAGS=-std=c++17 -m64 -msse4 -MD -D$(PLATFORM) $(INCLUDE_DIR)
DEBUG ?= 1
ifeq ($(DEBUG), 1)
	CFLAGS=$(BASE_CFLAGS) -O0 -g -D_DEBUG
	MAGMA_LIB=magmad
else
	CFLAGS=$(BASE_CFLAGS) -O3 -DNDEBUG
	MAGMA_LIB=magma
endif
LDFLAGS=$(LIB_DIR) -l$(MAGMA_LIB) -lxcb -lvulkan


FRAMEWORK_OBJS= \
	$(FRAMEWORK)/graphicsPipeline.o \
	$(FRAMEWORK)/main.o \
	$(FRAMEWORK)/utilities.o \
	$(FRAMEWORK)/vulkanApp.o \
    $(FRAMEWORK)/xcbApp.o

%.o: %.cpp
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.vert
	$(GLSLC) -V $*.vert -o $*.o

%.o: %.frag
	$(GLSLC) -V $*.frag -o $*.o
