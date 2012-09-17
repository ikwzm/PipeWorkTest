
DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/ghdl/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools
MAKECOMPONENTPACKAGE = $(DUMMY_PLUG_TOOL_PATH)/MakeComponentPackage.rb

GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P../pipework -P$(DUMMY_PLUG_WORK_PATH)

SRC_PATH   = ../../../src/examples/fifo_with_done

TEST_BENCH = fifo_with_done_test_bench           \
             fifo_with_done_test_bench_async_5_9 \
             fifo_with_done_test_bench_async_9_5 \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH) fifo_with_done_components.vhd

$(TEST_BENCH) : $(addsuffix .o,$(TEST_BENCH))
	 $(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	-$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

DUT : fifo_with_done.o fifo_with_done_ctrl.o fifo_with_done_ctrl_sync.o fifo_with_done_components.o

fifo_with_done_test_bench.o: $(SRC_PATH)/fifo_with_done_test_bench.vhd DUT
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

fifo_with_done_test_bench_async_5_9.o: $(SRC_PATH)/fifo_with_done_test_bench_async_5_9.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

fifo_with_done_test_bench_async_9_5.o: $(SRC_PATH)/fifo_with_done_test_bench_async_9_5.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

fifo_with_done.o           : $(SRC_PATH)/fifo_with_done.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

fifo_with_done_ctrl.o      : $(SRC_PATH)/fifo_with_done_ctrl.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

fifo_with_done_ctrl_sync.o : $(SRC_PATH)/fifo_with_done_ctrl_sync.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

fifo_with_done_components.o: $(SRC_PATH)/fifo_with_done_components.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

$(SRC_PATH)/fifo_with_done_components.vhd : $(SRC_PATH)/fifo_with_done.vhd $(SRC_PATH)/fifo_with_done_test_bench.vhd
	$(MAKECOMPONENTPACKAGE) --verbose \
            --brief   'FIFO_WITH_DONE COMPONENT LIBRARY DESCRIPTION' \
            --version 1.2.0 \
            --author  'Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>' \
            --library WORK \
            --package FIFO_WITH_DONE_COMPONENTS \
            --output  $(SRC_PATH)/fifo_with_done_components.vhd \
            $(SRC_PATH)/fifo_with_done.vhd \
            $(SRC_PATH)/fifo_with_done_test_bench.vhd
