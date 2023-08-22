class driver_dut extends uvm_driver#(transaction_dut);

    virtual interface_dut vif;
 
    `uvm_component_utils(driver_dut)
    function new(string name = "driver_dut", uvm_component parent = null);
        super.new(name, parent);
    endfunction
 
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual interface_dut)::get(this, "", "vif", vif))
            `uvm_fatal("driver_dut", "virtual interface must be set for vif!!!")
    endfunction
 
    extern task main_phase(uvm_phase phase);
    extern task drive_one_pkt(transaction_dut tr);
endclass
 
task driver_dut::main_phase(uvm_phase phase);
    vif.data <= 8'b0;
    vif.valid <= 1'b0;
    while(!vif.rst_n)
        @(posedge vif.clk);
    while(1) begin
        seq_item_port.get_next_item(req);
        drive_one_pkt(req);
        seq_item_port.item_done();
    end
endtask
 
task driver_dut::drive_one_pkt(transaction_dut tr);
    byte unsigned     data_q[];
    int  data_size;
    
    data_size = tr.pack_bytes(data_q) / 8; 
    `uvm_info("driver_dut", "begin to drive one pkt", UVM_LOW);
    repeat(3) @(posedge vif.clk);
    for ( int i = 0; i < data_size; i++ ) begin
        @(posedge vif.clk);
        vif.valid <= 1'b1;
        vif.data <= data_q[i]; 
    end
 
    @(posedge vif.clk);
    vif.valid <= 1'b0;
    `uvm_info("driver_dut", "end drive one pkt", UVM_LOW);
endtask
 