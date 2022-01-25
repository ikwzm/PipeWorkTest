PROJECT_NAME  = axi4_stream_to_master
SRC_TEST_PATH = ../../../src/test/vhdl/$(PROJECT_NAME)
SCENARIO_PATH = ../../../src/test/scenarios/$(PROJECT_NAME)

NVC           = nvc
NVCFLAGS      = -L ./ -M 128M
COPY          = cp

TEST_BENCH    = axi4_s2m_tb_32_32_256_sync          \
                axi4_s2m_tb_32_64_256_sync          \
                axi4_s2m_tb_64_32_256_sync          \
                axi4_s2m_tb_64_64_256_sync          \
                axi4_s2m_tb_32_32_256_100mhz_250mhz \
                axi4_s2m_tb_32_32_256_250mhz_100mhz \
                $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -rf *.o WORK DUMMY_PLUG PIPEWORK analyze_libs.sh $(addsuffix .snr,$(TEST_BENCH))

analyze_libs.sh: libs.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config libs.yml > analyze_libs.sh

analyze_libs : analyze_libs.sh
	sh analyze_libs.sh

axi4_s2m_tb_32_32_256_sync          : analyze_libs axi4_stream_to_master_test_bench_32_32_256.snr
	$(NVC) $(NVCFLAGS) --work=WORK -e $@
	$(NVC) $(NVCFLAGS) --work=WORK -r $@


axi4_s2m_tb_32_64_256_sync          : analyze_libs axi4_stream_to_master_test_bench_32_64_256.snr
	$(NVC) $(NVCFLAGS) --work=WORK -e $@
	$(NVC) $(NVCFLAGS) --work=WORK -r $@

axi4_s2m_tb_64_32_256_sync          : analyze_libs axi4_stream_to_master_test_bench_64_32_256.snr
	$(NVC) $(NVCFLAGS) --work=WORK -e $@
	$(NVC) $(NVCFLAGS) --work=WORK -r $@

axi4_s2m_tb_64_64_256_sync          : analyze_libs axi4_stream_to_master_test_bench_64_64_256.snr
	$(NVC) $(NVCFLAGS) --work=WORK -e $@
	$(NVC) $(NVCFLAGS) --work=WORK -r $@

axi4_s2m_tb_32_32_256_100mhz_250mhz : analyze_libs axi4_stream_to_master_test_bench_32_32_256.snr
	$(NVC) $(NVCFLAGS) --work=WORK -e $@
	$(NVC) $(NVCFLAGS) --work=WORK -r $@

axi4_s2m_tb_32_32_256_250mhz_100mhz : analyze_libs axi4_stream_to_master_test_bench_32_32_256.snr
	$(NVC) $(NVCFLAGS) --work=WORK -e $@
	$(NVC) $(NVCFLAGS) --work=WORK -r $@

axi4_stream_to_master_test_bench_32_32_256.snr : $(SCENARIO_PATH)/axi4_stream_to_master_test_bench_32_32_256.snr
	cp $< $@

axi4_stream_to_master_test_bench_32_64_256.snr : $(SCENARIO_PATH)/axi4_stream_to_master_test_bench_32_64_256.snr
	cp $< $@

axi4_stream_to_master_test_bench_64_32_256.snr : $(SCENARIO_PATH)/axi4_stream_to_master_test_bench_64_32_256.snr
	cp $< $@

axi4_stream_to_master_test_bench_64_64_256.snr : $(SCENARIO_PATH)/axi4_stream_to_master_test_bench_64_64_256.snr
	cp $< $@
