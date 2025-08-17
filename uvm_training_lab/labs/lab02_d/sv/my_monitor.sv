class my_monitor extends uvm_monitor;
    // 将自定义的 monitor 类向 UVM 注册
    `uvm_component_utils(my_monitor)

    // 构造函数，name 为实例化时对象的默认名称, uvm_component 为实例化时指向父对象的句柄
    function new(string name = "my_monitor",uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task  reset_phase(uvm_phase phase);
        #50;
        `uvm_info("MON_RESET_PHASE", "Now monitor reset the DUT...", UVM_MEDIUM)
    endtask

    // 在 run_phase() 任务中完成 monitor 的功能
    virtual task run_phase(uvm_phase phase);
        forever begin
            `uvm_info("MON_RUN_PHASE", "Monitor is running", UVM_MEDIUM); // 打印等级为 UVM_MEDIUM
            #100;
        end
    endtask
endclass