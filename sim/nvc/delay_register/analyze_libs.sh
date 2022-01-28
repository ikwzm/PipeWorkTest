nvc -L ./ --work=DUMMY_PLUG -a ../../../Dummy_Plug/src/main/vhdl/core/util.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/components.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/delay_adjuster.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/delay_register.vhd
nvc -L ./ --work=WORK -a ../../../src/test/vhdl/delay_register/delay_register_test_bench.vhd
