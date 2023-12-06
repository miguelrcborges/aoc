const maps = input.split('\n\n').map(x => x.slice(x.indexOf(':') + 2));
maps[0] = maps[0].split(' ').reduce((a, c, i) => {
	if (i % 2 == 0) {
		return a + `${c} `;
	} else {
		return a + c + "\n";
	}
	return a;
}, "").slice(0, -1);
maps.map(x => x.split('\n').map(x => x.split(' ').map(n => parseInt(n))))
	.reduce((a, c, i) => {
		let ranges = [];
		const dontMatch = (min1, len1, min2, len2) => 
			(min1 + len1 <= min2) || 
			(min2 + len2 <= min1 && min2 <= min1); 

		const checkRange = (min, len) => {
			if (len <= 0) return;
			const f1 = c.filter(e => !dontMatch(e[1], e[2], min, len))[0]
			if (f1) {
				const is_bot_cont = f1[1] <= min;
				const is_top_cont = f1[1] + f1[2] >= min + len;
				const bot = is_bot_cont ? min : f1[1] ;
				const top = is_top_cont ? min + len : f1[1] + f1[2];
				ranges.push([bot + f1[0] - f1[1], top - bot]);
				if (!is_bot_cont) {
					checkRange(min, bot - min);
				}
				if (!is_top_cont) {
					checkRange(top, min + len - top);
				}
				return;
			};
			ranges.push([min, len]);
		};
		a.map(r => checkRange(r[0], r[1]));
		return ranges;
	})
	.map(x => x[0])
	.reduce((a, c) => a > c ? c : a)
