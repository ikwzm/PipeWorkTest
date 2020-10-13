GHDL=ghdl
GHDLFLAGS    = --mb-comments -P../../../Dummy_Plug/sim/ghdl-0.35/dummy_plug -P./
GHDLRUNFLAGS = $(GHDLFLAGS)
WORK=PIPEWORK
CAT=cat

SRC_MAIN_PATH     = ../../../PipeWork/src/components
SRC_TEST_PATH     = ../../../src/test/vhdl/queue_tree_arbiter
SRC_SCENARIO_PATH = ../../../src/test/scenarios/queue_tree_arbiter

TEST_BENCH = test_bench_08_4_0 \
             test_bench_08_4_3 \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)

test_bench_08_4_0: test_bench.o test_08_4_0.snr
	$(GHDL) -e $(GHDLFLAGS) $@
	$(GHDL) -r $(GHDLRUNFLAGS) $@

test_bench_08_4_3: test_bench.o test_08_4_3.snr
	$(GHDL) -e $(GHDLFLAGS) $@
	$(GHDL) -r $(GHDLRUNFLAGS) $@

test_08_4_0.snr : $(SRC_SCENARIO_PATH)/test_08_4.snr
	$(CAT) $^ > $@

test_08_4_3.snr : $(SRC_SCENARIO_PATH)/test_08_4.snr
	$(CAT) $^ > $@

test_bench.o: dut 
test_bench.o: $(SRC_TEST_PATH)/test_bench.vhd 
	$(GHDL) -a $(GHDLFLAGS) --work=work $<

dut : components.o queue_tree_arbiter.o queue_arbiter.o queue_arbiter_one_hot_arch.o

components.o                : $(SRC_MAIN_PATH)/components.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

queue_tree_arbiter.o        :  $(SRC_MAIN_PATH)/queue_tree_arbiter.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

queue_arbiter.o             :  $(SRC_MAIN_PATH)/queue_arbiter.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

queue_arbiter_integer_arch.o:  $(SRC_MAIN_PATH)/queue_arbiter_integer_arch.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

queue_arbiter_one_hot_arch.o:  $(SRC_MAIN_PATH)/queue_arbiter_one_hot_arch.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

