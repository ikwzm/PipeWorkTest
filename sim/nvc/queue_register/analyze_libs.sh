nvc -L ./ --work=DUMMY_PLUG -a ../../../Dummy_Plug/src/main/vhdl/core/tinymt32.vhd
nvc -L ./ --work=DUMMY_PLUG -a ../../../Dummy_Plug/src/main/vhdl/core/util.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/components.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/queue_register.vhd
nvc -L ./ --work=WORK -a ../../../src/test/vhdl/queue_register/queue_register_test_bench.vhd
