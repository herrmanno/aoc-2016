const fs = require("fs");
const input = fs.readFileSync("./input.txt", "utf8");

const instructions = input.split(",").map(i => i.trim());

const Directions = ["N","O","S","W"];

let direction = 0;
let position = {x: 0, y: 0};

for(let instr of instructions) {
	const turn = instr[0];
	const length = parseInt(instr.slice(1));

	if(turn === "R")
		direction++;
	else
		direction --;
	direction += Directions.length;
	direction %= Directions.length

	for(let i = 0; i < length; i++) {
		if(direction === 0) // N
			position.y++;
		if(direction === 1) // E
			position.x++;
		if(direction === 2) // S
			position.y--;
		if(direction === 3) // W
			position.x--;
	}
}

const distance = Math.abs(position.x) + Math.abs(position.y);

console.log("==========================\n");
console.log(`The end position is {x: ${position.x}, y: ${position.y}}; The taxi-cab-distance from the start (0,0) is:
	${distance}.`);