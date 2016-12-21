use "files"
use "collections"

actor Main
    
    new create(env: Env) =>        
        var password = "fbgdceah"
        let scrambler = Scrambler(password)
        try 
            let lines' = readLlines(env.root)
            let lines = List[String val]
            for line in lines' do
                lines.unshift(line)
            end
            match scrambler.scramble(lines.values(), {(line: String, pw: String)(env) => env.out.print("Did: '" + line + "'. \t\t\t\t -> " + pw)})
            | let e: String => env.out.print(e)
            end
        end
        env.out.print("The unscrambled password is: " + scrambler.password)


    fun readLlines(auth: (AmbientAuth | None) ): FileLines ? =>
        try
            let path = FilePath(auth as AmbientAuth, "input.txt")
            let file = File.open(path)
            let lines = FileLines(file)
            return lines
        else
            error
        end


class Scrambler
    var password: String
    let length: ISize

    new create(password': String) =>
        password = password'
        length = password.size().isize()


    fun ref scramble(lines: Iterator[String], cb: {(String, String)}): (String | None) ? =>
        for line in lines do
            match _parseline(line)
            | let s: String => return s
            end 
            cb(line, password)
        end
        None


    fun ref _parseline(line: String): (String | None) ? =>
        let parts = line.split(" ")
        match parts(0)
        | "swap" =>     match parts(1)
                        | "position" => _swap_position(parts(2).isize(), parts(5).isize()) 
                        | "letter" => _swap_letter(parts(2), parts(5)) 
                        end
        | "rotate" =>   match parts(1)
                        | "left" => _rotate(-1 * parts(2).isize())
                        | "right" => _rotate(parts(2).isize())
                        | "based" => _rotate_based(parts(6))
                        end
        | "reverse" => _reverse(parts(2).isize(), parts(4).isize())
        | "move" => _move(parts(5).isize(), parts(2).isize())
        else
            return "Error matching instruction: " + line
        end

        None


    fun ref _swap_position(x: ISize, y: ISize): None =>
        let xChar: String box = password.substring(x.isize(), x.isize()+1).string()
        let yChar: String box = password.substring(y.isize(), y.isize()+1).string()
        if x < y then
            password = password.substring(0, x) + yChar + password.substring(x+1, y) + xChar + password.substring(y+1)
        else
            password = password.substring(0, y) + xChar + password.substring(y+1, x) + yChar + password.substring(x+1)
        end
        None

    
    fun ref _swap_letter(a: String, b: String): None ? =>
        _swap_position(password.find(a).isize(), password.find(b).isize())
        None

    fun ref _rotate(n: ISize) =>
        let n' = n % length
        if n > 0 then
            password = password.substring(n') + password.substring(0, n')
        else
            password = password.substring(length + n') + password.substring(0, length + n')
        end

    
    fun ref _rotate_based(char: String): None =>
        var i: ISize = 0
        var pw: String val = password.clone()

        while true do
            pw = pw.substring(1) + pw.substring(0, 1)
            i = i + 1

            let pos = if i >= 6 then i - 2 else i - 1 end
            let c: String = pw.substring(pos, pos + 1)
            
            if c.eq(char) then
                break
            end

        end
        password = pw
        None


    fun ref _reverse(x: ISize, y: ISize) =>
        let prefix: String box = password.substring(0, x)
        let suffix: String box = password.substring(y + 1)
        let reversed: String box = password.substring(x, y + 1).reverse()
        password = prefix + reversed + suffix 
        
    
    fun ref _move(x: ISize, y: ISize): None =>
        let xChar: String val = password.substring(x.isize(), x.isize()+1).string()
        let tmp: String box = password.substring(0, x) + password.substring(x+1)
        password = tmp.insert(y, xChar)
        None