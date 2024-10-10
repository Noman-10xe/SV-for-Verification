class c_1_4;
    rand bit[0:0] HSEL = 1'h0; // rand_mode = OFF 

    constraint c_HSEL_this    // (constraint_mode = ON) (transaction.sv:93)
    {
       (HSEL == 1'h1);
    }
endclass

program p_1_4;
    c_1_4 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "zz1xzzzzz11zzxx01zz01x1x011z11x0xxzzzzzxzxzzxzzxzzzxzzzzxxxxxxzx";
            obj.set_randstate(randState);
            obj.HSEL.rand_mode(0);
            obj.randomize();
        end
endprogram
