const input = await Deno.readTextFile("input.txt");

const codes = input
	.trim()
	.split('\n');


function compileCode(code) {
	const values_to_append = {
		"0": {
			"0": ["A"],
			"1": ["^<A"],
			"2": ["^A"],
			"3": ["^>A", ">^A"],
			"4": ["^^<A"],
			"5": ["^^A"],
			"6": ["^^>A", ">^^A"],
			"7": ["^^^<A"],
			"8": ["^^^A"],
			"9": ["^^^>A", ">^^^A"],
			"A": [">A"],
		},
		"1": {
			"0": [">vA"],
			"1": ["A"],
			"2": [">A"],
			"3": [">>A"],
			"4": ["^A"],
			"5": ["^>A", ">^A"],
			"6": ["^>>A", ">>^A"],
			"7": ["^^A"],
			"8": ["^^>A", ">^^A"],
			"9": ["^^>>A", ">>^^A"],
			"A": [">>vA"],
		},
		"2": {
			"0": ["vA"],
			"1": ["<A"],
			"2": ["A"],
			"3": [">A"],
			"4": ["^<A"],
			"5": ["^A"],
			"6": ["^>A", ">^A"],
			"7": ["^^<A", "<^^A"],
			"8": ["^^A"],
			"9": ["^^>A", ">^^A"],
			"A": ["v>A", ">vA"],
		},
		"3": {
			"0": ["v<A", "<vA"],
			"1": ["<<A"],
			"2": ["<A"],
			"3": ["A"],
			"4": ["^<<A", "<<^A"],
			"5": ["^<A", "<^A"],
			"6": ["^A"],
			"7": ["^^<<A", "<<^^A"],
			"8": ["^^<A", "<^^A"],
			"9": ["^^A"],
			"A": ["vA"],
		},
		"4": {
			"0": [">vvA"],
			"1": ["vA"],
			"2": ["v>A", ">vA"],
			"3": [">>vA", "v>>A"],
			"4": ["A"],
			"5": [">A"],
			"6": [">>A"],
			"7": ["^A"],
			"8": ["^>A", ">^A"],
			"9": ["^>>A", ">>^A"],
			"A": [">>vvA"],
		},
		"5": {
			"0": ["vvA"],
			"1": ["v<A", "<vA"],
			"2": ["vA"],
			"3": ["v>A", ">vA"],
			"4": ["<A"],
			"5": ["A"],
			"6": [">A"],
			"7": ["^<A", "<^A"],
			"8": ["^A"],
			"9": ["^>A", ">^A"],
			"A": ["vv>A", ">vvA"],
		},
		"6": {
			"0": ["vv<A", "<vvA"],
			"1": ["v<<A", "<<vA"],
			"2": ["v<A", "<vA"],
			"3": ["vA"],
			"4": ["<<A"],
			"5": ["<A"],
			"6": ["A"],
			"7": ["^<<A", "<<^A"],
			"8": ["^<A", "<^A"],
			"9": ["^A"],
			"A": ["vvA"],
		},
		"7": {
			"0": [">vvvA"],
			"1": ["vvA"],
			"2": ["vv>A", ">vvA"],
			"3": ["vv>>A", ">>vvA"],
			"4": ["vA"],
			"5": ["v>A", ">vA"],
			"6": ["v>>A", ">>vA"],
			"7": ["A"],
			"8": [">A"],
			"9": [">>A"],
			"A": [">>vvvA"],
		},
		"8": {
			"0": ["vvvA"],
			"1": ["vv<A", "<vvA"],
			"2": ["vvA"],
			"3": ["vv>A", ">vvA"],
			"4": ["v<A", "<vA"],
			"5": ["vA"],
			"6": ["v>A", ">vA"],
			"7": ["<A"],
			"8": ["A"],
			"9": [">A"],
			"A": [">vvvA", "vvv>A"],
		},
		"9": {
			"0": ["vvv<A", "<vvvA"],
			"1": ["vv<<A", "<<vvA"],
			"2": ["vv<A", "<vvA"],
			"3": ["vvA"],
			"4": ["v<<A", "<<vA"],
			"5": ["v<A", "<vA"],
			"6": ["vA"],
			"7": ["<<A"],
			"8": ["<A"],
			"9": ["A"],
			"A": ["vvvA"],
		},
		"A": {
			"0": ["<A"],
			"1": ["^<<A"],
			"2": ["^<A", "<^A"],
			"3": ["^A"],
			"4": ["^^<<A"],
			"5": ["<^^A", "^^<A"],
			"6": ["^^A"],
			"7": ["^^^<<A"],
			"8": ["^^^<A", "<^^^A"],
			"9": ["^^^A"],
			"A": ["A"],
		}
	};

	let current_pos = "A";
	let all_possible_outputs = [""];
	for (let i = 0; i < code.length; i += 1) {
		const strings_to_add = values_to_append[current_pos][code[i]];
		all_possible_outputs = all_possible_outputs
			.reduce((acc, el) => {
				for (const s in strings_to_add) {
					acc.push(el + strings_to_add[s]);
				}
				return acc;
			}, []);
		current_pos = code[i];
	}
	return all_possible_outputs;
}



function compileInputs(inputs) {
	const values_to_append = {
		"A": {
			"^": ["<A"],
			"<": ["v<<A"],
			"v": ["v<A"],//, "<vA"],
			">": ["vA"],
			"A": ["A"],
		},
		"^": {
			"^": ["A"],
			"<": ["v<A"],
			"v": ["vA"],
			">": ["v>A"],//, ">vA"],
			"A": [">A"],
		},
		"v": {
			"^": ["^A"],
			"<": ["<A"],
			"v": ["A"],
			">": [">A"],
			"A": ["^>A"],//, ">^A"],
		},
		"<": {
			"^": [">^A"],
			"<": ["A"],
			"v": [">A"],
			">": [">>A"],
			"A": [">>^A"],
		},
		">": {
			"^": ["<^A"],//, "^<A"],
			"<": ["<<A"],
			"v": ["<A"],
			">": ["A"],
			"A": ["^A"],
		}
	}

	const compiled_inputs = inputs.map(input => {
		/*
		let current_pos = "A";
		let compiled_input = [""];

		for (let i = 0; i < input.length; i += 1) {
			const strings_to_add = values_to_append[current_pos][input[i]];
			compiled_input = compiled_input 
				.reduce((acc, el) => {
					for (const s in strings_to_add) {
						acc.push(el + strings_to_add[s]);
					}
					return acc;
				}, []);
			current_pos = input[i];
		}

		return compiled_input
		*/
		let current_pos = "A";
		let compiled_input = "";
		 
		for (let i = 0; i < input.length; i += 1) {
			const strings_to_add = values_to_append[current_pos][input[i]];
			compiled_input += values_to_append[current_pos][input[i]][0];
			current_pos = input[i];
		}

		return compiled_input;
	});
	//return compiled_inputs.flat();
	return compiled_inputs;
}


function compileInputObject(inputs) {
	const values_to_append = {
		"A": {
			"^": ["<A"],
			"<": ["v<<A"],
			"v": ["v<A"],//, "<vA"],
			">": ["vA"],
			"A": ["A"],
		},
		"^": {
			"^": ["A"],
			"<": ["v<A"],
			"v": ["vA"],
			">": ["v>A"],//, ">vA"],
			"A": [">A"],
		},
		"v": {
			"^": ["^A"],
			"<": ["<A"],
			"v": ["A"],
			">": [">A"],
			"A": ["^>A"],//, ">^A"],
		},
		"<": {
			"^": [">^A"],
			"<": ["A"],
			"v": [">A"],
			">": [">>A"],
			"A": [">>^A"],
		},
		">": {
			"^": ["<^A"],//, "^<A"],
			"<": ["<<A"],
			"v": ["<A"],
			">": ["A"],
			"A": ["^A"],
		}
	}

	const compiled_inputs = inputs.map(input => {
		/*
		let current_pos = "A";
		let compiled_input = [""];

		for (let i = 0; i < input.length; i += 1) {
			const strings_to_add = values_to_append[current_pos][input[i]];
			compiled_input = compiled_input 
				.reduce((acc, el) => {
					for (const s in strings_to_add) {
						acc.push(el + strings_to_add[s]);
					}
					return acc;
				}, []);
			current_pos = input[i];
		}

		return compiled_input
		*/
		let current_pos = "A";
		let compiled_input = "";
		 
		for (let i = 0; i < input.length; i += 1) {
			const strings_to_add = values_to_append[current_pos][input[i]];
			compiled_input += values_to_append[current_pos][input[i]][0];
			current_pos = input[i];
		}

		return compiled_input;
	});
	//return compiled_inputs.flat();
	return compiled_inputs;
}


function partOne() {
	return codes
		.map(code => {
			const in1 = compileCode(code);
			const in2 = compileInputs(in1);
			const in3 = compileInputs(in2).sort((a, b) => a.length - b.length);
			console.log(in2[0]);
			console.log(in2[in2.length-1]);
			console.log(in3[0]);
			console.log(in3[in3.length-1]);
			const code_n = parseInt(code);
			return in3[0].length * code_n;
		})
		.reduce((acc, el) => acc + el);
}


function partTwo() {
	return codes
		.map(code => {
			const code_n = parseInt(code);
			let last_inputs = compileCode(code);
			for (let i = 0; i < 26; i += 1) {
				console.log("Doing iter ", i);
				last_inputs = compileInputs(last_inputs);
				last_inputs = last_inputs.sort((a, b) => a.length - b.length);
				last_inputs = last_inputs.slice(0, 100);
				console.log(last_inputs.length);
			}
			//last_inputs.sort((a, b) => a.length - b.length);
			return last_inputs[0].length * code_n;
		})
		.reduce((acc, el) => acc + el);
}

console.log("Silver:", partOne());
console.log("Gold:", partTwo());
