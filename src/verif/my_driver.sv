class my_driver extends uvm_driver#(my_transaction);

    `uvm_component_utils(my_driver)

    virtual my_if input_if;

    function new(string name="my_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction
   
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("my_driver", "build_phase is called", UVM_LOW);
        if(!uvm_config_db#(virtual my_if)::get(uvm_root::get(), "", "input_if", input_if))
            `uvm_fatal("my_driver", "virtual interface must be set for vif")

    endfunction

    virtual task run_phase(uvm_phase phase);

        //phase.raise_objection(this);
        `uvm_info("my_driver", "main_phase is called", UVM_LOW);
        fork
            get_and_drive();
            rst_dut();
        join
        //phase.drop_objection(this);
    endtask

    virtual task get_and_drive();
        forever begin
            @(posedge input_if.clk);
            if(!input_if.rst_n) begin
                @(posedge input_if.rst_n);
                @(posedge input_if.clk);
            end
            seq_item_port.get_next_item(req);
                `uvm_info("my_driver", "get data from seq", UVM_LOW);
                input_if.data <= req.data;
                input_if.valid <= 1'b1;
                @(posedge input_if.clk);
                input_if.valid <= 1'b0;
            seq_item_port.item_done();
        end
    endtask: get_and_drive

    virtual task rst_dut();
        forever begin
            @(negedge input_if.rst_n);
            input_if.data <= 8'b0;
            input_if.valid <= 1'b0;
        end
    endtask: rst_dut

endclass: my_driver

