class my_env extends uvm_env;
    // 将自定义的 env 类向 UVM 注册
    `uvm_component_utils(my_env)

    master_agent m_agt; // 定义 env 中 agent 的句柄
    env_config m_env_cfg; // 定义 env_config 类对象的句柄

    // 构造函数，name 为实例化时对象的名称, uvm_component 为实例化时指向父对象的句柄
    function new(string name = "my_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    // 1. 重写 build_phase() 函数
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(env_config)::get(this, "", "env_cfg", m_env_cfg)) begin
            `uvm_fatal("CONFIG_FATAL", "ENV can not get the configuration !!!")
        end

        uvm_config_db#(agent_config)::set(this, "m_agt", "m_agent_cfg", m_env_cfg.m_agent_cfg);

        if(m_env_cfg.is_coverage) begin
            uvm_info("COVERAGE_ENABLE", "The coverage function is enable for this testcase", UVM_MEDIUM)
        end

        if(m_env_cfg.is_check) begin
            uvm_info("CHECK_ENABLE", "The check function is enable for this testcase", UVM_MEDIUM)
        end

        // 使用 UVM 的 factory 机制创建对象，"m_agt" 为该对象的名字，this 为实例化时指向父对象的句柄（父对象即当前的 env）
        m_agt = master_agent::type_id::create("m_agt", this);
    endfunction

    // 2. 当前为简化的 env，省去组件的连接
endclass