class my_testcase extends uvm_test;

    `uvm_component_utils(my_testcase)

    my_tb tb;

    function new(string name="my_testcase", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tb = my_tb::type_id::create("tb", this);
    endfunction

    task run_phase(uvm_phase phase);
        
        my_first_seq my_seq;
        my_seq = my_first_seq::type_id::create("my_seq", this);

        phase.raise_objection(this);
        //for(int i=0; i<25; i++) begin
            my_seq.start(tb.env.my_agt.my_sqr);
        //end
        phase.drop_objection(this);
    endtask

endclass: my_testcase
