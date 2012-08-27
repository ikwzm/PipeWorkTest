GHDL=ghdl
GHDLFLAGS=--mb-comments
WORK=PIPEWORK

DUMMY_PLUG_SRC_PATH    = ../../../Dummy_Plug/src/main/vhdl
PIPEWORK_SRC_MAIN_PATH = ../../../src/main/vhdl
PIPEWORK_SRC_TEST_PATH = ../../../src/test/vhdl

TEST_BENCH = delay_register_test_bench_all \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf tmp.vhd $(TEST_BENCH) $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .vhd,$(TEST_BENCH))

util.o              : $(DUMMY_PLUG_SRC_PATH)/core/util.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=DUMMY_PLUG $<

components.o        : $(PIPEWORK_SRC_MAIN_PATH)/components/components.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

delay_register.o    : $(PIPEWORK_SRC_MAIN_PATH)/components/delay_register.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

delay_adjuster.o    : $(PIPEWORK_SRC_MAIN_PATH)/components/delay_adjuster.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

delay_register_test_bench.o: components.o delay_adjuster.o delay_register.o util.o
delay_register_test_bench.o: $(PIPEWORK_SRC_TEST_PATH)/delay_register/delay_register_test_bench.vhd 
	$(GHDL) -a $(GHDLFLAGS) --work=work $<


delay_register_test_bench_all   : delay_register_test_bench.o
	 $(GHDL) -e $(GHDLFLAGS) --work=work $@
	-$(GHDL) -r $(GHDLFLAGS) --work=work $@

delay_register_test_bench_8_3_3 : delay_register_test_bench.o
	 $(GHDL) -e $(GHDLFLAGS) --work=work $@
	-$(GHDL) -r $(GHDLFLAGS) --work=work $@
