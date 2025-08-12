program automatic test;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    initial begin
        run_test(); // 调用 UVM 的全局任务 run_test() 来启动验证平台
    end
endprogram