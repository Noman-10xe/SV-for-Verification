class c_7_2;
    rand bit[31:0] HADDR = 32'he; // rand_mode = OFF 
    rand bit[2:0] HSIZE = 3'h2; // rand_mode = OFF 

    constraint c_HADDR_this    // (constraint_mode = ON) (transaction.sv:69)
    {
       ((!(HSIZE == 3'h1)) && (HSIZE == 3'h2)) -> ((HADDR % 4) == 0);
    }
endclass

program p_7_2;
    c_7_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "0001xz0x1101zx1x1000zxxx11zzxzzzxzzzzxzxzzzzzzxzzxzxxzxzzzzxxxxx";
            obj.set_randstate(randState);
            obj.HADDR.rand_mode(0);
            obj.HSIZE.rand_mode(0);
            obj.randomize();
        end
endprogram
