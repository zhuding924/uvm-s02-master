class my_monitor extends uvm_monitor;

    virtual interface_dut vif;
 
    uvm_analysis_port #(transaction_dut)  ap;
    
    `uvm_component_utils(my_monitor)
    function new(string name = "my_monitor", uvm_component parent = null);
       super.new(name, parent);
    endfunction
 
    virtual function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       if(!uvm_config_db#(virtual interface_dut)::get(this, "", "vif", vif))
          `uvm_fatal("my_monitor", "virtual interface must be set for vif!!!")
       ap = new("ap", this);
    endfunction
 
    extern task main_phase(uvm_phase phase);
    extern task collect_one_pkt(transaction_dut tr);
 endclass
 
 task my_monitor::main_phase(uvm_phase phase);
    transaction_dut tr;
    while(1) begin
       tr = new("tr");
       collect_one_pkt(tr);
       ap.write(tr);
    end
 endtask
 
 task my_monitor::collect_one_pkt(transaction_dut tr);
    byte unsigned data_q[$];
    byte unsigned data_array[];
    logic [7:0] data;
    logic valid = 0;
    int data_size;
    
    while(1) begin
       @(posedge vif.clk);
       if(vif.valid) break;
    end
    
    `uvm_info("my_monitor", "begin to collect one pkt", UVM_LOW);
    while(vif.valid) begin
       data_q.push_back(vif.data);
       @(posedge vif.clk);
    end
    data_size  = data_q.size();   
    data_array = new[data_size];
    for ( int i = 0; i < data_size; i++ ) begin
       data_array[i] = data_q[i]; 
    end
    tr.pload = new[data_size - 18]; //da sa, e_type, crc
    data_size = tr.unpack_bytes(data_array) / 8; 
    `uvm_info("my_monitor", "end collect one pkt", UVM_LOW);
 endtask
 