input.split('\n')
	.map(x => x.match(/\d/)[0] + x.match(/\d(?=[^\d]*$)/)[0])
	.map(x => parseInt(x))
	.reduce((x, y) => x + y)
