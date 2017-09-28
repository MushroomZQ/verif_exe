virtual class my_base_seq extends uvm_sequence#(my_transaction);

    function new(string name = "my_base_seq");
        super.new(name);
    endfunction

endclass

class my_first_seq extends my_base_seq;

    `uvm_object_utils(my_first_seq)

    my_transaction my_trans;

    function new(string name = "my_first_seq");
        super.new(name);
    endfunction

    virtual task body();
        /*`uvm_create(my_trans);
        `uvm_info("my_first_seq", "randomize data", UVM_LOW);
        my_trans.data = $urandom();
        `uvm_info("my_first_seq", "send data", UVM_LOW);
        `uvm_send(my_trans);*/
        `uvm_info("my_first_seq", "create data", UVM_LOW);
       repeat(10) begin
            `uvm_info("my_first_seq", "randomize data", UVM_LOW);
           `uvm_do(my_trans);
       end
        `uvm_info("my_first_seq", "send data", UVM_LOW);
       #1000;
    endtask

endclass: my_first_seq
