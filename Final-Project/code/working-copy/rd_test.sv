/////////////////////////////////////////////////////////////////////
//   															   //
//   		  		  Read Test Program                            //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2024 10xEngineers 	                   //
//             www.10xengineers.ai                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////
// FILE NAME      : wr_test.sv
// DESCRIPTION    : Verifies the Simple (Word) Read Test
// AUTHOR         : Noman Rafiq
// AUTHOR'S EMAIL : noman.rafiq@10xengineers.ai
// ------------------------------------------------------------------
// RELEASE HISTORY													 
// ------------------------------------------------------------------
// VERSION DATE        	AUTHOR         								 
// 1.0     2024-Sep-27  Noman Rafiq 						 		 
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
      HADDR.rand_mode(0);
      HBURST.rand_mode(0);
      HWDATA.rand_mode(0);
      HSIZE.rand_mode(0);
      HTRANS.rand_mode(0);
      HWRITE.rand_mode(0);
      
      
      HWRITE = 0;			// Read Operation
      
      HBURST	= 3'd0;
      HSIZE		= 3'd2;		// Word Size Transfers
      HTRANS	= 2'd2;

      
      // Write Operation
      if ( !HWRITE ) begin
      HADDR		= count;
	  count = count + 4;	// Word Sized Tranfers
//	  count = count + 2;	// Halfword Sized Tranfers
//	  count++;				// Byte Sized Tranfers
      end
      
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
    env.gen.t 				= my_tr;
    env.gen.repeat_count 	= 10;					// Set the repeat count of generator as 10, means to generate 10 packets
    env.run;										// Call run method for environment
  end
    
endprogram
