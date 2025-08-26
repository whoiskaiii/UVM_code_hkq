import uvm_pkg::*;

module top;
    bit sys_clk;

    dut_interface itf(sys_clk);

    router dut (
        .reset_n    (itf.reset_n   ),
        .clock      (itf.clk       ),
        .frame_n    (itf.frame_n   ),
        .valid_n    (itf.valid_n   ),
        .din        (itf.din       ),
        .dout       (itf.dout      ),
        .busy_n     (itf.busy_n    ),
        .valido_n   (itf.valido_n  ),
        .frameo_n   (itf.frameo_n  )
    );
    
    initial begin
        sys_clk = 1'b0;
        forever begin
            #10
            sys_clk = ~sys_clk;
        end
    end

    initial begin
        uvm_config_db#(virtual dut_interface)::set(null, "*.m_agt.*", "vif", itf);
        run_test();
    end

    initial begin
        $wlfdumpvars();
    end

endmodule