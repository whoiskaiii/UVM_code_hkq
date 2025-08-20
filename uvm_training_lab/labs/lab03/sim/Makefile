# tc = my_test_type_da3
tc = my_test_inst_da3

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
	+UVM_TESTNAME=$(tc) \
	-l uvm_sim.log \

clean:
	rm -rf \
	AN.DB DVEfiles csrc simv.* *simv inter.vpd ucli.key *.log novas* *fsdb verdiLog vc_hdrs.h
