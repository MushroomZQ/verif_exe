class my_driver extends uvm_driver;

    `uvm_component_utils(my_driver)

    virtual my_if vif;

    function new(string name="my_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction
   
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("my_driver", "build_phase is called", UVM_LOW);
        if(!uvm_config_db#(virtual my_if)::get(uvm_root::get(), "*", "input_if", vif))
            `uvm_fatal("my_driver", "virtual interface must be set for vif")
    endfunction

    virtual task main_phase(uvm_phase phase);

        phase.raise_objection(this);
        `uvm_info("my_driver", "main_phase is called", UVM_LOW);
        /*vif.data <= 8'b0;
        vif.valid <= 1'b0;
        while(!vif.rst_n) 
            @(posedge vif.clk);
        for(int i = 0; i < 256; i++) begin
            @(posedge vif.clk);
            vif.data <= $urandom_range(0, 255);
            vif.valid <= 1'b1;
            `uvm_info("my_driver", "data is drived", UVM_LOW);
        end
        @(posedge vif.clk);
        vif.valid <= 1'b0;*/
        fork
            get_and_drive();
            rst_dut();
        join
        phase.drop_objection(this);
    endtask

    virtual task get_and_drive();
        forever begin
            @(posedge vif.clk);
            if(!vif.rst_n) begin
                @(posedge vif.rst_n);
                @(posedge vif.clk);
            end
            seq_item_port.get_next_item(req);
                `uvm_info("my_driver", "get data from seq", UVM_LOW);
                vif.data <= req.data;
                vif.valid <= 1'b1;
                `uvm_info("my_driver", "data is drived", UVM_LOW);
                @(posedge vif.clk);
                vif.valid <= 1'b0;
            seq_item_port.item_done();
        end
    endtask: get_and_drive

    virtual task rst_dut();
        forever begin
            @(negedge rst_n);
            vif.data <= 8'b0;
            vif.valid <= 1'b0;
        end
    endtask: rst_dut

endclass: my_driver

