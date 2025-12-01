const input = await Deno.readTextFile("input.txt");


const [grid_part, moves_part] = input.split('\n\n');


const moves = moves_part.replaceAll('\n', '');

const free = 0
const wall = 1;
const block = 2;

const charToElement1 = {
	'#': wall,
	'O': block,
	'@': free,
	'.': free
};

let robot1;

const grid1 = grid_part
	.split('\n')
	.map((l, y) => l
		.split('')
		.map((c, x) => {
			if (c == '@') {
				robot1 = {
					x: x,
					y: y,
				};
			}
			return charToElement1[c];
		})
	);


function printGrid(grid, robot) {
	const elementToChar = {
		[free]: '.',
		[wall]: '#',
		[block]: 'O',
		[block_left]: '[',
		[block_right]: ']'
	}

	if (robot == undefined) {
		robot = {
			x: -1,
			y: -1
		}
	}

	const grid_str = grid.reduce(
		(acc, l, y) => acc + l.reduce((acc2, e, x) => robot.y == y && robot.x == x
			? acc2 + '@'
			: acc2 + elementToChar[e]
		, '') + '\n'
	, '');
	console.log(grid_str)
}



function tryToMoveBox(x, y, dx, dy) {
	if (grid1[y+dy][x+dx] == free) {
		grid1[y+dy][x+dx] = block;
		grid1[y][x] = free;
		return true;
	} else if (grid1[y+dy][x+dx] == wall) {
		return false;
	} else {
		const nextMoved = tryToMoveBox(x+dx, y+dy, dx, dy);
		if (nextMoved) {
			grid1[y+dy][x+dx] = block;
			grid1[y][x] = free;
			return true;
		}
		return false;
	}
}


for (let i = 0; i < moves.length; i += 1) {
	const move = moves[i];
	let dx = 0;
	let dy = 0;
	switch (move) {
		case '^': 
			dy = -1
			break;
		case '<':
			dx = -1
			break;
		case '>':
			dx = 1
			break;
		case 'v':
			dy = 1
			break;
		default:
			throw new Error("Invalid move");
	}
	const target_cell_value = grid1[robot1.y+dy][robot1.x+dx];
	if (target_cell_value == free) {
		robot1.x += dx;
		robot1.y += dy;
	} else if (target_cell_value == block) {
		if (tryToMoveBox(robot1.x+dx, robot1.y+dy, dx, dy)) {
			robot1.x += dx;
			robot1.y += dy;
		}
	}
}


let part1 = 0;
for (let y = 0; y < grid1.length; y += 1) {
	for (let x = 0; x < grid1[y].length; x += 1) {
		if (grid1[y][x] == block) {
			part1 += y * 100 + x;
		}
	}
}


const block_left = 3;
const block_right = 4;

let robot2;

const grid2 = grid_part
	.split('\n')
	.map((l, y) => l
		.split('')
		.reduce((acc, e) => {
			if (e == '#') {
				acc.push(wall);
				acc.push(wall);
			} else if (e == '@') {	
				robot2 = {
					x: acc.length,
					y: y
				};
				acc.push(free);
				acc.push(free);
			} else if (e == 'O') {
				acc.push(block_left);
				acc.push(block_right);
			} else {
				acc.push(free);
				acc.push(free);
			}
			return acc;
		}, [])
	)


function isBox2MoveValid(x, y, dx, dy) {
	if (grid2[y][x] == block_left) {
		if (dx == 1) {
			if (grid2[y][x+2] == free) return true;
			return isBox2MoveValid(x+2, y, dx, dy);
		} else if (dx == -1) {
			if (grid2[y][x-1] == free) return true;
			return isBox2MoveValid(x-2, y, dx, dy);
		} else {
			if (grid2[y+dy][x] == free && grid2[y+dy][x+1] == free) return true;
			if (grid2[y+dy][x] == block_left) return isBox2MoveValid(x, y+dy, dx, dy);
			return isBox2MoveValid(x, y+dy, dx, dy) && isBox2MoveValid(x+1, y+dy, dx, dy);
		}
	} else if (grid2[y][x] == block_right) {
		if (dx == 1) {
			if (grid2[y][x+1] == free) return true;
			return isBox2MoveValid(x+2, y, dx, dy);
		} else if (dx == -1) {
			if (grid2[y][x-2] == free) return true;
			return isBox2MoveValid(x-2, y, dx, dy);
		} else {
			if (grid2[y+dy][x] == free && grid2[y+dy][x-1] == free) return true;
			if (grid2[y+dy][x] == block_right) return isBox2MoveValid(x, y+dy, dx, dy);
			return isBox2MoveValid(x, y+dy, dx, dy) && isBox2MoveValid(x-1, y+dy, dx, dy);
		}
	}
	return grid2[y][x] == free;
}


function moveBox2(x, y, dx, dy) {
	if (grid2[y][x] == block_left) {
		if (dx == 1) {
			moveBox2(x+2, y, dx, dy);
			grid2[y][x+2] = block_right;
			grid2[y][x+1] = block_left;
			grid2[y][x] = free;
		} else if (dx == -1) {
			moveBox2(x-2, y, dx, dy);
			grid2[y][x+1] = free;
			grid2[y][x] = block_right;
			grid2[y][x-1] = block_left;
		} else {
			if (grid2[y+dy][x] == block_left) {
				moveBox2(x, y+dy, dx, dy);
			} else {
				moveBox2(x, y+dy, dx, dy);
				moveBox2(x+1, y+dy, dx, dy);
			}
			grid2[y+dy][x] = block_left;
			grid2[y+dy][x+1] = block_right;
			grid2[y][x] = free;
			grid2[y][x+1] = free;
		}
	} else if (grid2[y][x] == block_right) {
		if (dx == 1) {
			moveBox2(x+2, y, dx, dy);
			grid2[y][x+1] = block_right;
			grid2[y][x] = block_left;
			grid2[y][x-1] = free;
		} else if (dx == -1) {
			moveBox2(x-2, y, dx, dy);
			grid2[y][x] = free;
			grid2[y][x-1] = block_right;
			grid2[y][x-2] = block_left;
		} else {
			if (grid2[y+dy][x] == block_right) {
				moveBox2(x, y+dy, dx, dy);
			} else {
				moveBox2(x, y+dy, dx, dy);
				moveBox2(x-1, y+dy, dx, dy);
			}
			grid2[y+dy][x-1] = block_left;
			grid2[y+dy][x] = block_right;
			grid2[y][x-1] = free;
			grid2[y][x] = free;
		}
	}
}

for (let i = 0; i < moves.length; i += 1) {
	const move = moves[i];
	let dx = 0;
	let dy = 0;
	switch (move) {
		case '^': 
			dy = -1
			break;
		case '<':
			dx = -1
			break;
		case '>':
			dx = 1
			break;
		case 'v':
			dy = 1
			break;
		default:
			throw new Error("Invalid move");
	}
	const target_cell_value = grid2[robot2.y+dy][robot2.x+dx];
	if (target_cell_value == free) {
		robot2.x += dx;
		robot2.y += dy;
	} else if (target_cell_value != wall) {
		if (isBox2MoveValid(robot2.x+dx, robot2.y+dy, dx, dy)) {
			moveBox2(robot2.x+dx, robot2.y+dy, dx, dy);
			robot2.x += dx;
			robot2.y += dy;
		}
	}
}


let part2 = 0;
for (let y = 0; y < grid2.length; y += 1) {
	for (let x = 0; x < grid2[y].length; x += 1) {
		if (grid2[y][x] == block_left) {
			part2 += y * 100 + x;
		}
	}
}


console.log("Silver: ", part1);
console.log("Gold: ", part2);
