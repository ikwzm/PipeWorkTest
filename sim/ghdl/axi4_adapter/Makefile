
DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/ghdl/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools
PIPEWORK_PATH        = ../../../PipeWork
PIPEWORK_WORK_PATH   = $(PIPEWORK_PATH)/sim/ghdl
PIPEWORK_SRC_PATH    = $(PIPEWORK_PATH)/src
PIPEWORK_TOOL_PATH   = $(PIPEWORK_PATH)/tools
SRC_TEST_PATH        = ../../../src/test/vhdl/axi4_adapter

COPY       = cp
GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

pipework:
	$(PIPEWORK_TOOL_PATH)/MakeSerializedPackageList.rb \
            --library PipeWork \
            --use_entity 'QUEUE_ARBITER(INTEGER_ARCH)' \
            --use_entity 'SDPRAM(MODEL)' \
            --execute '$(GHDL) -a $(GHDLFLAGS) --work=#{library_name} #{file_name}' \
            $(PIPEWORK_SRC_PATH)


axi4_adapter_test_bench_4096_32_32   : axi4_adapter_test_bench_4096_32_32.o axi4_adapter.o axi4_write_adapter.o axi4_adapter_test_bench_4096.snr
	 $(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	-$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

axi4_adapter_test_bench_4096_32_32.o : $(SRC_TEST_PATH)/axi4_adapter_test_bench_4096_32_32.vhd axi4_adapter_test_bench.o
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_adapter_test_bench.o            : $(SRC_TEST_PATH)/axi4_adapter_test_bench.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_write_adapter.o                 : $(SRC_TEST_PATH)/axi4_write_adapter.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_adapter.o                       : $(SRC_TEST_PATH)/axi4_adapter.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

