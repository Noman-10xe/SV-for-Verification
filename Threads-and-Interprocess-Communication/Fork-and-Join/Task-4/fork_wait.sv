module fork_wait ();
  
  initial begin
    fork
        begin
          $display("Thread 1 Task Starting  @ %0t",$time);
          #30;
          $display("Thread 1 Task Finished  @ %0t",$time);
        end

        begin
          $display("Thread 2 Task Starting  @ %0t",$time);
          #15;
          $display("Thread 2 Task Finished  @ %0t",$time);
        end
    join_none

    //Add code here to wait for all forked threads to finish

    #5;
    $display("Program Finished @ %0t",$time);
    $finish;
  end
endmodule