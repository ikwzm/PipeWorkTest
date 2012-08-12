GHDL=ghdl
GHDLFLAGS=--mb-comments

DUMMY_PLUG_SRC_PATH    = ../../../Dummy_Plug/src/main/vhdl
PIPEWORK_SRC_MAIN_PATH = ../../../src/main/vhdl
PIPEWORK_SRC_TEST_PATH = ../../../src/test/vhdl

TEST_BENCH = chopper_test_bench_all            \
             chopper_test_bench_3_6_6          \
             chopper_test_bench_5_5_5          \
             chopper_test_bench_5_5_5_no_burst \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf tmp.vhd $(TEST_BENCH) $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .vhd,$(TEST_BENCH))

chopper_test_bench_all            : chopper_test_bench.o 
	 $(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	-$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

chopper_test_bench_3_6_6          : chopper_test_bench.o
	 $(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	-$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

chopper_test_bench_7_12_24        : chopper_test_bench.o
	 $(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	-$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

chopper_test_bench_5_5_5          : chopper_test_bench.o
	 $(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	-$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

chopper_test_bench_5_5_5_no_burst : chopper_test_bench.o
	 $(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	-$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

chopper_function_model.o : util.o
chopper_function_model.o : $(PIPEWORK_SRC_TEST_PATH)/chopper/chopper_function_model.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

chopper_test_bench.o     : chopper_function_model.o components.o chopper.o
chopper_test_bench.o     : $(PIPEWORK_SRC_TEST_PATH)/chopper/chopper_test_bench.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

components.o : $(PIPEWORK_SRC_MAIN_PATH)/components/components.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK   $<

chopper.o    : $(PIPEWORK_SRC_MAIN_PATH)/components/chopper.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK   $<

util.o       : $(DUMMY_PLUG_SRC_PATH)/core/util.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=DUMMY_PLUG $<
