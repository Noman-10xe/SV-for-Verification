/////////////////////////////////////////////////////////////////////
//   								   //
//   		      Function Definitions                         //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2024 10xEngineers 	                   //
//             www.10xengineers.ai                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////
// FILE NAME      : others.sv
// AUTHOR         : Noman Rafiq
// AUTHOR'S EMAIL : noman.rafiq@10xengineers.ai
// ------------------------------------------------------------------
// RELEASE HISTORY													 
// ------------------------------------------------------------------
// VERSION DATE        	AUTHOR         								 
// 1.0     2024-Oct-01  Noman Rafiq 						 		 
// ------------------------------------------------------------------

	bit [31:0] mem[256];	// A Local Memory of 256 Words

	/* 	Definitions for the following Functions
         * 	1. READ(transaction t)
         *	2. WRITE(transaction t)
         */

    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Function Definitions (To be Used in Scoreboard)
    //

    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // 1. WRITE Operation	( Assuming Big Endian )
    //

    task WRITE(transaction t);	
      
      case (t.HSIZE)
        /*	HSIZE == 3'b0 - BYTE Case */
        3'd0 : begin
          if (t.HADDR[1:0] == 2'b00) begin			        // 0th Byte
            mem[t.HADDR[31:2]][7:0]	= t.HWDATA[7:0];	        // Updated Local Memory for Comparison
            
            if ( t.HWDATA[7:0] == mem[t.HADDR[31:2]][7:0] )
              $display ("[SCB-PASS] :: (BYTE) WRITE OPERATION :: Expected = %0h, Actual = %0h", mem[t.HADDR[31:2]][7:0], t.HWDATA[7:0]);
            else
              $display ("[SCB-FAIL] :: (BYTE) WRITE OPERATION :: Expected = %0h, Actual = %0h", mem[t.HADDR[31:2]][7:0], t.HWDATA[7:0]);
          end
          
          else if (t.HADDR[1:0] == 2'b01) begin			        // 1st Byte
            mem[t.HADDR[31:2]][15:8]	= t.HWDATA[15:8];	        // Updated Local Memory for Comparison
            
            if ( t.HWDATA[15:8] == mem[t.HADDR[31:2]][15:8] )
              $display ("[SCB-PASS] :: (BYTE) WRITE OPERATION :: Expected = %0h, Actual = %0h", mem[t.HADDR[31:2]][15:8], t.HWDATA[15:8]);
            else
              $display ("[SCB-FAIL] :: (BYTE) WRITE OPERATION :: Expected = %0h, Actual = %0h", mem[t.HADDR[31:2]][15:8], t.HWDATA[15:8]);
          end
          
          else if (t.HADDR[1:0] == 2'b10) begin			        // 2nd Byte
            mem[t.HADDR[31:2]][23:16]	= t.HWDATA[23:16];		// Updated Local Memory for Comparison
            
            if ( t.HWDATA[23:16] == mem[t.HADDR[31:2]][23:16] )
              $display ("[SCB-PASS] :: (BYTE) WRITE OPERATION :: Expected = %0h, Actual = %0h", mem[t.HADDR[31:2]][23:16], t.HWDATA[23:16]);
            else
              $display ("[SCB-FAIL] :: (BYTE) WRITE OPERATION :: Expected = %0h, Actual = %0h", mem[t.HADDR[31:2]][23:16], t.HWDATA[23:16]);
          end
          
          else if (t.HADDR[1:0] == 2'b11) begin				// 3rd Byte
            mem[t.HADDR[31:2]][31:24]	= t.HWDATA[31:24];		// Updated Local Memory for Comparison
            
            if ( t.HWDATA[31:24] == mem[t.HADDR[31:2]][31:24] )
              $display ("[SCB-PASS] :: (BYTE) WRITE OPERATION :: Expected = %0h, Actual = %0h", mem[t.HADDR[31:2]][31:24], t.HWDATA[31:24]);
            else
              $display ("[SCB-FAIL] :: (BYTE) WRITE OPERATION :: Expected = %0h, Actual = %0h", mem[t.HADDR[31:2]][31:24], t.HWDATA[31:24]);
          end
        end
		
        /*	HSIZE == 3'd1 - Halfword Case */
        3'd1 : begin
          
          if (t.HADDR[1] == 1'b0) begin			 		// 0th Halfword
            mem[t.HADDR[31:2]][15:0] = t.HWDATA[15:0];			// Updated Local Memory for Comparison
            //$readmemh("memory_init.mem", mem);
                        
            if ( t.HWDATA[15:0] == mem[t.HADDR[31:2]][15:0] )
              $display ("[SCB-PASS] :: (HALFWORD) WRITE OPERATION :: Expected = %0h, Actual = %0h", mem[t.HADDR[31:2]][15:0], t.HWDATA[15:0]);
            else
              $display ("[SCB-FAIL] :: (HALFWORD) WRITE OPERATION :: Expected = %0h, Actual = %0h", mem[t.HADDR[31:2]][15:0], t.HWDATA[15:0]);
          end
          
          else if (t.HADDR[1] == 1'b1) begin				// 1st Halfword	(Addresses Multiple of 2)
            mem[t.HADDR[31:2]][31:16] = t.HWDATA[31:16];		// Updated Local Memory for Comparison
            //$readmemh("memory_init.mem", mem);
            
            if ( t.HWDATA[31:16] == mem[t.HADDR[31:2]][31:16] )
              $display ("[SCB-PASS] :: (HALFWORD) WRITE OPERATION :: Expected = %0h, Actual = %0h", mem[t.HADDR[31:2]][31:16], t.HWDATA[31:16]);
            else
              $display ("[SCB-FAIL] :: (HALFWORD) WRITE OPERATION :: Expected = %0h, Actual = %0h", mem[t.HADDR[31:2]][31:16], t.HWDATA[31:16]);
          end
            
        end
        
 	/*	HSIZE == 3'd2 - Word Case */
       	3'd2 : begin
          
            mem[t.HADDR[31:2]]	=	 t.HWDATA;		        // Updated Local Memory for Comparison
            
            if ( t.HWDATA == mem[t.HADDR[31:2]] )
              $display ("[SCB-PASS] :: (WORD) WRITE OPERATION :: Expected = %0h, Actual = %0h", mem[t.HADDR[31:2]], t.HWDATA);
            else
              $display ("[SCB-FAIL] :: (WORD) WRITE OPERATION :: Expected = %0h, Actual = %0h", mem[t.HADDR[31:2]], t.HWDATA);
        end
          
        default:	$display("HSZIE Should be BYTE, Half-Word or Word Size Only");
      endcase
      
    endtask
          

          
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // 2. READ Operation        ( Assuming Big Endian ) 
    //
          
	task READ(transaction t);	
      bit	[31		:0]     temp;	        // Temp Variable for comparison
      
      case (t.HSIZE)
        
        /*	HSIZE == 3'b0 - BYTE Case */
        3'd0 : begin
          if (t.HADDR[1:0] == 2'b00) begin		// 0th Byte
            temp = mem[t.HADDR[31:2]][7:0];		// Read Value from Local Memory and store in temp
            
            if ( t.HRDATA[7:0] == temp )
              $display ("[SCB-PASS] :: (BYTE) READ OPERATION :: Expected = %0h, Actual = %0h", temp, t.HRDATA[7:0]);
            else
              $display ("[SCB-FAIL] :: (BYTE) READ OPERATION :: Expected = %0h, Actual = %0h", temp, t.HRDATA[7:0]);
          end
          
          else if (t.HADDR[1:0] == 2'b01) begin		// 1st Byte
            temp = mem[t.HADDR[31:2]][15:8];		// Updated Local Memory for Comparison
            
            if ( t.HRDATA[15:8] == temp )
              $display ("[SCB-PASS] :: (BYTE) READ OPERATION :: Expected = %0h, Actual = %0h", temp, t.HRDATA[15:8]);
            else
              $display ("[SCB-FAIL] :: (BYTE) READ OPERATION :: Expected = %0h, Actual = %0h", temp, t.HRDATA[15:8]);
          end
          
          else if (t.HADDR[1:0] == 2'b10) begin		// 2nd Byte
            temp = mem[t.HADDR[31:2]][23:16];		// Read Value from Local Memory and store in temp
            
            if ( t.HRDATA[23:16] == temp )
              $display ("[SCB-PASS] :: (BYTE) READ OPERATION :: Expected = %0h, Actual = %0h", temp, t.HRDATA[23:16]);
            else
              $display ("[SCB-FAIL] :: (BYTE) READ OPERATION :: Expected = %0h, Actual = %0h", temp, t.HRDATA[23:16]);
          end
          
          else if (t.HADDR[1:0] == 2'b11) begin		// 3rd Byte
            temp = mem[t.HADDR[31:2]][31:24];	        // Read Value from Local Memory and store in temp
            
            if ( t.HRDATA[31:24] == temp )
              $display ("[SCB-PASS] :: (BYTE) READ OPERATION :: Expected = %0h, Actual = %0h", temp, t.HRDATA[31:24]);
            else
              $display ("[SCB-FAIL] :: (BYTE) READ OPERATION :: Expected = %0h, Actual = %0h", temp, t.HRDATA[31:24]);
          end
        end
		
        /*	HSIZE == 3'd1 - Halfword Case */
        3'd1 : begin
          
          if (t.HADDR[1] == 1'b0) begin			// 0th Halfword
            temp = mem[t.HADDR[31:2]][15:0];		// Read Value from Local Memory and store in temp
            
            if ( t.HRDATA[15:0] == temp )
              $display ("[SCB-PASS] :: (HALFWORD) READ OPERATION :: Expected = %0h, Actual = %0h", temp, t.HRDATA[15:0]);
            else
              $display ("[SCB-FAIL] :: (HALFWORD) READ OPERATION :: Expected = %0h, Actual = %0h", temp, t.HRDATA[15:0]);
          end
          
          else if (t.HADDR[1] == 1'b1) begin		// 1st Halfword	(Addresses Multiple of 2)
            
            temp = mem[t.HADDR[31:2]][31:16];		// Read Value from Local Memory and store in temp
            
            if ( t.HRDATA[31:16] == temp )
              $display ("[SCB-PASS] :: (HALFWORD) READ OPERATION :: Expected = %0h, Actual = %0h", temp, t.HRDATA[31:16]);
            else
              $display ("[SCB-FAIL] :: (HALFWORD) READ OPERATION :: Expected = %0h, Actual = %0h", temp, t.HRDATA[31:16]);
          end
        end
        
 	/*	HSIZE == 3'd2 - Word Case */
       	3'd2 : begin
          
          temp = mem[t.HADDR[31:2]];		        // Read Value from Local Memory and store in temp
          
          if ( t.HRDATA == temp )
              $display ("[SCB-PASS] :: (WORD) READ OPERATION :: Expected = %0h, Actual = %0h", temp, t.HRDATA);
            else
              $display ("[SCB-FAIL] :: (WORD) READ OPERATION :: Expected = %0h, Actual = %0h", temp, t.HRDATA);
        end
          
          default:	$display("HSZIE Should be BYTE, HALFWORD or WORD Size Only");
      endcase
      
    endtask
