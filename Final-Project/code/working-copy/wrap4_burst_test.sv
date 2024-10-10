/////////////////////////////////////////////////////////////////////
//   								   //
//   		        WRAP4 BURST Transfer                       //
//                         (Bonus Task)                            //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2024 10xEngineers 	                   //
//             www.10xengineers.ai                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////
// FILE NAME      : wrap4_burst_test.sv
// DESCRIPTION    : Verifies a write Transfer using a 4-beat WRAPPING 
// BURST Operation
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
  
    // Variable to manage write and read operations
    bit write_done;
    bit [7:0] wr_addr[0:3]; // Store addresses for WRAP4 Burst
    
    
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
      c_HADDR.constraint_mode(0);
      HTRANS.rand_mode(0);
      HADDR.rand_mode(0);
      
      HSIZE     = 3'd2;                 // WORD SIZED BURSTS
      
      
      if (!write_done) begin
        
        // Perform Write Operation
        HWRITE    = 1;
        HBURST    = 3'd2;               // WRAP4 BURST
        HREADY    = 1;
        
        case (cnt)
          // T0 - T1 (NONSEQ)
          8'h38 : begin
            HADDR   = cnt;
            HTRANS  = 2'd2;             // Start BURST with a NONSEQ Transfer
            wr_addr[0] = HADDR;         // Store address
          end
          
          // T1 - T2 (SEQ)
          8'h3C : begin
            HADDR   = cnt;
            HTRANS  = 2'd3;             // SEQ Transfer
            wr_addr[1] = HADDR;         // Store address
          end
          
          // T2 - T3 (SEQ)
          8'h40 : begin
            HADDR   = cnt - 16;         // Address = (0x30)
            HTRANS  = 2'd3;             // SEQ Transfer
            wr_addr[2] = HADDR;         // Store address
          end
          
          // T3 - T4 (SEQ)
          8'h44 : begin
            HADDR   = cnt - 16;         // ADDRESS = (0x34)
            HTRANS  = 2'd3;             // SEQ Transfer
            wr_addr[3] = HADDR;         // Store address
          end
          
          default: begin
            write_done = 1;             // Mark write as done
            cnt = 8'h34;                // Reset counter
          end
        endcase
      end
      
      else begin
        // Perform Read Operation after write
        HWRITE = 0;
        HREADY = 1;
        HBURST = 3'd2;                  // SINGLE BURST
        
        case (cnt)
          // Read from stored write addresses
          8'h38: begin 
          HADDR = wr_addr[0];
          HTRANS = 2'd2;                // NONSEQ READ
          end
          
          8'h3C: begin 
          HADDR = wr_addr[1];
          HTRANS = 2'd3;                // SEQ READ
          end
          
          8'h40: begin 
          HADDR = wr_addr[2];
          HTRANS = 2'd3;                // SEQ Read
          end
          
          8'h44: begin 
          HADDR = wr_addr[3];
          HTRANS = 2'd3;                // SEQ Read
          end
          
          default: write_done = 0;      // Reset after read
        endcase
      end
      
      cnt = cnt + 4;                    // For Word Operation
    endfunction

  endclass

  //////////////////////////////////////////////////////////////////
  //
  // Declaration
  //
  environment env;
  my_trans my_tr;

  initial begin
    my_tr 			= new();
    env 			= new(ahb_intf);        // Initialization
    env.gen.t 		        = my_tr;
    my_tr.cnt                   = 8'h38;
    env.gen.repeat_count 	= 10;	                // Set the repeat count of generator as 10
    env.run;						// Call run method for environment
  end
    
endprogram
