class master_agent extends uvm_agent;
    // 将自定义的 agent 类向 UVM 注册
    `uvm_component_utils(master_agent)

    // 定义 agent 中 sequencer、driver、monitor 的句柄
    my_sequencer m_seqr;
    my_driver m_driv;
    my_monitor m_moni;

    // 构造函数，name 为实例化时对象的默认名称, uvm_component 为实例化时指向父对象的句柄
    function new(string name = "master_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    // 1. 在 build_phase() 中创建 agent 中的各个组件
    // 重写 build_phase() 函数，build_phase() 是验证环境中第一个执行的静态 phase，
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); // 执行父类的 build_phase() 函数

        // 如果该 agent 是 active 的，则创建 sequencer 和 driver。is_active 是 agent 内建的变量，默认值为 UVM_ACTIVE
        if(is_active == UVM_ACTIVE) begin 
            // 使用 UVM 的 factory 机制创建对象
            // 与 new() 的参数类似，"m_seqr" 为该对象的名字，this 为实例化时指向父对象的句柄（父对象即当前的 agent）
            m_seqr = my_sequencer::type_id::create("m_seqr", this);
            m_driv = my_driver::type_id::create("m_driv", this);
        end
        m_moni = my_monitor::type_id::create("m_moni", this);
    endfunction

    // 2. 在 connect_phase() 中连接 agent 中的各个组件
    virtual function void connect_phase(uvm_phase phase);
        // 如果该 agent 是 active 的，则将 driver 的 seq_item_port（收）连接至 sequencer 的 seq_item_export（发），
        // 以实现 driver 和 sequencer 之间的 transaction 级通信
        if(is_active == UVM_ACTIVE) begin 
            m_driv.seq_item_port.connect(m_seqr.seq_item_export);
        end
    endfunction
endclass
