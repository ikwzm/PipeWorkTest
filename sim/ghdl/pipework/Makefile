GHDL=ghdl
GHDLFLAGS=--mb-comments
WORK=PIPEWORK

SRC_MAIN_PATH  = ../../../src/main/vhdl/components

COMPONENTS = chopper                            \
             delay_adjuster                     \
             delay_register                     \
             queue_arbiter                      \
             queue_arbiter_integer_arch         \
             queue_register                     \
             reducer                            \
             sdpram                             \
             sdpram_model                       \
             syncronizer                        \
             syncronizer_input_pending_register \
             pump_count_up_register             \
             pump_count_down_register           \
             $(END_LINE)

OBJS      = $(addsuffix .o,$(COMPONENTS))

all  : $(OBJS)

clean:
	rm -f *.o *.cf 

$(OBJS) : components.o

components.o                         : $(SRC_MAIN_PATH)/components.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

chopper.o                            : $(SRC_MAIN_PATH)/chopper.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

delay_register.o                     : $(SRC_MAIN_PATH)/delay_register.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

delay_adjuster.o                     : $(SRC_MAIN_PATH)/delay_adjuster.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

queue_arbiter.o                      : $(SRC_MAIN_PATH)/queue_arbiter.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

queue_arbiter_integer_arch.o         : $(SRC_MAIN_PATH)/queue_arbiter_integer_arch.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

queue_register.o                     : $(SRC_MAIN_PATH)/queue_register.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

reducer.o                            : $(SRC_MAIN_PATH)/reducer.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

sdpram.o                             : $(SRC_MAIN_PATH)/sdpram.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

sdpram_model.o                       : $(SRC_MAIN_PATH)/sdpram_model.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

syncronizer.o                        : $(SRC_MAIN_PATH)/syncronizer.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

syncronizer_input_pending_register.o : $(SRC_MAIN_PATH)/syncronizer_input_pending_register.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

pump_count_up_register.o             : $(SRC_MAIN_PATH)/pump_count_up_register.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

pump_count_down_register.o           : $(SRC_MAIN_PATH)/pump_count_down_register.vhd
	 $(GHDL) -a $(GHDLFLAGS) --work=$(WORK) $<

