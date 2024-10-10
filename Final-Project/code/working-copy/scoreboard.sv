/////////////////////////////////////////////////////////////////////
//   							           //
//   		       Scoreboard Class                            //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2024 10xEngineers 	                   //
//             www.10xengineers.ai                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////
// FILE NAME      : scoreboard.sv
// AUTHOR         : Noman Rafiq
// AUTHOR'S EMAIL : noman.rafiq@10xengineers.ai
// ------------------------------------------------------------------
// RELEASE HISTORY													 
// ------------------------------------------------------------------
// VERSION DATE        	AUTHOR         								 
// 1.0     2024-Sep-27  Noman Rafiq 						 		 
// ------------------------------------------------------------------


// Include Function Definitions
`include "others.sv"

//////////////////////////////////////////////////////////////////
//
// Class Definition
//
class scoreboard;  
  
  //////////////////////////////////////////////////////////////////
  //
  // Declarations
  //
  mailbox mon2sco;		// Mailbox
  int no_transactions;	        // To Track Number of Transactions
  bit	prev_reset;		// Stores Previous Value of Reset
  
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Constructor
  //
  function new(mailbox mon2sco);
    this.mon2sco = mon2sco;
    $readmemh("memory_init.mem", mem);			// Initialize Memory to a Known State
    
    /*																
     *	Only Enable rd_mem.mem if you are trying to run rd_test.    
     *																
     *	"rd_mem.mem" is a memory initialized to randomly generated	
     *	numbers so we can verify read operations.                  	
     *                                                             	
     *	[NOTE] :: Make sure to provide the DUT with the same 	  	
     *	Memory as Scoreboard for correct configuration. (INIT_FILE)	
     */

	//$readmemh("rd_mem.mem", mem);			// For rd_test Only
  
  endfunction
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Main Method
  //
  
  // Stores HWDATA and compare HRDATA with the stored data
  task main();
  transaction t;
  forever begin
    mon2sco.get(t);

    // Check if Reset is Asserted
    if (!t.HRESETn && prev_reset) begin
      $display("Local Memory Reset");
      $readmemh("memory_init.mem", mem);				// Initialize Memory to a Known State upon reset
    end else begin
      
      if (t.HREADY == 1'b1) begin 				        // Check if Master is READY
        $display("[SCB] :: Transfer Can be Initiated");

        if (t.HPROT == 4'd1) begin 					// Checks if HPROT == 1
          $display("[SCB] :: Protection is set to DATA ACCESS Only");

          if (t.HSEL == 1'b1) begin 					// Check if Slave is Selected for Transfer
            $display("[SCB] :: Slave has been Selected");

            // Transfer Type (HTRANS)            									
            if (t.HPROT == 4'd1) begin					// Perform Transfers when Data Access is Enabled
                htrans(t);
            end
  	    
  	    // BURST CASE
            if (t.HBURST == 3'd0 || t.HBURST == 3'd2 || t.HBURST == 3'd3) begin // Check the Type of BURST
                                                                                 // 0 (Single BURST), 2 (WRAP4), 3 (INCR4 BURST)
                burst(t);
            end
          end
        else $error("Slave has not been Selected");
        end
        no_transactions++;
      end
    end
    
    prev_reset = t.HRESETn;
    
//     $display("--------- [Scoreboard - %0d] Debug Data  ------", no_transactions);
//     $display("\t HADDR 	= 0x%0h", t.HADDR);
//     $display("\t HWDATA 	= 0x%0h", t.HWDATA);
//     $display("\t HRDATA 	= 0x%0h", t.HRDATA);
//     $display("\t HWRITE	= %0b", t.HWRITE);
//     $display("\t HSIZE 	= %0b", t.HSIZE);
//     $display("\t HBURST 	= %0b", t.HBURST);
//     $display("\t HPROT 	= %0b", t.HPROT);
//     $display("\t HTRANS	= %0b", t.HTRANS);
//     $display("\t HREADYOUT	= %0b", t.HREADYOUT);
//     $display("\t HREADY 	= %0b", t.HREADY);
//     $display("\t HRESP 	= %0b", t.HRESP);
//     $display("\t HSEL 	= %0b", t.HSEL);
//     $display("\t HRESETn 	= %0b", t.HRESETn);
//     $display("\t prev_reset  = %0b", prev_reset);
//     $display("\t no_transactions 	= %0d", no_transactions);
//     $display("---------------------------------------------\n");
    end
endtask
endclass
