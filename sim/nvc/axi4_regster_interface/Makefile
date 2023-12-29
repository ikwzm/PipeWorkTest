PROJECT_NAME  = axi4_register_interface
SRC_TEST_PATH = ../../../src/test/vhdl/$(PROJECT_NAME)
SCENARIO_PATH = ../../../src/test/scenarios/$(PROJECT_NAME)

NVC           = nvc
NVCFLAGS      = -L ./ -M 32M
COPY          = cp

TEST_BENCH    = axi4_register_interface_test_bench_32_32_0      \
                axi4_register_interface_test_bench_32_32_1      \
                axi4_register_interface_test_bench_32_64_0      \
                axi4_register_interface_test_bench_32_64_1      \
                axi4_register_interface_test_bench_64_32_0      \
                axi4_register_interface_test_bench_64_32_1      \
                $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -rf *.o WORK DUMMY_PLUG PIPEWORK analyze_libs.sh $(addsuffix .snr,$(TEST_BENCH))

analyze_libs.sh: libs.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config libs.yml > analyze_libs.sh

define NVC_ANALIZE_FILE
$(addprefix WORK/WORK.,$(shell echo $(1) | tr a-z A-Z))
endef

define NVC_EXECUTE_FILE
$(addsuffix .elab.so,$(addprefix WORK/_WORK.,$(shell echo $(1) | tr a-z A-Z)))
endef

define SCENARIO_FILE
$(addsuffix .snr,$(subst _0,,$(subst _1,,$(1))))
endef

define NVC_RUN
$(1): $(call NVC_EXECUTE_FILE,$(1)) $(2)
	$(NVC) $(NVCFLAGS) --work=WORK -r $(1)

$(2): $(addprefix $(SCENARIO_PATH)/,$(2))
	$(COPY) $(addprefix $(SCENARIO_PATH)/,$(2)) $(2)
endef

define NVC_ELAB
$(call NVC_EXECUTE_FILE,$(1)): $(call NVC_ANALIZE_FILE,$(1))
	$(NVC) $(NVCFLAGS) --work=WORK -e $(1)
endef

$(call NVC_ANALIZE_FILE, $(TEST_BENCH)) : analyze_libs.sh
	sh analyze_libs.sh

analyze_libs : $(call NVC_ANALIZE_FILE, $(TEST_BENCH))

$(foreach TB, $(TEST_BENCH), $(eval $(call NVC_ELAB, $(TB))))
$(foreach TB, $(TEST_BENCH), $(eval $(call NVC_RUN , $(TB), $(call SCENARIO_FILE, $(TB)))))

