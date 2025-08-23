class my_sequence extends uvm_sequence #(my_transaction); // uvm_sequence 是参数化的基类，指定该 sequence 所产生的 transaction 的类型
    // 将自定义的 sequence 类向 UVM 注册
    `uvm_object_utils(my_sequence)

    int item_num = 10;

    // 构造函数，name 为实例化时对象的名称
    function new(string name = "my_sequence");
        super.new(name); // 调用父类的构造函数
    endfunction

    function void pre_randomize();
        uvm_config_db#(int)::get(my_sequencer, "", "item_num", item_num);
    endfunction

    // body() 任务，用于产生、控制 transition 序列
    virtual task body(); // 虚方法关键字，方便后续可能的重写，普通任务不能被子类重写
        if(starting_phase != null)
            starting_phase.raise_objection(this); // 当前组件（this）正在执行操作，提出 objection，阻止当前 phase 结束
        
        // 产生并发送 item_num 个 transaction 对象
        repeat(item_num) begin
            // 1. uvm_do 为 uvm 内建的宏，每调用一次则产生并发送一个 transaction 对象
            // 2. 因为父类 uvm_sequence 的参数为 (req, rsp)，所以 req 为指向 my_transaction 对象的句柄
            `uvm_do(req);
        end

        #100;
        if(starting_phase != null)
            starting_phase.drop_objection(this); // 当前组件（this）执行操作完成，解除 objection，允许 phase 结束
    endtask
endclass