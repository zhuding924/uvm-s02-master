`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "interface_dut.sv"
`include "case0.sv"
`include "case1.sv"
`include "case2.sv"

module tb_top;

    reg clk;
    reg rst_n;
    reg[7:0] rxd;
    reg rx_dv;
    wire[7:0] txd;
    wire tx_en;

    interface_dut input_if(clk, rst_n);
    interface_dut output_if(clk, rst_n);

    wrapper dut(.clk(clk),
            .rst_n(rst_n),
            .rxd(input_if.data),
            .rx_dv(input_if.valid),
            .txd(output_if.data),
            .tx_en(output_if.valid));

    initial begin
        clk = 0;
        forever begin
            #100 clk = ~clk;
        end
    end

    initial begin
        rst_n = 1'b0;
        #1000;
        rst_n = 1'b1;
    end

    initial begin
        run_test();
    end

    initial begin
        // set the format for time display
        $timeformat(-9, 2, "ns", 10);      
        // do interface configuration from tb_top (HW) to verification env (SW)
        uvm_config_db#(virtual interface_dut)::set(null, "uvm_test_top.env.in_agt.drv", "vif", input_if);
        uvm_config_db#(virtual interface_dut)::set(null, "uvm_test_top.env.in_agt.mon", "vif", input_if);
        uvm_config_db#(virtual interface_dut)::set(null, "uvm_test_top.env.out_agt.mon", "vif", output_if);
    end

`ifdef DUMP_FSDB
    initial begin 
        string testname;
        if($value$plusargs("TESTNAME=%s", testname)) begin
            $fsdbDumpfile({testname, "_sim_dir/", testname, ".fsdb"});
        end else begin
            $fsdbDumpfile("tb.fsdb");
        end
        $fsdbDumpvars(0, tb_top.dut);
        $fsdbDumpvars(0, tb_top.input_if);
        $fsdbDumpvars(0, tb_top.output_if);
    end 
`endif 


endmodule
