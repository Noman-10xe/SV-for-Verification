/////////////////////////////////////////////////////////////////////
//   															   //
//   		  			  Monitor Class                            //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2024 10xEngineers 	                   //
//             www.10xengineers.ai                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////
// FILE NAME      : monitor.sv
// AUTHOR         : Noman Rafiq
// AUTHOR'S EMAIL : noman.rafiq@10xengineers.ai
// ------------------------------------------------------------------
// RELEASE HISTORY													 
// ------------------------------------------------------------------
// VERSION DATE        	AUTHOR         								 
// 1.0     2024-Sep-27  Noman Rafiq 						 		 
// ------------------------------------------------------------------


//////////////////////////////////////////////////////////////////
//
// Macro Definition for Using Clocking Block for Sampling Inputs w.r.t to DUT
//
`define MON_IF ahb_vif.MONITOR.cb_monitor


//////////////////////////////////////////////////////////////////
//
// Class Definition
//
class monitor;
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Declarations
  //
  virtual ahb3_lite ahb_vif;	// Virtual Interface Handle
  mailbox mon2sco;				// Mailbox
  int no_transactions;			// Track Number of Transactions

  
  //////////////////////////////////////////////////////////////////
  //
  // Constructor
  //
  function new(virtual ahb3_lite ahb_vif, mailbox mon2sco);
    this.ahb_vif			= ahb_vif;
    this.mon2sco		   	= mon2sco;
  endfunction
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Main Method
  //
  task main();
    
    forever begin
      transaction t;
      t = new();
      
      t.HRESETn		= ahb_vif.MONITOR.HRESETn;	// Assign Value to HRESETn for Testing

      @(posedge ahb_vif.MONITOR.HCLK);
      
      // Get Values from the Interface and put into mailbox on the clock
      t.HREADY  	= `MON_IF.HREADYOUT;		// HREADYOUT will DRIVE the HREADY SIGNAL
      t.HADDR  		= `MON_IF.HADDR; 
      t.HSIZE		= `MON_IF.HSIZE;
      t.HBURST		= `MON_IF.HBURST;
      t.HPROT		= `MON_IF.HPROT;
      t.HTRANS		= `MON_IF.HTRANS;
      t.HSEL		= `MON_IF.HSEL;
      //t.HWRITE 		= `MON_IF.HWRITE;
      
      // Transfer Response
      t.HREADYOUT  	= `MON_IF.HREADYOUT;
      t.HRESP  		= `MON_IF.HRESP;
      
      // Write Case
      wait(`MON_IF.HWRITE || !`MON_IF.HWRITE);
      if (`MON_IF.HWRITE) begin
		t.HWDATA = `MON_IF.HWDATA;       
        t.HWRITE = `MON_IF.HWRITE;
        @(posedge ahb_vif.MONITOR.HCLK);
      end
      
      // else Read Case
      else begin
      	t.HWRITE = `MON_IF.HWRITE;
        @(posedge ahb_vif.MONITOR.HCLK);
        t.HRDATA = `MON_IF.HRDATA;				// Slave Responds with value on next clock
        end      
        mon2sco.put(t);
      
	$display("--------- [Monitor - %0d] Parsed Data  ------", no_transactions);
    $display("\t HADDR 		= 0x%0h", t.HADDR);
    $display("\t HWDATA 	= 0x%0h", t.HWDATA);
    $display("\t HRDATA 	= 0x%0h", t.HRDATA);
    $display("\t HWRITE		= %0b", t.HWRITE);
    $display("\t HSIZE 		= %0b", t.HSIZE);
    $display("\t HBURST 	= %0b", t.HBURST);
    $display("\t HPROT 		= %0b", t.HPROT);
    $display("\t HTRANS		= %0b", t.HTRANS);
    $display("\t HREADYOUT	= %0b", t.HREADYOUT);
    $display("\t HREADY 	= %0b", t.HREADY);
    $display("\t HRESP 		= %0b", t.HRESP);
    $display("\t HSEL 		= %0b", t.HSEL);
    $display("\t HRESETn 	= %0b", t.HRESETn);
    $display("\t no_transactions 	= %0d", no_transactions);
    
    $display("---------------------------------------------\n");
      no_transactions++;

    end
  endtask 
endclass
