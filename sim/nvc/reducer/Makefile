DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/nvc/lib/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools

PIPEWORK_PATH        = ../../../PipeWork
PIPEWORK_WORK_PATH   = $(PIPEWORK_PATH)/sim/nvc/PIPEWORK
PIPEWORK_SRC_PATH    = $(PIPEWORK_PATH)/src
PIPEWORK_TOOL_PATH   = $(PIPEWORK_PATH)/tools

SRC_MAIN_PATH        = ../../../PipeWork/src/components
SRC_TEST_PATH        = ../../../src/test/vhdl/reducer

NVC       = nvc
NVCFLAGS  = --map=Dummy_Plug:$(DUMMY_PLUG_WORK_PATH) --map=PIPEWORK:$(PIPEWORK_WORK_PATH)

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
	rm -rf *.o work tmp.vhd $(TEST_BENCH) $(addsuffix .o,$(TEST_BENCH)) $(addsuffix .vhd,$(TEST_BENCH))

reducer_test_model.o : $(SRC_TEST_PATH)/reducer_test_model.vhd
	$(NVC) $(NVCFLAGS) --work=work -a $<

$(addsuffix .o,$(TEST_BENCH)) : reducer_test_model.o
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

