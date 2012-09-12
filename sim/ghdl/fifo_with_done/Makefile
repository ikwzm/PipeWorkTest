GHDL=ghdl
GHDLFLAGS=--mb-comments -P../pipework -P../../../Dummy_Plug/sim/ghdl/dummy_plug

DUMMY_PLUG_SRC_PATH     = ../../../Dummy_Plug/src/main/vhdl
SRC_PATH = ../../../src/examples/fifo_with_done

TEST_BENCH = fifo_with_done_test_bench \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf tmp.vhd $(TEST_BENCH) fifo_with_done_components.vhd

$(TEST_BENCH) : $(addsuffix .o,$(TEST_BENCH))
	 $(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	-$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

DUT : fifo_with_done.o fifo_with_done_ctrl.o fifo_with_done_ctrl_sync.o fifo_with_done_components.o

fifo_with_done_test_bench.o: $(SRC_PATH)/fifo_with_done_test_bench.vhd DUT
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

fifo_with_done.o           : $(SRC_PATH)/fifo_with_done.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

fifo_with_done_ctrl.o      : $(SRC_PATH)/fifo_with_done_ctrl.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

fifo_with_done_ctrl_sync.o : $(SRC_PATH)/fifo_with_done_ctrl_sync.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

fifo_with_done_components.o: fifo_with_done_components.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

fifo_with_done_components.vhd : $(SRC_PATH)/fifo_with_done.vhd $(SRC_PATH)/fifo_with_done_test_bench.vhd
	../../../../Dummy_Plug/tools/MakeComponentPackage.rb --verbose \
            --brief   'FIFO_WITH_DONE COMPONENT LIBRARY DESCRIPTION' \
            --version 1.2.0 \
            --author  'Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>' \
            --library WORK \
            --package FIFO_WITH_DONE_COMPONENTS \
            --output  fifo_with_done_components.vhd \
            $(SRC_PATH)/fifo_with_done.vhd \
            $(SRC_PATH)/fifo_with_done_test_bench.vhd
