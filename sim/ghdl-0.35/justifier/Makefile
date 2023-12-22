DUMMY_PLUG_WORK_PATH = ../../../Dummy_Plug/sim/ghdl-0.35/dummy_plug
PIPEWORK_WORK_PATH   = ../../../PipeWork/sim/ghdl-0.35
SRC_PATH             = ../../../src

GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

TEST_BENCH     = justifier_test_bench_64_0_0 \
                 justifier_test_bench_64_0_1 \
                 justifier_test_bench_64_0_2 \
                 justifier_test_bench_64_0_3 \
                 justifier_test_bench_64_4_0 \
                 justifier_test_bench_64_4_1 \
                 justifier_test_bench_64_4_2 \
                 justifier_test_bench_64_4_3 \
                 $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH)

justifier_test_bench_64_0_0  : justifier_test_bench.o justifier_test_bench_64_0.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

justifier_test_bench_64_0_1  : justifier_test_bench.o justifier_test_bench_64_0.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

justifier_test_bench_64_0_2  : justifier_test_bench.o justifier_test_bench_64_0.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

justifier_test_bench_64_0_3  : justifier_test_bench.o justifier_test_bench_64_0.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

justifier_test_bench_64_4_0  : justifier_test_bench.o justifier_test_bench_64_4.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

justifier_test_bench_64_4_1  : justifier_test_bench.o justifier_test_bench_64_4.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

justifier_test_bench_64_4_2  : justifier_test_bench.o justifier_test_bench_64_4.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

justifier_test_bench_64_4_3  : justifier_test_bench.o justifier_test_bench_64_4.snr
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $@
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $@

justifier_test_bench.o : $(SRC_PATH)/test/vhdl/justifier/justifier_test_bench.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=WORK $<

justifier_test_bench_64_0.snr : $(SRC_PATH)/test/scenarios/justifier/justifier_test_bench_64_0.snr
	cp $< $@

justifier_test_bench_64_4.snr : $(SRC_PATH)/test/scenarios/justifier/justifier_test_bench_64_4.snr
	cp $< $@
