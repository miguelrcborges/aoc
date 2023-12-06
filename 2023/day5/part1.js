const maps = input.split('\n\n').map(x => x.slice(x.indexOf(':') + 2));
maps[0] = maps[0].replaceAll(' ', '\n');
maps.map(x => x.split('\n').map(x => x.split(' ').map(n => parseInt(n))))
	.reduce((a, c, i) => a.map(l => {
			const f = c.filter(e => l[0] >= e[1] && l[0] < e[1] + e[2])[0];
			if (!f) {
					return l;
			}
			return [f[0] + l[0] - f[1]];
	}))
	.map(x => x[0])
	.reduce((a, c) => a > c ? c : a)
