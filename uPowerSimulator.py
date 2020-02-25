"""
Modified uPower Simulator Code.
->Changes Done:
1)Previous Errors Corrected.
2)Modified load, store, read_text_segment, read_data_segment and data_table.
3)special_registers added
4)PC functionality added.
5).asciiz can be read.(further modifications may be reqd(based on tests performed.)).
6)print_register_data, print_special_regs, print_data_table modified and added.
7)Execute function created.
->To be done:
1)Add jump instructions.
2)Test the existing code.
3)line var to be changed to ir
"""
line = ""

from math import pow

#memory table definition
register_table = []  #register table definition

for i in range(0,32):
    register_table.append(0)

data_table = {} #data table definition
special_registers = {"pc": '0x0000000000400000', 'sp': '0x0000003ffffffff0'}

#convertion functions and overflow check functions.
def get_decimal_value(binary_value):
   counter = len(binary_value)-1
   decimal = 0
   for digit in binary_value:
       decimal = decimal + int(digit) * pow(2, counter)
       counter = counter - 1
   return(int(decimal))

def get_two_complement_number(binary_value):
    initial_value = -1 * int(binary_value[0]) * pow(2, len(binary_value)-1)
    counter = len(binary_value)-2
    for digit in binary_value[1:]:
        initial_value = initial_value + int(digit) * pow(2, counter)
        counter = counter - 1
    return(int(initial_value))

def check_overflow(value):
    if value > (int(pow(2, 63))-1):
        binary = bin(value)
        binary = binary[2:]
        binary = binary[len(binary)-64:]
        value  = get_two_complement_number(binary)
    elif value < (-1 * int(pow(2, 63))):
        value = value + int(pow(2, 64))
    return value

#instruction execution function.
def add():
    register_table[get_decimal_value(line[6:11])] = register_table[get_decimal_value(line[11:16])] + register_table[get_decimal_value(line[16:21])]
    register_table[get_decimal_value(line[6:11])] = check_overflow(int(register_table[get_decimal_value(line[6:11])]))

def subf():
    register_table[get_decimal_value(line[6:11])] = register_table[get_decimal_value(line[16:21])] - register_table[get_decimal_value(line[11:16])]
    register_table[get_decimal_value(line[6:11])] = check_overflow(int(register_table[get_decimal_value(line[6:11])]))

def addi(called = 0):
    if called == 0:
        register_table[get_decimal_value(line[6:11])] = register_table[get_decimal_value(line[11:16])] + get_two_complement_number(line[16:])
    else:
        register_table[get_decimal_value(line[6:11])] = register_table[get_decimal_value(line[11:16])] - get_two_complement_number(line[16:])
    register_table[get_decimal_value(line[6:11])] = check_overflow(int(register_table[get_decimal_value(line[6:11])]))

def Nand():
    register_table[get_decimal_value(line[6:11])] = ~(register_table[get_decimal_value(line[11:16])] & register_table[get_decimal_value(line[16:21])])

def load():
    base = 0x0000000010000000
    ra = register_table[get_decimal_value(line[11:16])]
    offset = get_two_complement_number(line[16:])
    loc = base + ra + offset
    if loc >= int('0x0000000010000000', 0):
        loc = "0x{:016x}".format(loc)
        if loc in data_table.keys():
            register_table[get_decimal_value(line[6:11])] = data_table[loc]
        else:
            register_table[get_decimal_value(line[6:11])] = 0

def store():
    base = 0x0000000010000000
    ra = register_table[get_decimal_value(line[11:16])]
    offset = get_two_complement_number(line[16:30])
    loc = base + ra + offset
    loc = "0x{:016x}".format(loc)
    data_table[loc] = register_table[get_decimal_value(line[6:11])]

def And():
    register_table[get_decimal_value(line[6:11])] = (register_table[get_decimal_value(line[11:16])] & register_table[get_decimal_value(line[16:21])])

def Or():
    register_table[get_decimal_value(line[6:11])] = (register_table[get_decimal_value(line[11:16])] | register_table[get_decimal_value(line[16:21])])

def Ori():
    register_table[get_decimal_value(line[6:11])] = register_table[get_decimal_value(line[11:16])] | get_two_complement_number(line[16:])

def SRDW():
    get_binary = bin(register_table[get_decimal_value(line[16:21])])
    get_binary = get_binary[2:]
    get_binary = get_binary[len(get_binary)-7:]
    get_integer = get_decimal_value(get_binary)
    register_table[get_decimal_value(line[6:11])] = register_table[get_decimal_value(line[11:16])] >> get_integer
    register_table[get_decimal_value(line[6:11])] = check_overflow(int(register_table[get_decimal_value(line[6:11])]))

def SLDW():
    get_binary = bin(register_table[get_decimal_value(line[16:21])])
    get_binary = get_binary[2:]
    get_binary = get_binary[len(get_binary)-7:]
    get_integer = get_decimal_value(get_binary)
    register_table[get_decimal_value(line[6:11])] = register_table[get_decimal_value(line[11:16])] << get_integer
    register_table[get_decimal_value(line[6:11])] = check_overflow(int(register_table[get_decimal_value(line[6:11])]))

def Andi():
    register_table[get_decimal_value(line[6:11])] = register_table[get_decimal_value(line[11:16])] & get_two_complement_number(line[16:])

#instruction dictionaries and detection function.
XO = {266: add, 40: subf}
X  = {476: Nand, 28: And, 444: Or, 539: SRDW, 27: SLDW}
XS = {}
get_instruction_from_pop = {14:addi, 58:load, 62:store, 24:Ori, 28:Andi}

#instruction detection function.
def compute_instruction():
    primary_opcode_value = get_decimal_value(line[:6])
    if primary_opcode_value in list(get_instruction_from_pop.keys()):
        get_instruction_from_pop[primary_opcode_value]()
    else:
        possible_values = []
        possible_values = [get_decimal_value(line[21:31]), get_decimal_value(line[21:30]), get_decimal_value(line[22:31])]
        if possible_values[0] in list(X.keys()):
            X[possible_values[0]]()
            return
        elif possible_values[1] in list(XS.keys()):
            XS[possible_values[1]]()
            return
        elif possible_values[2] in list(XO.keys()):
            XO[possible_values[2]]()
            return
        else:
            print("Instruction Error");

#printing the memory state functions.
def print_register_data():
    print("Register contents:")
    print()
    for i in range(0, 31, 2):
        binary_value = "{:064b}"
        for i in range(i, i+2):
            print("Reg[",i, "]: ",binary_value.format(register_table[i]),"({})".format(register_table[i]), sep ="", end = "   ")
        print("\n")

def print_data_table():
    print("Data Table Contents:")
    print()
    for key in data_table.keys():
        print("Address: {} Value: {}".format(key, data_table[key]))

def print_special_regs():
    print("Special register contents:")
    for i in special_registers.keys():
        print(i,": ", special_registers[i])

#reading the binary file functions.
def read_data_segment():
    base = 0x0000000010000000
    init_data = open('initdata.txt', 'r')
    line_list = init_data.readlines()
    for data in line_list:
        decode  = data.split()
        address = decode[1]
        type_of_data = decode[2]
        no_of_data_in_line = decode[3]
        if type_of_data == '11':
            offset = 1
        elif type_of_data == '01':
            offset = 4
        elif type_of_data == '10':
            offset = 1
        next_addr = base + get_decimal_value(address)
        for i in range(0, no_of_data_in_line):
            data_table["0x{:016x}".format(next_addr)] = decode[4 + i]
            next_addr = base + get_decimal_value(address) + offset
    init_data.close()

def read_text_segment():
    init_text = open('insterfile.txt', 'r')
    inslist = init_text.readlines()
    global line
    #step count execution code of uPower assembly code.
    print("Enter the step count", "1->execute all instructions in .text", "2->explicit count information", sep = "\n")
    get_info = int(input())
    if get_info == 2:
        print("Enter the instruction count")
        count = int(input())
        if count >= len(inslist):
            count = len(inslist)
    else:
        count = len(inslist)

    for index in range(0, count):
        special_registers["pc"] = int(special_registers["pc"], 0)
        special_registers["pc"] = special_registers["pc"] + 4
        special_registers["pc"] = "0x{:016x}".format(special_registers["pc"])
        line = inslist[index][:32]
        compute_instruction()
    init_text.close()

#wrapper function.
def execute():
        print("Initially: ")
        print_register_data()
        print_data_table()
        print_special_regs()
        print()
        print("Under execution...")
        print()
        read_data_file()
        read_text_segment()
        print_register_data()
        print_data_table()
        print_special_regs()

if __name__ == '__main__':
    execute()
#-------------------------------
