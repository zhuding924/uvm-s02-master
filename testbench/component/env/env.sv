`ifndef __ENV_SV
`define __ENV_SV

`include "agent.sv"
`include "model.sv"
`include "scoreboard.sv"

class my_env extends uvm_env;

    my_agent   in_agt;
    my_agent   out_agt;
    my_model   mdl;
    my_scoreboard scb;
    
    uvm_tlm_analysis_fifo #(transaction_dut) agt_scb_fifo;
    uvm_tlm_analysis_fifo #(transaction_dut) agt_mdl_fifo;
    uvm_tlm_analysis_fifo #(transaction_dut) mdl_scb_fifo;
    
    function new(string name = "my_env", uvm_component parent);
       super.new(name, parent);
    endfunction
 
    virtual function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       in_agt = my_agent::type_id::create("in_agt", this);
       out_agt = my_agent::type_id::create("out_agt", this);
       in_agt.is_active = UVM_ACTIVE;
       out_agt.is_active = UVM_PASSIVE;
       mdl = my_model::type_id::create("mdl", this);
       scb = my_scoreboard::type_id::create("scb", this);
       agt_scb_fifo = new("agt_scb_fifo", this);
       agt_mdl_fifo = new("agt_mdl_fifo", this);
       mdl_scb_fifo = new("mdl_scb_fifo", this);
 
    endfunction
 
    extern virtual function void connect_phase(uvm_phase phase);
    
    `uvm_component_utils(my_env)
 endclass
 
 function void my_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    in_agt.ap.connect(agt_mdl_fifo.analysis_export);
    mdl.port.connect(agt_mdl_fifo.blocking_get_export);
    mdl.ap.connect(mdl_scb_fifo.analysis_export);
    scb.exp_port.connect(mdl_scb_fifo.blocking_get_export);
    out_agt.ap.connect(agt_scb_fifo.analysis_export);
    scb.act_port.connect(agt_scb_fifo.blocking_get_export); 
 endfunction

`endif
