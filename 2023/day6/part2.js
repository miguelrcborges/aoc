const NWays = (a) => {
	// Needs to add one since it is winning races (> target time and not >=)
	const root = (a[0]**2 - 4*(a[1]+1)**0.5;
	// Using root directly doesn't work consistently since depends 
	// on the rounding and the position of the base of the square function. 
	const min = Math.ceil((a[0] - root)/2);
	const max = Math.floor((a[0] + root)/2);
	return max - min + 1;  
}
NWays(input.split('\n').map(x => parseInt(x.slice(x.indexOf(':')+1).replaceAll(' ', ''))))
