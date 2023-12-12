// NOTE: STILL NOT READY

const grid = input.split('\n').map(l => l.split(''));
const s = grid.reduce((a, c, i) => {
    const i2 = c.indexOf('S');
    return i2 === -1 
        ? a
        : [i, i2]
}, []);

const is_loop = grid.map(l => l.map(n => 0));
const visit = (y, x, tv) => {
	if (is_loop[y][x] == 1) {
		return;
	}
	is_loop[y][x] = 1;

	switch (grid[y][x]) {
		case '|':
			tv.push([y-1, x]);
			tv.push([y+1, x]);
			break;
		case '-':
			tv.push([y, x-1]);
			tv.push([y, x+1]);
			break;
		case 'L':
			tv.push([y-1, x]);
			tv.push([y, x+1]);
			break;
		case 'J':
			tv.push([y-1, x]);
			tv.push([y, x-1]);
			break;
		case '7':
			tv.push([y+1, x]);
			tv.push([y, x-1]);
			break;
		case 'F':
			tv.push([y+1, x]);
			tv.push([y, x+1]);
			break;
		default:
			console.log(`panic at ${x}:${y} w ${cs}`);
	}
}

const start = () => {
	is_loop[s[0]][s[1]] = 1;
	const north_allowed = ["|", "7", "F"];
	const west_allowed = ["F", "-", "L"];
	const east_allowed = ["-", "J", "7"];
	const south_allowed = ["|", "J", "L"];

	const to_visit = [];

	const at_north = s[0] > 0 && north_allowed.includes(grid[s[0]-1][s[1]]);
	const at_west  = s[1] > 0 && west_allowed.includes(grid[s[0]][s[1]-1]);
	const at_east  = s[1] + 1 < grid[0].length && east_allowed.includes(grid[s[0]][s[1]+1]);
	const at_south = s[0] + 1 < grid.length && south_allowed.includes(grid[s[0]+1][s[1]]);

	if (at_north) {
		to_visit.push([s[0]-1, s[1]]);
	}
	if (at_east) {
		to_visit.push([s[0], s[1]+1]);
	}
	if (at_west) {
		to_visit.push([s[0], s[1]-1]);
	}
	if (at_south) {
		to_visit.push([s[0]+1, s[1]]);
	}

	switch (true) {
		case at_north && at_south:
			grid[s[0]][s[1]] = '|'
			break;
		case at_north && at_east:
			grid[s[0]][s[1]] = 'L'
			break;
		case at_north && at_west:
			grid[s[0]][s[1]] = 'J'
			break;
		case at_south && at_west:
			grid[s[0]][s[1]] = '7'
			break;
		case at_south && at_east:
			grid[s[0]][s[1]] = 'F'
			break;
		case at_west && at_east:
			grid[s[0]][s[1]] = '-'
			break;
	}

	while (to_visit.length > 0) {
		const tmp = to_visit.pop();
		visit(tmp[0], tmp[1], to_visit);
	}
	const expansions = {
		'|': [[0, 1, 0], [0, 1, 0], [0, 1, 0]],
		'-': [[0, 0, 0], [1, 1, 1], [0, 0 ,0]],
		'L': [[0, 1, 0], [0, 1, 1], [0, 0, 0]],
		'J': [[0, 1, 0], [1, 1, 0], [0, 0, 0]],
		'7': [[0, 0, 0], [1, 1, 0], [0, 1, 0]],
		'F': [[0, 0, 0], [0, 1, 1], [0, 1, 0]],
	}
	const expanded = [];
	for (let y = 0; y < is_loop.length; y++) {
		for (let x = 0; x < is_loop[y].length; x++) {
			if (is_loop[y][x] == 0) {
				if (x == 0) {
					expanded.push([0, 0, 0], [0, 0, 0], [0, 0, 0])
				} else for (let i = y * 3; i < y * 3 + 3; i++) {
					expanded[i].push(0, 0, 0);
				}
				if (y == 4) {
				}
			} else {
				if (x == 0) {
					expanded.push(...expansions[grid[y][x]].map(y => y.map(x => x)));
				} else for (let i = 0; i < 3; ++i) {
					expanded[y*3+i].push(...expansions[grid[y][x]][i])
				}
			}	
		}
	};

	const inverse = expanded.map(l => l.map(e => e == 0 ? 1 : 0));
	const labels_matches = {};
	const insertMatch = (k1, k2) => {
		if (k1 == k2 || k1 == 1) return k2;
		const [max, min] = k1 > k2 ? [k1, k2] : [k2, k1];
		if (!labels_matches[max]) {
			labels_matches[max] = min;
		}
		return min;
	}

	let cl = 1;
	for (let y = 0; y < inverse.length; y++) {
		for (let x = 0; x < inverse[y].length; x++) {
			const left_free = x > 0;
			const top_free = y > 0;
			const right_free = x + 1 < inverse[y].length;
			if (inverse[y][x] == 1) {
				if (left_free && inverse[y][x-1] > 1) {
					inverse[y][x] = insertMatch(inverse[y][x], inverse[y][x-1]);
				}
				if (left_free && top_free && inverse[y-1][x-1] > 1) {
					inverse[y][x] = insertMatch(inverse[y][x], inverse[y-1][x-1]);
				}
				if (top_free && inverse[y-1][x] > 1) {
					inverse[y][x] = insertMatch(inverse[y][x], inverse[y-1][x]);
				}
				if (inverse[y][x] == 1) {
					cl++;
					inverse[y][x] = cl;
				}
			}
		}
	}

	for (let y = 0; y < inverse.length; y++) {
		for (let x = 0; x < inverse[y].length; x++) {
			const v = labels_matches[inverse[y][x]];
			inverse[y][x] = v ? v : inverse[y][x];
		}
	}
	
	const border_labels = new Set([0]);
	for (let x = 0; x < inverse[0].length; x++) {
		border_labels.add(inverse[0][x]);
		border_labels.add(inverse[inverse.length-1][x]);
	}
	for (let y = 0; y < inverse.length; y++) {
		border_labels.add(inverse[y][0]);
		border_labels.add(inverse[y][inverse[y].length-1]);
	}
	const enclosed = inverse.map(l => l.map(n => border_labels.has(n) ? 0 : 1));
	const count = enclosed
		.reduce((a, l, y) => y % 3 != 1 
			? a 
			: a + l.reduce((a2, e, x) => x % 3 != 1
				? a2 
				: a2 + e, 0), 0);
	console.log(is_loop);
	console.log(expanded);
	console.log(inverse);
	console.log(enclosed);
	console.log(count);
}

start();
