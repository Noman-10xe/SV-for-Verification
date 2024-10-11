exec vcs -sverilog +incdir+./include-files ./Testbench/testbench.sv ./RTL/design.sv -o simv

if { [file exists simv] } {
	exec ./simv     > log.txt
	
	exec dve -vpd dump.vcd &
	
} else {
	puts "Compilation Failed"
}

