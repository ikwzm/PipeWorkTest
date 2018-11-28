
DUMMY_PLUG_WORK_PATH = ../../../Dummy_Plug/sim/ghdl-0.35/dummy_plug
PIPEWORK_WORK_PATH   = ../../../PipeWork/sim/ghdl-0.35
SRC_PATH             = ../../../src

GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

DUT_COMPONENTS = image_window_player        \
                 image_window_master_player \
                 image_window_slave_player  \
                 $(END_LIST)

TEST_BENCH     = image_window_player_test_8x1_1x1 \
                 image_window_player_test_8x1_3x3 \
                 image_window_player_test_8x3_4x1 \
                 $(END_LIST)

all: DUT $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)

image_window_player_test_8x1_1x1    : image_window_player_test_bench.o DUT test_8x1_1x1.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_window_player_test_8x1_3x3    : image_window_player_test_bench.o DUT test_8x1_3x3.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_window_player_test_8x3_4x1    : image_window_player_test_bench.o DUT test_8x3_4x1.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

DUT : $(addsuffix .o,$(DUT_COMPONENTS))

image_window_player.o                          : $(SRC_PATH)/test/vhdl/image_window_models/image_window_player.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_window_master_player.o                   : $(SRC_PATH)/test/vhdl/image_window_models/image_window_master_player.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_window_slave_player.o                    : $(SRC_PATH)/test/vhdl/image_window_models/image_window_slave_player.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_window_models.o                          : $(SRC_PATH)/test/vhdl/image_window_models/image_window_models.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_window_player_test_bench.o               : $(SRC_PATH)/test/vhdl/image_window_models/image_window_player_test_bench.vhd image_window_models.o
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

test_8x1_1x1.snr : $(SRC_PATH)/test/scenarios/image_window_models/test_8x1_1x1.snr
	cp $< $@

test_8x1_3x3.snr : $(SRC_PATH)/test/scenarios/image_window_models/test_8x1_3x3.snr
	cp $< $@

test_8x3_4x1.snr : $(SRC_PATH)/test/scenarios/image_window_models/test_8x3_4x1.snr
	cp $< $@

