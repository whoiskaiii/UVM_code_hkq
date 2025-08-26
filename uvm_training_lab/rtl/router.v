module router (
    input           reset_n,
    input           clock,
    // input
    input   [15:0]  frame_n,
    input   [15:0]  valid_n,
    input   [15:0]  din,
    // output
    output  [15:0]  dout,
    output  [15:0]  busy_n,
    output  [15:0]  valido_n,
    output  [15:0]  frameo_n
);

endmodule