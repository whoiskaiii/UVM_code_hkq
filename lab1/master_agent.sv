class master_agent extends uvm_agent;
    // 将自定义的 agent 类向 UVM 注册
    `uvm_component_utils(master_agent)

    // 定义 agent 中的各个组件句柄
    my_sequencer m_seqr;
    my_driver m_drv;
    m_monitor m_mon;

    // 构造函数，name 为实例化时对象的名称, uvm_component 为实例化时父对象的指针
    function new(string name = "master_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    // 1. 创建 agent 中的各个组件
    // 重写 build_phase 方法，build_phase 是验证环境中第一个执行的静态 phase，
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); // 执行父类的 build_phase 方法

        if(is_active == UVM_ACTIVE) begin // 如果该 agent 是 active 的，则创建 sequencer 和 driver，is_active 是 agent 内建的变量，默认值为 UVM_ACTIVE
            // 使用 UVM 的 factory 机制创建对象，"m_seqr" 为该对象的名字，this 为该对象的父对象（即当前的 agent）
            m_seqr = my_sequencer::type_id::create("m_seqr", this);
            m_drv = my_driver::type_id::create("m_drv", this);
        end
        m_mon = m_monitor::type_id::create("m_mon", this);
    endfunction

    // 2. 连接 agent 中的各个组件
    virtual function void connect_phase(uvm_phase phase);
        if(is_active == UVM_ACTIVE) begin // 如果该 agent 是 active 的，则连接 sequencer 的 seq_item_port 和 driver 的 seq_item_export
            m_drv.seq_item_port.connect(m_seqr.seq_item_export);
        end
    endfunction
endclass