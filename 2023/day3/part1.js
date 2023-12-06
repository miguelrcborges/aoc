const getValidNumbersStart = (e, x, y, m) => {
	const isNumber = (e) => e >= '0' && e <= '9';
	if (!isNumber(e)) { return false; }
	const left_free = x > 0;

	if (left_free && isNumber(m[y][x-1])) {
		return false;
	}

	const isSchematicNear = (x, y, m) => {
		const left_free = x > 0;
		const right_free = x + 1 < m[0].length;
		const top_free = y > 0;
		const bottom_free = y + 1 < m.length;

		const isSchematic = (e) => !isNumber(e) && e != '.';

		const has_schematic = (left_free && top_free && isSchematic(m[y-1][x-1])) ||
			(top_free && isSchematic(m[y-1][x])) ||
			(top_free && right_free && isSchematic(m[y-1][x+1])) ||
			(right_free && isSchematic(m[y][x+1])) ||
			(bottom_free && right_free && isSchematic(m[y+1][x+1])) ||
			(bottom_free && isSchematic(m[y+1][x])) ||
			(bottom_free && left_free && isSchematic(m[y+1][x-1])) ||
			(left_free && isSchematic(m[y][x-1]))

		if (!has_schematic && isNumber(m[y][x+1])) {
			return isSchematicNear(x+1, y, m);
		}
		return has_schematic;
	}

	return isSchematicNear(x, y, m);
}

input.split('\n')
	.map(x => x.split(""))
	.map((r, y, m) => r.map((e, x) => getValidNumbersStart(e, x, y, m)))
	.map((r, ri) => r.reduce((a, c, i) => c ? parseInt(input.split('\n')[ri].slice(i)) + a : a, 0))
	.reduce((a, c) => a + c)
