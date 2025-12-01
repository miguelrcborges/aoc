const input = await Deno.readTextFile("demo_input.txt");

const wall = 0;
const track = 1;

let start_position;
let end_position;

const grid = input
	.trim()
	.split('\n')
	.map((l, y) => l
		.split('')
		.map((c, x) => {
			if (c == 'S') {
				start_position = {
					x, y
				};
				return track;
			}
			else if (c == 'E') {
				end_position = {
					x, y
				};
				return track;
			} else if (c == '.') {
				return track;
			}
			return wall;
		})
);

const width = grid[0].length;
const height = grid.length;


function travel() {
	let best_value = Number.MAX_SAFE_INTEGER;
	const best_map = new Map();

	const to_process_list = [[start_position, 0]]

	while (to_process_list.length > 0) {
		const [current_pos, current_count] = to_process_list.pop();
		const cond1 = current_pos.x < 0;
		const cond2 = current_pos.x >= width;
		const cond3 = current_pos.y < 0;
		const cond4 = current_pos.y >= height;
		if (cond1 || cond2 || cond3 || cond4) continue;
		if (grid[current_pos.y][current_pos.x] == wall) continue;
		if (current_pos.x == end_position.x && current_pos.y == end_position.y) {
			best_value = Math.min(best_value, current_count);
			continue;
		}
		const current_found_best = best_map.get(current_pos.y * width + current_pos.x);
		if (current_found_best != undefined && current_count >= current_found_best) continue;
		best_map.set(current_pos.y * width + current_pos.x, current_count);
		to_process_list.push([{x: current_pos.x-1, y: current_pos.y}, current_count+1]);
		to_process_list.push([{x: current_pos.x+1, y: current_pos.y}, current_count+1]);
		to_process_list.push([{x: current_pos.x, y: current_pos.y-1}, current_count+1]);
		to_process_list.push([{x: current_pos.x, y: current_pos.y+1}, current_count+1]);
	}

	return [best_value, best_map];
}


function travel_with_cheat_n_if_beats(n_cheating_iters, best_path_length, best_path_map) {
	const output_list = []

	const to_process_list = [[start_position, 0, -1]]

	while (to_process_list.length > 0) {
		let [current_pos, current_count, cheating_iter] = to_process_list.pop();
		console.log(current_pos, cheating_iter);
		const cond1 = current_pos.x < 0;
		const cond2 = current_pos.x >= width;
		const cond3 = current_pos.y < 0;
		const cond4 = current_pos.y >= height;
		const cond5 = current_count >= best_path_length;
		if (cond1 || cond2 || cond3 || cond4 || cond5) continue;
		if (grid[current_pos.y][current_pos.x] == wall) {
			if (cheating_iter == 0) {
				continue;	
			} else if (cheating_iter == -1) {
				cheating_iter = n_cheating_iters-1;
			}
		}
		if (cheating_iter > 0) cheating_iter -= 1;
		if (current_pos.x == end_position.x && current_pos.y == end_position.y) {
			output_list.push(best_path_length - current_count);
			continue;
		}
		const best_path_map_value = best_path_map.get(current_pos.y * width + current_pos.x);
		if (best_path_map_value != undefined && current_count > best_path_map_value) continue;

		to_process_list.push([{x: current_pos.x-1, y: current_pos.y}, current_count+1, cheating_iter]);
		to_process_list.push([{x: current_pos.x+1, y: current_pos.y}, current_count+1, cheating_iter]);
		to_process_list.push([{x: current_pos.x, y: current_pos.y-1}, current_count+1, cheating_iter]);
		to_process_list.push([{x: current_pos.x, y: current_pos.y+1}, current_count+1, cheating_iter]);
	}

	console.log(output_list)
	return output_list;
}


function partOne() {
	const [best_path_length, best_path_map] = travel();
	const savings = travel_with_cheat_n_if_beats(2, best_path_length, best_path_map);
	return savings.filter(n => n >= 0).length;
}

console.log("Silver:", partOne());
