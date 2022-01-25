PIPEWORK_PATH     = ../../../PipeWork
SRC_TEST_PATH     = ../../../src/test/vhdl/axi4_adapter
SRC_SCENARIO_PATH = ../../../src/test/scenarios/axi4_adapter

NVC       = nvc
NVCFLAGS  = -L ./ -M 32M

TEST_BENCH = axi4_adapter_test_bench_4096_32_32 \
             axi4_adapter_test_bench_4096_32_64 \
             axi4_adapter_test_bench_4096_64_32 \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -rf *.o WORK DUMMY_PLUG PIPEWORK analyze_libs.sh $(TEST_BENCH) $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .vhd,$(TEST_BENCH))

analyze_libs.sh: libs.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config libs.yml > analyze_libs.sh

analyze_libs : analyze_libs.sh
	sh analyze_libs.sh

define TEST
$(1): analyze_libs $(2)
	$(NVC) $(NVCFLAGS) --work=WORK -e $(1)
	$(NVC) $(NVCFLAGS) --work=WORK -r $(1)
endef

$(foreach TB, $(TEST_BENCH), $(eval $(call TEST, $(TB), $(addsuffix .snr,$(TB)))))

axi4_adapter_test_bench_4096_32_32.snr : $(SRC_SCENARIO_PATH)/make_scenario.rb
	$< --name       AXI4_ADAPTER_TEST_4096_32_32 \
             --t_width    32 \
             --m_width    32 \
             --m_max_size 4096 \
             --output     axi4_adapter_test_bench_4096_32_32.snr

axi4_adapter_test_bench_4096_32_64.snr : $(SRC_SCENARIO_PATH)/make_scenario.rb
	$<   --name       AXI4_ADAPTER_TEST_4096_32_64 \
             --t_width    32 \
             --m_width    64 \
             --m_max_size 4096 \
             --output     axi4_adapter_test_bench_4096_32_64.snr

axi4_adapter_test_bench_4096_64_32.snr : $(SRC_SCENARIO_PATH)/make_scenario.rb
	$<   --name       AXI4_ADAPTER_TEST_4096_64_32 \
             --t_width    64 \
             --m_width    32 \
             --m_max_size 4096 \
             --output     axi4_adapter_test_bench_4096_64_32.snr
