class my_test extends uvm_test;
    // 将自定义的 test 类向 UVM 注册
    `uvm_component_utils(my_test)

    my_env m_env; // 定义 env 的句柄
    env_config m_env_cfg; // 定义 env_config 的句柄

    // 构造函数，name 为实例化时对象的名称, uvm_component 为实例化时指向父对象的句柄
    function new(string name = "my_test", uvm_component parent);
        super.new(name, parent);
        m_env_cfg = new("m_env_cfg"); // 创建 env_config 的对象
    endfunction

    // 1. 重写 build_phase() 函数
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // 使用 UVM 的 factory 机制创建对象，"m_env" 为该对象的名字，this 为实例化时指向父对象的句柄（父对象即当前的 testcase）
        m_env = my_env::type_id::create("m_env", this);

        // 使用 uvm_config 机制，为 agent 中的 sequencer 配置 default_sequence
        // uvm_config_db 是 UVM 内建的参数化的类，set() 是 uvm_config_db 中的静态函数，用于为指定的目标设置资源
        // uvm_config_db#(uvm_object_wrapper)::set(
        //     this, "*.m_seqr.run_phase",
        //     "default_sequence", my_sequence::get_type());

        uvm_config_db#(int)::set(this, "*.m_seqr", "item_num", 20);

        // 在 build_phase() 中对各个配置变量赋值
        m_env_cfg.is_coverage               =   1;
        m_env_cfg.is_check                  =   1;
        m_env_cfg.m_agent_cfg.is_active     =   UVM_ACTIVE;
        m_env_cfg.m_agent_cfg.pad_cycles    =   10;

        // 从顶层获取 virtual interface，并传递给 m_env_cfg.m_agent_cfg 中的 m_vif
        if(!uvm_config_db#(virtual dut_interface)::get(
            this, "", "top_if", m_env_cfg.m_agent_cfg.m_vif)) begin
            `uvm_fatal("CONFIG_ERROR", "test can not get the interface !!!");
        end

        // 将 m_env_cfg 配置到 m_env 中，id 为 env_cfg
        uvm_config_db#(env_config)::set(this, "m_env", "env_cfg", m_env_cfg);
    endfunction

    // 2. 重写 start_of_simulation_phase()
    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        uvm_top.print_topology(uvm_default_tree_printer); // 打印当前验证环境的结构
    endfunction

    // 在 run_phase() 中手动启动 sequence
    virtual task  run_phase(uvm_phase phase);
        my_sequence m_seq;
        m_seq = my_sequence::type_id::create("m_seq");
        phase.raise_objection(this);
        m_seq.start(m_env.m_agent.m_seqr); // 为 sequence 指定相关联的 sequencer
        phase.drop_objection(this);
    endtask

endclass
