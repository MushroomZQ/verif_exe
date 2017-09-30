class my_predictor extends uvm_component;

    my_transaction input_trans;
    my_transaction output_trans;

    //uvm_blocking_get_port#(my_transaction) mon_pred_port;
    `uvm_analysis_imp_decl(_mon_pred)
    uvm_analysis_imp_mon_pred#(my_transaction, my_predictor) mon_pred_imp;
    uvm_analysis_port#(my_transaction) pred_scbd_ap;

    `uvm_component_utils(my_predictor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        mon_pred_imp = new("mon_pred_imp", this);
        pred_scbd_ap = new("pred_scbd_ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    function void write_mon_pred(my_transaction _trans);
        do_prediction(_trans);
    endfunction

    function void do_prediction(my_transaction _trans);
        output_trans = new();
        output_trans = _trans;
        pred_scbd_ap.write(output_trans);
    endfunction

    /*task run_phase(uvm_phase phase);
        fork
            do_prediction();
        join
    endtask

    virtual task do_prediction();
        input_trans = new();
        output_trans = new();
    
        mon_pred_port.get(input_trans);
        output_trans = input_trans;

        pred_scbd_ap.write(output_trans);
    endtask*/
endclass
