# Set the working directory (optional)
cd /home/xe-user106/10x-Engineers/SOC-DV/SV-for-Verification/Testbench-Basics/Interface/Task-2


vlog /home/xe-user106/10x-Engineers/SOC-DV/SV-for-Verification/Testbench-Basics/Interface/Task-2/design.sv
vlog /home/xe-user106/10x-Engineers/SOC-DV/SV-for-Verification/Testbench-Basics/Interface/Task-2/testbench.sv

# Load the simulation (use your top-level testbench module)
vsim tb

add wave -r /*


run -all    # or "run 100ns" for a fixed amount of time

