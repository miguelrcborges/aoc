const possible_values = ["J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"];
const rank = possible_values.reduce((a, c, i) => { a[c] = i; return a; }, {});
const compareCards = (h1, h2, i) => h1[i] != h2[i] ? rank[h1[i]] - rank[h2[i]] : compareCards(h1, h2, i+1);

const getType = (h) => possible_values
	.map(v => possible_values.map(v2 => h.replaceAll("J", v).split(v2).length - 1)
		.sort((a, b) => b - a).slice(0, 2))
	.sort((a, b) => b[0] != a[0] ? b[0] - a[0] : b[1] - a[1])[0]


input.split('\n')
	.map(x => x.split(' ').map((c, i) => i == 1 ? parseInt(c) : [c, getType(c)], {}))
	.sort((a, b) => a[0][1][0] != b[0][1][0]
		? a[0][1][0]- b[0][1][0]
		: a[0][1][1] != b[0][1][1]
			? a[0][1][1] - b[0][1][1]
			: compareCards(a[0][0], b[0][0], 0))
	.reduce((a, c, i) => a + c[1] * (i+1), 0)
