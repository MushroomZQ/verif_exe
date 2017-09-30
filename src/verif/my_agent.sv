class my_agent extends uvm_agent;

    my_sequencer my_sqr;
    my_driver my_drv;
    my_monitor my_mo;

    `uvm_component_utils(my_agent)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        my_sqr = my_sequencer::type_id::create("my_sqr", this);
        my_drv = my_driver::type_id::create("my_drv", this);
        my_mo = my_monitor::type_id::create("my_mo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        my_drv.seq_item_port.connect(my_sqr.seq_item_export);
    endfunction

endclass: my_agent
