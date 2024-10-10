class c_2_5;
    rand bit[0:0] HREADY = 1'h0; // rand_mode = OFF 

    constraint c_HREADY_this    // (constraint_mode = ON) (transaction.sv:98)
    {
       (HREADY == 1'h1);
    }
endclass

program p_2_5;
    c_2_5 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "zz1xzzzzz11zzxx01zz01x1x011z11x0xxzzzzzxzxzzxzzxzzzxzzzzxxxxxxzx";
            obj.set_randstate(randState);
            obj.HREADY.rand_mode(0);
            obj.randomize();
        end
endprogram
