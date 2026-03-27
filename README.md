# Project Overview
This is a SystemVerilog calculator that performs 64-bit unsigned integer addition by combining two 32-bit sums. This project introduces you to logic design, RTL coding, FSM-based control, and functional verification.

**What is included:**
- **adder32.sv** – adds two 32-bit values with carry-in and out
- **result_buffer.sv** – stores results in a 64-bit register (upper/lower controlled by a select signal)
- **controller.sv** – manages reads, writes, adder operation, and sequencing via an FSM
- **top_lvl.sv** - serves as the top level chip file
- **adder32.sv** - a 32-bit adder built using 32 full adders, connected using generate statements
