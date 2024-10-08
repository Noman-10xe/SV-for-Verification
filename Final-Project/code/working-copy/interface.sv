/////////////////////////////////////////////////////////////////////
//   															   //
//   		  		 AHB-3 Lite Interface                          //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2024 10xEngineers 	                   //
//             www.10xengineers.ai                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////
// FILE NAME      : interface.sv
// AUTHOR         : Noman Rafiq
// AUTHOR'S EMAIL : noman.rafiq@10xengineers.ai
// ------------------------------------------------------------------
// RELEASE HISTORY													 
// ------------------------------------------------------------------
// VERSION DATE        	AUTHOR         								 
// 1.0     2024-Sep-25 	Noman Rafiq  						 		 
// ------------------------------------------------------------------

interface ahb3_lite #(
  parameter HADDR_SIZE = 32,
  parameter HDATA_SIZE = 32
)
(
  input logic HCLK, HRESETn
);
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Signals List
  //
  logic                       HSEL;
  logic      [HADDR_SIZE-1:0] HADDR;
  logic      [HDATA_SIZE-1:0] HWDATA;
  logic 	 [HDATA_SIZE-1:0] HRDATA;
  logic                       HWRITE;
  logic      [           2:0] HSIZE;
  logic      [           2:0] HBURST;
  logic      [           3:0] HPROT;
  logic      [           1:0] HTRANS;
  logic                  	  HREADYOUT;
  logic                  	  HREADY;
  logic                  	  HRESP;
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Driver Clocking Block
  //
  clocking cb_driver @(posedge HCLK);
  //default input #1 output #7;
  output                      HSEL;
  output      				  HADDR;
  output     				  HWDATA;
  input 	 				  HRDATA;
  output                      HWRITE;
  output     				  HSIZE;
  output     				  HBURST;
  output     				  HPROT;
  output     			      HTRANS;
  output					  HREADY;
  input                  	  HREADYOUT;
  input                  	  HRESP;
  endclocking
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Monitor Clocking Block
  //
  clocking cb_monitor @(posedge HCLK);
  //default input #1 output #7;
  input                       HSEL;
  input       				  HADDR;
  input      				  HWDATA;
  input		 				  HRDATA;
  input                       HWRITE;
  input      				  HSIZE;
  input      				  HBURST;
  input      				  HPROT;
  input      			      HTRANS;
  input                 	  HREADYOUT;
  input                  	  HREADY;
  input                  	  HRESP;
  endclocking
    
  
  //////////////////////////////////////////////////////////////////
  //
  // MODPORTS Definitions
  //
  modport DRIVER	(input HRESETn, input HCLK, clocking cb_driver); 	// Driver Modport
  modport MONITOR	(input HRESETn, input HCLK, clocking cb_monitor); 	// Monitor Modport

endinterface
