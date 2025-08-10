class my_env extends uvm_env;
    // 将自定义的 env 类向 UVM 注册
    `uvm_component_utils(my_env)

    // 定义 env 中 agent 的句柄
    master_agent m_agt;

    // 构造函数，name 为实例化时对象的名称, uvm_component 为实例化时指向父对象的句柄
    function new(string name = "my_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    // 1. 重写 build_phase() 函数
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // 使用 UVM 的 factory 机制创建对象，"m_agt" 为该对象的名字，this 为实例化时指向父对象的句柄（父对象即当前的 env）
        m_agt = master_agent::type_id::create("m_agt", this);
    endfunction

    // 2. 简化的 env，省去组件的连接
endclass