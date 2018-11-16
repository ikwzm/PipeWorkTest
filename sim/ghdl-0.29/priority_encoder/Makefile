GHDL=ghdl
GHDLFLAGS=--mb-comments

DUMMY_PLUG_SRC_PATH    = ../../../Dummy_Plug/src/main/vhdl
PIPEWORK_SRC_MAIN_PATH = ../../../PipeWork/src
PIPEWORK_SRC_TEST_PATH = ../../../src/test/vhdl

test_bench_all: test_bench.o 
	 $(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	-$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

test_bench    : test_bench.o 
	 $(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	-$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

test_bench.o  : $(PIPEWORK_SRC_TEST_PATH)/priority_encoder/test_bench.vhd priority_encoder_procedures.o util.o mt19937ar.o
	 $(GHDL) -a $(GHDLFLAGS) --work=WORK       $<

priority_encoder_procedures.o : $(PIPEWORK_SRC_MAIN_PATH)/components/priority_encoder_procedures.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PipeWork   $<

util.o        : $(DUMMY_PLUG_SRC_PATH)/core/util.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=DUMMY_PLUG $<

mt19937ar.o   : $(DUMMY_PLUG_SRC_PATH)/core/mt19937ar.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=DUMMY_PLUG $<

