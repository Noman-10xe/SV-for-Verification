/////////////////////////////////////////////////////////////////////
//   							           //
//   			AHB3-Lite Memory Testbench                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2024 10xEngineers 	                   //
//             www.10xengineers.ai                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////
// FILE NAME      : testbench.sv
// AUTHOR         : Noman Rafiq
// AUTHOR'S EMAIL : noman.rafiq@10xengineers.ai
// ------------------------------------------------------------------
// RELEASE HISTORY													 
// ------------------------------------------------------------------
// VERSION DATE        	AUTHOR         								 
// 1.0     2024-Sep-25  Noman Rafiq 						 		 
// ------------------------------------------------------------------
// KEYWORDS : AMBA AHB3-Lite MEMORY TESTBENCH					 
// ------------------------------------------------------------------
// PURPOSE  : Verification of AHB3-Lite Memory						 
// ------------------------------------------------------------------

// Including Interface and Testcase Files
`include "interface.sv"

//-------------------------[NOTE]---------------------------------
// Particular testcase can be run by uncommenting, and commenting the rest
// `include "reset_test.sv"
// `include "rd_test.sv"
// `include "wr_test.sv"
// `include "random_wr_rd_test.sv"
// `include "word_wr_rd_test.sv"
// `include "halfword_wr_rd_test.sv"
// `include "byte_wr_rd_test.sv"
// `include "waited_transfer_test.sv"
 `include "wrap4_burst_test.sv"
//----------------------------------------------------------------


module tb_top;
  
  //////////////////////////////////////////////////////////////////
  //
  // Declarations
  //
  bit HCLK;
  bit HRESETn;
  
  always #5 HCLK = ~HCLK;							// clock generation
  ahb3_lite ahb_intf(.HCLK(HCLK), 
                     .HRESETn(HRESETn));			// Created instance of Interface
  test t1(ahb_intf);								// Testcase Instance, Interface handle is passed to test as an argument
  
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Design Instantiation
  //
  ahb3lite_sram1rw UUT (					// UUT Instance
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HSEL(ahb_intf.HSEL),
    .HADDR(ahb_intf.HADDR),
    .HWDATA(ahb_intf.HWDATA),
    .HRDATA(ahb_intf.HRDATA),
    .HWRITE(ahb_intf.HWRITE),
    .HSIZE(ahb_intf.HSIZE),
    .HBURST(ahb_intf.HBURST),
    .HPROT(ahb_intf.HPROT),
    .HTRANS(ahb_intf.HTRANS),
    .HREADYOUT(ahb_intf.HREADYOUT),
    .HREADY(ahb_intf.HREADY),
    .HRESP(ahb_intf.HRESP)
  );

  initial begin 
    $dumpvars;
    $dumpfile("dump.vcd"); 					// Enable the wave dump
  end
 
  initial begin    						// Reset Generation
    HRESETn 	= 0;
    repeat (2) @(posedge HCLK); 
    HRESETn 	= 1;
    repeat (100) @(posedge HCLK);
//     HRESETn 	= 0;
//     #10 
//     HRESETn 	= 1;
  end
endmodule
