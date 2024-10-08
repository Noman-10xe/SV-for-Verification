/////////////////////////////////////////////////////////////////////
//   															   //
//   		  		 Write/Read Test Program					   //
//							(Bonus Task)						   //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2024 10xEngineers 	                   //
//             www.10xengineers.ai                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////
// FILE NAME      : wr_rd_test.sv
// DESCRIPTION    : Verifies the Alternate (Word) WRITE/READ Test to 
// the same address
// AUTHOR         : Noman Rafiq
// AUTHOR'S EMAIL : noman.rafiq@10xengineers.ai
// ------------------------------------------------------------------
// RELEASE HISTORY													 
// ------------------------------------------------------------------
// VERSION DATE        	AUTHOR         								 
// 1.0     2024-Oct-03  Noman Rafiq 						 		 
// ------------------------------------------------------------------

`include "environment.sv"

//////////////////////////////////////////////////////////////////
//
// Program Definition
//
program test(ahb3_lite ahb_intf);
  
  class my_trans extends transaction;

    // Write Pointer
	static int wr_ptr	= 0;
      
	// Read Pointer
	static int rd_ptr	= 0;
    
    
    //////////////////////////////////////////////////////////////////
	//
	// Pre-Randomize Function
	//
    function void pre_randomize();
      HADDR.rand_mode(0);
      HBURST.rand_mode(0);
      HSIZE.rand_mode(0);
      HTRANS.rand_mode(0);
      HWRITE.rand_mode(0);
      
      
      HBURST	= 3'd0;
      HSIZE		= 3'd2;
      HTRANS	= 2'd2;
      
      
      // Write Operation
      if ( cnt % 8 == 0 ) begin
        HWRITE	= 1;
        HADDR	= wr_ptr;
        wr_ptr 	= wr_ptr + 4;	// Update Write Pointer (Word)
      end

      // Read Operation
      else begin
      	HWRITE	= 0;
        HADDR	= rd_ptr;
        rd_ptr 	= rd_ptr + 4;	// Update Read Pointer (Word)
      end
      
      cnt = cnt+4;
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
