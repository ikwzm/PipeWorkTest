nvc -L ./ --work=DUMMY_PLUG -a ../../../Dummy_Plug/src/main/vhdl/core/util.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/components.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/unrolled_loop_counter.vhd
nvc -L ./ --work=WORK -a ../../../src/test/vhdl/unrolled_loop_counter/unrolled_loop_counter_test_bench.vhd
