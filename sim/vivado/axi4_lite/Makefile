all: add_sim.tcl \
     axi4_lite_test_bench_32_32.snr \
     axi4_lite_test_bench_32_64.snr \
     axi4_lite_test_bench_64_32.snr 

clean:
	rm add_sim.tcl axi4_lite_test_bench_32_32.snr axi4_lite_test_bench_32_64.snr axi4_lite_test_bench_64_32.snr

add_sim.tcl     : add_sim.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config add_sim.yml     > add_sim.tcl

SCENARIO_PATH  = ../../../src/test/scenarios/axi4_lite
COPY       = cp

axi4_lite_test_bench_32_32.snr: $(SCENARIO_PATH)/axi4_lite_test_bench_32_32.snr
	$(COPY) $< .

axi4_lite_test_bench_32_64.snr: $(SCENARIO_PATH)/axi4_lite_test_bench_32_64.snr
	$(COPY) $< .

axi4_lite_test_bench_64_32.snr: $(SCENARIO_PATH)/axi4_lite_test_bench_64_32.snr
	$(COPY) $< .


