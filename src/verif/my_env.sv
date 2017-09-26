class my_env extends uvm_env;

    my_agent my_agt;

    `uvm_component_utils(my_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        my_agt = my_agent::type_id::create("my_agt", this);

    endfunction

endclass: my_env
