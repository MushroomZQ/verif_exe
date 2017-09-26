class my_sqr extends uvm_sequencer#(my_transaction);

    `uvm_component_utils_begin(my_sqr)

    `uvm_component_utils_end

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction 

endclass: my_sqr
