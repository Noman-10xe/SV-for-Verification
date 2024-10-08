class c_2_2;
    rand bit[31:0] HADDR = 32'h1; // rand_mode = OFF 
    rand bit[2:0] HSIZE = 3'h1; // rand_mode = OFF 

    constraint c_HADDR_this    // (constraint_mode = ON) (transaction.sv:69)
    {
       (HSIZE == 3'h1) -> ((HADDR % 2) == 0);
    }
endclass

program p_2_2;
    c_2_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "zz1xzzzzz11zzxx01zz01x1x011z11x0xxzzzzzxzxzzxzzxzzzxzzzzxxxxxxzx";
            obj.set_randstate(randState);
            obj.HADDR.rand_mode(0);
            obj.HSIZE.rand_mode(0);
            obj.randomize();
        end
endprogram
