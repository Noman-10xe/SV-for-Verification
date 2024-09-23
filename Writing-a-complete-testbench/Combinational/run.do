exec vcs -sverilog design.sv testbench.sv -o simv

if { [file exists simv] } {
    exec ./simv

    exec dve -vpd dump.vcd &
} else {
    puts "Compilation failed"
}
