/////////////////////////////////////////////////////////////////////
//   								   //
//   		           Driver Class                            //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2024 10xEngineers 	                   //
//             www.10xengineers.ai                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////
// FILE NAME      : driver.sv
// AUTHOR         : Noman Rafiq
// AUTHOR'S EMAIL : noman.rafiq@10xengineers.ai
// ------------------------------------------------------------------
// RELEASE HISTORY													 
// ------------------------------------------------------------------
// VERSION DATE        	AUTHOR         								 
// 1.0     2024-Sep-26  Noman Rafiq 						 		 
// ------------------------------------------------------------------

//////////////////////////////////////////////////////////////////
//
// Macro Definition for Using Clocking Block for Driving Inputs 
// w.r.t to TESTBENCH
//
`define DRIV_IF ahb_vif.DRIVER.cb_driver

class driver;
  
  //////////////////////////////////////////////////////////////////
  //
  // Declarations
  //
  virtual ahb3_lite ahb_vif;	        // Virtual Interface Handle
  mailbox gen2drv;
  int no_transactions;			// Track Number of Transactions driven to DUT

  
  //////////////////////////////////////////////////////////////////
  //
  // Constructor
  //
  function new(virtual ahb3_lite ahb_vif, mailbox gen2drv);
    this.ahb_vif = ahb_vif;
    this.gen2drv = gen2drv;
  endfunction
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Reset Method
  //
  task reset();
    wait(!ahb_vif.DRIVER.HRESETn);		// Wait for an Active-Low Resetn Signal => 0
    
    $display("--------- [DRIVER] Reset Started ---------");
    `DRIV_IF.HSEL 	<= 0;
    `DRIV_IF.HADDR 	<= 0;
    `DRIV_IF.HWDATA 	<= 0;
    `DRIV_IF.HWRITE 	<= 0;
    `DRIV_IF.HSIZE 	<= 0;
    `DRIV_IF.HBURST 	<= 0;
    `DRIV_IF.HPROT 	<= 0;
    `DRIV_IF.HTRANS    	<= 0;			// IDLE State HTRANS[1:0] = 2'b00
    `DRIV_IF.HREADY 	<= 0;			// Ready for Next Transfer
    
    wait(ahb_vif.DRIVER.HRESETn);		// Wait for Resetn to be de-asserted => (1)
    
    $display("--------- [DRIVER] Reset Ended ---------");
  endtask
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Drive Method
  //
  task drive();
    transaction trans;
    gen2drv.get(trans);
    $display("--------- [DRIVER-TRANSFER: %0d] ---------",no_transactions);

    // Check for HRESETn
    if (!ahb_vif.DRIVER.HRESETn) begin
      $display("[DRIVER] :: Intermediate RESET = %0d", ahb_vif.DRIVER.HRESETn);
      reset();						// Call Reset method if reset is asserted while driving
    end
    
    @(posedge ahb_vif.DRIVER.HCLK);
    // Pass Values to Interface from Transaction on Clock Cycle
    `DRIV_IF.HREADY     <= trans.HREADY;
    `DRIV_IF.HSEL       <= trans.HSEL;			// HSEL always 1 to initiate a transfer
    `DRIV_IF.HADDR      <= trans.HADDR;
    `DRIV_IF.HSIZE 	<= trans.HSIZE;
    `DRIV_IF.HBURST     <= trans.HBURST;
    `DRIV_IF.HPROT 	<= trans.HPROT;
    `DRIV_IF.HTRANS     <= trans.HTRANS;
    
    // Write Operation
    if(trans.HWRITE) begin
    @(posedge ahb_vif.DRIVER.HCLK);             // Synchronization
    `DRIV_IF.HWDATA <= trans.HWDATA;
    `DRIV_IF.HWRITE <= trans.HWRITE;
    //@(posedge ahb_vif.DRIVER.HCLK);             // Synchronization    
    end
    
    // Read Operation
    else begin
    `DRIV_IF.HWRITE <= trans.HWRITE;
    @(posedge ahb_vif.DRIVER.HCLK);
    //`DRIV_IF.HWRITE <= trans.HWRITE;      // Update HWRITE so Driver doesn't keep driving HWRITE = 0 (Read Operation)
    trans.HRDATA = `DRIV_IF.HRDATA;
    end
    
    

    $display("--------- [Driver - %0d] Driven Data  ------", no_transactions);
    $display("\t HADDR 		= 0x%0h", trans.HADDR);
    $display("\t HWDATA 	= 0x%0h", trans.HWDATA);
    $display("\t HRDATA 	= 0x%0h", trans.HRDATA);
    $display("\t HWRITE		= %0b", trans.HWRITE);
    $display("\t HSIZE 		= %0b", trans.HSIZE);
    $display("\t HBURST 	= %0b", trans.HBURST);
    $display("\t HPROT 		= %0b", trans.HPROT);
    $display("\t HTRANS		= %0b", trans.HTRANS);
    $display("\t HREADYOUT	= %0b", trans.HREADYOUT);
    $display("\t HREADY 	= %0b", trans.HREADY);
    $display("\t HRESP 		= %0b", trans.HRESP);
    $display("\t HSEL 		= %0b", trans.HSEL);
    $display("\t HRESETn 	= %0b", trans.HRESETn);
    $display("\t no_transactions 	= %0d", no_transactions);
    
    $display("---------------------------------------------\n");
    no_transactions++;
    
  endtask
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Main Method
  //
  task main();
//     forever begin
//     wait(!ahb_vif.DRIVER.HRESETn);			// Waiting for negative edge of reset
//     drive();
//     end
    
    forever begin
      fork
          begin							
            wait(!ahb_vif.DRIVER.HRESETn);		//Thread-1: Waiting for reset
          end
        begin				        	//Thread-2: Calling drive task
          forever
            drive();
        end
      join_any
      disable fork;				        // Stops driving Transactions if reset thread completes
    end
  endtask
  
endclass
