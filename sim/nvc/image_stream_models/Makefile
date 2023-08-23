PROJECT_NAME  = image_stream_models
SRC_TEST_PATH = ../../../src/test/vhdl/$(PROJECT_NAME)
SCENARIO_PATH = ../../../src/test/scenarios/$(PROJECT_NAME)

NVC           = nvc
NVCFLAGS      = -L ./ -M 32M
COPY          = cp
RUBY          = ruby

TEST_BENCH    = test_8x0x0x0x0 \
                test_8x0x0x2x2 \
                test_8x1x0x0x0 \
                test_8x1x0x1x1 \
                test_8x3x0x4x1 \
                test_8x4x4x3x3 \
                $(END_LIST)

all: $(TEST_BENCH)

clean_all:
	rm -rf *.o WORK DUMMY_PLUG PIPEWORK analyze_libs.sh $(addsuffix .snr,$(TEST_BENCH))

clean:
	rm -rf *.o WORK DUMMY_PLUG PIPEWORK

analyze_libs.sh: libs.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config libs.yml > analyze_libs.sh

define ENTITY
$(addprefix image_stream_player_,$(1))
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

define GEN_SCENARIO
$(call SCENARIO_FILE, $(1)) : $(call MAKE_SCENARIO_SCRIPT, $(1))
	$(RUBY) $(call MAKE_SCENARIO_SCRIPT, $(1))
endef

$(foreach TB, $(TEST_BENCH), $(eval $(call GEN_SCENARIO, $(TB))))
