
DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/ghdl-0.35/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools
PIPEWORK_WORK_PATH   = ../../../PipeWork/sim/ghdl-0.35

SRC_TEST_PATH        = ../../../src/test/vhdl/axi4_lite
SCENARIO_PATH        = ../../../src/test/scenarios/axi4_lite

COPY       = cp
GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

TEST_BENCH = axi4_lite_test_bench_32_32        \
             axi4_lite_test_bench_32_64        \
             axi4_lite_test_bench_64_32        \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)


axi4_lite_test_bench_32_32    : axi4_lite_test_bench_32_32.o axi4_lite_test_bench_32_32.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

axi4_lite_test_bench_32_64    : axi4_lite_test_bench_32_64.o axi4_lite_test_bench_32_64.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

axi4_lite_test_bench_64_32    : axi4_lite_test_bench_64_32.o axi4_lite_test_bench_64_32.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

axi4_lite_test_bench_32_32.o  : $(SRC_TEST_PATH)/axi4_lite_test_bench_32_32.vhd axi4_lite_test_bench.o
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_lite_test_bench_32_64.o  : $(SRC_TEST_PATH)/axi4_lite_test_bench_32_64.vhd axi4_lite_test_bench.o
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_lite_test_bench_64_32.o  : $(SRC_TEST_PATH)/axi4_lite_test_bench_64_32.vhd axi4_lite_test_bench.o
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_lite_test_bench.o        : $(SRC_TEST_PATH)/axi4_lite_test_bench.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_lite_test_bench_32_32.snr: $(SCENARIO_PATH)/axi4_lite_test_bench_32_32.snr
	$(COPY) $< .

axi4_lite_test_bench_32_64.snr: $(SCENARIO_PATH)/axi4_lite_test_bench_32_64.snr
	$(COPY) $< .

axi4_lite_test_bench_64_32.snr: $(SCENARIO_PATH)/axi4_lite_test_bench_64_32.snr
	$(COPY) $< .

