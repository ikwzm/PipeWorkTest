
DUMMY_PLUG_WORK_PATH = ../../../Dummy_Plug/sim/ghdl-0.35/dummy_plug
PIPEWORK_WORK_PATH   = ../../../PipeWork/sim/ghdl-0.35
SRC_PATH             = ../../../src

GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

DUT_COMPONENTS = image_stream_player        \
                 image_stream_master_player \
                 image_stream_slave_player  \
                 $(END_LIST)

TEST_BENCH     = image_stream_player_test_8x0x0x0x0 \
                 image_stream_player_test_8x0x0x2x2 \
                 image_stream_player_test_8x1x0x0x0 \
                 image_stream_player_test_8x1x0x1x1 \
                 image_stream_player_test_8x3x0x4x1 \
                 image_stream_player_test_8x4x4x3x3 \
                 $(END_LIST)

all: DUT $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)

image_stream_player_test_8x0x0x0x0  : image_stream_player_test_bench.o DUT test_8x0x0x0x0.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_stream_player_test_8x0x0x2x2  : image_stream_player_test_bench.o DUT test_8x0x0x2x2.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_stream_player_test_8x1x0x0x0  : image_stream_player_test_bench.o DUT test_8x1x0x0x0.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_stream_player_test_8x1x0x1x1  : image_stream_player_test_bench.o DUT test_8x1x0x1x1.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_stream_player_test_8x3x0x4x1  : image_stream_player_test_bench.o DUT test_8x3x0x4x1.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_stream_player_test_8x4x4x3x3  : image_stream_player_test_bench.o DUT test_8x4x4x3x3.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

DUT : $(addsuffix .o,$(DUT_COMPONENTS))

image_stream_player.o                          : $(SRC_PATH)/test/vhdl/image_stream_models/image_stream_player.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_stream_master_player.o                   : $(SRC_PATH)/test/vhdl/image_stream_models/image_stream_master_player.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_stream_slave_player.o                    : $(SRC_PATH)/test/vhdl/image_stream_models/image_stream_slave_player.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_stream_models.o                          : $(SRC_PATH)/test/vhdl/image_stream_models/image_stream_models.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_stream_player_test_bench.o               : $(SRC_PATH)/test/vhdl/image_stream_models/image_stream_player_test_bench.vhd image_stream_models.o
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

test_8x0x0x0x0.snr : $(SRC_PATH)/test/scenarios/image_stream_models/test_8x0x0x0x0.snr
	cp $< $@

test_8x0x0x2x2.snr : $(SRC_PATH)/test/scenarios/image_stream_models/test_8x0x0x2x2.snr
	cp $< $@

test_8x1x0x0x0.snr : $(SRC_PATH)/test/scenarios/image_stream_models/test_8x1x0x0x0.snr
	cp $< $@

test_8x1x0x1x1.snr : $(SRC_PATH)/test/scenarios/image_stream_models/test_8x1x0x1x1.snr
	cp $< $@

test_8x3x0x4x1.snr : $(SRC_PATH)/test/scenarios/image_stream_models/test_8x3x0x4x1.snr
	cp $< $@

test_8x4x4x3x3.snr : $(SRC_PATH)/test/scenarios/image_stream_models/test_8x4x4x3x3.snr
	cp $< $@

