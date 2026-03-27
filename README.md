# Project Overview

Welcome to the Digital Design Team of SiliconJackets!

For your onboarding project, you'll design a SystemVerilog calculator that performs 64-bit unsigned integer addition by combining two 32-bit sums. This project introduces you to logic design, RTL coding, FSM-based control, and functional verification. You'll also familiarize yourself with our tools and team workflows. If you get stuck or need clarification, don’t hesitate to ask questions!

---

## Requirements

You will build a 64-bit calculator system using these key modules:
- **adder32.sv** – adds two 32-bit values with carry-in and out
- **result_buffer.sv** – stores results in a 64-bit register (upper/lower controlled by a select signal)
- **controller.sv** – manages reads, writes, adder operation, and sequencing via an FSM
- **top_lvl.sv** - serves as the top level chip file
- **adder32.sv** - a 32-bit adder built using 32 full adders, connected using generate statements
- There are also other files which you **do not** need to edit, but a description can be found at the top to help you understand their function.
- Additional descriptions of each module are provided within their respective sv files. 

In general, your controller should be adding two 64-bit numbers stored in SRAM by reading the lower 32-bits of each number, adding them, storing the result in the lower half of the result buffer, then reading the upper 32-bits of each number, adding them, and storing the result in the upper half of the result buffer. Finally, the controller should write the full 64-bit result back to SRAM.

As an example, the controller should add the first two addresses of SRAM (each containing 64-bit numbers) starting from `read_start_addr` and write the result to the address starting from `write_start_addr`. The controller should then move on to the third and fourth read addresses, and writing to the second write address, and so on until all additions are complete.There should be 128 64bit writes in total.

Your task is to implement each module with correct input/output handling, FSM-based control, and memory-mapped behavior. There are specific //TODO: comments in the code with hints on what to do, so it is possible to complete the task without extensive modifications to the provided code.

<img width="961" alt="image" src="./resources/calculator.drawio.png">

## Optional Challenge
For an additional challenge, put yourself in the perspective of an RTL designer who is latency-constrained. The provided testbench has a built in cycle counter that will print out how many cycles your design took to complete all additions. Try to minimize this number by optimizing your controller FSM and module interactions. If you choose to do this, please mention your design's cycle count during your submission or in-person check-off. Note that this is optional and will not affect your ability to get checked off. There is no target performance, just try to make it as low as possible!


<img width="961" alt="image" src="./resources/cycle_count.png">


--- 

## Submission Disclaimers 
- **Any submissions after 11:59pm on the deadline 2/8/2026 will not be considered under any circumstance.** Make sure your submission is correct before the deadline :) 
- Incorrect submissions after the deadline will also not be permitted to pass onto the next stage. This is to protect the sanity of reviewing leads, ensure subsequent onboarding stages progress smoothly, and encourage starting earlier.
- You may collaborate with friends but you can not share code. This is to ensure you develop the skills to contribute meaningfully in the club.
- AI usage for understanding is encouraged, but using AI to write verilog is not allowed. AI is also very bad at hardware description languages, and there are a few "tells" which makes it easier to detect. Detected AI useage will not be passed onto the next phase.
- Please do not share ECE virtual server access. This is a GT ECE policy, so request and setup ECE server access early.


---


## Instructions  
### 0. Reference Materials (Optional – read as needed)

- **[Verilog basics](https://nandland.com/introduction-to-verilog-for-beginners-with-code-examples/)**
- **[SystemVerilog Basics](https://www.chipverify.com/tutorials/systemverilog)**
- **[HDLBits Verilog Lessons](https://hdlbits.01xz.net/wiki/Problem_sets)**  
  > Note: HDLBits uses Verilog (`wire`, `reg`). In SystemVerilog, use `logic` instead.
- **SystemVerilog vs. Verilog:** SystemVerilog uses `logic` (a unified type) instead of Verilog’s `wire` and `reg`.
- **[SystemVerilog Spec (Advanced/Optional)](https://rfsoc.mit.edu/6S965/_static/F24/documentation/1800-2017.pdf)**
- **[ChipDev.io Practices (Optional)](http://chipdev.io/question-list)**
  
  Reference resources/hdlbit-roadmap.md for a suggested learning path.

---


### 1. Adder Module (adder32.sv)  
Build a 32-bit addition module. Requirements:
- Compute sum of two 32-bit unsigned integers
- Output the 32-bit result
- Use the generate function to create 32 1-bit adders
- Reference: https://www.chipverify.com/verilog/verilog-generate-block 

---

### 2. Result Buffer (result_buffer.sv)
Create a buffer module that:
- Stores a 64-bit result
- Accepts a 32-bit result input
- Uses a 1-bit control signal to place the 32-bit input in either the upper or lower half of the 64-bit buffer
- Resets synchronously

---

### 3. FSM Diagram
Create a finite state machine (FSM) diagram for your **controller** module. This is the suggested outline of states and transitions:  
<img width="961" alt="image" src="./resources/suggested_fsm.drawio.png">

---

### 4. Controller Module (controller.sv)
Implement a finite state machine (FSM) that:
- Begins computation on reset release
- Sequences through read, process, and write operations
- Pulses output signals when results are ready
- Your controller should read/write data on the SRAM module as shown on the functional block diagram 

This module manages all coordination among memory, the adder, and the result buffer.  

---

### 5. Chip Top (top_lvl.sv)
- The purpose of this file is to connect everything together. Your task is to use your understanding of surrounding declarations to "fill in the blank" 
- Your task is to connect the SRAM to the file itself. The wireframe already exists, but you should connect it to your logic in the top_lvl.sv file. 
- Optional: To understand how the SRAM macro pins works, use this link
- https://chipfoundry.io/commercial-sram-macro
- Here is a timing diagram to help you understand how the SRAM works:  
<img width="961" alt="image" src="./resources/timing_diagram.jpg">
Please note that we are using a functional model of the SRAM, so you can safely ignore timing-related details like setup/hold times. You can transition signals on clock edges without worrying about timing violations. Focus on the logical sequence of operations instead. You will deal with timing more when you work on real modules for the club.
---  

### 6. Coding Guidelines
- Use `always_comb` and `always_ff` appropriately
- Use **blocking (`=`)** for combinational logic and **non-blocking (`<=`)** for sequential logic
- Avoid `%` or other expensive arithmetic unless explicitly allowed

---

### 7. (Optional) Testbench Enhancement
Add more test cases to your testbench to strengthen verification.

---

### 8. Results Report For Online Submission (PDF)
We offer the option to submit your onboarding and get checked off in-person instead of online, but if you choose to submit online, please attach a PDF report including the following:
- Waveform screenshot(s) showing module behavior and outputs
- 1–2 paragraph explanation of the waveform behavior and why it's correct

---

### 9. Final Check-in (Optional)
Check briefly with team leads before the onboarding deadline to conduct a quick review of your RTL for synthesizability. Synthesizability will be checked when you submit your final onboarding, and you will not pass if your design is not synthesizable. We recommend checking in early to avoid last-minute issues. Common synthesizability issues include:
- Using unsupported constructs (e.g., `initial` blocks, delays)
- Dollar sign system tasks (e.e., $log2) used in functional signals
- Unbounded while loops

---

## Getting Started

1. Sign the EULA agreement for Cadence tools (https://eulas.ece.gatech.edu/Cadence/)
    - Under Primary GT Affiliation -> Select "Researcher or Staff"
    - Your Title: "Student"
    - ECE Faculty Advisor / Professor Name : "Visvesh S Sathe"
    - ECE Faculty Advisor / Professor Email: "sathe@gatech.edu"
    - Software needed for -> "Research"
    - Research Project Name : "SiliconJackets"
    - Agree to Cadence agreement
2. Download Georgia Tech VPN (https://vpn.gatech.edu/global-protect/getsoftwarepage.esp)
3. Log into the GlobalProtect VPN once downloaded(portal: vpn.gatech.edu)  
    - use your school username and password
    - 'push1' sends a push to DUO, 'phone1' gives you an automated phone call
4. Download FastX or MobaXterm (or your preferred remote Terminal Emulator)
    - FastX (https://www.starnet.com/download-fastx-client/)
    - MobaXterm (https://mobaxterm.mobatek.net/download-home-edition.html)
5. Log in remotely to ECE Research server
    - The setup will be similar but different depending on the terminal emulator you choose
    - The following instructions work for FastX, but ask if you need help setting up with MobaXterm
    - Ensure you are connected to GT VPN
    - Open FastX Client
    - File->Connections. Click the plus sign to add a connection.
    - Host:  ece-rschsrv.ece.gatech.edu
    - Username: <your_GT_username>
    - Port: 22
    - Name: Whatever you want to call the connection
    - Here is an example of what your screen should look like:
    - ![image](./screenshots/fastxSetup1.png)
    - Connect to the session and type in your GT password at the prompt
    - Click the plus sign and then "xterm"
    - ![image](./screenshots/fastxSetup2.png)
    - You should now be remotely connected to the Research server Linux terminal 
    - ![image](./screenshots/fastxSetup3.png)
  
6. run the tcsh command to switch to c-shell. This command needs to be run every time you log into the server.
7. Add the following line to your ~/.my-cshrc file: source /tools/software/cadence/setup.csh. This will allow you to run the commands for cadence tools if you have gotten your EULA approved. (your ~/.my-cshrc file might be empty up until now, so just make this the first line). This is how you can do this: return to your home directory by running "cd ~". Then, do "nano ~/.my-cshrc" to enter the config file. Copy the line provided into it, then hit ctrl + the letter "o", then hit enter to save. Then hit ctrl + x to quit. To apply the changes, type "source ~/.my-cshrc". Now, typing xrun should not show an error. 
8. Clone this repo into the linux server. This is done using git clone url <--replace url with github-provided url. You might be prompted to input your username and password for git. 
9.  At this point, you can write your code in the files within the src folder. 
10. To see your waveforms, change directory into sim/behav and run the command __make link__ . If you are unfamiliar with the linux terminal, read this [article](https://www.hostinger.com/tutorials/linux-commands?utm_campaign=Generic-Tutorials-DSA|NT:SE|LO:USA&utm_medium=ppc&gad_source=1&gad_campaignid=20027522868&gbraid=0AAAAADMy-hYjLhKiHPvplnMB_BIAldozR&gclid=Cj0KCQjwzaXFBhDlARIsAFPv-u-bnckMRN43R_4lbPDlpdZdL66msX8hXGlCMpWa6KpdSEYULiDg-bcaAh0mEALw_wcB). You probably only need mkdir, ls, cd. 
11. Run the command "make xrun". This might take a second. 
12. Run the command "make simvision".
13. Once the GUI has popped up, you should be able to drag the module into variable section, whereby the signals will appear on the right.

---

## DELIVERABLES, More Succinctly

**a.** A working adder, buffer, toplvl, and controller module (all pass simulation and testbench)

**b.** A write-up if you are submitting online(.docx or preferably .pdf) showing:
- Simulation passing screenshots
- Waveforms with adequate signals and zoom to show a cycle of addition happening. 
- An explanation of correctness, states, and design decisions. 

**c.** FSM diagram for your controller

For **online submissions**, dm your "packet" to the sjcheckoffs discord account. Please note that this should only be done if you can't make it to the in-person sessions, as this account is monitored less frequently.   
<img width="341" height="274" alt="image" src="https://github.gatech.edu/user-attachments/assets/0c341854-4034-4733-a831-6d58d5675182" />


---

## Directory Overview

Here's what's going on in this onboarding project's directory:

### `scripts/`
Python scripts for generating test vectors.

### `src/`
Your Verilog source files

#### `src/verilog/`
Write your modules here (adder, controller, result buffer)

##### `sim/behav/include/calculator.include`
Tells Xcelium which files to compile

##### `src/verilog/tb_*.sv`
Testbenches for your modules

### `sim/behav/`
Behavioral simulation (run `make` here to simulate your design)

### `resources/`
Diagrams and images to help you understand the design

---

## Makefile Commands

The following make commands are available in the `sim/behav/` directory:

**`make help`**  
Display the help message showing all available make commands and their descriptions.

**`make clean`**  
Remove the WORKSPACE directory and all generated files. Use this to start fresh before running new simulations.

**`make link`**  
Generate symbolic links in WORKSPACE/sym_links/ directory. This creates links to source files based on the include file (default: calculator.include). Links are managed by the link_files.py Python script.

**`make xrun`**  
Compile and simulate the design using Cadence Xcelium simulator. 

**`make simvision`**  
Open SimVision waveform viewer to view the waves.shm waveform database generated by the simulation. 

**`make run_and_view`** *(Default target)*  
Convenience command that sequentially runs both `xrun` and `simvision`. Compiles, simulates, and immediately opens the waveform viewer.

**`make coverage`**  
Open IMC (Incisive Metrics Center) to view code coverage results from the simulation. Loads the coverage database from cov_work/scope/test.

**`make verify_onboarding`** *(Digital Design Onboarding Only)*  
Complete verification flow that checks project correctness. 




---

## Tips for Waveform viewers
<img width="961" alt="image" src="./screenshots/simvision.png">

1. Navigate hierarchy by clicking on the + sign next to module names (Yellow Box)
2. Add Signal by clicking on a module, then clicking on the signal in the signal panel (Blue Box)
3. Use the seek bar at the bottom of the waveform viewer to navigate through time and zoom.
4. Right-click a signal to "Set Radix" (e.g., binary, hex, decimal)
5. Right click on the signal window and use Save/Load to save a waveform setup so you don't have to re-add signals every time
   1. When saving, put the file outside of the WORKSPACE directory to avoid overwriting during `make clean`

## Code Linting Guide
[Verilator Linting Guide](https://gtvault.sharepoint.com/:w:/s/SiliconJackets/EW0qm5W59tdKj9TpwMpdu2YBIAYuL4C1B1nUTCNmcCsSIw?e=c1aNhq)

## An RTL/Verilog Textbook
[RTL Modeling with SystemVerilog for Simulation and Synthesis using SystemVerilog for ASIC and FPGA design](https://gtvault.sharepoint.com/:b:/s/SiliconJackets/EbxCET5NlPtMu3aUb6LRpQ8BvPQVkJjA3sXMsZEofq5taQ?e=7JvuNE)


## Onboarding Policy:
- Submissions must be made individually. Your work should not be copied from others. Collboration is allowed but submissions too similar will not be checked off.
- AI use is allowed but you must show adequate understanding of the code you submit. We may ask you to explain any part of your code as a follow-up to your submission.
- Use your own account and linux credentials for submission. Do not run your code on someone else's crediantials. This is against GT policy and ECE IT rules.
- There is strictly no extensions for onboarding deadlines. We do not have enough leads to accomodate extensions.
- Non-working submissions will not be checked off. Make sure your code runs and passes all checks before submission. We will provide feedbacks on all submissions but we do not guarantee timely feedback unless you submit at least 24 hours before the deadline.
