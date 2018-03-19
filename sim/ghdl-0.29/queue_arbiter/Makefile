GHDL=ghdl
GHDLFLAGS=--mb-comments
GHDLRUNFLAGS=$(GHDLFLAGS)
WORK=PIPEWORK

SRC_MAIN_PATH = ../../../PipeWork/src/components
SRC_TEST_PATH = ../../../src/test/vhdl/queue_arbiter

TEST_BENCH = test_bench_one_hot_arch \
             test_bench_integer_arch \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)

test_bench_one_hot_arch: test_bench.o 
	 $(GHDL) -e $(GHDLFLAGS) $@
	-$(GHDL) -r $(GHDLRUNFLAGS) $@

test_bench_integer_arch: test_bench.o 
	 $(GHDL) -e $(GHDLFLAGS) $@
	-$(GHDL) -r $(GHDLRUNFLAGS) $@

test_bench.o: components.o queue_arbiter.o queue_arbiter_one_hot_arch.o queue_arbiter_integer_arch.o 
test_bench.o: $(SRC_TEST_PATH)/test_bench.vhd 
	$(GHDL) -a $(GHDLFLAGS) --work=work $<

components.o: $(SRC_MAIN_PATH)/components.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

queue_arbiter.o:  $(SRC_MAIN_PATH)/queue_arbiter.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

queue_arbiter_integer_arch.o:  $(SRC_MAIN_PATH)/queue_arbiter_integer_arch.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

queue_arbiter_one_hot_arch.o:  $(SRC_MAIN_PATH)/queue_arbiter_one_hot_arch.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

