PROJECT_NAME  = image_stream_buffer
SRC_TEST_PATH = ../../../src/test/vhdl/$(PROJECT_NAME)
SCENARIO_PATH = ../../../src/test/scenarios/$(PROJECT_NAME)

NVC           = nvc
NVCFLAGS      = -L ./ -M 64M
COPY          = cp
RUBY          = ruby

TEST_BENCH    = test_4_8_1x1x1_1x1x1x1        \
                test_4_8_4x1x1_4x1x1x1        \
                test_1_8_1x4x1_1x1x5x5        \
                test_0_2_32x1x1_32x4x3x3      \
                test_0_2_32x1x1_32x4x3x3_bug1 \
                $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -rf *.o WORK DUMMY_PLUG PIPEWORK analyze_libs.sh $(addsuffix .snr,$(TEST_BENCH))

analyze_libs.sh: libs.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config libs.yml > analyze_libs.sh

define ENTITY
$(addprefix image_stream_buffer_,$(1))
endef

define SCENARIO_FILE
$(addsuffix .snr,$(1))
endef

define MAKE_SCENARIO_SCRIPT
$(addprefix $(SCENARIO_PATH)/,$(addsuffix .rb, $(subst test_,make_,$(1))))
endef

define NVC_ANALIZE_FILE
$(addprefix WORK/WORK.,$(shell echo $(1) | tr a-z A-Z))
endef

define NVC_EXECUTE_FILE
$(addsuffix .elab.so,$(addprefix WORK/_WORK.,$(shell echo $(1) | tr a-z A-Z)))
endef

define NVC_RUN
$(1): $(call NVC_EXECUTE_FILE, $(2)) $(3)
	$(NVC) $(NVCFLAGS) --work=WORK -r $(2)
endef

define NVC_ELAB
$(call NVC_EXECUTE_FILE,$(1)): $(call NVC_ANALIZE_FILE,$(1))
	$(NVC) $(NVCFLAGS) --work=WORK -e $(1)
endef

$(call NVC_ANALIZE_FILE, $(call ENTITY,$(TEST_BENCH))) : analyze_libs.sh
	sh analyze_libs.sh

analyze_libs : $(call NVC_ANALIZE_FILE, $(call ENTITY $(TEST_BENCH)))

$(foreach TB, $(TEST_BENCH), $(eval $(call NVC_ELAB, $(call ENTITY,$(TB)))))
$(foreach TB, $(TEST_BENCH), $(eval $(call NVC_RUN , $(TB), $(call ENTITY,$(TB)), $(addsuffix .snr,$(TB)))))

define COPY_SCENARIO
$(1): $(addprefix $(SCENARIO_PATH)/,$(1))
	$(COPY) $(addprefix $(SCENARIO_PATH)/,$(1)) $(1)
endef

$(foreach TB, $(TEST_BENCH), $(eval $(call COPY_SCENARIO, $(call SCENARIO_FILE, $(TB)))))
