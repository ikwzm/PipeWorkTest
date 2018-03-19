GHDL=ghdl
GHDLFLAGS=--mb-comments
WORK=PIPEWORK

PIPEWORK_SRC_MAIN_PATH = ../../../PipeWork/src
PIPEWORK_SRC_TEST_PATH = ../../../src/test/vhdl

TEST_BENCH = least_recently_used_selector_test_bench \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf $(TEST_BENCH) $(addsuffix .o,$(TEST_BENCH))

components.o        : $(PIPEWORK_SRC_MAIN_PATH)/components/components.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

least_recently_used_selector.o    : $(PIPEWORK_SRC_MAIN_PATH)/components/least_recently_used_selector.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK $<

least_recently_used_selector_test_bench.o: components.o least_recently_used_selector.o
least_recently_used_selector_test_bench.o: $(PIPEWORK_SRC_TEST_PATH)/least_recently_used_selector/least_recently_used_selector_test_bench.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=work $<


least_recently_used_selector_test_bench  : least_recently_used_selector_test_bench.o
	 $(GHDL) -e $(GHDLFLAGS) --work=work $@
	-$(GHDL) -r $(GHDLFLAGS) --work=work $@

