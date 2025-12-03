var input = System.IO.File.ReadAllText("input.txt");

bool IsSilverValid(ulong n) {
	int l = (int) Math.Floor(Math.Log10(n) + 1);
	if (l % 2 != 0) return false;
	ulong d = (ulong)Math.Pow(10, l / 2);
	return n % d == n / d;
}

bool IsGoldValid(ulong n) {
	int l = (int) Math.Floor(Math.Log10(n) + 1);
	int hl = l / 2;
	for (int sl = 1; sl <= hl; sl += 1) {
		var nsl = l / sl;
		var nslrem = l % sl;
		if (nslrem != 0 || nsl < 2) {
			continue;
		}
		var bten = (ulong) Math.Pow(10, sl);
		var to_divide = n / bten;
		var target = n % bten;
		bool valid = true;
		while (to_divide > 0) {
			var curr_rem = to_divide % bten;
			var next_to_divide = to_divide / bten;
			if (curr_rem != target) {
				valid = false;
				break;
			} else {
				to_divide = next_to_divide;
			}
		}
		if (valid) {
			return true;
		}
	}
	return false;
}

var commands = input.Split(',');
var ranges = commands.ToList().ConvertAll(c => c.Split('-').ToList().ConvertAll(s => ulong.Parse(s)));

ulong silver = 0;
ulong gold = 0;

foreach (var r in ranges) {
	for (ulong n = r[0]; n <= r[1]; n += 1) {
		if (IsSilverValid(n)) {
			silver += n;
		}
		if (IsGoldValid(n)) {
			gold += n;
		}
	}
}

Console.WriteLine($"Silver: {silver}");
Console.WriteLine($"Gold: {gold}");