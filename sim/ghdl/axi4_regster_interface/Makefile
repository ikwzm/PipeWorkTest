
DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/ghdl/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools
MAKECOMPONENTPACKAGE = $(DUMMY_PLUG_TOOL_PATH)/MakeComponentPackage.rb
PIPEWORK_SRC_MAIN_PATH = ../../../src/main/vhdl
PIPEWORK_SRC_TEST_PATH = ../../../src/test/vhdl

GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH)

PIPEWORK_COMPONENTS = components                             \
                      chopper                                \
                      reducer                                \
                      queue_arbiter                          \
                      queue_arbiter_integer_arch             \
                      sdpram                                 \
                      sdpram_model                           \
                      axi4_types                             \
                      axi4_components                        \
                      axi4_register_write_interface          \
                      axi4_register_read_interface           \
                      axi4_register_interface                \
                      $(END_LIST)

TEST_BENCH = axi4_register_interface_test_bench_32_32        \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)

$(TEST_BENCH) : $(addsuffix .o,$(TEST_BENCH))
	 $(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	-$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

DUT : $(addsuffix .o,$(PIPEWORK_COMPONENTS))

axi4_types.o                             : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_types.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_components.o                        : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_components.vhd axi4_types.o
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_register_write_interface.o          : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_register_write_interface.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_register_read_interface.o           : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_register_read_interface.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_register_interface.o                : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_register_interface.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

components.o                             : $(PIPEWORK_SRC_MAIN_PATH)/components/components.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

chopper.o                                : $(PIPEWORK_SRC_MAIN_PATH)/components/chopper.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

reducer.o                                : $(PIPEWORK_SRC_MAIN_PATH)/components/reducer.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

sdpram.o                                 : $(PIPEWORK_SRC_MAIN_PATH)/components/sdpram.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

sdpram_model.o                           : $(PIPEWORK_SRC_MAIN_PATH)/components/sdpram_model.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

queue_arbiter.o                          : $(PIPEWORK_SRC_MAIN_PATH)/components/queue_arbiter.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

queue_arbiter_integer_arch.o             : $(PIPEWORK_SRC_MAIN_PATH)/components/queue_arbiter_integer_arch.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_register_interface_test_bench_32_32.o : $(PIPEWORK_SRC_TEST_PATH)/axi4_register_interface/axi4_register_interface_test_bench_32_32.vhd axi4_register_interface_test_bench.o axi4_register_interface_32_32.snr
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_register_interface_test_bench.o : $(PIPEWORK_SRC_TEST_PATH)/axi4_register_interface/axi4_register_interface_test_bench.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<
