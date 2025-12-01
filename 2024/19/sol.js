const input = await Deno.readTextFile("input.txt");

const [owned_parts_part, todos_part] = input.split("\n\n");

const owned_parts = owned_parts_part
	.split(",")
	.map(s => s.trim())
const todos = todos_part
	.trim()
	.split("\n")

const ways_to_do_sequence_cache = new Map();
ways_to_do_sequence_cache[""] = 1;


function ways_to_do_sequence(sequence) {
	const search = ways_to_do_sequence_cache[sequence];
	if (search != undefined) return search;
	let combinations = 0;
	for (const part of owned_parts) {
		if (sequence.startsWith(part)) {
			combinations += ways_to_do_sequence(sequence.slice(part.length));
		}
	}
	ways_to_do_sequence_cache[sequence] = combinations;
	return combinations;
}


const common = todos.map(s => ways_to_do_sequence(s)).filter(n => n > 0);

const result1 = common.length;
const result2 = common.reduce((acc, el) => acc + el);

console.log("Silver: ", result1);
console.log("Gold: ", result2);
