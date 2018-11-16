
DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/ghdl-0.29/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools
PIPEWORK_PATH        = ../../../PipeWork
PIPEWORK_WORK_PATH   = $(PIPEWORK_PATH)/sim/ghdl-0.29
PIPEWORK_SRC_PATH    = $(PIPEWORK_PATH)/src
PIPEWORK_TOOL_PATH   = $(PIPEWORK_PATH)/tools
SRC_PATH             = ../../../src
SRC_TEST_PATH        = $(SRC_PATH)/test/vhdl/axi4_adapter

COPY       = cp
GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

PIPEWORK_COMPONENTS = axi4_adapter       \
                      axi4_write_adapter \
                      axi4_read_adapter  \
                      $(END_LIST)

TEST_BENCH = axi4_adapter_test_bench_4096_32_32 \
             axi4_adapter_test_bench_4096_32_64 \
             axi4_adapter_test_bench_4096_64_32 \
             $(END_LIST)

all: DUT $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)


$(TEST_BENCH) : $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .snr,$(TEST_BENCH))
	 $(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	-$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

DUT : $(addsuffix .o,$(PIPEWORK_COMPONENTS))

pipework:
	$(PIPEWORK_TOOL_PATH)/MakeSerializedPackageList.rb \
            --library PipeWork \
            --use_entity 'QUEUE_ARBITER(INTEGER_ARCH)' \
            --use_entity 'SDPRAM(MODEL)' \
            --execute '$(GHDL) -a $(GHDLFLAGS) --work=#{library_name} #{file_name}' \
            $(PIPEWORK_SRC_PATH)

axi4_adapter_test_bench_4096_32_32.o : $(SRC_TEST_PATH)/axi4_adapter_test_bench_4096_32_32.vhd axi4_adapter_test_bench.o
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_adapter_test_bench_4096_32_64.o : $(SRC_TEST_PATH)/axi4_adapter_test_bench_4096_32_64.vhd axi4_adapter_test_bench.o
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_adapter_test_bench_4096_64_32.o : $(SRC_TEST_PATH)/axi4_adapter_test_bench_4096_64_32.vhd axi4_adapter_test_bench.o
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_adapter_test_bench.o            : $(SRC_TEST_PATH)/axi4_adapter_test_bench.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_write_adapter.o                 : $(SRC_TEST_PATH)/axi4_write_adapter.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_read_adapter.o                  : $(SRC_TEST_PATH)/axi4_read_adapter.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_adapter.o                       : $(SRC_TEST_PATH)/axi4_adapter.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<


axi4_adapter_test_bench_4096_32_32.snr : $(SRC_PATH)/test/scenarios/axi4_adapter/make_scenario.rb
	 $(SRC_PATH)/test/scenarios/axi4_adapter/make_scenario.rb \
             --name       AXI4_ADAPTER_TEST_4096_32_32 \
             --t_width    32 \
             --m_width    32 \
             --m_max_size 4096 \
             --output     axi4_adapter_test_bench_4096_32_32.snr

axi4_adapter_test_bench_4096_32_64.snr : $(SRC_PATH)/test/scenarios/axi4_adapter/make_scenario.rb
	 $(SRC_PATH)/test/scenarios/axi4_adapter/make_scenario.rb \
             --name       AXI4_ADAPTER_TEST_4096_32_64 \
             --t_width    32 \
             --m_width    64 \
             --m_max_size 4096 \
             --output     axi4_adapter_test_bench_4096_32_64.snr

axi4_adapter_test_bench_4096_64_32.snr : $(SRC_PATH)/test/scenarios/axi4_adapter/make_scenario.rb
	 $(SRC_PATH)/test/scenarios/axi4_adapter/make_scenario.rb \
             --name       AXI4_ADAPTER_TEST_4096_64_32 \
             --t_width    64 \
             --m_width    32 \
             --m_max_size 4096 \
             --output     axi4_adapter_test_bench_4096_64_32.snr
