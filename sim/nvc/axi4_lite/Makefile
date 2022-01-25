PROJECT_NAME  = axi4_lite
SRC_TEST_PATH = ../../../src/test/vhdl/$(PROJECT_NAME)
SCENARIO_PATH = ../../../src/test/scenarios/$(PROJECT_NAME)

NVC           = nvc
NVCFLAGS      = -L ./ -M 32M
COPY          = cp

TEST_BENCH    = axi4_lite_test_bench_32_32 \
                axi4_lite_test_bench_32_64 \
                axi4_lite_test_bench_64_32 \
                $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -rf *.o WORK DUMMY_PLUG PIPEWORK analyze_libs.sh $(addsuffix .snr,$(TEST_BENCH))

analyze_libs.sh: libs.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config libs.yml > analyze_libs.sh

analyze_libs : analyze_libs.sh
	sh analyze_libs.sh

define TEST
$(1): analyze_libs $(2)
	$(NVC) $(NVCFLAGS) --work=WORK -e $(1)
	$(NVC) $(NVCFLAGS) --work=WORK -r $(1)

$(2): $(addprefix $(SCENARIO_PATH)/,$(2))
	$(COPY) $(addprefix $(SCENARIO_PATH)/,$(2)) $(2)
endef

$(foreach TB, $(TEST_BENCH), $(eval $(call TEST, $(TB), $(addsuffix .snr,$(TB)))))


