`timescale 1ns/1ps

`include "my_pkg.sv"
`include "../rtl/dut.v"

module top_tb;
    import my_exe_pkg::*;

    reg clk;
    reg rst_n;
    reg [7:0] rxd;
    reg rx_dv;
    wire [7:0] txd;
    wire tx_en;

    my_if input_if(clk, rst_n);
    my_if output_if(clk, rst_n);

    dut my_dut(.clk(clk),
               .rst_n(rst_n),
               .rxd(input_if.data),
               .rx_dv(input_if.valid),
               .txd(output_if.data),
               .tx_en(output_if.valid)
                );

    initial begin
        $fsdbDumpfile("./test.fsdb");
        $fsdbDumpvars(0, top_tb);
    end

    initial begin
        uvm_config_db#(virtual my_if)::set(uvm_root::get(), "", "input_if", input_if);
        uvm_config_db#(virtual my_if)::set(uvm_root::get(), "", "output_if", output_if);
    end

    initial begin
        run_test();
    end

    assign input_if.clk = clk;
    assign input_if.rst_n = rst_n;

    assign output_if.clk = clk;
    assign output_if.rst_n = rst_n;

    initial begin
        clk <= 1'b0;
        rst_n <= 1'b1;
        forever begin
            #5 clk <= ~clk;
        end
    end

    initial begin
        #100;
        rst_n = 1'b0;
        #20;
        rst_n = 1'b1;
    end

endmodule
