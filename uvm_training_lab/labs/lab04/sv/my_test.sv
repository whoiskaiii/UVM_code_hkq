class my_test extends uvm_test;
    // 将自定义的 test 类向 UVM 注册
    `uvm_component_utils(my_test)

    // 定义 env 的句柄
    my_env m_env;

    // 构造函数，name 为实例化时对象的名称, uvm_component 为实例化时指向父对象的句柄
    function new(string name = "my_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    // 1. 重写 build_phase() 函数
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // 使用 UVM 的 factory 机制创建对象，"m_env" 为该对象的名字，this 为实例化时指向父对象的句柄（父对象即当前的 testcase）
        m_env = my_env::type_id::create("m_env", this);

        // 使用 uvm_config 机制，为 agent 中的 sequencer 配置 default_sequence
        // uvm_config_db 是 UVM 内建的参数化的类，set() 是 uvm_config_db 中的静态函数，用于为指定的目标设置资源
        uvm_config_db#(uvm_object_wrapper)::set(
            this, "*.m_seqr.run_phase",
            "default_sequence", my_sequence::get_type());

        uvm_config_db#(int)::set(this, ".m_seqr", "item_num", 20)
    endfunction

    // 2. 重写 start_of_simulation_phase()
    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        uvm_top.print_topology(uvm_default_tree_printer); // 打印当前验证环境的结构
    endfunction

endclass
