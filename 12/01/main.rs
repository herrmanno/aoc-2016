use std::io::prelude::*;
use std::io::Error;
use std::fs::File;
// use std::io::BufReader;
// use std::path::Path;
// use std::vec::Vec;

struct Registers {
    a: i32,
    b: i32,
    c: i32,
    d: i32
}

impl Registers {
    fn cpy(&mut self, i: &mut i32, val: &String, dst: &String) {
        let value = self.getValue(val);
        self.applyRegister(dst, &|v:i32| value); 
        *i = *i + 1;
    }

    fn inc(&mut self, i: &mut i32, dst: &String) {
        self.applyRegister(dst, &|v:i32| v + 1); 
        *i = *i + 1;
    }

    fn dec(&mut self, i: &mut i32, dst: &String) {
        self.applyRegister(dst, &|v:i32| v - 1); 
        *i = *i + 1;
    }

    fn jnz(&self, i: &mut i32, condition: &String, offset: &String) {
        let value = self.getValue(condition);
        if value != 0 {
            *i = *i + offset.parse::<i32>().unwrap();
        }
        else {
            *i = *i + 1;
        }
    }

    fn applyRegister(&mut self, val: &String, func: &Fn(i32) -> i32) {
        match val.as_ref() {
            "a" => self.a = func(self.a),
            "b" => self.b = func(self.b),
            "c" => self.c = func(self.c),
            "d" => self.d = func(self.d),
            _   => panic!("unkown register")
        };
    }

    fn getValue(&self, val: &String) -> i32 {
        let value = match val.as_ref() {
            "a" => self.a,
            "b" => self.b,
            "c" => self.c,
            "d" => self.d,
            _   => val.parse::<i32>().unwrap()
        };

        return value;
    }
}


fn main() {
    let mut f = File::open("input.txt").unwrap();
    let mut buffer = String::new();
    let _ = f.read_to_string(&mut buffer);
    let lines: Vec<String> = buffer
        .lines()
        .map(ToOwned::to_owned)
        .collect();

    
    let mut registers = Registers {a: 0, b: 0, c: 0, d: 0};
    let mut i: i32 = 0;
    while i < (lines.len() as i32) {
        let instr: Vec<String> = lines[i as usize].split_whitespace().map(ToOwned::to_owned).collect();
        let ref t = instr[0];

        match t.as_ref() {
            "cpy" => {
                registers.cpy(&mut i, &instr[1], &instr[2])
            },
            "inc" => {
                registers.inc(&mut i, &instr[1])
            },
            "dec" => {
                registers.dec(&mut i, &instr[1])
            },
            "jnz" => {
                registers.jnz(&mut i, &instr[1], &instr[2])
            },
            _ => panic!("unkwon instruction")
        }
        
        println!("{}\t{}\t{}\t{}", registers.a, registers.b, registers.c, registers.d);
    }

}