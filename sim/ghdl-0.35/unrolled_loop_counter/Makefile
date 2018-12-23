GHDL=ghdl
GHDLFLAGS=--mb-comments -P../../../PipeWork/sim/ghdl-0.35 -P../../../Dummy_Plug/sim/ghdl-0.35/dummy_plug

DUMMY_PLUG_SRC_PATH    = ../../../Dummy_Plug/src/main/vhdl
PIPEWORK_SRC_MAIN_PATH = ../../../PipeWork/src/
PIPEWORK_SRC_TEST_PATH = ../../../src/test/vhdl/unrolled_loop_counter

TEST_BENCH = unrolled_loop_counter_test_bench_32_0_1_1 \
             unrolled_loop_counter_test_bench_32_0_2_1 \
             unrolled_loop_counter_test_bench_32_0_1_2 \
             unrolled_loop_counter_test_bench_32_1_1_2 \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf tmp.vhd $(TEST_BENCH) $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .vhd,$(TEST_BENCH))

unrolled_loop_counter_test_bench_32_0_1_1 : unrolled_loop_counter_test_bench.o
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

unrolled_loop_counter_test_bench_32_0_2_1 : unrolled_loop_counter_test_bench.o
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

unrolled_loop_counter_test_bench_32_0_1_2 : unrolled_loop_counter_test_bench.o
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

unrolled_loop_counter_test_bench_32_1_1_2 : unrolled_loop_counter_test_bench.o
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

unrolled_loop_counter_test_bench.o     : util.o components.o unrolled_loop_counter.o
unrolled_loop_counter_test_bench.o     : $(PIPEWORK_SRC_TEST_PATH)/unrolled_loop_counter_test_bench.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

components.o            : $(PIPEWORK_SRC_MAIN_PATH)/components/components.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK   $<

unrolled_loop_counter.o : $(PIPEWORK_SRC_MAIN_PATH)/components/unrolled_loop_counter.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK   $<

util.o : $(DUMMY_PLUG_SRC_PATH)/core/util.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=DUMMY_PLUG $<
