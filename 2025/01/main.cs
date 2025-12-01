int silver = 0;
int gold = 0;
int current_travel = 50;
char last_dir = 'X';

using (var reader = new System.IO.StreamReader("input.txt")) {
	string? line;

	while ((line = reader.ReadLine()) != null) {
		var dir = line[0];
		var amount = int.Parse(line[1..]);

		if (dir != last_dir) {
			current_travel = (100 - current_travel) % 100;
			last_dir = dir;
		}

		current_travel += amount;
		gold += current_travel / 100;
		current_travel %= 100;
		Console.WriteLine($"{line} -> {current_travel} : {gold}");
		if (current_travel == 0) {
			silver += 1;
		}
	}
}

Console.WriteLine($"Silver: {silver}");
Console.WriteLine($"Gold: {gold}");