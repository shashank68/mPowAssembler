line = ""

#defining the compute table.

from math import pow

#register table----------------------------------------------------------------------------------------------------------------------------------------------------------

register_table = []

for i in range(0,32):
    register_table.append(0)

data_table = {}

#required functions------------------------------------------------------------------------------------------------------------------------------------------------------

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

#mini instruction set-----------------------------------------------------------------------------------------------------------------------------------------------------

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

def beq():
    pass

def load(called = 0):
    ra = (register_table[get_decimal_value(line[11:16])])
    offset = get_two_complement_number(line[16:])
    loc = ra + offset
    mem_int = []
    for i in data_table.keys():
        mem_int.append(get_decimal_value(i))
    if loc in mem_int:
        loc = bin(loc)
        loc = loc[2:]
        register_table[get_decimal_value(line[6:11])] = data_table[loc]
    else:
        register_table[get_decimal_value(line[6:11])] = 0  

def store(called = 0):
    ra = (register_table[get_decimal_value(line[11:16])])
    offset = get_two_complement_number(line[16:30])
    loc = ra + offset
    loc = bin(loc)[2:]
    data_table[loc] = register_table[get_decimal_value(line[6:11])]

def And():
    register_table[get_decimal_value(line[6:11])] = (register_table[get_decimal_value(line[11:16])] & register_table[get_decimal_value(line[16:21])])

def Or():
    register_table[get_decimal_value(line[6:11])] = (register_table[get_decimal_value(line[11:16])] | register_table[get_decimal_value(line[16:21])])

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

def Cmp():
    pass

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#dictionaries definition.

XO = {266: add, 40: subf}
X  = {476: Nand, 28: And, 444: Or, 539: SRDW, 27: SLDW}
XS = {}

get_instruction_from_pop = {14:addi, 58:load, 62: store}

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

def print_register_data():
    print("Register contents(in decimal):")
    print()
    for i in range(0, 31, 4):
        for i in range(i, i+4):
            print("Reg[",i, "]: ", register_table[i], sep ="", end = "   ")
        print("\n")


def read_data_file():
    init_data = open('initdata.txt', 'r')
    line_list = init_data.readlines()
    for lin in line_list:
        l = lin.split()
        print(l)
        addr = l[1]
        type1 = l[2]
        no_of_data = l[3]
        if type1 == '11':
            offset = 1
        elif type1 == '01':
            print("reached heire")
            offset = 4
        next_addr = addr
        for i in range(0,no_of_data):
            data_table[next_addr] = l[4+i]
            next_addr = get_decimal_value(addr) + offset
            next_addr = bin(next_addr)
            next_addr = next_addr[2:]

    init_data.close()


def readtextsect():
    inittext = open('instrfile.txt', 'r')
    inslist = inittext.readlines()
    for ir in inslist:
        global line
        line = ir[:32]
        compute_instruction()

read_data_file()
print_register_data()
print(data_table)
readtextsect()
print_register_data()
print(data_table)    
        

    
        
