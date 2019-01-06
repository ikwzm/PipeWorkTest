
DUMMY_PLUG_WORK_PATH = ../../../Dummy_Plug/sim/ghdl-0.35/dummy_plug
PIPEWORK_WORK_PATH   = ../../../PipeWork/sim/ghdl-0.35
SRC_PATH             = ../../../src
VHDL_SRC_PATH        = $(SRC_PATH)/test/vhdl
SCENARIO_PATH        = $(SRC_PATH)/test/scenarios/image_window_channel_reducer


GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

IMAGE_MODELS   = image_window_player.o        \
                 image_window_master_player.o \
                 image_window_slave_player.o  \
                 $(END_LIST)

TEST_BENCH     = image_window_channel_reducer_test_0_0_1_2 \
                 image_window_channel_reducer_test_0_0_2_1 \
                 image_window_channel_reducer_test_0_0_4_8 \
                 image_window_channel_reducer_test_0_0_8_4 \
                 image_window_channel_reducer_test_1_1_8_8 \
                 $(END_LIST)

all: $(TEST_BENCH)

IMAGE_WINDOW_MODELS : image_window_models.o image_window_player.o image_window_master_player.o image_window_slave_player.o

clean:
	rm -f *.o *.cf $(TEST_BENCH)

image_window_channel_reducer_test_0_0_1_2 : image_window_channel_reducer_test_bench.o test_0_0_1_2.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_window_channel_reducer_test_0_0_2_1 : image_window_channel_reducer_test_bench.o test_0_0_2_1.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_window_channel_reducer_test_0_0_4_8 : image_window_channel_reducer_test_bench.o test_0_0_4_8.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_window_channel_reducer_test_0_0_8_4 : image_window_channel_reducer_test_bench.o test_0_0_8_4.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_window_channel_reducer_test_1_1_8_8 : image_window_channel_reducer_test_bench.o test_1_1_8_8.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_window_player.o                          : $(VHDL_SRC_PATH)/image_window_models/image_window_player.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_window_master_player.o                   : $(VHDL_SRC_PATH)/image_window_models/image_window_master_player.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_window_slave_player.o                    : $(VHDL_SRC_PATH)/image_window_models/image_window_slave_player.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_window_models.o                          : $(VHDL_SRC_PATH)/image_window_models/image_window_models.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_window_channel_reducer_test_bench.o      : $(VHDL_SRC_PATH)/image_window_channel_reducer/image_window_channel_reducer_test_bench.vhd IMAGE_WINDOW_MODELS 
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

test_0_0_1_2.snr : $(SCENARIO_PATH)/test_0_0_1_2.snr
	cp $< $@

test_0_0_2_1.snr : $(SCENARIO_PATH)/test_0_0_2_1.snr
	cp $< $@

test_0_0_4_8.snr : $(SCENARIO_PATH)/test_0_0_4_8.snr
	cp $< $@

test_0_0_8_4.snr : $(SCENARIO_PATH)/test_0_0_8_4.snr
	cp $< $@

test_1_1_8_8.snr : $(SCENARIO_PATH)/test_1_1_8_8.snr
	cp $< $@

