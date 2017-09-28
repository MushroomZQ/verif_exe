class my_tb extends uvm_env;

    `uvm_component_utils(my_tb)

    my_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = my_env::type_id::create("env", this);
    endfunction

    /*function connect_phase(uvm_phase phase);

    endfunction*/

endclass: my_tb
