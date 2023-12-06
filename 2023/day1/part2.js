const dickt = [
	["one", "o1e"],
	["two", "t2o"],
	["three", "t3e"],
	["four", "f4r"],
	["five", "f5e"],
	["six", "s6x"],
	["seven", "s7n"],
	["eight", "e8t"],
	["nine", "n9e"]
]

input.split('\n')
	.map(x => dickt.reduce((a, e) => a.replaceAll(e[0], e[1]), x))
	.map(x => x.match(/\d/)[0] + x.match(/\d(?=[^\d]*$)/)[0])
	.map(x => parseInt(x))
	.reduce((x, y) => x + y)
