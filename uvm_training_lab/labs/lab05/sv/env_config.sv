class env_config extends uvm_object;
int is_coverage =   0;
int is_check    =   0;

agent_config m_agent_cfg; // agent_config 类的句柄

`uvm_object_utils_begin(env_config)
    `uvm_field_int(is_active, UVM_ALL_ON)
    `uvm_field_int(is_check, UVM_ALL_ON)
    `uvm_field_object(m_agent_cfg, UVM_ALL_ON)
`uvm_object_utils_end

    function new(string name = "env_config");
        super.new(name)
        m_agent_cfg = new("m_agent_cfg") // 实例化 agent_config 类的对象
    endfunction //new()
endclass //env_config extends uvm_object