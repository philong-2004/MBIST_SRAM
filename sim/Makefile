#========================
# Define variables
#========================
TESTNAME ?= tb
TB_NAME  ?= mbist_top_tb.v
TB_MODULE ?= mbist_top_tb
RADIX    ?= hexadecimal
SEED     ?= 1
QUESTA_HOME ?= D:/QuetaSim#đổi lại đường dẫn thư viện để chạy
UVM_HOME ?= $(QUESTA_HOME)/verilog_src/uvm-1.1d/src#đổi lại đường dẫn thư viện để chạy
UVM_LIB ?= uvm_lib
#========================
# Default target
#========================

all: build run

#========================
# Build
#========================
build:
	@echo "UVM_HOME: $(UVM_HOME)"
	
	
	vlib $(UVM_LIB)
	vmap $(UVM_LIB) $(UVM_LIB)
	vlog -sv +incdir+"$(UVM_HOME)" -work $(UVM_LIB) "$(UVM_HOME)/uvm_pkg.sv"
	vlib work
	vmap work work
	vlog -sv +incdir+$(UVM_HOME) +incdir+../tb +incdir+../rtl -f compile.f -l compile.log


#========================
# Run simulation
#========================
run:
	
	vsim -L $(UVM_LIB) -sv_seed $(SEED) -debugDB -l $(TESTNAME).log -voptargs=+acc -assertdebug -c work.$(TB_MODULE) -do "log -r /*;run -all;" +$(TESTNAME)

#========================
# Open waveform
#========================
wave:
	@echo "----------------------------------------"
	@echo "  Opening waveform viewer..."
	@echo "----------------------------------------"
	vsim -view vsim.wlf -do "add wave -r /*; radix -hexadecimal"

#========================
# Run simulation with GUI
#========================
gui:
	vsim -L $(UVM_LIB) -sv_seed $(SEED) -debugDB -l $(TESTNAME)_gui.log \-voptargs=+acc -assertdebug work.$(TB_MODULE) \-do "log -r /*; add wave -r /*; run -all;"
#-del /Q /F *.ini >nul 2>&1
clean:
	@echo "----------------------------------------"
	@echo "  Cleaning simulation files..."
	@echo "----------------------------------------"
	rm -f *.ini *.log *.wlf vsim.dbg transcript
	rm -rf work uvm_lib
	@echo ">> Clean complete."

#========================
# Help
#========================
help:
	@echo""
	@echo "************************************"
	@echo "** make build : compile the design and testbench"
	@echo "** make run   : run simulation"
	@echo "** make all   : compile and run simulation"
	@echo "** make wave  : open waveform"
	@echo "** make clean : clean all compiled data"
	@echo "************************************"