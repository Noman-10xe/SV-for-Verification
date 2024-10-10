/////////////////////////////////////////////////////////////////////
//   			                                           //
//   		  	     Environment Class                     //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2024 10xEngineers 	                   //
//             www.10xengineers.ai                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////
// FILE NAME      : environment.sv
// AUTHOR         : Noman Rafiq
// AUTHOR'S EMAIL : noman.rafiq@10xengineers.ai
// ------------------------------------------------------------------
// RELEASE HISTORY													 
// ------------------------------------------------------------------
// VERSION DATE        	AUTHOR         								 
// 1.0     2024-Sep-27  Noman Rafiq 						 		 
// ------------------------------------------------------------------

`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"


//////////////////////////////////////////////////////////////////
//
// Class Definition
//
class environment;
  
  //////////////////////////////////////////////////////////////////
  //
  // Declarations
  //
  generator  gen;				// Handles for Testbench Components
  driver     drv;
  monitor    mon;
  scoreboard sco;
  				
  mailbox gen2drv;				// Mailbox Handles
  mailbox mon2sco;
  
  event done;					// Event for Synchronization between generator and test
  
  virtual ahb3_lite ahb_vif;	                // Virtual Interface
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Constructor
  //
  function new(virtual ahb3_lite ahb_vif);
    
    this.ahb_vif = ahb_vif;		        // Pass the actual interface from test
    
    // Initialization
    gen2drv	= new();
    mon2sco = new();
    gen 	= new(gen2drv,done);
    drv		= new(ahb_vif,gen2drv);
    mon 	= new(ahb_vif,mon2sco);
    sco 	= new(mon2sco);
    
  endfunction
  
  
  //////////////////////////////////////////////////////////////////
  //
  // 	Test Methods
  //
  // 1. pre_test()
  task pre_test();
    drv.reset();
  endtask
  
  // 2. test()
  task test();
    fork 
    gen.main();
    drv.main();
    mon.main();
    sco.main();      
    join_any
    
  endtask
  
  // 3. post_test()
  task post_test();
    wait(done.triggered);
    wait(gen.repeat_count == drv.no_transactions);
    wait(gen.repeat_count == mon.no_transactions);
    wait(gen.repeat_count == sco.no_transactions);
  endtask  
    
  // 4. Test Task
//   task test(input transaction[] user_sequence);
//     gen.set_sequence(user_sequence);  // Set user-defined sequence to generator
    
//     fork 
//       gen.main();
//       drv.main();
//       mon.main();
//       sco.main();      
//     join_any
//   endtask
  
  
  //////////////////////////////////////////////////////////////////
  //
  // 	Run Method
  //
  task run;
    pre_test();
    test();
    post_test();
    $finish;
    
  endtask
  
endclass
