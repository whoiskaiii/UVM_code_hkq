// uvm_driver 为一个参数化的类，指定该 driver 所要处理的 transaction 的类型
class my_driver extends uvm_driver #(my_transaction);
    // 将自定义的 driver 类向 UVM 注册
    // 注：平台组件的注册需要使用 `uvm_compnent_utils 宏，其余的注册需要使用 `uvm_object_utils 宏
    `uvm_compnent_utils(my_driver)

    // 构造函数，name 为实例化时对象的名称, uvm_component 为实例化时父对象的指针
    function new(string name = "my_dirver", uvm_component parent);
        super.new(name, parent); // 调用父类的构造函数
    endfunction

    // 在 run_phase 中完成 driver 的功能
    virtual task run_phase(uvm_phase phase)
        forever begin
            seq_item_port.get_next_item(req); // 从 sequence 中获取 transaction 对象
            `uvm_info("DRV_RUN_PHASE", req.sprint(), UVM_MEDIUM) // 将获取到的 transaction 对象打印出来
            #100;
            seq_item_port.item_done(); // 通知 sequence 该 transaction 对象已处理完毕，通常与 seq_item_port.get_next_item 成对使用
        end
    endtask
endclass