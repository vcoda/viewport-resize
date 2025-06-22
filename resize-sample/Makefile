include ../Makeshared.mk

default: magma viewport-resize shaders

magma:
	$(MAKE) -C $(MAGMA)

viewport-resize: viewport-resize.o $(FRAMEWORK_OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)

shaders: transform.o frontFace.o

clean:
	$(MAKE) -C $(MAGMA) clean
	@find . -iregex '.*\.\(d\|o\)' -delete
	@find $(FRAMEWORK) -iregex '.*\.\(d\|o\)' -delete
	@rm -rf viewport-resize
