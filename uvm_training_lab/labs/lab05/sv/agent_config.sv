class agent_config extends uvm_object; // 数据建模一般扩展于 uvm_object 基类
    uvm_active_passive_enum is_active   =   UVM_ACTIVE;
    int unsigned pad_cycles             =   5;

    virtual dut_interface m_vif;

    // 将自定义的 agent_config 类向 UVM 注册
    `uvm_object_utils_begin(agent_config)
        // UVM_ALL_ON：对 sa 变量开启所有自动化功能
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
        `uvm_field_int(pad_cycles, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "agent_config");
        super.new(name)
    endfunction //new()
endclass //agent_config extends uvm_object