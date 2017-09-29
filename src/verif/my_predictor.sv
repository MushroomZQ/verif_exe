class my_predictor extends uvm_component;

    uvm_blocking_get_port#(my_transaction) mon_pred_port;
    uvm_analysis_port#(my_transaction) pred_scbd_ap;

    `uvm_component_utils(my_predictor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        mon_pred_port = new("mon_pred_port", this);
        pred_scbd_ap = new("pred_scbd_ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        fork
            do_prediction();
        join
    endtask

    virtual task do_prediction();
        my_transaction input_trans;
        my_transaction output_trans;
        input_trans = new();
        output_trans = new();
    
        mon_pred_port.get(input_trans);
        output_trans = input_trans;

        pred_scbd_ap.write(output_trans);
    endtask
endclass
