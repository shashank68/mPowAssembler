# Assembler for microPower Isa.

Requirements: *nix like OS, flex (only for compilation).

Steps:

0. Install Flex (only for compilation): `sudo apt install flex`  (optional)
1. Clone the Repo: `git clone https://github.com/shashank68/mPowAssembler.git`
2. Change the directory: `cd mPowAssembler`
3. Run the assembler: `./assemble <assembly file name>`       (for eg: `./assemble test.asm`)

Output binary is `bin.out`
Symbol table and text section and static data section files can also be generated.

# Simulator for microPower Isa instructions.

Requirements: python3

Steps:
1. Run `./simulator` inside mPowAssembler directory. ( after running assembler )
 
