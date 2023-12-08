const [directions, data] = input.split('\n\n');
const orders = data.split('\n')
	.map(l => l.split(' = ').map((c, i) => i == 0 ? c : c.slice(1, -1).split(', ')))
	.reduce((a, c) => {a[c[0]] = {"L": c[1][0], "R": c[1][1]}; return a;}, {});

const times = (p) => {
	let i = 0;
	while (p[2] != 'Z') {
		p = orders[p][directions[i % directions.length]];
		i += 1;
	}
	return i;
}

const gcd = (a, b) => !b ? a : gcd(b, a % b);
const lcm = (a, b) => a * b / gcd(a, b);

console.log(
	Object.keys(orders)
		.filter(l => l[2] == 'A')
		.map(l => times(l))	
		.reduce((a, c) => lcm(a, c)))
