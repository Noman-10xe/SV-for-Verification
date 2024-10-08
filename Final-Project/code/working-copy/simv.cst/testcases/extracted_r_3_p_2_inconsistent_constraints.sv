class c_3_2;
    rand bit[31:0] HADDR = 32'h1; // rand_mode = OFF 
    rand bit[2:0] HSIZE = 3'h1; // rand_mode = OFF 

    constraint c_HADDR_this    // (constraint_mode = ON) (transaction.sv:69)
    {
       (HSIZE == 3'h1) -> ((HADDR % 2) == 0);
    }
endclass

program p_3_2;
    c_3_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "z101z1z0xx0xxzzxx01zxzz10xx11z1zxxzzxxxxxzzzxxzxzxzxxzxzxxzzzzzx";
            obj.set_randstate(randState);
            obj.HADDR.rand_mode(0);
            obj.HSIZE.rand_mode(0);
            obj.randomize();
        end
endprogram
