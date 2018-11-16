GHDL=ghdl
GHDLFLAGS   =--mb-comments
GHDLRUNFLAGS=--mb-comments
WORK=work

DUMMY_PLUG_SRC_PATH    = ../../../Dummy_Plug/src/main/vhdl
PIPEWORK_SRC_MAIN_PATH = ../../../PipeWork/src
PIPEWORK_SRC_TEST_PATH = ../../../src/test/vhdl

TEST_BENCH = sdpram_test_bench_depth08_rd3_wd3_we0 \
             sdpram_test_bench_depth08_rd4_wd4_we0 \
             sdpram_test_bench_depth08_rd5_wd5_we0 \
             sdpram_test_bench_depth08_rd6_wd6_we3 \
             sdpram_test_bench_depth08_rd3_wd4_we0 \
             sdpram_test_bench_depth08_rd3_wd5_we0 \
             sdpram_test_bench_depth08_rd4_wd3_we0 \
             sdpram_test_bench_depth08_rd5_wd3_we0 \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)

sdpram_test_bench_all: sdpram_test_bench.o 
	$(GHDL) -e $(GHDLFLAGS) $@
	$(GHDL) -r $(GHDLRUNFLAGS) $@

sdpram_test_bench_depth08_rd3_wd3_we0 : sdpram_test_bench.o 
	$(GHDL) -e $(GHDLFLAGS) $@
	$(GHDL) -r $(GHDLRUNFLAGS) $@

sdpram_test_bench_depth08_rd4_wd4_we0 : sdpram_test_bench.o 
	$(GHDL) -e $(GHDLFLAGS) $@
	$(GHDL) -r $(GHDLRUNFLAGS) $@

sdpram_test_bench_depth08_rd5_wd5_we0 : sdpram_test_bench.o 
	$(GHDL) -e $(GHDLFLAGS) $@
	$(GHDL) -r $(GHDLRUNFLAGS) $@

sdpram_test_bench_depth08_rd6_wd6_we3 : sdpram_test_bench.o 
	$(GHDL) -e $(GHDLFLAGS) $@
	$(GHDL) -r $(GHDLRUNFLAGS) $@

sdpram_test_bench_depth08_rd3_wd4_we0 : sdpram_test_bench.o 
	$(GHDL) -e $(GHDLFLAGS) $@
	$(GHDL) -r $(GHDLRUNFLAGS) $@

sdpram_test_bench_depth08_rd3_wd5_we0 : sdpram_test_bench.o 
	$(GHDL) -e $(GHDLFLAGS) $@
	$(GHDL) -r $(GHDLRUNFLAGS) $@

sdpram_test_bench_depth08_rd4_wd3_we0 : sdpram_test_bench.o 
	$(GHDL) -e $(GHDLFLAGS) $@
	$(GHDL) -r $(GHDLRUNFLAGS) $@

sdpram_test_bench_depth08_rd5_wd3_we0 : sdpram_test_bench.o 
	$(GHDL) -e $(GHDLFLAGS) $@
	$(GHDL) -r $(GHDLRUNFLAGS) $@

sdpram_test_bench: sdpram_test_bench.o sdpram_model.o 
	$(GHDL) -e $(GHDLFLAGS) $@
	$(GHDL) -r $(GHDLRUNFLAGS) $@

sdpram_test_bench.o: mt19937ar.o components.o sdpram.o sdpram_model.o 
sdpram_test_bench.o: $(PIPEWORK_SRC_TEST_PATH)/sdpram/test_bench.vhd 
	$(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

mt19937ar.o:    $(DUMMY_PLUG_SRC_PATH)/core/mt19937ar.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=DUMMY_PLUG $<

components.o:   $(PIPEWORK_SRC_MAIN_PATH)/components/components.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

sdpram.o:       $(PIPEWORK_SRC_MAIN_PATH)/components/sdpram.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

sdpram_model.o: $(PIPEWORK_SRC_MAIN_PATH)/components/sdpram_model.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<
