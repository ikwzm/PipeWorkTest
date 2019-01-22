
SRC_PATH             = ../../../src
DUMMY_PLUG_SRC_PATH  = ../../../Dummy_Plug/src/main/vhdl
PIPEWORK_SRC_PATH    = ../../../PipeWork/src/
DUMMY_PLUG_WORK_PATH = ./dummy_plug/
PIPEWORK_WORK_PATH   = ./pipework/
VHDL_SRC_PATH        = $(SRC_PATH)/test/vhdl
SCENARIO_PATH        = $(SRC_PATH)/test/scenarios/image_stream_buffer


GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH) 

IMAGE_MODELS   = image_stream_player.o        \
                 image_stream_master_player.o \
                 image_stream_slave_player.o  \
                 $(END_LIST)

TEST_BENCH     = image_stream_buffer_test_4_8_1x1x1_1x1x1_1_1   \
                 image_stream_buffer_test_4_8_4x1x1_4x1x1_1_1   \
                 image_stream_buffer_test_1_8_1x4x1_1x5x5_1_1   \
                 image_stream_buffer_test_0_2_32x1x1_32x3x3_8_4 \
                 $(END_LIST)

.PHONY: all $(TEST_BENCH)

all: $(TEST_BENCH)

pipework   : $(PIPEWORK_WORK_PATH)/pipework-obj93.cf

$(PIPEWORK_WORK_PATH)/pipework-obj93.cf :
	@if [ ! -d $(PIPEWORK_WORK_PATH) ]; \
	    then echo "mkdir -p $(PIPEWORK_WORK_PATH)"; mkdir -p $(PIPEWORK_WORK_PATH); \
	fi
	../../../PipeWork/tools/vhdl-archiver.rb \
            --library PIPEWORK \
            --use_entity 'QUEUE_ARBITER(INTEGER_ARCH)' \
            --use_entity 'SDPRAM(MODEL)' \
            --execute '$(GHDL) -a $(GHDLFLAGS) --work=#{library_name} --workdir=$(PIPEWORK_WORK_PATH) #{file_name}' \
            --top IMAGE_STREAM_BUFFER \
            $(PIPEWORK_SRC_PATH)

dummy_plug : $(DUMMY_PLUG_WORK_PATH)/dummy_plug-obj93.cf

$(DUMMY_PLUG_WORK_PATH)/dummy_plug-obj93.cf :
	@if [ ! -d $(DUMMY_PLUG_WORK_PATH) ]; \
	    then echo "mkdir -p $(DUMMY_PLUG_WORK_PATH)"; mkdir -p $(DUMMY_PLUG_WORK_PATH); \
	fi
	../../../PipeWork/tools/vhdl-archiver.rb \
	    --library DUMMY_PLUG \
	    --exclude $(DUMMY_PLUG_SRC_PATH)/core/sync_alt.vhd \
	    --exclude $(DUMMY_PLUG_SRC_PATH)/axi4/axi3_signal_printer.vhd \
	    --execute '$(GHDL) -a $(GHDLFLAGS) --work=#{library_name} --workdir=$(DUMMY_PLUG_WORK_PATH) #{file_name}' \
	    $(DUMMY_PLUG_SRC_PATH)


image_stream_model : image_stream_models.o image_stream_player.o image_stream_master_player.o image_stream_slave_player.o

clean:
	rm -f *.o *.cf $(TEST_BENCH)
	rm -rf ./dummy_plug/ ./pipework/

image_stream_buffer_test_4_8_1x1x1_1x1x1_1_1   : image_stream_buffer_test_bench.o test_4_8_1x1x1_1x1x1_1_1.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_stream_buffer_test_4_8_4x1x1_4x1x1_1_1   : image_stream_buffer_test_bench.o test_4_8_4x1x1_4x1x1_1_1.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_stream_buffer_test_1_8_1x4x1_1x5x5_1_1   : image_stream_buffer_test_bench.o test_1_8_1x4x1_1x5x5_1_1.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_stream_buffer_test_0_2_32x1x1_32x3x3_8_4 : image_stream_buffer_test_bench.o test_0_2_32x1x1_32x3x3_8_4.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_stream_player.o                 : $(VHDL_SRC_PATH)/image_stream_models/image_stream_player.vhd        dummy_plug pipework
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_stream_master_player.o          : $(VHDL_SRC_PATH)/image_stream_models/image_stream_master_player.vhd dummy_plug pipework
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_stream_slave_player.o           : $(VHDL_SRC_PATH)/image_stream_models/image_stream_slave_player.vhd  dummy_plug pipework
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_stream_models.o                 : $(VHDL_SRC_PATH)/image_stream_models/image_stream_models.vhd        dummy_plug pipework
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_stream_buffer_test_bench.o      : $(VHDL_SRC_PATH)/image_stream_buffer/image_stream_buffer_test_bench.vhd image_stream_model
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

test_4_8_1x1x1_1x1x1_1_1.snr   : $(SCENARIO_PATH)/test_4_8_1x1x1_1x1x1_1_1.snr
	cp $< $@

test_4_8_4x1x1_4x1x1_1_1.snr   : $(SCENARIO_PATH)/test_4_8_4x1x1_4x1x1_1_1.snr
	cp $< $@

test_1_8_1x4x1_1x5x5_1_1.snr   : $(SCENARIO_PATH)/test_1_8_1x4x1_1x5x5_1_1.snr
	cp $< $@

test_0_2_32x1x1_32x3x3_8_4.snr : $(SCENARIO_PATH)/test_0_2_32x1x1_32x3x3_8_4.snr
	cp $< $@

