
DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/ghdl/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools
MAKECOMPONENTPACKAGE = $(DUMMY_PLUG_TOOL_PATH)/MakeComponentPackage.rb
PIPEWORK_SRC_MAIN_PATH = ../../../src/main/vhdl
PIPEWORK_SRC_TEST_PATH = ../../../src/test/vhdl
SRC_PATH               = ../../../src/examples/pump_axi4_to_axi4

GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH)

PIPEWORK_COMPONENTS = components                             \
                      chopper                                \
                      reducer                                \
                      queue_arbiter                          \
                      queue_arbiter_integer_arch             \
                      queue_register                         \
                      sdpram                                 \
                      sdpram_model                           \
                      pump_components                        \
                      pump_count_up_register                 \
                      pump_count_down_register               \
                      pump_valve_control_register            \
                      axi4_types                             \
                      axi4_components                        \
                      axi4_master_address_channel_controller \
                      axi4_master_read_controller            \
                      axi4_master_write_controller           \
                      axi4_register_write_interface          \
                      axi4_register_read_interface           \
                      axi4_register_interface                \
                      pump_axi4_to_axi4                      \
                      $(END_LIST)

TEST_BENCH = pump_axi4_to_axi4_test_bench_32_32 \
             $(END_LIST)

all: DUT $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)

$(TEST_BENCH) : $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .snr,$(TEST_BENCH))
	 $(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	-$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

DUT : $(addsuffix .o,$(PIPEWORK_COMPONENTS))

axi4_types.o                             : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_types.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_components.o                        : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_components.vhd axi4_types.o
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_master_address_channel_controller.o : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_master_address_channel_controller.vhd  axi4_components.o
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_master_read_controller.o            : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_master_read_controller.vhd             axi4_components.o
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_master_write_controller.o           : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_master_write_controller.vhd            axi4_components.o
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_register_write_interface.o          : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_register_write_interface.vhd           axi4_components.o
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_register_read_interface.o           : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_register_read_interface.vhd            axi4_components.o
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

axi4_register_interface.o                : $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_register_interface.vhd                 axi4_components.o
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

components.o                             : $(PIPEWORK_SRC_MAIN_PATH)/components/components.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

chopper.o                                : $(PIPEWORK_SRC_MAIN_PATH)/components/chopper.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

reducer.o                                : $(PIPEWORK_SRC_MAIN_PATH)/components/reducer.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

queue_register.o                         : $(PIPEWORK_SRC_MAIN_PATH)/components/queue_register.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

sdpram.o                                 : $(PIPEWORK_SRC_MAIN_PATH)/components/sdpram.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

sdpram_model.o                           : $(PIPEWORK_SRC_MAIN_PATH)/components/sdpram_model.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

queue_arbiter.o                          : $(PIPEWORK_SRC_MAIN_PATH)/components/queue_arbiter.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

queue_arbiter_integer_arch.o             : $(PIPEWORK_SRC_MAIN_PATH)/components/queue_arbiter_integer_arch.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

pump_components.o                        : $(PIPEWORK_SRC_MAIN_PATH)/pump/pump_components.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

pump_count_up_register.o                 : $(PIPEWORK_SRC_MAIN_PATH)/pump/pump_count_up_register.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

pump_count_down_register.o               : $(PIPEWORK_SRC_MAIN_PATH)/pump/pump_count_down_register.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

pump_valve_control_register.o            : $(PIPEWORK_SRC_MAIN_PATH)/pump/pump_valve_control_register.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

pump_axi4_to_axi4.o                      : $(SRC_PATH)/pump_axi4_to_axi4.vhd components.o axi4_components.o pump_components.o
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

pump_axi4_to_axi4_test_bench.o           : $(SRC_PATH)/pump_axi4_to_axi4_test_bench.vhd components.o axi4_components.o pump_components.o
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

pump_axi4_to_axi4_test_bench_32_32.o     : $(SRC_PATH)/pump_axi4_to_axi4_test_bench_32_32.vhd pump_axi4_to_axi4_test_bench.o
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK $<

$(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_components.vhd :                                  \
            $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_types.vhd                             \
            $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_master_address_channel_controller.vhd \
            $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_master_read_controller.vhd            \
            $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_master_write_controller.vhd           \
            $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_register_write_interface.vhd          \
            $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_register_read_interface.vhd           \
            $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_register_interface.vhd                \
            $(END_LIST)
	$(MAKECOMPONENTPACKAGE) --verbose \
            --brief   'PIPEWORK AXI4 LIBRARY DESCRIPTION' \
            --version 1.0.7 \
            --author  'Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>' \
            --library PIPEWORK \
            --package AXI4_COMPONENTS \
            --output  $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_components.vhd              \
            $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_master_address_channel_controller.vhd \
            $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_master_read_controller.vhd            \
            $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_master_write_controller.vhd           \
            $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_register_write_interface.vhd          \
            $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_register_read_interface.vhd           \
            $(PIPEWORK_SRC_MAIN_PATH)/axi4/axi4_register_interface.vhd                \
            $(END_LIST)

$(PIPEWORK_SRC_MAIN_PATH)/pump/pump_components.vhd :                                  \
            $(PIPEWORK_SRC_MAIN_PATH)/pump/pump_count_up_register.vhd                 \
            $(PIPEWORK_SRC_MAIN_PATH)/pump/pump_count_down_register.vhd               \
            $(PIPEWORK_SRC_MAIN_PATH)/pump/pump_valve_control_register.vhd            \
            $(END_LIST)
	$(MAKECOMPONENTPACKAGE) --verbose \
            --brief   'PIPEWORK PUMP LIBRARY DESCRIPTION' \
            --version 0.0.1 \
            --author  'Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>' \
            --library PIPEWORK \
            --package PUMP_COMPONENTS \
            --output  $(PIPEWORK_SRC_MAIN_PATH)/pump/pump_components.vhd              \
            $(PIPEWORK_SRC_MAIN_PATH)/pump/pump_count_up_register.vhd                 \
            $(PIPEWORK_SRC_MAIN_PATH)/pump/pump_count_down_register.vhd               \
            $(PIPEWORK_SRC_MAIN_PATH)/pump/pump_valve_control_register.vhd            \
            $(END_LIST)
