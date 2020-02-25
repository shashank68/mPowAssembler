# Assembler and Instruction Simulator for microPower Isa.

Requirements: Linux, Flex.

Steps:
1. Install Flex : `sudo apt install flex`
2. Clone the Repo: `git clone https://github.com/shashank68/mPowAssembler.git`
3. Change the directory: `cd mPowAssembler`
4. Run the assembler: `./assemble <assembly file name>`       (for eg: `./assemble test.asm`)

Output binary is `bin.out`
Symbol table and text section and static data section files are also generated.

## Simulator.
Requirements: Python3

1. `python3 simulator.py`
