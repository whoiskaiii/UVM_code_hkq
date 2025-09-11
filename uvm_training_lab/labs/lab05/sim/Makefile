# tc = my_test_type_da3
# tc = my_test_inst_da3
tc = my_test

uvm_all: clean uvm_cmp uvm_sim

uvm_cmp:
	vcs \
	-sverilog -full64 -timescale=1ns/1ps \
	-debug_access+r+w+nomemcbk -debug_region+cell \
	+vpi \
	+incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm.sv $(UVM_HOME)/src/dpi/uvm_dpi.cc \
	-CFLAGS -DVCS \
	-f filelist.f -l uvm_cmp.log \
	# -debug_acc+all \
	# -ntb_opts_uvm \

uvm_sim:
	./simv \
	+UVM_TESTNAME=$(tc) \
	-l uvm_sim.log \
	-ucli \
	-i ./dump_wave.tcl \
	+fsdb+functions

verdi:
	verdi \
	-sv -2012 -uvm \
	+libext+.v \
	-f ./filelist.f \
	-ssf ./top.fsdb \
	-top top \
	&

clean:
	rm -rf \
	AN.DB DVEfiles csrc simv.* *simv inter.vpd ucli.key *.log novas* *fsdb verdiLog vc_hdrs.h
