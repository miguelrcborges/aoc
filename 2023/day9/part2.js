const lastEl = (a) => a[a.length-1];
const isOver = (a) => a.reduce((a, c) => a && c == 0, true);
const derive = (a) => a.reduce((a, c, i, arr) => {
	i == (arr.length - 1) ? undefined : a.push(arr[i+1]-c);
	return a;
}, []);
const predict = (a) => {
	const arrs = [a];
	while (!isOver(lastEl(arrs))) {
		arrs.push(derive(lastEl(arrs)))
	}
	arrs.reverse()
		.map((a, i) => i == 0 
			? arrs[i].push(0) 
			: arrs[i].push(lastEl(arrs[i-1])+lastEl(arrs[i])))
	return lastEl(lastEl(arrs));
}

input.split('\n')
	.map(l => l.split(' ').map(n => parseInt(n)).reverse())
	.reduce((a, c) => a + predict(c), 0)
