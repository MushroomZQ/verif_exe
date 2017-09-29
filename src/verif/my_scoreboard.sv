class my_scoreboard extends uvm_scoreboard;
    my_transaction pred_queue[$];
    my_transaction pred_trans;
    my_transaction real_trans;
    my_transaction ref_trans;

    int match;

    uvm_blocking_get_port#(my_transaction) mon_scbd_port;
    uvm_blocking_get_port#(my_transaction) pred_scbd_port;

    `uvm_component_utils(my_scoreboard)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        mon_scbd_port = new("mon_scbd_port", this);
        pred_scbd_port = new("pred_scbd_port", this);
        match = 0;
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        fork
            get_pred_trans();
            compare_trans();
        join
    endtask

    task get_pred_trans();
        forever begin
            pred_scbd_port.get(pred_trans);
            pred_queue.push_back(pred_trans);
        end
    endtask

    task compare_trans();
        forever begin
            mon_scbd_port.get(real_trans);
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
    endtask

endclass
