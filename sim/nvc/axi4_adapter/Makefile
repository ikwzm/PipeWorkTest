PROJECT_NAME  = axi4_adapter
PIPEWORK_PATH = ../../../PipeWork
SRC_TEST_PATH = ../../../src/test/vhdl/$(PROJECT_NAME)
SCENARIO_PATH = ../../../src/test/scenarios/$(PROJECT_NAME)

NVC           = nvc
NVCFLAGS      = -L ./ -M 32M

TEST_BENCH    = axi4_adapter_test_bench_4096_32_32 \
                axi4_adapter_test_bench_4096_32_64 \
                axi4_adapter_test_bench_4096_64_32 \
                $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -rf *.o WORK DUMMY_PLUG PIPEWORK analyze_libs.sh

analyze_libs.sh: libs.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config libs.yml > analyze_libs.sh

define NVC_ANALIZE_FILE
$(addprefix WORK/WORK.,$(shell echo $(1) | tr a-z A-Z))
endef

define NVC_EXECUTE_FILE
$(addsuffix .elab.so,$(addprefix WORK/_WORK.,$(shell echo $(1) | tr a-z A-Z)))
endef

define NVC_RUN
$(1): $(call NVC_EXECUTE_FILE,$(1)) $(2)
	$(NVC) $(NVCFLAGS) --work=WORK -r $(1)
endef

define NVC_ELAB
$(call NVC_EXECUTE_FILE,$(1)): $(call NVC_ANALIZE_FILE,$(1))
	$(NVC) $(NVCFLAGS) --work=WORK -e $(1)
endef

$(call NVC_ANALIZE_FILE, $(TEST_BENCH)) : analyze_libs.sh
	sh analyze_libs.sh

analyze_libs : $(call NVC_ANALIZE_FILE, $(TEST_BENCH))

$(foreach TB, $(TEST_BENCH), $(eval $(call NVC_ELAB, $(TB))))
$(foreach TB, $(TEST_BENCH), $(eval $(call NVC_RUN , $(TB), $(addsuffix .snr,$(TB)))))

axi4_adapter_test_bench_4096_32_32.snr : $(SCENARIO_PATH)/make_scenario.rb
	$<   --name       AXI4_ADAPTER_TEST_4096_32_32 \
             --t_width    32 \
             --m_width    32 \
             --m_max_size 4096 \
             --output     axi4_adapter_test_bench_4096_32_32.snr

axi4_adapter_test_bench_4096_32_64.snr : $(SCENARIO_PATH)/make_scenario.rb
	$<   --name       AXI4_ADAPTER_TEST_4096_32_64 \
             --t_width    32 \
             --m_width    64 \
             --m_max_size 4096 \
             --output     axi4_adapter_test_bench_4096_32_64.snr

axi4_adapter_test_bench_4096_64_32.snr : $(SCENARIO_PATH)/make_scenario.rb
	$<   --name       AXI4_ADAPTER_TEST_4096_64_32 \
             --t_width    64 \
             --m_width    32 \
             --m_max_size 4096 \
             --output     axi4_adapter_test_bench_4096_64_32.snr
