GHDL=ghdl
GHDLFLAGS=--mb-comments -P../../../PipeWork/sim/ghdl-0.35 -P../../../Dummy_Plug/sim/ghdl-0.35/dummy_plug

SRC_MAIN_PATH = ../../../PipeWork/src/components
SRC_TEST_PATH = ../../../src/test/vhdl/reducer

TEST_BENCH = reducer_test_bench_dwc_w08_i1_o1_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i1_o1_q0_j0_k0_v1 \
             reducer_test_bench_dwc_w08_i1_o2_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i1_o3_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i1_o4_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i2_o1_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i2_o2_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i2_o3_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i2_o4_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i3_o1_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i3_o2_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i3_o3_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i3_o4_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i4_o1_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i4_o2_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i4_o3_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i4_o4_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i4_o4_q0_j0_k0_v4 \
             reducer_test_bench_dwc_w08_i1_o1_q1_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i1_o2_q2_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i1_o3_q3_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i1_o4_q4_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i2_o1_q2_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i2_o2_q3_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i2_o3_q4_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i2_o4_q5_j0_k0_v0 \
             reducer_test_bench_dwc_w08_i4_o1_q0_j1_k0_v0 \
             reducer_test_bench_dwc_w08_i4_o2_q0_j1_k0_v0 \
             reducer_test_bench_dwc_w08_i4_o3_q0_j1_k0_v0 \
             reducer_test_bench_dwc_w08_i4_o4_q0_j1_k0_v0 \
             reducer_test_bench_dwc_w32_i1_o1_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w32_i1_o2_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w32_i2_o1_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w32_i2_o2_q0_j0_k0_v0 \
             reducer_test_bench_dwc_w32_i1_o1_q0_j0_k1_v0 \
             reducer_test_bench_dwc_w32_i1_o2_q0_j0_k1_v0 \
             reducer_test_bench_dwc_w32_i2_o1_q0_j0_k1_v0 \
             reducer_test_bench_dwc_w32_i2_o2_q0_j0_k1_v0 \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -f *.o *.cf tmp.vhd $(TEST_BENCH) $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .vhd,$(TEST_BENCH))

reducer_test_model.o : $(SRC_TEST_PATH)/reducer_test_model.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=work $<

$(addsuffix .o,$(TEST_BENCH)) : reducer_test_model.o
%.o : %.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=work $<

$(TEST_BENCH) : $(addsuffix .o,$(TEST_BENCH))
	$(GHDL) -e $(GHDLFLAGS) --work=work $@
	$(GHDL) -r $(GHDLFLAGS) --work=work $@

define TEST_BENCH_VHDL
$(addsuffix .vhd,$(1))
endef

TEST_BENCH_REPLACE_PATTERN = 's/^reducer_test_bench_dwc_w([0-9]+)_i([0-9]+)_o([0-9]+)_q([0-9]+)_j([0-9]+)_k([0-9]+)_v([0-9]+).vhd/-e s\/%W\/\1\/g -e s\/%I\/\2\/g -e s\/%O\/\3\/g -e s\/%Q\/\4\/g -e s\/%J\/\5\/g -e s\/%K\/\6\/g -e s\/%V\/\7\/g\n/'

define MAKE_TEST_BENCH_VHDL
$(1) : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	$(shell sed -E $(shell echo $(1) | sed -E $(TEST_BENCH_REPLACE_PATTERN)) < $(SRC_TEST_PATH)/reducer_test_bench_template.vhd > $(1))
endef

$(foreach TB, $(TEST_BENCH), $(eval $(call MAKE_TEST_BENCH_VHDL, $(call TEST_BENCH_VHDL, $(TB)))))
