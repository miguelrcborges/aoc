const grid = input.split('\n').map(l => l.split(''));
const s = grid.reduce((a, c, i) => {
    const i2 = c.indexOf('S');
    return i2 === -1 
        ? a
        : [i, i2]
}, []);

const steps = grid.map(l => l.map(n => -1));
const start = () => {
	steps[s[0]][s[1]] = 0;
	const top_allowed = ["|", "7", "F"];
	const left_allowed = ["F", "-", "L"];
	const right_allowed = ["-", "J", "7"];
	const south_allowed = ["|", "J", "L"];

	const to_visit = [];

	if (top_allowed.includes(grid[s[0]-1][s[1]])) {
		to_visit.push([s[0]-1, s[1], 1]);
	}
	if (right_allowed.includes(grid[s[0]][s[1]+1])) {
		to_visit.push([s[0], s[1]+1, 1]);
	}
	if (left_allowed.includes(grid[s[0]][s[1]-1])) {
		to_visit.push([s[0], s[1]-1, 1]);
	}
	if (south_allowed.includes(grid[s[0]+1][s[1]])) {
		to_visit.push([s[0]+1, s[1], 1]);
	}

	while (to_visit.length > 0) {
		const tmp = to_visit.pop();
		visit(tmp[0], tmp[1], tmp[2], to_visit);
	}
}

const visit = (y, x, cs, tv) => {
	if (steps[y][x] != -1 && steps[y][x] < cs) {
		return;
	}
	steps[y][x] = cs;

	switch (grid[y][x]) {
		case '|':
			tv.push([y-1, x, cs+1]);
			tv.push([y+1, x, cs+1]);
			break;
		case '-':
			tv.push([y, x-1, cs+1]);
			tv.push([y, x+1, cs+1]);
			break;
		case 'L':
			tv.push([y-1, x, cs+1]);
			tv.push([y, x+1, cs+1]);
			break;
		case 'J':
			tv.push([y-1, x, cs+1]);
			tv.push([y, x-1, cs+1]);
			break;
		case '7':
			tv.push([y+1, x, cs+1]);
			tv.push([y, x-1, cs+1]);
			break;
		case 'F':
			tv.push([y+1, x, cs+1]);
			tv.push([y, x+1, cs+1]);
			break;
		default:
			console.log(`panic at ${x}:${y} w ${cs}`);
	}

}

start();
const max = steps.reduce((a, c) => {
	const l_max = c.reduce((a, c) => a > c ? a : c);
	return a > l_max ? a : l_max;
}, -2);
console.log(max);
