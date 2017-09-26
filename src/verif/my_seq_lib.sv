virtual class my_base_seq extends uvm_sequence#(my_transaction);

    function new(string name = "my_base_seq");
        super.new(name);
    endfunction

endclass

class my_first_seq extends my_base_seq;

    `uvm_object_utils(my_first_seq)

    function new(string name = "my_first_seq");
        super.new(name);
    endfunction

    virtual task body();
        my_transaction my_trans;
        `uvm_create(my_trans);
        `uvm_info("my_first_seq", "randomize data", UVM_LOW);
        my_trans.data = $urandom();
        `uvm_send(my_trans);
    endtask
endclass: my_first_seq
