nvc -L ./ --work=DUMMY_PLUG -a ../../../Dummy_Plug/src/main/vhdl/core/util.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/chopper.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/components.vhd
nvc -L ./ --work=WORK -a ../../../src/test/vhdl/chopper/chopper_function_model.vhd
nvc -L ./ --work=WORK -a ../../../src/test/vhdl/chopper/chopper_test_bench.vhd
