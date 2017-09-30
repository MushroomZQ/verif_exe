class my_scoreboard extends uvm_scoreboard;
    my_transaction pred_queue[$];
    my_transaction pred_trans;
    my_transaction real_trans;
    my_transaction ref_trans;

    int match;

    //my_monitor(output_monitor)->my_scoreboard
    `uvm_analysis_imp_decl (_mon_scbd)
    uvm_analysis_imp_mon_scbd#(my_transaction, my_scoreboard) mon_scbd_imp;

   //my_predictor->my_scoreboard
   `uvm_analysis_imp_decl (_pred_scbd)
   uvm_analysis_imp_pred_scbd#(my_transaction, my_scoreboard) pred_scbd_imp;

    //uvm_blocking_get_port#(my_transaction) mon_scbd_port;
    //uvm_blocking_get_port#(my_transaction) pred_scbd_port;

    `uvm_component_utils(my_scoreboard)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        //mon_scbd_port = new("mon_scbd_port", this);
        //pred_scbd_port = new("pred_scbd_port", this);

        mon_scbd_imp = new("mon_scbd_imp", this);
        pred_scbd_imp = new("pred_scbd_imp", this);
        match = 0;
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    function void write_pred_scbd(my_transaction _trans);
        pred_trans = new();
        pred_trans = _trans;
        pred_queue.push_back(pred_trans);
    endfunction

    function void write_mon_scbd(my_transaction _trans);
        real_trans = new();
        ref_trans = new();
        real_trans = _trans;
        ref_trans = pred_queue.pop_front();
        if(real_trans.compare(ref_trans)) begin
            match = 1;
            `uvm_info(get_type_name(), "compare pass", UVM_LOW);
        end
        else begin
            match = 0;
            `uvm_error(get_type_name(), $psprintf("\nreal_trans is \n%s",real_trans.sprint()));
            `uvm_error(get_type_name(), $psprintf("\nref_trans is \n%s",ref_trans.sprint()));
        end
    endfunction

    /*task run_phase(uvm_phase phase);
        fork
            get_pred_trans();
            compare_trans();
        join
    endtask

    task get_pred_trans();
        forever begin
            //pred_scbd_port.get(pred_trans);
            pred_scbd_imp.get(pred_trans);
            pred_queue.push_back(pred_trans);
        end
    endtask

    task compare_trans();
        forever begin
            //mon_scbd_port.get(real_trans);
            mon_scbd_imp.get(real_trans);
            if(pred_queue.size()>0) begin
                ref_trans = pred_queue.pop_front();
                if(ref_trans.compare(real_trans)) begin
                    match = 1;
                    `uvm_info(get_type_name(), "compare pass", UVM_LOW);
                end
                else begin
                    match = 0;
                    `uvm_error(get_type_name(), $psprintf("\nreal_trans is \n%s",real_trans.sprint()));
                    `uvm_error(get_type_name(), $psprintf("\nref_trans is \n%s",ref_trans.sprint()));
                end
            end
            else begin
                `uvm_info(get_type_name(), "received from DUT, but pred queue is empty", UVM_LOW);
                `uvm_info(get_type_name(), $psprintf("\nreal_trans is \n%s",real_trans.sprint()), UVM_LOW);
                #100;
            end
        end
    endtask*/

endclass
