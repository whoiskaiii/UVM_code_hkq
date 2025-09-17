interface dut_interface(input bit clk);
    logic           reset_n;
    logic   [15:0]  din;
    logic   [15:0]  frame_n;
    logic   [15:0]  valid_n;
    logic   [15:0]  dout;
    logic   [15:0]  busy_n;
    logic   [15:0]  valido_n;
    logic   [15:0]  frameo_n;

// 时钟块用于同步信号交互，定义信号在时钟边沿的采样/驱动时间，避免竞争冒险

// 1. 用于驱动 DUT 的输入信号，在 clk 上升沿触发
// 2. output 信号：由验证环境的 driver 控制，发送到 DUT
// 3. input 信号：driver 接收 DUT 的信号
clocking driver_cb@(posedge clk);
    default input #1 output #0; // 默认：输入信号在时钟沿后 1ns 采样，输出信号在时钟沿立即驱动
    output  reset_n;
    output  frame_n;
    output  valid_n;
    output  din;
    input   busy_n;
endclocking

clocking i_monitor_cb@(posedge clk);
    default input #1 output #0;
    input   frame_n;
    input   valid_n;
    input   din;
    input   busy_n;
endclocking

clocking o_monitor_cb@(posedge clk);
    default input #1 output #0;
    input   dout;
    input   valido_n;
    input   frameo_n;
endclocking

// 模块端口定义接口的不同视图，限制不同验证组件对信号的访问权限（如只读/只写），提高封装性。
modport driver    (clocking driver_cb, output reset_n); // driver 视角：仅能访问 driver_cb 和 reset_n
modport i_monitor (clocking i_monitor_cb); // i_monitor 视角：仅能访问 i_monitor_cb
modport o_monitor (clocking o_monitor_cb); // o_monitor 视角：仅能访问 o_monitor_cb

endinterface