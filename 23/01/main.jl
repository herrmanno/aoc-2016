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

Register() = Register(7, 0, 0, 0)


type Instruction
    t::Symbol
    a1::String
    a2::String
end


type Program
    ip::Int
    instructions::Array{Instruction} # Instruction it Tuple of "what", "arg1", "arg2"
    register::Register
end

Program() = Program(1, readInstructions(), Register())


function readInstructions()
    instructions = Array{Instruction}(0)
    f = open("input.txt");
    for line in eachline(f)
        parts = map(x -> String(x), split(line, " "))
        t = Symbol(parts[1])
        arg1 = rstrip(parts[2])
        arg2 = length(parts) == 3 ? rstrip(parts[3]) : ""
        instruction = Instruction(t, arg1, arg2)
        push!(instructions, instruction)
    end
    close(f)

    return instructions
end


function process(prog, instr, x, y)
    print("Could not match instruction: $instr $x $y\n")
    return 1
end

function process(prog, instr::Symbol, x, y)
    # print("processing $instr $x $y \n")
    return process(prog, Val{instr}, x, y)
end

function process(prog, _::Type{Val{:cpy}}, x::String, y::String)
    value = getReg(prog.register, x)
    setReg(prog.register, y, value)
    return 1;
end

function process(prog, _::Type{Val{:inc}}, x::String, y::Any)
    value = getReg(prog.register, x) + 1
    setReg(prog.register, x, value)
    return 1;
end

function process(prog, _::Type{Val{:dec}}, x::String, y::Any)
    value = getReg(prog.register, x) - 1
    setReg(prog.register, x, value)
    return 1;
end

function process(prog, _::Type{Val{:jnz}}, x::String, y::String)
    compareValue = getReg(prog.register, x)
    jumpOffset = getReg(prog.register, y)
    if compareValue != 0
        return jumpOffset
    else
        return 1
    end
end

function process(prog, _::Type{Val{:tgl}}, x::String, y::Any)
    instrOffset = getReg(prog.register, x)
    instrIdx = prog.ip + instrOffset
    
    if !(1 <= instrIdx <= length(prog.instructions))
        # invalid target instrunction index
        return 1
    end

    target = prog.instructions[instrIdx]
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

    # replace instruction
    prog.instructions[instrIdx] = target

    return 1

end

function run(prog::Program)
    
    while prog.ip <= length(prog.instructions)
        instr = prog.instructions[prog.ip]
        prog.ip += process(prog, instr.t, instr.a1, instr.a2)
        # print(prog.register, "\n")
    end

end


prog = Program()
run(prog)

print("Value of Register a is: $(prog.register.a)\n")