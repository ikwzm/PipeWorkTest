
WORK                  := WORK
SRC_PATH              := ../../../src
DUMMY_PLUG_SRC_PATH   := ../../../Dummy_Plug/src/main/vhdl
PIPEWORK_SRC_PATH     := ../../../PipeWork/src/
DUMMY_PLUG_WORK_PATH  := ./dummy_plug/
PIPEWORK_WORK_PATH    := ./pipework/
VHDL_SRC_PATH         := $(SRC_PATH)/test/vhdl
SCENARIO_PATH         := $(SRC_PATH)/test/scenarios/convolution_parameter_buffer

GHDL                  := ghdl
GHDLFLAGS             := --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

TEST_BENCH            := convolution_parameter_buffer_test_bench_1x1x1x1   \
                         convolution_parameter_buffer_test_bench_1x1x1x1_1x1x1x1 \
                         convolution_parameter_buffer_test_bench_1x1x1x4   \
                         convolution_parameter_buffer_test_bench_1x1x2x4   \
                         convolution_parameter_buffer_test_bench_3x3x1x1   \
                         convolution_parameter_buffer_test_bench_3x3x2x4   \
                         $(END_LIST)

DUMMY_PLUG            := $(DUMMY_PLUG_WORK_PATH)/dummy_plug-obj93.cf
PIPEWORK              := $(PIPEWORK_WORK_PATH)/pipework-obj93.cf
IMAGE_STREAM_MODELS   := image_stream_models.o image_stream_player.o image_stream_slave_player.o

.PHONY all: $(TEST_BENCH)

convolution_parameter_buffer_test_bench_1x1x1x1         : convolution_parameter_buffer_test_bench.o test_1x1x1x1.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

convolution_parameter_buffer_test_bench_1x1x1x1_1x1x1x1 : convolution_parameter_buffer_test_bench.o test_1x1x1x1_1x1x1x1.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

convolution_parameter_buffer_test_bench_1x1x1x4         : convolution_parameter_buffer_test_bench.o test_1x1x1x4.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

convolution_parameter_buffer_test_bench_1x1x2x4         : convolution_parameter_buffer_test_bench.o test_1x1x2x4.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

convolution_parameter_buffer_test_bench_3x3x1x1         : convolution_parameter_buffer_test_bench.o test_3x3x1x1.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

convolution_parameter_buffer_test_bench_3x3x2x4         : convolution_parameter_buffer_test_bench.o test_3x3x2x4.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

test_1x1x1x1.snr         : $(SCENARIO_PATH)/test_1x1x1x1.snr
	cp $< $@

test_1x1x1x1_1x1x1x1.snr : $(SCENARIO_PATH)/test_1x1x1x1_1x1x1x1.snr
	cp $< $@

test_1x1x1x4.snr         : $(SCENARIO_PATH)/test_1x1x1x4.snr
	cp $< $@

test_1x1x2x4.snr         : $(SCENARIO_PATH)/test_1x1x2x4.snr
	cp $< $@

test_3x3x1x1.snr         : $(SCENARIO_PATH)/test_3x3x1x1.snr
	cp $< $@

test_3x3x2x4.snr         : $(SCENARIO_PATH)/test_3x3x2x4.snr
	cp $< $@

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

clean:
	rm -f *.o *.cf $(TEST_BENCH)
	rm -rf ./dummy_plug/ ./pipework/

analyze: $(DUMMY_PLUG) $(PIPEWORK) $(IMAGE_STREAM_MODELS)

image_stream_models.o           : $(VHDL_SRC_PATH)/image_stream_models/image_stream_models.vhd $(DUMMY_PLUG) $(PIPEWORK)
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

image_stream_player.o           : $(VHDL_SRC_PATH)/image_stream_models/image_stream_player.vhd $(DUMMY_PLUG) $(PIPEWORK)
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

image_stream_slave_player.o     : $(VHDL_SRC_PATH)/image_stream_models/image_stream_slave_player.vhd $(DUMMY_PLUG) $(PIPEWORK)
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

convolution_parameter_buffer_test_bench.o : $(VHDL_SRC_PATH)/convolution_parameter_buffer/convolution_parameter_buffer_test_bench.vhd $(IMAGE_STREAM_MODELS)
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<
