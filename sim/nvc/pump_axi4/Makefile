PROJECT_NAME  = pump_axi4
PIPEWORK_PATH = ../../../PipeWork
SRC_TEST_PATH = ../../../src/test/vhdl/$(PROJECT_NAME)
SCENARIO_PATH = ../../../src/test/scenarios/$(PROJECT_NAME)

NVC           = nvc
NVC_G_FLAGS   = -L ./ -M 32M -H 256M
NVC_E_FLAGS   = --jit -O3
NVC_R_FLAGS   =

TEST_BENCH    = pump_axi4_to_axi4_test_bench_32_32        \
                pump_axi4_to_axi4_test_bench_32_64        \
                pump_axi4_to_axi4_test_bench_64_32        \
                pump_axi4_to_axi4_test_bench_32_32_test_7 \
                pump_axi4_to_axi4_test_bench_32_32_test_8 \
                $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -rf *.o work DUMMY_PLUG PIPEWORK analyze_libs.sh $(TEST_BENCH) $(addsuffix .o,$(TEST_BENCH))

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
	$(NVC) $(NVC_G_FLAGS) --work=WORK -r $(NVC_R_FLAGS) $(1)
endef

define NVC_ELAB
$(call NVC_EXECUTE_FILE,$(1)): $(call NVC_ANALIZE_FILE,$(1))
	$(NVC) $(NVC_G_FLAGS) --work=WORK -e $(NVC_E_FLAGS) $(1)
endef

$(call NVC_ANALIZE_FILE, $(TEST_BENCH)) : analyze_libs.sh
	sh analyze_libs.sh

analyze_libs : $(call NVC_ANALIZE_FILE, $(TEST_BENCH))

$(foreach TB, $(TEST_BENCH), $(eval $(call NVC_ELAB, $(TB))))
$(foreach TB, $(TEST_BENCH), $(eval $(call NVC_RUN , $(TB), $(addsuffix .snr,$(TB)))))

pump_axi4_to_axi4_test_bench_32_32.snr      : $(SCENARIO_PATH)/make_scenario.rb
	$<   --name    PUMP_AXI4_TO_AXI4_TEST_32_32  \
             --i_width 32  \
             --o_width 32  \
             --output  pump_axi4_to_axi4_test_bench_32_32.snr

pump_axi4_to_axi4_test_bench_32_64.snr      : $(SCENARIO_PATH)/make_scenario.rb
	$<   --name    PUMP_AXI4_TO_AXI4_TEST_32_64  \
             --i_width 32  \
             --o_width 64  \
             --output  pump_axi4_to_axi4_test_bench_32_64.snr

pump_axi4_to_axi4_test_bench_64_32.snr      : $(SCENARIO_PATH)/make_scenario.rb
	$<   --name    PUMP_AXI4_TO_AXI4_TEST_64_32  \
             --i_width 64  \
             --o_width 32  \
             --output  pump_axi4_to_axi4_test_bench_64_32.snr

pump_axi4_to_axi4_test_bench_32_32_test_7.snr : $(SCENARIO_PATH)/make_scenario.rb
	$<   --name    PUMP_AXI4_TO_AXI4_TEST_32_32  \
             --i_width 32  \
             --o_width 32  \
             --test_item 7 \
             --timeout 10000000 \
             --output  pump_axi4_to_axi4_test_bench_32_32_test_7.snr

pump_axi4_to_axi4_test_bench_32_32_test_8.snr : $(SCENARIO_PATH)/make_scenario_feature.rb
	$<   --name    PUMP_AXI4_TO_AXI4_TEST_32_32  \
             --i_width 32  \
             --o_width 32  \
             --test_item 8 \
             --timeout 10000000 \
             --output  pump_axi4_to_axi4_test_bench_32_32_test_8.snr

