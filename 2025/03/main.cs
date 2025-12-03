int silver = 0;
long gold = 0;


using (var reader = new System.IO.StreamReader("input.txt")) {
	string? line;
	while ((line = reader.ReadLine()) != null) {
		// Silver
		int decimals_i = 0;
		char decimals_v = (char) 0;
		for (int i = 0; i < line.Length - 1; i += 1) {
			if (line[i] > decimals_v) {
				decimals_i = i;
				decimals_v = line[i];
				if (decimals_v == '9') break;
			}
		}
		char units_v = (char) 0;
		for (int i = decimals_i + 1; i < line.Length; i += 1) {
			if (line[i] > units_v) {
				units_v = line[i];
				if (units_v == '9') break;
			}
		}
		silver += (decimals_v - '0') * 10 + (units_v - '0');


		// Gold
		int idx = 11;
		int last_written_idx = -1;
		long n_to_sum = 0;
		while (idx >= 0) {
			char current_max = (char) 0;
			for (int i = last_written_idx + 1; i < line.Length - idx; i += 1) {
				if (line[i] > current_max) {
					current_max = line[i];
					last_written_idx = i;
					if (line[i] == '9') break;
				}
			}
			idx -= 1;
			n_to_sum = n_to_sum * 10 + (long) (current_max - '0');
		}
		gold += n_to_sum;
	}
}

Console.WriteLine($"Silver: {silver}");
Console.WriteLine($"Gold: {gold}");