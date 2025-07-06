class my_env extends uvm_env;
    // 将自定义的 driver 类向 UVM 注册
    `uvm_compnent_utils(my_env)

    // 定义 agent 的句柄
    master_agent m_agt;

    // 构造函数，name 为实例化时对象的名称, uvm_component 为实例化时父对象的指针
    function new(string name = "", uvm_component parent);
        super.new(name, parent);
    endfunction

    // 重写 build_phase 方法
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // 使用 UVM 的 factory 机制创建对象，"m_agt" 为该对象的名字，this 为该对象的父对象（即当前的 env）
        m_agt = master_agent::type_id::create("m_agt", this);
    endfunction
endclass