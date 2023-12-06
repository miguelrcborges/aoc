const getValidGears = (e, x, y, m) => {
	const isNumber = (e) => e >= '0' && e <= '9';
	const isGear = (e) => !isNumber(e) && e != '.';
	if (!isGear(e)) { return 0; }

	const left_free = x > 0;
	const right_free = x + 1 < m[0].length;
	const top_free = y > 0;
	const bot_free = y + 1 < m.length;

	const is_left_top_num = left_free && top_free && isNumber(m[y-1][x-1]);
	const is_top_num = !is_left_top_num && top_free && isNumber(m[y-1][x]);
	const is_right_top_num = top_free && !isNumber(m[y-1][x]) && right_free && isNumber(m[y-1][x+1]);

	const is_left_bot_num = left_free && bot_free && isNumber(m[y+1][x-1]);
	const is_bot_num = !is_left_bot_num && bot_free && isNumber(m[y+1][x]);
	const is_right_bot_num = bot_free && !isNumber(m[y+1][x]) && right_free && isNumber(m[y+1][x+1]);

	const is_left_num = left_free && isNumber(m[y][x-1]);
	const is_right_num = right_free && isNumber(m[y][x+1]);

	const num_count = is_left_top_num + is_top_num + is_right_top_num +
		is_right_num + is_right_bot_num + is_bot_num + is_left_bot_num + is_left_num;

	if (num_count != 2) {
		return 0;
	}

	const parseNum = (x, y, m) => {
		const left_free = x > 0;
		if (left_free && isNumber(m[y][x-1])) {
			return parseNum(x-1, y, m);
		}
		return parseInt(input.split('\n')[y].slice(x));
	};

	let r = 1;
	if (is_left_top_num) {r *= parseNum(x-1, y-1, m);}
	if (is_top_num) {r *= parseNum(x, y-1, m);}
	if (is_right_top_num) {r *= parseNum(x+1, y-1, m);}
	if (is_right_num) {r *= parseNum(x+1, y, m);}
	if (is_right_bot_num) {r *= parseNum(x+1, y+1, m);}
	if (is_bot_num) {r *= parseNum(x, y+1, m);}
	if (is_left_bot_num) {r *= parseNum(x-1, y+1, m);}
	if (is_left_num) {r *= parseNum(x-1, y, m);}

	return r;
}

input.split('\n')
	.map(x => x.split(""))
	.map((r, y, m) => r.map((e, x) => getValidGears(e, x, y, m)))
	.map(r => r.reduce((a, c) => a + c))
	.reduce((a, c) => a + c)

