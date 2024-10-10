/////////////////////////////////////////////////////////////////////
//   								   //
//   		           Waited Transfer                         //
//                         (Bonus Task)                            //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2024 10xEngineers 	                   //
//             www.10xengineers.ai                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////
// FILE NAME      : waited_transfer_test.sv
// DESCRIPTION    : Verifies the waited transfer operation and Check
// DUT Response to IDLE Cycles ( Should Provide Okay Response )
// AUTHOR         : Noman Rafiq
// AUTHOR'S EMAIL : noman.rafiq@10xengineers.ai
// ------------------------------------------------------------------
// RELEASE HISTORY													 
// ------------------------------------------------------------------
// VERSION DATE        	AUTHOR         								 
// 1.0     2024-OCT-09  Noman Rafiq 						 		 
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
      HREADY.rand_mode(0);
      c_HREADY.constraint_mode(0);
      HTRANS.rand_mode(0);
      HADDR.rand_mode(0);
      
      HSIZE = 3'd2;
      
      case (cnt)
      
      // T0 - T1
      0 :       begin
        HADDR   = cnt;
        HBURST  = 3'd0;
        HREADY  = 1;
        HWRITE  = 1;
        HTRANS  = 2'd2;
      end
      
      // T1 - T2 ( Wait State )
      4 :       begin
        HADDR   = cnt;
        HWRITE  = 1;
        HREADY  = 0;
        HTRANS  = 2'd0;         // Insert IDLE Cycle
      end
      
      // T2 - T3 ( Wait State )
      8 :       begin
        HADDR   = cnt;
        HWRITE  = 1;
        
        HREADY  = 0;
        HTRANS  = 2'd0;         // Insert IDLE Cycle
      end
      
      // T3 - T4 - Initiate a Transfer with NONSEQ
      12 :      begin
        HADDR   = cnt;
        HWRITE  = 1;
        
        HREADY  = 0;
        HTRANS  = 2'd2;         // Insert NONSEQ Transfer Cycle
      end
      
      
      // T4 - T6 ( Must Keep HTRANS & HADDR constant since HREADY = 0 )
      16 :      begin
        HADDR   = cnt - 4;      // Keep ADDRESS constant
        HWRITE  = 1;
        
        HREADY  = 0;
        HTRANS  = 2'd2;         // Insert NONSEQ Transfer Cycle
      end
      
      // T5 - T6
      20 :      begin
        HADDR   = cnt - 8;      // Keep ADDRESS constant
        HWRITE  = 1;
        
        HREADY  = 1;
        HTRANS  = 2'd2;         // Insert NONSEQ Transfer Cycle
      end
      
      // T6 - T7
      24 :      begin
        HADDR   = cnt;
        HWRITE  = 0;
        
        HREADY  = 1;
        HTRANS  = 2'd2;         // Insert NONSEQ Transfer Cycle
      end
      endcase
      
      cnt = cnt + 4;            // For Word Operation
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
    env.gen.repeat_count 	                = 8;				// Set the repeat count of generator as 10, means to generate 10 packets
    env.run;									// Call run method for environment
  end
    
endprogram
