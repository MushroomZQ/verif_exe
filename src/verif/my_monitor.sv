class my_monitor extends uvm_monitor;

    virtual my_if output_if;
    virtual my_if input_if;

    uvm_analysis_port#(my_transaction) mon_pred_ap;
    uvm_analysis_port#(my_transaction) mon_scbd_ap;

    `uvm_component_utils(my_monitor)

    function new(string name = "my_monitor", uvm_component parent = null);
        super.new(name, parent);
        mon_pred_ap = new("mon_pred_ap", this);
        mon_scbd_ap = new("mon_scbd_ap", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual my_if)::get(uvm_root::get(), "", "output_if", output_if))
            `uvm_fatal("my_driver", "virtual interface must be set for vif");
        if(!uvm_config_db#(virtual my_if)::get(uvm_root::get(), "", "input_if", input_if))
            `uvm_fatal("my_driver", "virtual interface must be set for vif");
    endfunction

    task run_phase(uvm_phase phase);
        fork
            collect_input_trans();
            collect_output_trans();
        join
    endtask

    virtual task collect_input_trans();

        my_transaction my_trans;

        forever begin
            my_trans = new();
            if(input_if.rst_n == 1'b0) begin
                @(posedge input_if.rst_n);
            end
            @(posedge input_if.valid);
            my_trans.data = input_if.data;

            mon_pred_ap.write(my_trans);
        end
    endtask

    virtual task collect_output_trans();

        my_transaction my_trans;

        forever begin
            my_trans = new();
            if(output_if.rst_n == 1'b0) begin
                @(posedge output_if.rst_n);
            end
            @(posedge output_if.valid);
            my_trans.data = output_if.data;

            mon_scbd_ap.write(my_trans);
        end
    endtask
endclass
