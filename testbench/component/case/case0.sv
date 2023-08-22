`ifndef __CASE0_SV
`define __CASE0_SV

`include "transaction_dut.sv"
`include "env.sv"

class case0_sequence extends uvm_sequence #(transaction_dut);
    transaction_dut m_trans;

    function  new(string name= "case0_sequence");
        super.new(name);
    endfunction 
 
    virtual task body();
        if(starting_phase != null) 
            starting_phase.raise_objection(this);
        repeat (10) begin
            `uvm_do_with(m_trans, { m_trans.pload.size() == 10;})
        end
        #100;
        if(starting_phase != null) 
            starting_phase.drop_objection(this);
    endtask
 
   `uvm_object_utils(case0_sequence)
endclass

class case0 extends uvm_test;
    my_env env;
   
    function new(string name = "case0", uvm_component parent = null);
        super.new(name,parent);
    endfunction 
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("case0", "case0 build_phase", UVM_LOW);
        env = my_env::type_id::create("env", this); 
        
        /* 1. use default_sequence */
        uvm_config_db#(uvm_object_wrapper)::set(this, "env.in_agt.sqr.main_phase", 
                                                "default_sequence", case0_sequence::type_id::get());
    endfunction

    virtual function void report_phase(uvm_phase phase); 
        uvm_report_server server;
        int err_num;
        string testname;
        $value$plusargs("TESTNAME=%s", testname);
        super.report_phase(phase);

        uvm_top.print_topology();
        server = get_report_server();
        err_num = server.get_severity_count(UVM_ERROR);
  
        if (err_num != 0) begin
            $display("--------------------------------------------------");
            $display("%s TestCase Failed!", testname);
            $display("--------------------------------------------------");
        end
        else begin
            $display("==================================================");
            $display("TestCase Passed: %s", testname);
            $display("==================================================");
        end
    endfunction
    `uvm_component_utils(case0)
endclass

`endif
 