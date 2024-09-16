// Author: Noman Rafiq
// Dated: Sep 12, 2024
// Driver class and tb


// Interface for connecting DUT
interface comb_inf();
  logic a, b, c, d;
  logic y;
endinterface

// Test module
module tb;
  comb_inf vif();	// create an interface handle
  
  // Instantiate module
  // Explicit port mapping
  comb dut(.a(vif.a), .b(vif.b), .c(vif.c), .d(vif.d), .y(vif.y));
  
  // Implicit port mapping
  //comb dut(vif.a, vif.b, vif.c, vif.d, vif.y);
  
  initial begin
  $dumpvars;
  $dumpfile("dump.vcd");
  
  vif.a = 0; vif.b = 0; vif.c = 0; vif.d = 0;
  #10;
    
  $monitor("a = %0b, b = %0b, c = %0b, d = %0b :: y = %0b", vif.a, vif.b, vif.c, vif.d, vif.y);
    
    repeat(10) begin
      vif.a = $urandom;
      vif.b = $urandom;
      vif.c = $urandom;
      vif.d = $urandom;
      #10;
    end
   
    vif.a = 1; vif.b = 1; vif.c = 1; vif.d = 1;
    #30;
    
    vif.a = 0; vif.b = 0; vif.c = 0; vif.d = 0;
  end
endmodule
