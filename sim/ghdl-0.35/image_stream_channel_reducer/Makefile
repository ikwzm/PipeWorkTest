
DUMMY_PLUG_WORK_PATH := ../../../Dummy_Plug/sim/ghdl-0.35/dummy_plug
PIPEWORK_WORK_PATH   := ../../../PipeWork/sim/ghdl-0.35
SRC_PATH             := ../../../src
TEST_SOURCE_PATH     := $(SRC_PATH)/test/vhdl
TEST_SCENARIO_PATH   := $(SRC_PATH)/test/scenarios/image_stream_channel_reducer

GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

IMAGE_MODELS   := image_stream_player.o        \
                  image_stream_master_player.o \
                  image_stream_slave_player.o  \
                  $(END_LIST)

TEST           := test_0_0_1_2 \
                  test_0_0_2_1 \
                  test_0_0_4_8 \
                  test_0_0_8_4 \
                  test_1_1_8_8 \
                  $(END_LIST)

TEST_SCENARIO  := $(addsuffix .snr, $(TEST))
TEST_BENCH     := $(patsubst %, image_stream_channel_reducer_%, $(TEST))

all: $(TEST)

clean:
	rm -f *.o *.cf $(TEST_BENCH) $(TEST_SCENARIO)

$(TEST)          : $(TEST_BENCH) 

$(TEST_BENCH)    : $(TEST_SCENARIO) image_stream_channel_reducer_test_bench.o
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

$(TEST_SCENARIO) : 
	cp $(TEST_SCENARIO_PATH)/$@ $@

IMAGE_STREAM_MODELS : image_stream_models.o image_stream_player.o image_stream_master_player.o image_stream_slave_player.o

image_stream_player.o                          : $(TEST_SOURCE_PATH)/image_stream_models/image_stream_player.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_stream_master_player.o                   : $(TEST_SOURCE_PATH)/image_stream_models/image_stream_master_player.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_stream_slave_player.o                    : $(TEST_SOURCE_PATH)/image_stream_models/image_stream_slave_player.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_stream_models.o                          : $(TEST_SOURCE_PATH)/image_stream_models/image_stream_models.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_stream_channel_reducer_test_bench.o      : $(TEST_SOURCE_PATH)/image_stream_channel_reducer/image_stream_channel_reducer_test_bench.vhd IMAGE_STREAM_MODELS 
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

