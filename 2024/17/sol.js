const input = await Deno.readTextFile("input.txt");

const [registers_part, program_part] = input.split('\n\n');

const reg_a = 0;
const reg_b = 1;
const reg_c = 2;

const initial_regs = registers_part
	.split('\n')
	.map(l => {
		const index = l.indexOf(':');
		const ss = l.substring(index+1);
		return parseInt(ss.trim());
	});


const program = program_part
	.substring(program_part.indexOf(':') + 1)
	.split(',')
	.map(e => parseInt(e));


function computeProgram(program, regs = initial_regs) {
	const registers = regs.map(x => x);
	let instr_p = 0;
	const outputs = [];

	while (instr_p < program.length) {
		switch (program[instr_p]) {
			case 0: {
				const num = registers[reg_a];
				let den;
				if (program[instr_p+1] <= 3) {
					den = 2**program[instr_p+1];
				} else {
					const reg_to_read = program[instr_p+1]-4;
					den = 2**registers[reg_to_read];
				}
				const result = Math.trunc(num / den);
				registers[reg_a] = result;
				break;
			}

			case 1: {
				registers[reg_b] = Number(BigInt(registers[reg_b]) ^ BigInt(program[instr_p+1]));
				break;
			}

			case 2: {
				let result;
				if (program[instr_p+1] <= 3) {
					result = program[instr_p+1];
				} else {
					const reg_to_read = program[instr_p+1]-4;
					result = registers[reg_to_read];
				}
				registers[reg_b] = result & 0b111;
				break;
			}

			case 3: {
				if (registers[reg_a] != 0) {
					if (program[instr_p+1] <= 3) {
						instr_p = program[instr_p+1];
					} else {
						const reg_to_read = program[instr_p+1]-4;
						instr_p = Number(registers[reg_to_read]);
					}
					continue;
				}
				break;
			}

			case 4: {
				registers[reg_b] = Number(BigInt(registers[reg_b]) ^ BigInt(registers[reg_c]));
				break;
			}

			case 5: {
				if (program[instr_p+1] <= 3) {
					outputs.push(program[instr_p+1]);
				} else {
					const reg_to_read = program[instr_p+1]-4;
					outputs.push(registers[reg_to_read] & 0b111);
				}
			}

			case 6: {
				const num = registers[reg_a];
				let den;
				if (program[instr_p+1] <= 3) {
					den = 2**program[instr_p+1];
				} else {
					const reg_to_read = program[instr_p+1]-4;
					den = 2**registers[reg_to_read];
				}
				const result = Math.trunc(num / den);
				registers[reg_b] = result;
				break;
			}

			case 7: {
				const num = registers[reg_a];
				let den;
				if (program[instr_p+1] <= 3) {
					den = 2**program[instr_p+1];
				} else {
					const reg_to_read = program[instr_p+1]-4;
					den = 2**registers[reg_to_read];
				}
				const result = Math.trunc(num / den);
				registers[reg_c] = result;
				break;
			}
		}
		instr_p += 2;
	}

	return outputs;
}


function findARegValue(program, _initial_regs = initial_regs) {
	const walk_base = program.length/2;
	const initial_offset_to_walk = walk_base**(program.length-4);
	const print_every_n = 10000;
	let initial_A_value = 1;
	let print_counter = print_every_n;

	while (true) {
		print_counter += 1;
		const regs = _initial_regs.map(x => x); 
		regs[reg_a] = initial_A_value;
		const output = computeProgram(program, regs);

		if (print_counter >= print_every_n) {
			console.log("Tried", initial_A_value, output.join());
			print_counter = 0;
		}

		if (output.length < program.length) {
			initial_A_value *= 2;
			continue;
		} else if (output.length > program.length) {
			throw new Error(`Oops, tried number ${initial_A_value} which has ${Math.log2(initial_A_value)} bits.`);
		}


		let to_add = initial_offset_to_walk;
		let is_correct = true;
		for (let i = output.length - 1; i >= 0; i -= 1) {
			if (output[i] == program[i]) {
				to_add /= walk_base;
			} else {
				is_correct = false;
				break;
			}
		}

		if (is_correct) {
			break;
		} else {
			if (to_add < 1) to_add = 1;
			initial_A_value += Math.trunc(to_add);
		}
	}
	return initial_A_value;
}

console.log("Silver: ", computeProgram(program).join());
console.log("Gold: ", findARegValue(program));
