class my_env extends uvm_env;

    my_agent my_agt;
    my_predictor my_pred;
    my_scoreboard my_scbd;

    `uvm_component_utils(my_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        my_agt = my_agent::type_id::create("my_agt", this);
        my_pred = my_predictor::type_id::create("my_pred", this);
        my_scbd = my_scoreboard::type_id::create("my_scbd", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        my_pred.pred_scbd_ap.connect(my_scbd.pred_scbd_port);
        my_agt.mon_scbd_ap.connect(my_scbd.mon_scbd_port);
    endfunction

endclass: my_env
