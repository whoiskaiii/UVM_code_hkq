program automatic test;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    initial begin
        run_test(); // 调用 UVM 的全局任务 run_test() 来启动验证平台
        
        // run_test("my_test"); 
        // // 除了在 simv 选项中 +UVM_TESTNAME=my_test 外，还可对 UVM 的全局任务 run_test() 传参来启动验证平台
    end
endprogram
