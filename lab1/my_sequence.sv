class my_sequence extends uvm_sequence #(my_transaction); // 参数化的类，指定该 sequence 所产生的 transaction 的类型
    // 将自定义的 sequence 类向 UVM 注册
    `uvm_object_utils(my_sequence)

    // 构造函数，name 为实例化时对象的名称
    function new(string name = "my_sequence");
        super.new(name); // 调用父类的构造函数
    endfunction

    // body() 任务，用于控制和和产生 transition 序列
    virtual task body(); // 虚方法关键字，方便后续可能的重写，普通任务不能被子类重写
        if(starting_phase != null)
            starting_phase.raise_objection(this); // 当前组件（this）正在执行操作，提出 objection，阻止当前 phase 结束
        
        // 产生并发送 10 个 transaction 对象
        repeat(10) begin
            `uvm_do(req); // 产生并发送一个 transaction 对象
        end

        #100;
        if(starting_phase != null)
            starting_phase.drop_objection(this); // 当前组件（this）执行操作完成，解除 objection，允许 phase 结束
    endtask
endclass