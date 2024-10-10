class c_1_5;
    rand bit[0:0] HREADY = 1'h0; // rand_mode = OFF 

    constraint c_HREADY_this    // (constraint_mode = ON) (transaction.sv:98)
    {
       (HREADY == 1'h1);
    }
endclass

program p_1_5;
    c_1_5 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "z11xzxx10xz01z1z100z10x01xx01z1zxxxxxxzxzzzzzxzxzxxxxzxzzzzzxzxz";
            obj.set_randstate(randState);
            obj.HREADY.rand_mode(0);
            obj.randomize();
        end
endprogram
