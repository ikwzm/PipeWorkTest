PROJECT_NAME  = convolution_parameter_buffer
SRC_TEST_PATH = ../../../src/test/vhdl/$(PROJECT_NAME)
SCENARIO_PATH = ../../../src/test/scenarios/$(PROJECT_NAME)

NVC           = nvc
NVCFLAGS      = -L ./ -M 128M
COPY          = cp

TEST_BENCH    = convolution_parameter_buffer_test_bench_1x1x1x1   \
                convolution_parameter_buffer_test_bench_1x1x1x1_1x1x1x1 \
                convolution_parameter_buffer_test_bench_1x1x1x4   \
                convolution_parameter_buffer_test_bench_1x1x2x4   \
                convolution_parameter_buffer_test_bench_3x3x1x1   \
                convolution_parameter_buffer_test_bench_3x3x2x4   \
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

define SCENARIO_FILE
$(addsuffix .snr,$(subst convolution_parameter_buffer_test_bench,test,$(1)))
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
$(foreach TB, $(TEST_BENCH), $(eval $(call NVC_RUN , $(TB), $(call SCENARIO_FILE, $(TB)))))

define COPY_SCENARIO
$(1): $(addprefix $(SCENARIO_PATH)/,$(1))
	$(COPY) $(addprefix $(SCENARIO_PATH)/,$(1)) $(1)
endef

$(foreach TB, $(TEST_BENCH), $(eval $(call COPY_SCENARIO, $(call SCENARIO_FILE, $(TB)))))

scenarios: $(SCENARIOS)
