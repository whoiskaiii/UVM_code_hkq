class my_monitor extends uvm_monitor;
    // 将自定义的 monitor 类向 UVM 注册
    `uvm_component_utils(my_monitor)

    virtual dut_interface m_vif;

    // 构造函数，name 为实例化时对象的默认名称, uvm_component 为实例化时指向父对象的句柄
    function new(string name = "my_monitor",uvm_component parent);
        super.new(name, parent);
    endfunction

    // 在 build_phase() 中使用 uvm_config_db::get 获取 virtual interface 的配置
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual dut_interface)::get(this, "", "vif", m_vif)) begin
            `uvm_fatal("CONFIG_FATAL", "Monitor can not get the interface !!!")
        end
    endfunction

    // 在 run_phase() 任务中完成 monitor 的功能
    virtual task run_phase(uvm_phase phase);
        my_transaction tr;
        forever begin
            `uvm_info("MON_RUN_PHASE", "Monitor is running", UVM_MEDIUM); // 打印等级为 UVM_MEDIUM
            #100;
        end
    endtask
endclass