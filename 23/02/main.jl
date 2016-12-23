DEBUG_PRINT = false

type Register
    a::Int
    b::Int
    c::Int
    d::Int
end

function getReg(register::Register, key::String)
    if key == "a"
        return register.a
    elseif key == "b"
        return register.b
    elseif key == "c"
        return register.c
    elseif key == "d"
        return register.d
    elseif key == "0"
        return 0
    else
        return parse(Int, key)
    end
end

function setReg(register::Register, key::String, value::Int)
    if key == "a"
        return register.a = value
    elseif key == "b"
        return register.b = value
    elseif key == "c"
        return register.c = value
    elseif key == "d"
        return register.d = value
    end
end

Register() = Register(12, 0, 0, 0)


type Instruction
    t::Symbol
    a1::String
    a2::String
    a3::String
end


type Program
    ip::Int
    instructions::Array{Instruction}
    currentInstructions::Array{Instruction}
    register::Register
end

Program() = Program(1, readInstructions(), readInstructions(), Register())


function readInstructions()
    instructions = Array{Instruction}(0)
    f = open("input.txt");
    for line in eachline(f)
        parts = map(x -> String(x), split(line, " "))
        t = Symbol(parts[1])
        arg1 = rstrip(parts[2])
        arg2 = length(parts) == 3 ? rstrip(parts[3]) : ""
        instruction = Instruction(t, arg1, arg2, "")
        push!(instructions, instruction)
    end
    close(f)

    return instructions
end

function optimize(instructions::Array{Instruction})
    # inc a
    # dec c
    # jnz c -2
    # -> Same as 'a = a + c'


    # optimize add
    for ip in 1:(length(instructions)-2)
        instr1 = instructions[ip]
        instr2 = instructions[ip+1]
        instr3 = instructions[ip+2]

        if instr1.t == :inc && (instr2.t == :dec || instr2.t == :inc) && instr3.t == :jnz && instr3.a1 == instr2.a1 && instr3.a2 == "-2"
            print("===================================\n")
            print("Optimizing add instruction from:\n")
            print(instr1, "\n")
            print(instr2, "\n")
            print(instr3, "\n")
            print("===================================\n")
            
            instr1.t = :add
            instr1.a2 = instr2.a1
            instr2.t = :dummy
            instr3.t = :dummy
        end

        if (instr1.t == :dec || instr1.t == :inc) && instr2.t == :inc && instr3.t == :jnz && instr3.a1 == instr1.a1 && instr3.a2 == "-2"
            print("===================================\n")
            print("Optimizing add instruction from:\n")
            print(instr1, "\n")
            print(instr2, "\n")
            print(instr3, "\n")
            print("===================================\n")
            
            instr1.t = :add
            instr1.a1 = instr2.a1
            instr1.a2 = instr3.a1
            instr2.t = :dummy
            instr3.t = :dummy
        end

    end

    # cpy b c
    # add a c
    # dec d
    # jnz d -3
    # -> Same as 'a += b * d'

    for ip in 2:(length(instructions))
        instr1 = instructions[ip-1] # dec d
        instr2 = instructions[ip]   # jnz d -5

        offset = get(tryparse(Int, instr2.a2), 1)
        if instr2.t == :jnz && offset < 0

            startIdx = ip + offset
            startInstr = instructions[startIdx]     #cpy b c    ->  add a b // a += b    
            startInstr2 = instructions[startIdx+1]  #add a c    ->
            
            if instr1.t == :dec && instr1.a1 == instr2.a1 && startInstr.t == :cpy && startInstr2.t == :add && startInstr.a2 == startInstr2.a2
                print("===================================\n")
                print("Optimizing multiply instruction from:\n")
                print(startInstr, "\n")
                print(startInstr2, "\n")
                print("(...)\n")
                print(instr1, "\n")
                print(instr2, "\n")
                print("===================================\n")
                
                # erase all instructions in between and enforce they aren't tgl instructions
                hasToggle = false
                for ip2 in (startIdx+1):ip
                    if instructions[ip2].t == :tgl
                        hasToggle = true
                    end
                end

                if hasToggle
                    continue
                end

                # make all instrucitons :dummy except the first which becomes a :mul instruction
                for ip2 in (startIdx+1):ip
                    instructions[ip2].t = :dummy
                end
                # make :add instruciton an :mul instruction
                startInstr.t = :mul
                startInstr.a2 = startInstr.a1
                startInstr.a3 = instr2.a1
                startInstr.a1 = startInstr2.a1

            end

        end

    end

end


function process(prog, instr, x, y, z)
    print("Could not match instruction: $instr $x $y\n")
    return 1
end

function process(prog, instr::Symbol, x, y, z)
    DEBUG_PRINT && print("processing $instr $x $y \n")
    return process(prog, Val{instr}, x, y, z)
end

function process(prog, _::Type{Val{:dummy}}, x, y, z)
    return 1;
end

function process(prog, _::Type{Val{:add}}, x::String, y::String, z)
    origin = getReg(prog.register, x)
    value = abs(getReg(prog.register, y))
    setReg(prog.register, x, origin + value)
    return 1;
end

function process(prog, _::Type{Val{:mul}}, x::String, y::String, z::String)
    origin = getReg(prog.register, x)
    value1 = getReg(prog.register, y)
    value2 = getReg(prog.register, z)
    setReg(prog.register, x, origin + (value1 * value2) )
    return 1;
end

function process(prog, _::Type{Val{:cpy}}, x::String, y::String, z)
    value = getReg(prog.register, x)
    setReg(prog.register, y, value)
    return 1;
end

function process(prog, _::Type{Val{:inc}}, x::String, y, z)
    value = getReg(prog.register, x) + 1
    setReg(prog.register, x, value)
    return 1;
end

function process(prog, _::Type{Val{:dec}}, x::String, y, z)
    value = getReg(prog.register, x) - 1
    setReg(prog.register, x, value)
    return 1;
end

function process(prog, _::Type{Val{:jnz}}, x::String, y::String, z)
    compareValue = getReg(prog.register, x)
    jumpOffset = getReg(prog.register, y)
    if compareValue != 0
        return jumpOffset
    else
        return 1
    end
end

function process(prog, _::Type{Val{:tgl}}, x::String, y::Any, z)
    instrOffset = getReg(prog.register, x)
    instrIdx = prog.ip + instrOffset
    
    # invalid target instrunction index
    if !(1 <= instrIdx <= length(prog.instructions))
        return 1
    end

    newInstructions = deepcopy(prog.currentInstructions)
    target = newInstructions[instrIdx]
    if target.t == :dummy
        throw(ArgumentError("Cannot toggle 'optimized dummy instruction' at instructions position $instrIdx"))
    end
    if target.a2 == ""      # one-arg instruction
        if target.t == :inc
            target.t = :dec
        else
            target.t = :inc
        end
    elseif target.a2 != ""  # two-arg instruction
        if target.t == :jnz
            target.t = :cpy
        else
            target.t = :jnz
        end
    end

    # replace instructions
    newInstructions[instrIdx] = target
    prog.instructions = newInstructions
    prog.currentInstructions = deepcopy(newInstructions)

    optimize(prog.instructions)
    return 1

end

function run(prog::Program)
    
    while prog.ip <= length(prog.instructions)
        instr = prog.instructions[prog.ip]
        prog.ip += process(prog, instr.t, instr.a1, instr.a2, instr.a3)
        DEBUG_PRINT && print(prog.register, "\n")
    end

end


prog = Program()
optimize(prog.instructions)

run(prog)

print("Value of Register a is: $(prog.register.a)\n")