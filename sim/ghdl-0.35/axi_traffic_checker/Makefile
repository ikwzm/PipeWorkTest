
DUMMY_PLUG_WORK_PATH = ../../../Dummy_Plug/sim/ghdl-0.35/dummy_plug
PIPEWORK_WORK_PATH   = ../../../PipeWork/sim/ghdl-0.35
SRC_PATH             = ../../../src/test/vhdl/axi_traffic_checker
SCENARIO_PATH        = ../../../src/test/scenarios/axi_traffic_checker

GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

DUT_COMPONENTS = axi_traffic_checker \
                 $(END_LIST)

TEST_BENCH     = axi_traffic_checker_test_bench_32_64  \
                 axi_traffic_checker_test_bench_64_64  \
                 $(END_LIST)

all: DUT $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)

axi_traffic_checker_test_bench_32_64           : axi_traffic_checker_test_bench.o DUT test_32_64.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

axi_traffic_checker_test_bench_64_64           : axi_traffic_checker_test_bench.o DUT test_64_64.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

DUT : $(addsuffix .o,$(DUT_COMPONENTS))

axi_traffic_checker.o                          : $(SRC_PATH)/axi_traffic_checker.vhd 
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi_traffic_checker_test_bench.o               : $(SRC_PATH)/axi_traffic_checker_test_bench.vhd 
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

test_32_64.snr : $(SCENARIO_PATH)/test_32_64.snr
	cp $< $@

test_64_64.snr : $(SCENARIO_PATH)/test_64_64.snr
	cp $< $@

