TB	=	mc_top_tb

all: clean elab sim

help:
	@echo "1.make elab to elaborate/compile design"
	@echo "2.make sim to simulate design"
	@echo "3.make verdi to view the waveform"
	@echo "4.make clean to clean up the current folder"

elab:
	vcs \
	-full64 \
	-debug_acc+all \
	-sverilog \
	+v2k \
	-l comp.log \
	-y /home/synopsys/syn/O-2018.06-SP1/dw/dw06/src_ver \
	-y /home/synopsys/syn/O-2018.06-SP1/dw/dw03/src_ver \
	+libext+.v \
	-f ./filelist.f \
	-timescale=1ns/1ps \
	+incdir+../sim

sim:
	./simv \
	-ucli \
	-i ./wave_gen.tcl \
	-l run.log \
	+fsdb+functions 

verdi:
	verdi \
	-y /home/synopsys/syn/O-2018.06-SP1/dw/dw06/src_ver \
	-y /home/synopsys/syn/O-2018.06-SP1/dw/dw03/src_ver \
	+libext+.v \
	-f ./filelist.f \
	-ssf ./$(TB).fsdb \
	-top $(TB) \
	&

clean:
	rm -rf \
	AN.DB DVEfiles csrc simv.* *simv inter.vpd ucli.key *.log novas* *fsdb verdiLog

uvm_all: clean uvm_cmp uvm_sim

uvm_cmp:
	vcs \
	-sverilog -full64 -timescale=1ns/1ps \
	+acc +vpi \
	+incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm.sv $(UVM_HOME)/src/dpi/uvm_dpi.cc \
	-CFLAGS -DVCS \
	-f filelist.f -l uvm_cmp.log \

uvm_sim:
	./simv \
	+UVM_TESTNAME=my_test \
	-l uvm_sim.log \
