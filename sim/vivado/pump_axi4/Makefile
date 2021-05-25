all: add_sources.tcl \
     add_sim.tcl \
     pump_axi4_to_axi4_test_bench_32_32.snr \
     pump_axi4_to_axi4_test_bench_32_64.snr \
     pump_axi4_to_axi4_test_bench_64_32.snr \
     pump_axi4_to_axi4_test_bench_32_32_test_7.snr \
     pump_axi4_to_axi4_test_bench_32_32_test_8.snr 

add_sources.tcl : add_sources.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config add_sources.yml > add_sources.tcl


add_sim.tcl     : add_sim.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config add_sim.yml     > add_sim.tcl

SRC_PATH = ../../../src

pump_axi4_to_axi4_test_bench_32_32.snr      : $(SRC_PATH)/test/scenarios/pump_axi4/make_scenario.rb
	$(SRC_PATH)/test/scenarios/pump_axi4/make_scenario.rb \
             --name    PUMP_AXI4_TO_AXI4_TEST_32_32  \
             --i_width 32  \
             --o_width 32  \
             --output  pump_axi4_to_axi4_test_bench_32_32.snr

pump_axi4_to_axi4_test_bench_32_64.snr      : $(SRC_PATH)/test/scenarios/pump_axi4/make_scenario.rb
	$(SRC_PATH)/test/scenarios/pump_axi4/make_scenario.rb \
             --name    PUMP_AXI4_TO_AXI4_TEST_32_64  \
             --i_width 32  \
             --o_width 64  \
             --output  pump_axi4_to_axi4_test_bench_32_64.snr

pump_axi4_to_axi4_test_bench_64_32.snr      : $(SRC_PATH)/test/scenarios/pump_axi4/make_scenario.rb
	$(SRC_PATH)/test/scenarios/pump_axi4/make_scenario.rb \
             --name    PUMP_AXI4_TO_AXI4_TEST_64_32  \
             --i_width 64  \
             --o_width 32  \
             --output  pump_axi4_to_axi4_test_bench_64_32.snr

pump_axi4_to_axi4_test_bench_32_32_test_7.snr : $(SRC_PATH)/test/scenarios/pump_axi4/make_scenario.rb
	$(SRC_PATH)/test/scenarios/pump_axi4/make_scenario.rb \
             --name    PUMP_AXI4_TO_AXI4_TEST_32_32  \
             --i_width 32  \
             --o_width 32  \
             --test_item 7 \
             --timeout 10000000 \
             --output  pump_axi4_to_axi4_test_bench_32_32_test_7.snr

pump_axi4_to_axi4_test_bench_32_32_test_8.snr : $(SRC_PATH)/test/scenarios/pump_axi4/make_scenario_feature.rb
	$(SRC_PATH)/test/scenarios/pump_axi4/make_scenario_feature.rb \
             --name    PUMP_AXI4_TO_AXI4_TEST_32_32  \
             --i_width 32  \
             --o_width 32  \
             --test_item 8 \
             --timeout 10000000 \
             --output  pump_axi4_to_axi4_test_bench_32_32_test_8.snr

