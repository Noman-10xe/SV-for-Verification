/////////////////////////////////////////////////////////////////////
//   								   //
//   		  	Transaction Class                          //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2024 10xEngineers 	                   //
//             www.10xengineers.ai                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////
// FILE NAME      : transaction.sv
// AUTHOR         : Noman Rafiq
// AUTHOR'S EMAIL : noman.rafiq@10xengineers.ai
// ------------------------------------------------------------------
// RELEASE HISTORY													 
// ------------------------------------------------------------------
// VERSION DATE        	AUTHOR         								 
// 1.0     2024-Sep-26  Noman Rafiq 						 		 
// ------------------------------------------------------------------

class transaction #(
  parameter HADDR_SIZE = 32,
  parameter HDATA_SIZE = 32
);
  
  bit		 [	7:0] cnt;		// For Testing Purposes
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Radnomized Signals List
  //
  rand bit   [HADDR_SIZE-1:0] HADDR;		// Address of transaction needs to be Randomized
  rand bit   [HDATA_SIZE-1:0] HWDATA;		// Write Data needs to be randomized
  randc bit                   HWRITE;		// Need to be randomized (R/W Operations)
  rand bit   [           2:0] HBURST;		// HBURST needs to be randomized
  rand bit   [           2:0] HSIZE;		// Transfer Size need to be randomized
  rand bit   [           3:0] HPROT;		// HPROT need to randomized
  rand bit                    HSEL;		// Selects a particular Slave
  rand bit   [           1:0] HTRANS;		// HTRANS/Transfer type need randomization
  rand bit	              HREADY;	        // Transfer Ready Signal
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Non-Radnomized Signals List
  //
  bit 	     [HDATA_SIZE-1:0] HRDATA;		// Read-Data need not to be randomized
  
  // Transfer Response
  bit 	                      HRESP;		// Response Signal
  bit                  	      HREADYOUT;	// Slave's Ready Signal
  
  // Reset for Testing Purposes
  rand bit		      HRESETn;
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Constraints
  //
  
  // 1. HBURST
  constraint c_HBURST {
    HBURST inside {0, [2:3]};		// SINGLE, 4-beat WRAP BURST, and 4-Beat INCR BURST
  }
    
  // 2. HADDR
  constraint c_HADDR {
    solve HSIZE before HADDR;		// Evaluate HADDR based on the outcome of HSIZE
    
    HADDR inside {[0:255]};		// Constraint Addresses to only 256 words
    
    if (HSIZE == 1) {  			// Align for half-word transfers
        HADDR % 2 == 0;
    } 
    else if (HSIZE == 2) {  		// Align for word transfers
        HADDR % 4 == 0;
    }
      }
  
  // 3. HPROT
  constraint c_HPROT {
    HPROT == 4'd1;			// Protection for Data-Access Only
  }
  
  // 4. HSIZE
  constraint c_HSIZE {
    HSIZE inside {[0:2]};	        // Use only Byte, Half-word and Word Transfers
  }
      
  // 5. HSIZE
  constraint c_HSEL {
    HSEL == 1;	   		        // Selects slave
  }
  
  // 6. HREADY
  constraint c_HREADY {
    HREADY == 1;	   	        // Ready for Transfer
  }
      
  // 7. HRESETn
//   constraint c_HRESETn {
//     HRESETn == 1'b1;			// Default Value
//   }
      
  
  //////////////////////////////////////////////////////////////////
  //
  // Methods
      
  // 1. Print Transaction Method to display randomized values of items 
  function void print_trans();
    $display("--------- [Generator] Randomized Data  ------");
    $display("\t HADDR 		= 0x%0h", HADDR);
    $display("\t HWDATA 	= 0x%0h", HWDATA);
    $display("\t HRDATA 	= 0x%0h", HRDATA);
    $display("\t HWRITE		= %0b", HWRITE);
    $display("\t HSIZE 		= %0b", HSIZE);
    $display("\t HBURST 	= %0b", HBURST);
    $display("\t HPROT 		= %0b", HPROT);
    $display("\t HTRANS		= %0b", HTRANS);
    $display("\t HREADYOUT	= %0b", HREADYOUT);
    $display("\t HREADY 	= %0b", HREADY);
    $display("\t HRESP 		= %0b", HRESP);
    $display("\t HSEL 		= %0b", HSEL);
    $display("---------------------------------------------\n");
  endfunction
    
  // 2. Copy Transaction Method to copy transaction 
  function transaction copy();
    transaction trans;
    trans = new();
    
  	trans.HADDR	= this.HADDR;
  	trans.HWDATA	= this.HWDATA;
  	trans.HWRITE	= this.HWRITE;
  	trans.HBURST	= this.HBURST;
  	trans.HSIZE	= this.HSIZE;
  	trans.HPROT	= this.HPROT;
  	trans.HSEL	= this.HSEL;
  	trans.HRDATA	= this.HRDATA;
  	trans.HTRANS	= this.HTRANS;
  	trans.HREADY	= this.HREADY;
  	trans.HRESP	= this.HRESP;
  	trans.HREADYOUT	= this.HREADYOUT;
    
    return trans;
  endfunction
    
endclass
