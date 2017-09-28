class my_driver extends uvm_driver#(my_transaction);

    `uvm_component_utils(my_driver)

    virtual my_if input_if;

    int a;

    function new(string name="my_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction
   
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("my_driver", "build_phase is called", UVM_LOW);
        //if(!uvm_config_db#(virtual my_if)::get(uvm_root::get(), "", "input_if", input_if))
        if(!uvm_config_db#(virtual my_if)::get(uvm_root::get(), "", "input_if", input_if))
            `uvm_fatal("my_driver", "virtual interface must be set for vif")

        uvm_config_db#(virtual my_if)::get(uvm_root::get(), "", "input_if", input_if);
        uvm_config_db#(int)::get(uvm_root::get(), "", "test_bit", a);
    endfunction

    virtual task run_phase(uvm_phase phase);

        //phase.raise_objection(this);
        `uvm_info("my_driver", "main_phase is called", UVM_LOW);
        fork
            get_and_drive();
            //rst_dut();
        join
        //phase.drop_objection(this);
    endtask

    virtual task get_and_drive();
        `uvm_info(get_type_name(), $psprintf("a = %d", a), UVM_LOW);
        forever begin
            `uvm_info("my_driver", "start get forever", UVM_LOW);
            @(posedge input_if.clk);
            `uvm_info("my_driver", "get the input clk", UVM_LOW);
            if(!input_if.rst_n) begin
                @(posedge input_if.rst_n);
                @(posedge input_if.clk);
            end
            seq_item_port.get_next_item(req);
                `uvm_info("my_driver", "get data from seq", UVM_LOW);
                input_if.data <= req.data;
                input_if.valid <= 1'b1;
                `uvm_info("my_driver", "data is driving", UVM_LOW);
                //@(posedge input_if.clk);
                //#10;
                `uvm_info("my_driver", "waiting done", UVM_LOW);
                //input_if.valid <= 1'b0;
                `uvm_info("my_driver", "data was drived", UVM_LOW);
            seq_item_port.item_done();
        end
    endtask: get_and_drive

    virtual task rst_dut();
        forever begin
            `uvm_info("my_driver", "start reset forever", UVM_LOW);
            @(negedge input_if.rst_n);
            input_if.data <= 8'b0;
            input_if.valid <= 1'b0;
        end
    endtask: rst_dut

endclass: my_driver

