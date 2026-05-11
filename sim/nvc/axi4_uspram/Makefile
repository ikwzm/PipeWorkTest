
SCENARIO_PATH = ../../../src/test/scenarios/axi4_uspram

NVC           = nvc
NVCFLAGS      = -L ./ -M 32M
COPY          = cp

TEST_BENCH_RF = AXI4_USPRAM_64x32_R4W4RF_TEST_BENCH \
                AXI4_USPRAM_64x32_R8W4RF_TEST_BENCH \
                AXI4_USPRAM_64x32_R4W8RF_TEST_BENCH \
                AXI4_USPRAM_64x32_R1W4RF_TEST_BENCH \
                AXI4_USPRAM_64x32_R4W1RF_TEST_BENCH \
                $(END_LIST)
TEST_BENCH_WF = AXI4_USPRAM_64x32_R4W4WF_TEST_BENCH \
                AXI4_USPRAM_64x32_R8W4WF_TEST_BENCH \
                AXI4_USPRAM_64x32_R4W8WF_TEST_BENCH \
                AXI4_USPRAM_64x32_R1W4WF_TEST_BENCH \
                AXI4_USPRAM_64x32_R4W1WF_TEST_BENCH \
                $(END_LIST)
TEST_BENCH_NC = AXI4_USPRAM_64x32_R4W4NC_TEST_BENCH \
                AXI4_USPRAM_64x32_R8W4NC_TEST_BENCH \
                AXI4_USPRAM_64x32_R4W8NC_TEST_BENCH \
                AXI4_USPRAM_64x32_R1W4NC_TEST_BENCH \
                AXI4_USPRAM_64x32_R4W1NC_TEST_BENCH \
                $(END_LIST)
TEST_BENCH    = $(TEST_BENCH_RF) $(TEST_BENCH_WF) $(TEST_BENCH_NC)

all: $(TEST_BENCH)

clean:
	rm -rf *.o WORK DUMMY_PLUG PIPEWORK analyze_libs.sh *.snr

analyze_libs.sh: libs.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config libs.yml > analyze_libs.sh

define NVC_ANALIZE_FILE
$(addprefix WORK/WORK.,$(shell echo $(1) | tr a-z A-Z))
endef

define NVC_EXECUTE_FILE
$(addsuffix .elab.so,$(addprefix WORK/_WORK.,$(shell echo $(1) | tr a-z A-Z)))
endef

define SCENARIO_FILE
$(addsuffix .snr,$(shell echo $(1) | tr A-Z a-z))
endef

define NVC_RUN
$(1): $(call NVC_EXECUTE_FILE,$(1)) $(SCENARIO_FILE)
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


