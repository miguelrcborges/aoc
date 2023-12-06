input.split('\n')
	.map(x => x.slice(x.indexOf(':') + 1))
	.map(x => x.split('|').map(s => s.split(' ').filter(s => s != '').map(n => parseInt(n))))
	.map(x => x[1].filter(e => x[0].includes(e)).length)
	.reduce((a, c, i, m) => {
		const addCopyN = (a, i, t, n) => t <= 0 ? undefined : 
			!(a[i]) ? (a[i] = n) && addCopyN(a, i+1, t-1, n) :
			(a[i] += n) && addCopyN(a, i+1, t-1, n);
		addCopyN(a, i, 1, 1);
		addCopyN(a, i+1, c, a[i]);
		return a;
	}, [])
	.reduce((a, c) => a + c)
