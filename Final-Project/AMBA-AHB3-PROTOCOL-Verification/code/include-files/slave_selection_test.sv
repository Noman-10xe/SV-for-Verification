/////////////////////////////////////////////////////////////////////
//   								   //
//   		        Slave Selection Test                       //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2024 10xEngineers 	                   //
//             www.10xengineers.ai                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////
// FILE NAME      : slave_selection_test.sv
// DESCRIPTION    : Verifies the selection bit functionality of AHB3
// Lite Protocol
// AUTHOR         : Noman Rafiq
// AUTHOR'S EMAIL : noman.rafiq@10xengineers.ai
// ------------------------------------------------------------------
// RELEASE HISTORY													 
// ------------------------------------------------------------------
// VERSION DATE        	AUTHOR         								 
// 1.0     2024-OCT-10  Noman Rafiq 						 		 
// ------------------------------------------------------------------

`include "environment.sv"

//////////////////////////////////////////////////////////////////
//
// Program Definition
//
program test(ahb3_lite ahb_intf);
  
  class my_trans extends transaction;
    
    bit [7:0] count;
    
    
    //////////////////////////////////////////////////////////////////
    //
    // Pre-Randomize Function
    //
    function void pre_randomize();
      HWRITE.rand_mode(0);
      HBURST.rand_mode(0);
      HSIZE.rand_mode(0);
      HSEL.rand_mode(0);
      c_HSEL.constraint_mode(0);

      HBURST	= 3'd0;		// SINGLE BURST Operation
      HSIZE	= 3'd2;		// Word Sized Transfers
      HSEL      = 0;            // No slave Selected
      
      // Write Operation
      if(cnt % 8 == 0) begin
        HWRITE = 1;
      end
      
      // Read Operation
      else begin
        HWRITE = 0;
      end
      
      cnt = cnt + 4;            // For Word Operation
//    cnt = cnt + 2;            // For Halfword Operation
//    cnt++;                    // For Byte Operation
    endfunction
  
  endclass
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Declaration
  //
  environment env;
  my_trans my_tr;
  
  initial begin
    my_tr 					= new();
    env 					= new(ahb_intf);		// Initialization
    env.gen.t 				        = my_tr;
    env.gen.repeat_count 	                = 20;				// Set the repeat count of generator as 10, means to generate 20 packets
    env.run;									// Call run method for environment
  end
    
endprogram
