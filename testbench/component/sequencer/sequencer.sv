class my_sequencer extends uvm_sequencer #(transaction_dut);
   
    function new(string name, uvm_component parent);
       super.new(name, parent);
    endfunction 
    
    `uvm_component_utils(my_sequencer)
 endclass