
DUMMY_PLUG_WORK_PATH = ../../../Dummy_Plug/sim/ghdl-0.29/dummy_plug
PIPEWORK_WORK_PATH   = ../../../PipeWork/sim/ghdl-0.29
SRC_PATH             = ../../../src

GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

DUT_COMPONENTS = axi4_master_to_stream \
                 $(END_LIST)

TEST_BENCH     = axi4_m2s_tb_32_32_256_sync          \
                 axi4_m2s_tb_32_64_256_sync          \
                 axi4_m2s_tb_64_32_256_sync          \
                 axi4_m2s_tb_64_64_256_sync          \
                 axi4_m2s_tb_32_32_256_100mhz_250mhz \
                 axi4_m2s_tb_32_32_256_250mhz_100mhz \
                 $(END_LIST)

all: DUT $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)

axi4_m2s_tb_32_32_256_sync          : axi4_master_to_stream_test_bench.o DUT axi4_master_to_stream_test_bench_32_32_256.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

axi4_m2s_tb_32_64_256_sync          : axi4_master_to_stream_test_bench.o DUT axi4_master_to_stream_test_bench_32_64_256.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

axi4_m2s_tb_64_32_256_sync          : axi4_master_to_stream_test_bench.o DUT axi4_master_to_stream_test_bench_64_32_256.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

axi4_m2s_tb_64_64_256_sync          : axi4_master_to_stream_test_bench.o DUT axi4_master_to_stream_test_bench_64_64_256.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

axi4_m2s_tb_32_32_256_100mhz_250mhz : axi4_master_to_stream_test_bench.o DUT axi4_master_to_stream_test_bench_32_32_256.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

axi4_m2s_tb_32_32_256_250mhz_100mhz : axi4_master_to_stream_test_bench.o DUT axi4_master_to_stream_test_bench_32_32_256.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

DUT : $(addsuffix .o,$(DUT_COMPONENTS))

axi4_master_to_stream.o                        : $(SRC_PATH)/test/vhdl/axi4_master_to_stream/axi4_master_to_stream.vhd 
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_master_to_stream_test_bench.o             : $(SRC_PATH)/test/vhdl/axi4_master_to_stream/axi4_master_to_stream_test_bench.vhd 
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_master_to_stream_test_bench_32_32_256.snr : $(SRC_PATH)/test/scenarios/axi4_master_to_stream/axi4_master_to_stream_test_bench_32_32_256.snr
	cp $< $@

axi4_master_to_stream_test_bench_32_64_256.snr : $(SRC_PATH)/test/scenarios/axi4_master_to_stream/axi4_master_to_stream_test_bench_32_64_256.snr
	cp $< $@

axi4_master_to_stream_test_bench_64_32_256.snr : $(SRC_PATH)/test/scenarios/axi4_master_to_stream/axi4_master_to_stream_test_bench_64_32_256.snr
	cp $< $@

axi4_master_to_stream_test_bench_64_64_256.snr : $(SRC_PATH)/test/scenarios/axi4_master_to_stream/axi4_master_to_stream_test_bench_64_64_256.snr
	cp $< $@
