PIPEWORK_PATH = ../../../PipeWork
SRC_TEST_PATH = ../../../src/test/vhdl/reducer

NVC       = nvc
NVCFLAGS  = -L ./ 

TEST_BENCH = reducer_test_bench_dwc_w08_i1_o1_q0_j0_v0 \
             reducer_test_bench_dwc_w08_i1_o1_q0_j0_v1 \
             reducer_test_bench_dwc_w08_i1_o2_q0_j0_v0 \
             reducer_test_bench_dwc_w08_i1_o3_q0_j0_v0 \
             reducer_test_bench_dwc_w08_i1_o4_q0_j0_v0 \
             reducer_test_bench_dwc_w08_i2_o1_q0_j0_v0 \
             reducer_test_bench_dwc_w08_i2_o2_q0_j0_v0 \
             reducer_test_bench_dwc_w08_i2_o3_q0_j0_v0 \
             reducer_test_bench_dwc_w08_i2_o4_q0_j0_v0 \
             reducer_test_bench_dwc_w08_i3_o1_q0_j0_v0 \
             reducer_test_bench_dwc_w08_i3_o2_q0_j0_v0 \
             reducer_test_bench_dwc_w08_i3_o3_q0_j0_v0 \
             reducer_test_bench_dwc_w08_i3_o4_q0_j0_v0 \
             reducer_test_bench_dwc_w08_i4_o1_q0_j0_v0 \
             reducer_test_bench_dwc_w08_i4_o2_q0_j0_v0 \
             reducer_test_bench_dwc_w08_i4_o3_q0_j0_v0 \
             reducer_test_bench_dwc_w08_i4_o4_q0_j0_v0 \
             reducer_test_bench_dwc_w08_i4_o4_q0_j0_v4 \
             reducer_test_bench_dwc_w08_i1_o1_q1_j0_v0 \
             reducer_test_bench_dwc_w08_i1_o2_q2_j0_v0 \
             reducer_test_bench_dwc_w08_i1_o3_q3_j0_v0 \
             reducer_test_bench_dwc_w08_i1_o4_q4_j0_v0 \
             reducer_test_bench_dwc_w08_i2_o1_q2_j0_v0 \
             reducer_test_bench_dwc_w08_i2_o2_q3_j0_v0 \
             reducer_test_bench_dwc_w08_i2_o3_q4_j0_v0 \
             reducer_test_bench_dwc_w08_i2_o4_q5_j0_v0 \
             reducer_test_bench_dwc_w08_i4_o1_q0_j1_v0 \
             reducer_test_bench_dwc_w08_i4_o2_q0_j1_v0 \
             reducer_test_bench_dwc_w08_i4_o3_q0_j1_v0 \
             reducer_test_bench_dwc_w08_i4_o4_q0_j1_v0 \
             reducer_test_bench_dwc_w32_i1_o1_q0_j0_v0 \
             reducer_test_bench_dwc_w32_i1_o2_q0_j0_v0 \
             reducer_test_bench_dwc_w32_i2_o1_q0_j0_v0 \
             reducer_test_bench_dwc_w32_i2_o2_q0_j0_v0 \
             $(END_LIST)

all: $(TEST_BENCH)

clean:
	rm -rf *.o work DUMMY_PLUG PIPEWORK tmp.vhd analyze_libs.sh $(TEST_BENCH) $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .vhd,$(TEST_BENCH))

analyze_libs.sh: libs.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config libs.yml > analyze_libs.sh

analyze_libs : analyze_libs.sh
	sh analyze_libs.sh

$(addsuffix .o,$(TEST_BENCH)) : analyze_libs
%.o : %.vhd
	$(NVC) $(NVCFLAGS) --work=work -a $<

$(TEST_BENCH) : $(addsuffix .o,$(TEST_BENCH))
	$(NVC) $(NVCFLAGS) --work=work -e $@
	$(NVC) $(NVCFLAGS) --work=work -r $@


reducer_test_bench_dwc_w08_i1_o1_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/1/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i1_o1_q0_j0_v1.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/1/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/1/g" < $< > $@

reducer_test_bench_dwc_w08_i1_o2_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/2/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i1_o3_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/3/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i1_o4_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/4/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i2_o1_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/2/g" -e "s/%O/1/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i2_o2_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/2/g" -e "s/%O/2/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i2_o3_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/2/g" -e "s/%O/3/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i2_o4_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/2/g" -e "s/%O/4/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i3_o1_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/3/g" -e "s/%O/1/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i3_o2_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/3/g" -e "s/%O/2/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i3_o3_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/3/g" -e "s/%O/3/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i3_o4_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/3/g" -e "s/%O/4/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o1_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/1/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o2_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/2/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o3_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/3/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o4_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/4/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o4_q0_j0_v4.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/4/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/4/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o4_q0_j4_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/4/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/4/g" < $< > $@

reducer_test_bench_dwc_w08_i1_o1_q1_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/1/g" -e "s/%Q/1/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i1_o2_q2_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/2/g" -e "s/%Q/2/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i1_o3_q3_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/3/g" -e "s/%Q/3/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i1_o4_q4_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/1/g" -e "s/%O/4/g" -e "s/%Q/4/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i2_o1_q2_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/2/g" -e "s/%O/1/g" -e "s/%Q/2/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i2_o2_q3_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/2/g" -e "s/%O/2/g" -e "s/%Q/3/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i2_o3_q4_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/2/g" -e "s/%O/3/g" -e "s/%Q/4/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i2_o4_q5_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/2/g" -e "s/%O/4/g" -e "s/%Q/5/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o1_q0_j1_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/1/g" -e "s/%Q/0/g" -e "s/%J/1/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o2_q0_j1_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/2/g" -e "s/%Q/0/g" -e "s/%J/1/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o3_q0_j1_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/3/g" -e "s/%Q/0/g" -e "s/%J/1/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w08_i4_o4_q0_j1_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/08/g" -e "s/%I/4/g" -e "s/%O/4/g" -e "s/%Q/0/g" -e "s/%J/1/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w32_i1_o1_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/32/g" -e "s/%I/1/g" -e "s/%O/1/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w32_i1_o2_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/32/g" -e "s/%I/1/g" -e "s/%O/2/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w32_i2_o1_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/32/g" -e "s/%I/2/g" -e "s/%O/1/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

reducer_test_bench_dwc_w32_i2_o2_q0_j0_v0.vhd : $(SRC_TEST_PATH)/reducer_test_bench_template.vhd
	sed -e "s/%W/32/g" -e "s/%I/2/g" -e "s/%O/2/g" -e "s/%Q/0/g" -e "s/%J/0/g" -e "s/%V/0/g" < $< > $@

