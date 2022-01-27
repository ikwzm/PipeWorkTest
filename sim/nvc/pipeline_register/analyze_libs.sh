nvc -L ./ --work=DUMMY_PLUG -a ../../../Dummy_Plug/src/main/vhdl/core/util.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/components.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/pipeline_register_controller.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/pipeline_register.vhd
nvc -L ./ --work=WORK -a ../../../src/test/vhdl/pipeline_register/pipeline_register_test_bench.vhd
