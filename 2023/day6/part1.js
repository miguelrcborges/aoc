const NWays = (a) => {
	const best_time = Math.floor(a[0]/2)
	const computeTime = (n) => a[0] * n - n * n;
	const recurseCompute = (n, dn) => {
		return computeTime(n) > a[1] ? 1 + recurseCompute(n + dn, dn) : 0; 
	}
	return 1 + recurseCompute(best_time+1, 1) + recurseCompute(best_time-1, -1);
}
input.split('\n').map(x => x.slice(x.indexOf(':')+1)
	.split(' ').filter(e => e !== '').map(n => parseInt(n)))
	.reduce((a, c, i, m) => m[0].map((col, i) => m.map(r => r[i])))
	.reduce((a, c) => a * NWays(c), 1)
