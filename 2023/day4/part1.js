input.split('\n')
	.map(x => x.slice(x.indexOf(':') + 1))
	.map(x => x.split('|').map(s => s.split(' ').filter(s => s != '').map(n => parseInt(n))))
	.map(x => x[1].filter(e => x[0].includes(e)).length)
	.map(x => Math.floor(2**(x-1)))
	.reduce((a, c) => a + c)
