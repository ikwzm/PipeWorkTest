GHDL=ghdl
GHDLFLAGS=--mb-comments -P../../../PipeWork/sim/ghdl

SRC_MAIN_PATH = ../../../PipeWork/src/components
SRC_TEST_PATH = ../../../src/test/vhdl/reducer

TEST_BENCH = reducer_test_bench_dwc_w08_i1_o1_q0_j0 \
             reducer_test_bench_dwc_w08_i1_o2_q0_j0 \
             reducer_test_bench_dwc_w08_i1_o3_q0_j0 \
             reducer_test_bench_dwc_w08_i1_o4_q0_j0 \
             reducer_test_bench_dwc_w08_i2_o1_q0_j0 \
             reducer_test_bench_dwc_w08_i2_o2_q0_j0 \
             reducer_test_bench_dwc_w08_i2_o3_q0_j0 \
             reducer_test_bench_dwc_w08_i2_o4_q0_j0 \
             reducer_test_bench_dwc_w08_i3_o1_q0_j0 \
             reducer_test_bench_dwc_w08_i3_o2_q0_j0 \
             reducer_test_bench_dwc_w08_i3_o3_q0_j0 \
             reducer_test_bench_dwc_w08_i3_o4_q0_j0 \
             reducer_test_bench_dwc_w08_i4_o1_q0_j0 \
             reducer_test_bench_dwc_w08_i4_o2_q0_j0 \
             reducer_test_bench_dwc_w08_i4_o3_q0_j0 \
             reducer_test_bench_dwc_w08_i4_o4_q0_j0 \
             reducer_test_bench_dwc_w08_i1_o1_q1_j0 \
             reducer_test_bench_dwc_w08_i1_o2_q2_j0 \
             reducer_test_bench_dwc_w08_i1_o3_q3_j0 \
             reducer_test_bench_dwc_w08_i1_o4_q4_j0 \
             reducer_test_bench_dwc_w08_i2_o1_q2_j0 \
             reducer_test_bench_dwc_w08_i2_o2_q3_j0 \
             reducer_test_bench_dwc_w08_i2_o3_q4_j0 \
             reducer_test_bench_dwc_w08_i2_o4_q5_j0 \
             reducer_test_bench_dwc_w08_i4_o1_q0_j1 \
             reducer_test_bench_dwc_w08_i4_o2_q0_j1 \
             reducer_test_bench_dwc_w08_i4_o3_q0_j1 \
             reducer_test_bench_dwc_w08_i4_o4_q0_j1 \
             reducer_test_bench_dwc_w32_i1_o1_q0_j0 \
             reducer_test_bench_dwc_w32_i1_o2_q0_j0 \
             reducer_test_bench_dwc_w32_i2_o1_q0_j0 \
             reducer_test_bench_dwc_w32_i2_o2_q0_j0 \
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
	-$(GHDL) -r $(GHDLFLAGS) --work=work $@


reducer_test_bench_dwc_w08_i1_o1_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/1/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i1_o2_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/2/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i1_o3_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/3/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i1_o4_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/4/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i2_o1_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/2/g" -e "s/%O/1/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i2_o2_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/2/g" -e "s/%O/2/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i2_o3_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/2/g" -e "s/%O/3/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i2_o4_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/2/g" -e "s/%O/4/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i3_o1_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/3/g" -e "s/%O/1/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i3_o2_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/3/g" -e "s/%O/2/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i3_o3_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/3/g" -e "s/%O/3/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i3_o4_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/3/g" -e "s/%O/4/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o1_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/1/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o2_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/2/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o3_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/3/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o4_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/4/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i1_o1_q1_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/1/g" -e "s/%Q/1/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i1_o2_q2_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/2/g" -e "s/%Q/2/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i1_o3_q3_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/3/g" -e "s/%Q/3/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i1_o4_q4_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/4/g" -e "s/%Q/4/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i2_o1_q2_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/2/g" -e "s/%O/1/g" -e "s/%Q/2/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i2_o2_q3_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/2/g" -e "s/%O/2/g" -e "s/%Q/3/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i2_o3_q4_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/2/g" -e "s/%O/3/g" -e "s/%Q/4/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i2_o4_q5_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/2/g" -e "s/%O/4/g" -e "s/%Q/5/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o1_q0_j1.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/1/g" -e "s/%Q/0/g" -e "s/%J/1/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o2_q0_j1.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/2/g" -e "s/%Q/0/g" -e "s/%J/1/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o3_q0_j1.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/3/g" -e "s/%Q/0/g" -e "s/%J/1/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o4_q0_j1.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/4/g" -e "s/%Q/0/g" -e "s/%J/1/g" < $< > $@

reducer_test_bench_dwc_w32_i1_o1_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/32/g" -e "s/%I/1/g" -e "s/%O/1/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w32_i1_o2_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/32/g" -e "s/%I/1/g" -e "s/%O/2/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w32_i2_o1_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/32/g" -e "s/%I/2/g" -e "s/%O/1/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

reducer_test_bench_dwc_w32_i2_o2_q0_j0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/32/g" -e "s/%I/2/g" -e "s/%O/2/g" -e "s/%Q/0/g" -e "s/%J/0/g" < $< > $@

