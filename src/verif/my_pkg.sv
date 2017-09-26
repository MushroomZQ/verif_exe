`include "my_if.sv"
package my_exe_pkg;
    //`include "uvm_macros.svh"
    import uvm_pkg::*;

    `include "my_driver.sv"
    `include "my_trans.sv"
    `include "my_seq_lib.sv"
    `include "my_sqr.sv"
endpackage: my_exe_pkg
