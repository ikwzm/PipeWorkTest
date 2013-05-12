
DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/ghdl/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools
MAKECOMPONENTPACKAGE = $(DUMMY_PLUG_TOOL_PATH)/MakeComponentPackage.rb
PIPEWORK_SRC_MAIN_PATH = ../../../PipeWork/src
SRC_TEST_PATH          = ../../../src/test/vhdl/axi4_register_interface
SCENARIO_PATH          = ../../../src/test/scenarios/axi4_register_interface

COPY       = cp
GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH)

PIPEWORK_COMPONENTS = components                             \
                      chopper                                \
                      reducer                                \
                      pool_outlet_port                       \
                      queue_register                         \
                      queue_arbiter                          \
                      queue_arbiter_integer_arch             \
                      sdpram                                 \
                      sdpram_model                           \
                      axi4_types                             \
                      axi4_components                        \
                      axi4_data_port                         \
                      axi4_data_outlet_port                  \
                      axi4_register_write_interface          \
                      axi4_register_read_interface           \
                      axi4_register_interface                \
                      $(END_LIST)

TEST_BENCH = axi4_register_interface_test_bench_32_32        \
             axi4_register_interface_test_bench_32_64        \
             axi4_register_interface_test_bench_64_32        \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)


axi4_register_interface_test_bench_32_32    : axi4_register_interface_test_bench_32_32.o axi4_register_interface_test_bench_32_32.snr
	 $(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	-$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

axi4_register_interface_test_bench_32_64    : axi4_register_interface_test_bench_32_64.o axi4_register_interface_test_bench_32_64.snr
	 $(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	-$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

axi4_register_interface_test_bench_64_32    : axi4_register_interface_test_bench_64_32.o axi4_register_interface_test_bench_64_32.snr
	 $(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	-$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

axi4_register_interface_test_bench_32_32.o  : $(SRC_TEST_PATH)/axi4_register_interface_test_bench_32_32.vhd axi4_register_interface_test_bench.o
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_register_interface_test_bench_32_64.o  : $(SRC_TEST_PATH)/axi4_register_interface_test_bench_32_64.vhd axi4_register_interface_test_bench.o
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_register_interface_test_bench_64_32.o  : $(SRC_TEST_PATH)/axi4_register_interface_test_bench_64_32.vhd axi4_register_interface_test_bench.o
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_register_interface_test_bench.o        : $(SRC_TEST_PATH)/axi4_register_interface_test_bench.vhd DUT
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

axi4_register_interface_test_bench_32_32.snr: $(SCENARIO_PATH)/axi4_register_interface_test_bench_32_32.snr
	$(COPY) $< .

axi4_register_interface_test_bench_32_64.snr: $(SCENARIO_PATH)/axi4_register_interface_test_bench_32_64.snr
	$(COPY) $< .

axi4_register_interface_test_bench_64_32.snr: $(SCENARIO_PATH)/axi4_register_interface_test_bench_64_32.snr
	$(COPY) $< .

DUT : $(addsuffix .o,$(PIPEWORK_COMPONENTS))

axi4_types.o                               : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_types.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_components.o                          : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_components.vhd axi4_types.o
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_register_write_interface.o            : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_register_write_interface.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_register_read_interface.o             : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_register_read_interface.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_register_interface.o                  : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_register_interface.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_data_port.o                           : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_data_port.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_data_outlet_port.o                    : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_data_outlet_port.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

components.o                               : $(PIPEWORK_SRC_MAIN_PATH)/components/components.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

chopper.o                                  : $(PIPEWORK_SRC_MAIN_PATH)/components/chopper.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

reducer.o                                  : $(PIPEWORK_SRC_MAIN_PATH)/components/reducer.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

sdpram.o                                   : $(PIPEWORK_SRC_MAIN_PATH)/components/sdpram.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

sdpram_model.o                             : $(PIPEWORK_SRC_MAIN_PATH)/components/sdpram_model.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

queue_arbiter.o                            : $(PIPEWORK_SRC_MAIN_PATH)/components/queue_arbiter.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

queue_arbiter_integer_arch.o               : $(PIPEWORK_SRC_MAIN_PATH)/components/queue_arbiter_integer_arch.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

queue_register.o                           : $(PIPEWORK_SRC_MAIN_PATH)/components/queue_register.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

pool_outlet_port.o                         : $(PIPEWORK_SRC_MAIN_PATH)/components/pool_outlet_port.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

