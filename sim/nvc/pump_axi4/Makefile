PIPEWORK_PATH     = ../../../PipeWork
SRC_TEST_PATH     = ../../../src/test/vhdl/pump_axi4
SRC_SCENARIO_PATH = ../../../src/test/scenarios/pump_axi4

NVC       = nvc
NVCFLAGS  = -L ./ -M 32M

TEST_BENCH = pump_axi4_to_axi4_test_bench_32_32        \
             pump_axi4_to_axi4_test_bench_32_64        \
             pump_axi4_to_axi4_test_bench_64_32        \
             pump_axi4_to_axi4_test_bench_32_32_test_7 \
             pump_axi4_to_axi4_test_bench_32_32_test_8 \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -rf *.o work DUMMY_PLUG PIPEWORK $(TEST_BENCH) $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .vhd,$(TEST_BENCH))

# analyze_libs.sh: libs.yml
# 	../../../PipeWork/tools/vhdl-archiver.rb -v --config libs.yml > analyze_libs.sh

analyze_libs : analyze_libs.sh
	sh analyze_libs.sh

$(addsuffix .o,$(TEST_BENCH)) : analyze_libs
%.o : %.vhd
	$(NVC) $(NVCFLAGS) --work=work -a $<

$(TEST_BENCH) : $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .snr,$(TEST_BENCH))
	$(NVC) $(NVCFLAGS) --work=work -e $@
	$(NVC) $(NVCFLAGS) --work=work -r $@

pump_axi4_to_axi4_test_bench_32_32.snr      : $(SRC_SCENARIO_PATH)/make_scenario.rb
	$<   --name    PUMP_AXI4_TO_AXI4_TEST_32_32  \
             --i_width 32  \
             --o_width 32  \
             --output  pump_axi4_to_axi4_test_bench_32_32.snr

pump_axi4_to_axi4_test_bench_32_64.snr      : $(SRC_SCENARIO_PATH)/make_scenario.rb
	$<   --name    PUMP_AXI4_TO_AXI4_TEST_32_64  \
             --i_width 32  \
             --o_width 64  \
             --output  pump_axi4_to_axi4_test_bench_32_64.snr

pump_axi4_to_axi4_test_bench_64_32.snr      : $(SRC_SCENARIO_PATH)/make_scenario.rb
	$<   --name    PUMP_AXI4_TO_AXI4_TEST_64_32  \
             --i_width 64  \
             --o_width 32  \
             --output  pump_axi4_to_axi4_test_bench_64_32.snr

pump_axi4_to_axi4_test_bench_32_32_test_7.snr : $(SRC_SCENARIO_PATH)/make_scenario.rb
	$<   --name    PUMP_AXI4_TO_AXI4_TEST_32_32  \
             --i_width 32  \
             --o_width 32  \
             --test_item 7 \
             --timeout 10000000 \
             --output  pump_axi4_to_axi4_test_bench_32_32_test_7.snr

pump_axi4_to_axi4_test_bench_32_32_test_8.snr : $(SRC_SCENARIO_PATH)/make_scenario_feature.rb
	$<   --name    PUMP_AXI4_TO_AXI4_TEST_32_32  \
             --i_width 32  \
             --o_width 32  \
             --test_item 8 \
             --timeout 10000000 \
             --output  pump_axi4_to_axi4_test_bench_32_32_test_8.snr

