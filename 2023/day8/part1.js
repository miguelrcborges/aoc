const [directions, data] = input.split('\n\n');
const orders = data.split('\n')
	.map(l => l.split(' = ').map((c, i) => i == 0 ? c : c.slice(1, -1).split(', ')))
	.reduce((a, c) => {a[c[0]] = {"L": c[1][0], "R": c[1][1]}; return a;}, {});

() => {
	let [p, i] = ['AAA', 0];
	while (p != 'ZZZ') {
		p = orders[p][directions[i % directions.length]];
		i += 1;
	}
	console.log(i);
}
