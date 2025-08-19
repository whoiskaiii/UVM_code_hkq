// uvm_sequencer 为一个参数化的类，一般需要指定 sequencer 传递的 transaction 类型，
// 表示一种 sequencer 对应一种类型的 transaction
typedef uvm_sequencer # (my_transaction) my_sequencer;
// typedef 用于为已有的数据类型创建一个别名，即将参数为 my_transaction 的 uvm_sequencer 命名为 my_sequencer