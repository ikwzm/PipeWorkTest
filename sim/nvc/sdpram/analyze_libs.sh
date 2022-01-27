nvc -L ./ --work=DUMMY_PLUG -a ../../../Dummy_Plug/src/main/vhdl/core/mt19937ar.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/components.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/sdpram.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/sdpram_model.vhd
nvc -L ./ --work=WORK -a ../../../src/test/vhdl/sdpram/test_bench.vhd
