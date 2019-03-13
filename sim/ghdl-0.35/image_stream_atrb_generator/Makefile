GHDL=ghdl
GHDLFLAGS=--mb-comments

DUMMY_PLUG_SRC_PATH    = ../../../Dummy_Plug/src/main/vhdl
PIPEWORK_SRC_MAIN_PATH = ../../../PipeWork/src
PIPEWORK_SRC_TEST_PATH = ../../../src/test/vhdl

TEST_BENCH = image_stream_atrb_generator_test_bench_1_1_32_0_0     \
             image_stream_atrb_generator_test_bench_3_1_32_0_0     \
             image_stream_atrb_generator_test_bench_3_1_32_1_1     \
             image_stream_atrb_generator_test_bench_4_4_32_0_0     \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf tmp.vhd $(TEST_BENCH) $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .vhd,$(TEST_BENCH))

image_stream_atrb_generator_test_bench_1_1_32_0_0  : image_stream_atrb_generator_test_bench.o
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_stream_atrb_generator_test_bench_3_1_32_0_0  : image_stream_atrb_generator_test_bench.o
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_stream_atrb_generator_test_bench_3_1_32_1_1  : image_stream_atrb_generator_test_bench.o
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_stream_atrb_generator_test_bench_4_4_32_0_0  : image_stream_atrb_generator_test_bench.o
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

image_stream_atrb_generator_test_bench.o     : image_types.o image_components.o image_stream_atrb_generator.o util.o
image_stream_atrb_generator_test_bench.o     : $(PIPEWORK_SRC_TEST_PATH)/image_stream_atrb_generator/image_stream_atrb_generator_test_bench.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

image_types.o                                : $(PIPEWORK_SRC_MAIN_PATH)/image/image_types.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK   $<

image_components.o                           : $(PIPEWORK_SRC_MAIN_PATH)/image/image_components.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK   $<

image_stream_atrb_generator.o                : $(PIPEWORK_SRC_MAIN_PATH)/image/image_stream_atrb_generator.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK   $<

util.o                    : $(DUMMY_PLUG_SRC_PATH)/core/util.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=DUMMY_PLUG $<
