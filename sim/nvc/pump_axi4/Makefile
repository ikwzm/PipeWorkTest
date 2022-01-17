PIPEWORK_PATH = ../../../PipeWork
SRC_TEST_PATH = ../../../src/test/vhdl/pump_axi4

NVC       = nvc
NVCFLAGS  = -L ./ 

TEST_BENCH = pump_axi4_to_axi4_test_bench_32_32        \
             pump_axi4_to_axi4_test_bench_32_64        \
             pump_axi4_to_axi4_test_bench_64_32        \
             pump_axi4_to_axi4_test_bench_32_32_test_7 \
             pump_axi4_to_axi4_test_bench_32_32_test_8 \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -rf *.o work DUMMY_PLUG PIPEWORK $(TEST_BENCH) $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .vhd,$(TEST_BENCH))

# analyze_libs.sh: libs.yml
# 	../../../PipeWork/tools/vhdl-archiver.rb -v --config libs.yml > analyze_libs.sh

analyze_libs : analyze_libs.sh
	sh analyze_libs.sh

$(addsuffix .o,$(TEST_BENCH)) : analyze_libs
%.o : %.vhd
	$(NVC) $(NVCFLAGS) --work=work -a $<

$(TEST_BENCH) : $(addsuffix .o,$(TEST_BENCH))
	$(NVC) $(NVCFLAGS) --work=work -e $@
	$(NVC) $(NVCFLAGS) --work=work -r $@

