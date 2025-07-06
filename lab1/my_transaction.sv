class my_transaction extends uvm_sequence_item;
    // 为激励成员指定 rand 属性
    rand bit [3:0] sa; // source address
    rand bit [3:0] da; // destination address
    rand reg [7:0] payload[$]; // payload 队列

    // 将自定义的 transaction 类向 UVM 注册
    `uvm_object_utils_begin(my_transaction)
        `uvm_field_int(sa, UVM_ALL_ON) // UVM_ALL_ON：对 sa 变量开启所有自动化功能
        `uvm_field_int(da, UVM_ALL_ON)
        `uvm_field_queue_int(payload, UVM_ALL_ON)
    `uvm_object_utils_end

    // 约束项，控制随机成员的随机范围
    constraint limit{
        sa inside {[0:15]};
        da inside {[0:15]};
        payload.size() inside {[2:4]}; // 约束 payload 队列的长度范围
    }

    // 构造函数，name 为实例化时对象的名称
    function new(string name = "my_transaction");
        super.new(name); // 调用父类的构造函数
    endfunction
endclass