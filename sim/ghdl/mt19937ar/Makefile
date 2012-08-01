GHDL=ghdl
GHDLFLAGS=--mb-comments
WORK=work

SRC_PATH = ../../../src/test/vhdl/mt19937ar

TEST_BENCH = test_bench \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)

test_bench: mt19937ar.o test_bench.o 
	 $(GHDL) -e $(GHDLFLAGS) $@
	-$(GHDL) -r $(GHDLRUNFLAGS) $@

test_bench.o: $(SRC_PATH)/test_bench.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=work $<

mt19937ar.o:  $(SRC_PATH)/mt19937ar.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

