
DUMMY_PLUG_WORK_PATH = ../../../Dummy_Plug/sim/ghdl-0.35/dummy_plug
PIPEWORK_WORK_PATH   = ../../../PipeWork/sim/ghdl-0.35
SRC_PATH             = ../../../src

GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

DUT_COMPONENTS = axi4_master_to_stream \
                 $(END_LIST)

TEST_BENCH     = axi4_master_to_stream_test_bench \
                 $(END_LIST)

all: DUT $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)

$(TEST_BENCH) : $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .snr,$(TEST_BENCH)) DUT
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

DUT : $(addsuffix .o,$(DUT_COMPONENTS))

axi4_master_to_stream.o                     : $(SRC_PATH)/test/vhdl/axi4_master_to_stream/axi4_master_to_stream.vhd 
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_master_to_stream_test_bench.o          : $(SRC_PATH)/test/vhdl/axi4_master_to_stream/axi4_master_to_stream_test_bench.vhd 
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_master_to_stream_test_bench.snr        : $(SRC_PATH)/test/scenarios/axi4_master_to_stream/test_32_32_32_4096.snr
	cp $< $@
