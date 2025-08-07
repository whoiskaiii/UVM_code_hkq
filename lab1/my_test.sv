class my_test extends uvm_test;
    // 将自定义的 test 类向 UVM 注册
    `uvm_compnent_utils(my_test)

    // 定义 env 的句柄
    my_env m_env;

    // 构造函数，name 为实例化时对象的名称, uvm_component 为实例化时父对象的指针
    function new(string name = "", uvm_component parent);
        super.new(name, parent);
    endfunction

    // 重写 build_pahse 方法
    virtual function void build_pahse(uvm_phase phase);
        super.build_pahse(phase);
        // 使用 UVM 的 factory 机制创建对象，"m_env" 为该对象的名字，this 为该对象的父对象（即当前的 testcase）
        m_env = my_env::type_id::create("m_env", this);

        // 使用 uvm_config 机制配置 agent sequencer 的 default_sequence
        uvm_config_db#(uvm_object_wrapper)::set(
            this, "*.m_seqr.run_phase",
            "default_sequence", my_sequence::get_type());
    endfunction

    // 重写 start_of_simulation_phase
    virtual function void start_of_simulation_phase(uvm_phase phase)
        super.start_of_simulation_phase(phase);
        uvm_top.print_topology(uvm_default_tree_printer);
    endfunction

endclass