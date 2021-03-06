
DUMMY_PLUG_WORK_PATH = ../../../Dummy_Plug/sim/ghdl-0.35/dummy_plug
PIPEWORK_WORK_PATH   = ../../../PipeWork/sim/ghdl-0.35
SRC_PATH             = ../../../src

GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

DUT_COMPONENTS = pump_axi4_to_axi4_core    \
                 pump_axi4_to_axi4         \
                 $(END_LIST)

TEST_BENCH = pump_axi4_to_axi4_test_bench_32_32        \
             pump_axi4_to_axi4_test_bench_32_64        \
             pump_axi4_to_axi4_test_bench_64_32        \
             pump_axi4_to_axi4_test_bench_32_32_test_7 \
             pump_axi4_to_axi4_test_bench_32_32_test_8 \
             $(END_LIST)

all: DUT $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)

$(TEST_BENCH) : $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .snr,$(TEST_BENCH)) DUT
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

DUT : $(addsuffix .o,$(DUT_COMPONENTS))

pump_axi4_to_axi4.o                         : $(SRC_PATH)/test/vhdl/pump_axi4/pump_axi4_to_axi4.vhd 
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

pump_axi4_to_axi4_core.o                    : $(SRC_PATH)/test/vhdl/pump_axi4/pump_axi4_to_axi4_core.vhd 
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

pump_axi4_to_axi4_test_bench.o              : $(SRC_PATH)/test/vhdl/pump_axi4/pump_axi4_to_axi4_test_bench.vhd 
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

pump_axi4_to_axi4_test_bench_32_32.o        : $(SRC_PATH)/test/vhdl/pump_axi4/pump_axi4_to_axi4_test_bench_32_32.vhd        pump_axi4_to_axi4_test_bench.o
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

pump_axi4_to_axi4_test_bench_32_32_test_7.o : $(SRC_PATH)/test/vhdl/pump_axi4/pump_axi4_to_axi4_test_bench_32_32_test_7.vhd pump_axi4_to_axi4_test_bench.o
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

pump_axi4_to_axi4_test_bench_32_32_test_8.o : $(SRC_PATH)/test/vhdl/pump_axi4/pump_axi4_to_axi4_test_bench_32_32_test_8.vhd pump_axi4_to_axi4_test_bench.o
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

pump_axi4_to_axi4_test_bench_32_64.o        : $(SRC_PATH)/test/vhdl/pump_axi4/pump_axi4_to_axi4_test_bench_32_64.vhd        pump_axi4_to_axi4_test_bench.o
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

pump_axi4_to_axi4_test_bench_64_32.o        : $(SRC_PATH)/test/vhdl/pump_axi4/pump_axi4_to_axi4_test_bench_64_32.vhd        pump_axi4_to_axi4_test_bench.o
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

pump_axi4_to_axi4_test_bench_32_32.snr      : $(SRC_PATH)/test/scenarios/pump_axi4/make_scenario.rb
	$(SRC_PATH)/test/scenarios/pump_axi4/make_scenario.rb \
             --name    PUMP_AXI4_TO_AXI4_TEST_32_32  \
             --i_width 32  \
             --o_width 32  \
             --output  pump_axi4_to_axi4_test_bench_32_32.snr

pump_axi4_to_axi4_test_bench_32_64.snr      : $(SRC_PATH)/test/scenarios/pump_axi4/make_scenario.rb
	$(SRC_PATH)/test/scenarios/pump_axi4/make_scenario.rb \
             --name    PUMP_AXI4_TO_AXI4_TEST_32_64  \
             --i_width 32  \
             --o_width 64  \
             --output  pump_axi4_to_axi4_test_bench_32_64.snr

pump_axi4_to_axi4_test_bench_64_32.snr      : $(SRC_PATH)/test/scenarios/pump_axi4/make_scenario.rb
	$(SRC_PATH)/test/scenarios/pump_axi4/make_scenario.rb \
             --name    PUMP_AXI4_TO_AXI4_TEST_64_32  \
             --i_width 64  \
             --o_width 32  \
             --output  pump_axi4_to_axi4_test_bench_64_32.snr

pump_axi4_to_axi4_test_bench_32_32_test_7.snr : $(SRC_PATH)/test/scenarios/pump_axi4/make_scenario.rb
	$(SRC_PATH)/test/scenarios/pump_axi4/make_scenario.rb \
             --name    PUMP_AXI4_TO_AXI4_TEST_32_32  \
             --i_width 32  \
             --o_width 32  \
             --test_item 7 \
             --timeout 10000000 \
             --output  pump_axi4_to_axi4_test_bench_32_32_test_7.snr

pump_axi4_to_axi4_test_bench_32_32_test_8.snr : $(SRC_PATH)/test/scenarios/pump_axi4/make_scenario_feature.rb
	$(SRC_PATH)/test/scenarios/pump_axi4/make_scenario_feature.rb \
             --name    PUMP_AXI4_TO_AXI4_TEST_32_32  \
             --i_width 32  \
             --o_width 32  \
             --test_item 8 \
             --timeout 10000000 \
             --output  pump_axi4_to_axi4_test_bench_32_32_test_8.snr

