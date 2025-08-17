// uvm_driver 为一个参数化的类，指定该 driver 所要处理的 transaction 的类型
class my_driver extends uvm_driver #(my_transaction);
    // 将自定义的 driver 类向 UVM 注册
    // 注：平台组件的注册需要使用 `uvm_component_utils 宏，其余的注册需要使用 `uvm_object_utils 宏
    `uvm_component_utils(my_driver)

    // 构造函数，name 为实例化时对象的默认名称, uvm_component 为实例化时指向父对象的句柄，
    // 句柄类似于 C++ 中的指针
    function new(string name = "my_dirver", uvm_component parent);
        super.new(name, parent); // 调用父类的构造函数
    endfunction

    virtual task  reset_phase(uvm_phase phase);
        #100;
        phase.raise_objection(this);
        #100;
        `uvm_info("DRV_RESET_PHASE", "Now driver reset the DUT...", UVM_MEDIUM)
        phase.drop_objection(this);
    endtask

    virtual task  configure_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        `uvm_info("DRV_CONFIGURE_PHASE", "Now driver config the DUT...", UVM_MEDIUM)
        phase.drop_objection(this);
    endtask

    // 在 run_phase() 任务中完成 driver 的功能
    virtual task run_phase(uvm_phase phase);
        #3000;
        forever begin
            // 通过 seq_item_port，从 sequencer 中获取下一个 sequence_item（transaction 对象），req 句柄指向获取到的对象，
            // req 句柄的类型是开头定义 my_driver 类时传入的 my_transaction 类型
            seq_item_port.get_next_item(req); 

            // 将获取到的 transaction 对象打印出来，打印等级为 UVM_MEDIUM
            `uvm_info("DRV_RUN_PHASE", req.sprint(), UVM_MEDIUM)
            #100;

            // 通过 seq_item_port，通知 sequencer 该 transaction 对象已处理完毕，通常与 seq_item_port.get_next_item 成对使用
            seq_item_port.item_done(); 
        end
    endtask
endclass
