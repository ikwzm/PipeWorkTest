
DUMMY_PLUG_WORK_PATH := ../../../Dummy_Plug/sim/ghdl-0.35/dummy_plug
PIPEWORK_WORK_PATH   := ../../../PipeWork/sim/ghdl-0.35
SRC_PATH             := ../../../src
TEST_SCENARIO_PATH   := $(SRC_PATH)/test/scenarios/image_stream_models
TEST_SOURCE_PATH     := $(SRC_PATH)/test/vhdl/image_stream_models

GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

DUT_COMPONENTS := image_stream_player        \
                  image_stream_master_player \
                  image_stream_slave_player  \
                  $(END_LIST)

TEST           := test_8x0x0x0x0 \
                  test_8x0x0x2x2 \
                  test_8x1x0x0x0 \
                  test_8x1x0x1x1 \
                  test_8x3x0x4x1 \
                  test_8x4x4x3x3 \
                  $(END_LIST)

TEST_SCENARIO  := $(addsuffix .snr, $(TEST))
TEST_BENCH     := $(patsubst %, image_stream_player_%, $(TEST))

all: $(TEST)

clean:
	rm -f *.o *.cf $(TEST_BENCH) $(TEST_SCENARIO)

$(TEST)          : $(TEST_BENCH) 

$(TEST_BENCH)    : $(TEST_SCENARIO) image_stream_player_test_bench.o DUT 
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

$(TEST_SCENARIO) : 
	cp $(TEST_SCENARIO_PATH)/$@ $@

DUT              : $(addsuffix .o,$(DUT_COMPONENTS))

image_stream_models.o                          : $(TEST_SOURCE_PATH)/image_stream_models.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_stream_player.o                          : $(TEST_SOURCE_PATH)/image_stream_player.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_stream_master_player.o                   : $(TEST_SOURCE_PATH)/image_stream_master_player.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_stream_slave_player.o                    : $(TEST_SOURCE_PATH)/image_stream_slave_player.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_stream_player_test_bench.o               : $(TEST_SOURCE_PATH)/image_stream_player_test_bench.vhd image_stream_models.o
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

