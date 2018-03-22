GHDL=ghdl
GHDLFLAGS=--mb-comments
WORK=PIPEWORK

DUMMY_PLUG_SRC_PATH    = ../../../Dummy_Plug/src/main/vhdl
PIPEWORK_SRC_MAIN_PATH = ../../../PipeWork/src
PIPEWORK_SRC_TEST_PATH = ../../../src/test/vhdl

TEST_BENCH = queue_receiver_test_bench_all \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf tmp.vhd $(TEST_BENCH) $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .vhd,$(TEST_BENCH))

util.o              : $(DUMMY_PLUG_SRC_PATH)/core/util.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=DUMMY_PLUG $<

tinymt32.o          : $(DUMMY_PLUG_SRC_PATH)/core/tinymt32.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=DUMMY_PLUG $<

components.o        : $(PIPEWORK_SRC_MAIN_PATH)/components/components.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

queue_receiver.o    : $(PIPEWORK_SRC_MAIN_PATH)/components/queue_receiver.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

queue_receiver_test_bench.o: components.o queue_receiver.o util.o tinymt32.o
queue_receiver_test_bench.o: $(PIPEWORK_SRC_TEST_PATH)/queue_receiver/queue_receiver_test_bench.vhd 
	$(GHDL) -a $(GHDLFLAGS) --work=work $<


queue_receiver_test_bench_all   : queue_receiver_test_bench.o
	$(GHDL) -e $(GHDLFLAGS) --work=work $@
	$(GHDL) -r $(GHDLFLAGS) --work=work $@

