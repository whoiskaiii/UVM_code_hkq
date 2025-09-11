// uvm_driver 为一个参数化的类，指定该 driver 所要处理的 transaction 的类型
class my_driver extends uvm_driver #(my_transaction);
    // 将自定义的 driver 类向 UVM 注册
    // 注：平台组件的注册需要使用 `uvm_component_utils 宏，其余的注册需要使用 `uvm_object_utils 宏
    `uvm_component_utils(my_driver)

    // 在 class 中，不能直接使用 interface，而是要使用 virtual interface。
    virtual dut_interface m_vif;
    int unsigned pad_cycles;

    // 构造函数，name 为实例化时对象的默认名称, uvm_component 为实例化时指向父对象的句柄，
    // 句柄类似于 C++ 中的指针
    function new(string name = "my_dirver", uvm_component parent);
        super.new(name, parent); // 调用父类的构造函数
    endfunction

    // 在 build_phase() 中使用 uvm_config_db::get 获取 virtual interface 的配置
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(int unsigned)::get(this, "", "pad_cycles", pad_cycles)) begin
            `uvm_fatal("CONFIG_FATAL", "Driver can not get the pad_cycles !!!")
        end
        if (!uvm_config_db#(virtual dut_interface)::get(this, "", "vif", m_vif)) begin
            `uvm_fatal("CONFIG_FATAL", "Driver can not get the interface !!!")
        end
    endfunction

    // 初始化 driver 接口信号
    virtual task pre_reset_phase(uvm_phase phase);
        super.pre_reset_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH); // %m 是 SV 的系统函数，用于打印当前的层次路径名
        phase.raise_objection(this);
        m_vif.driver_cb.frame_n <=  'x;
        m_vif.driver_cb.valid_n <=  'x;
        m_vif.driver_cb.din     <=  'x;
        m_vif.driver_cb.reset_n <=  'x;
        phase.drop_objection(this);
    endtask

    virtual task reset_phase(uvm_phase phase);  
        super.pre_reset_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH); // %m 是 SV 的系统函数，用于打印当前的层次路径名
        phase.raise_objection(this);
        m_vif.driver_cb.reset_n <=  '1;
        m_vif.driver_cb.frame_n <=  '1;
        m_vif.driver_cb.valid_n <=  '0;
        m_vif.driver_cb.din     <=  '1;

        repeat(5) @(m_vif.driver_cb);
        m_vif.driver_cb.reset_n <=  '0;
        repeat(5) @(m_vif.driver_cb);
        m_vif.driver_cb.reset_n <=  '1;
        phase.drop_objection(this);
    endtask

    // 在 run_phase() 任务中完成 driver 的功能
    virtual task run_phase(uvm_phase phase);
        logic [7:0] temp;
        repeat(15) @(m_vif.driver_cb);

        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info("DRV_RUN_PHASE", req.sprint(), UVM_MEDIUM)
            
            // send address
            m_vif.driver_cb.frame_n[req.sa] <=  1'b0;
            for (int i = 0; i < 4; i++) begin
                m_vif.driver_cb.din[req.sa] <=  req.da[i];
                @(m_vif.driver_cb);
            end

            // send pad
            m_vif.driver_cb.din[req.sa]     <=  1'b1;
            m_vif.driver_cb.valid_n[req.sa] <=  1'b1;
            repeat(5) @(m_vif.driver_cb);

            // send payload
            while (!m_vif.driver_cb.busy_n[req.sa]) @(m_vif.driver_cb);
            // 数组名后[]中出现的标识符就是索引变量，由foreach自动声明，无需提前定义
            foreach (req.payload[index]) begin
                temp = req.payload[index];
                for (int i = 0; i < 8; i++) begin
                    m_vif.driver_cb.din[req.sa]     <= temp[i];
                    m_vif.driver_cb.valid_n[req.sa] <= 1'b0;
                    m_vif.driver_cb.frame_n[req.sa] <= ((req.payload.size() - 1) == index) && (i == 7);
                    @(m_vif.driver_cb);
                end
            end

            m_vif.driver_cb.valid_n[req.sa] <=  1'b1;

            seq_item_port.item_done();
        end
    endtask
endclass
