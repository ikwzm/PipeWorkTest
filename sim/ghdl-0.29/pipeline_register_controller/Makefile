GHDL=ghdl
GHDLFLAGS=--mb-comments
WORK=PIPEWORK

DUMMY_PLUG_SRC_PATH    = ../../../Dummy_Plug/src/main/vhdl
PIPEWORK_SRC_MAIN_PATH = ../../../PipeWork/src
PIPEWORK_SRC_TEST_PATH = ../../../src/test/vhdl

TEST_BENCH = pipeline_register_controller_test_bench_all \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf tmp.vhd $(TEST_BENCH) $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .vhd,$(TEST_BENCH))

util.o              : $(DUMMY_PLUG_SRC_PATH)/core/util.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=DUMMY_PLUG $<

components.o        : $(PIPEWORK_SRC_MAIN_PATH)/components/components.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

pipeline_register_controller.o    : $(PIPEWORK_SRC_MAIN_PATH)/components/pipeline_register_controller.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

delay_adjuster.o    : $(PIPEWORK_SRC_MAIN_PATH)/components/delay_adjuster.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

pipeline_register_controller_test_bench.o: components.o pipeline_register_controller.o util.o
pipeline_register_controller_test_bench.o: $(PIPEWORK_SRC_TEST_PATH)/pipeline_register_controller/pipeline_register_controller_test_bench.vhd 
	$(GHDL) -a $(GHDLFLAGS) --work=work $<


pipeline_register_controller_test_bench_all   : pipeline_register_controller_test_bench.o
	 $(GHDL) -e $(GHDLFLAGS) --work=work $@
	-$(GHDL) -r $(GHDLFLAGS) --work=work $@

pipeline_register_controller_test_bench_0     : pipeline_register_controller_test_bench.o
	 $(GHDL) -e $(GHDLFLAGS) --work=work $@
	-$(GHDL) -r $(GHDLFLAGS) --work=work $@

pipeline_register_controller_test_bench_1     : pipeline_register_controller_test_bench.o
	 $(GHDL) -e $(GHDLFLAGS) --work=work $@
	-$(GHDL) -r $(GHDLFLAGS) --work=work $@

pipeline_register_controller_test_bench_2     : pipeline_register_controller_test_bench.o
	 $(GHDL) -e $(GHDLFLAGS) --work=work $@
	-$(GHDL) -r $(GHDLFLAGS) --work=work $@
