Span<string> input = System.IO.File.ReadAllLines("input.txt");

var gap = input.IndexOf("");

var ranges_str = input.Slice(0, gap);
var numbers_str = input.Slice(gap + 1);

var ranges = ranges_str.ToArray().Select(x => x.Split('-').Select(UInt64.Parse).ToList()).ToList();
var numbers = numbers_str.ToArray().Select(UInt64.Parse).ToList();

ranges.Sort((x, y) => x[0] < y[0] ? -1 : 1);
numbers.Sort();

for (int i = 0; i < ranges.Count - 1; ) {
	if (ranges[i][1] >= ranges[i+1][0]) {
		ranges[i][1] = ranges[i+1][1] > ranges[i][1] ? ranges[i+1][1] : ranges[i][1];
		ranges.RemoveAt(i+1);
	} else {
		i += 1;
	}
}

int silver = 0;
int range_idx = 0;
foreach (var n in numbers) {
	while (n > ranges[range_idx][1]) {
		range_idx += 1;
		if (range_idx >= ranges.Count) goto getout;
	}
	if (n >= ranges[range_idx][0]) {
		silver += 1;
	}
}

getout:
ulong gold = 0;
foreach (var r in ranges) {
	gold += r[1] - r[0] + 1;
}

Console.WriteLine($"Silver: {silver}");
Console.WriteLine($"Gold: {gold}");