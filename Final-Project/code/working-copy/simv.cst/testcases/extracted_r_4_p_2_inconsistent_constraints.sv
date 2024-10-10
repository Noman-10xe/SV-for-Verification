class c_4_2;
    rand bit[31:0] HADDR = 32'h36; // rand_mode = OFF 
    rand bit[2:0] HSIZE = 3'h2; // rand_mode = OFF 

    constraint c_HADDR_this    // (constraint_mode = ON) (transaction.sv:69)
    {
       ((!(HSIZE == 3'h1)) && (HSIZE == 3'h2)) -> ((HADDR % 4) == 0);
    }
endclass

program p_4_2;
    c_4_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "zz0z0100xxzx11zxxxzzx011z0z1zz1zxzxzxxxxxzxzzxxzzzxxxxxzxxzzxzxz";
            obj.set_randstate(randState);
            obj.HADDR.rand_mode(0);
            obj.HSIZE.rand_mode(0);
            obj.randomize();
        end
endprogram
