/////////////////////////////////////////////////////////////////////
//   							           //
//   		  	Generator Class                            //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2024 10xEngineers 	                   //
//             www.10xengineers.ai                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////
// FILE NAME      : generator.sv
// AUTHOR         : Noman Rafiq
// AUTHOR'S EMAIL : noman.rafiq@10xengineers.ai
// ------------------------------------------------------------------
// RELEASE HISTORY													 
// ------------------------------------------------------------------
// VERSION DATE        	AUTHOR         								 
// 1.0     2024-Sep-26  Noman Rafiq 						 		 
// ------------------------------------------------------------------

class generator;
  
  //////////////////////////////////////////////////////////////////
  //
  // Declarations
  //
  transaction t;	// Transaction
  mailbox gen2drv;	// Mailbox to share data with Driver
  event done;		// Event to Track Transactions
  int repeat_count;	// To Specify number of Transaction at run-time 
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Constructor
  //
  function new(mailbox gen2drv, event done);
    this.gen2drv = gen2drv;
    this.done	 = done;
    t = new();			// Blueprint Object
  endfunction
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Main Method
  //
  task main();
    repeat(repeat_count) begin
    if( !t.randomize() ) $fatal("Gen:: Transaction randomization Failed");      
      //t.print_trans();		// Print Transaction
      gen2drv.put(t.copy());
    end
    -> done;				// Trigger Event
  endtask
  
endclass
