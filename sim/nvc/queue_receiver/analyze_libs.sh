nvc -L ./ --work=DUMMY_PLUG -a ../../../Dummy_Plug/src/main/vhdl/core/tinymt32.vhd
nvc -L ./ --work=DUMMY_PLUG -a ../../../Dummy_Plug/src/main/vhdl/core/util.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/components.vhd
nvc -L ./ --work=PIPEWORK -a ../../../PipeWork/src/components/queue_receiver.vhd
nvc -L ./ --work=WORK -a ../../../src/test/vhdl/queue_receiver/queue_receiver_test_bench.vhd
