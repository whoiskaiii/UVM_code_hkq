program automatic test;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // `include "../sv/my_transaction_da3.sv" // 已经写进 filelist.f 中
    // `include "../sv/my_test_type_da3.sv"
    // `include "../sv/my_test_inst_da3.sv"

    initial begin
        run_test(); // 调用 UVM 的全局任务 run_test() 来启动验证平台
        
        // run_test("my_test"); 
        // // 除了在 simv 选项中 +UVM_TESTNAME=my_test 外，还可对 UVM 的全局任务 run_test() 传参来启动验证平台
    end
endprogram
