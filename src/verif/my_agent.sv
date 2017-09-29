class my_agent extends uvm_agent;

    my_sequencer my_sqr;
    my_driver my_drv;
    my_monitor my_mo;
    my_predictor my_pred;

    uvm_tlm_analysis_fifo#(my_transaction) agt_mdl_fifo;
    uvm_analysis_port#(my_transaction) mon_scbd_ap;

    `uvm_component_utils(my_agent)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        agt_mdl_fifo = new("agt_mdl_fifo", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        my_sqr = my_sequencer::type_id::create("my_sqr", this);
        my_drv = my_driver::type_id::create("my_drv", this);
        my_mo = my_monitor::type_id::create("my_mo", this);
        my_pred = my_predictor::type_id::create("my_pred", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        my_drv.seq_item_port.connect(my_sqr.seq_item_export);
        my_mo.mon_pred_ap.connect(agt_mdl_fifo.blocking_get_export);
        my_pred.mon_pred_port.connect(agt_mdl_fifo.analysis_export);
        mon_scbd_ap = my_mo.mon_scbd_ap;
    endfunction

endclass: my_agent
