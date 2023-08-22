class case2_sequence extends uvm_sequence #(transaction_dut);
    transaction_dut m_trans;

    function  new(string name= "case2_sequence");
        super.new(name);
    endfunction 
 
    virtual task body();
 
        repeat (10) begin
            `uvm_do_with(m_trans, { m_trans.pload.size() == 10;})
        end
        #100;
 
    endtask
 
   `uvm_object_utils(case2_sequence)
endclass

class case2 extends uvm_test;
    my_env env;
   
    function new(string name = "case2", uvm_component parent = null);
        super.new(name,parent);
    endfunction 
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("case2", "case2 build_phase", UVM_LOW);
        env = my_env::type_id::create("env", this); 
         
    endfunction

    virtual task main_phase(uvm_phase phase);
        /* 3. not use default_sequence, in addition set objection raise and drop in this */
        case2_sequence seq;
        phase.raise_objection(this);
        seq = case2_sequence::type_id::create("seq");
        seq.starting_phase = phase;
        seq.start(env.in_agt.sqr);
        phase.drop_objection(this);
    endtask 

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
    `uvm_component_utils(case2)
endclass


 