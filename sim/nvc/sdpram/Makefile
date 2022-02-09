PROJECT_NAME  = sdpram
SRC_TEST_PATH = ../../../src/test/vhdl/$(PROJECT_NAME)

NVC           = nvc
NVCFLAGS      = -L ./
COPY          = cp

TEST_BENCH    = sdpram_test_bench_depth08_rd3_wd3_we0 \
                sdpram_test_bench_depth08_rd4_wd4_we0 \
                sdpram_test_bench_depth08_rd5_wd5_we0 \
                sdpram_test_bench_depth08_rd6_wd6_we3 \
                sdpram_test_bench_depth08_rd3_wd4_we0 \
                sdpram_test_bench_depth08_rd3_wd5_we0 \
                sdpram_test_bench_depth08_rd4_wd3_we0 \
                sdpram_test_bench_depth08_rd5_wd3_we0 \
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
$(foreach TB, $(TEST_BENCH), $(eval $(call NVC_RUN , $(TB))))


