string[] lines = System.IO.File.ReadAllLines("input.txt");

string ll = lines[^1];

List<bool> is_mul = [];
List<ushort> col_width = [];

int prev_index = 0;
int col_width_sum = 0;
for (int i = 0; i < ll.Length; i += 1) {
	if (ll[i] != ' ') {
		if (is_mul.Count != 0) {
			col_width.Add((ushort) (i - prev_index - 1));
			col_width_sum += i - prev_index - 1;
			prev_index = i;
		}
		is_mul.Add(ll[i] == '*');
	}
}
col_width.Add((ushort) (ll.Length - prev_index));
col_width_sum += ll.Length - prev_index;

int n_operands = lines.Length - 1;
int n_operations = is_mul.Count;

uint[] silver_numbers = new uint[n_operands * n_operations];
uint[] gold_numbers = new uint[col_width_sum];

for (int i = 0; i < lines.Length - 1; i += 1) {
	string l = lines[i];
	int lpos = 0;
	int silver_i = i;
	int gold_i = 0;
	for (int ni = 0; ni < col_width.Count; ni += 1) {
		uint silver_acc = 0;
		int npos = 0;
		while (l[lpos+npos] == ' ') {
			gold_i += 1;
			npos += 1;
		}
		while (npos < col_width[ni] && l[lpos+npos] != ' ') {
			uint d = (uint) (l[lpos+npos] - '0');
			silver_acc = silver_acc * 10 + d;
			gold_numbers[gold_i] = gold_numbers[gold_i] * 10 + d;
			gold_i += 1;
			npos += 1;
		}
		gold_i += col_width[ni] - npos;
		silver_numbers[silver_i] = silver_acc;
		lpos += col_width[ni] + 1;
		silver_i += n_operands;
	}
}


ulong silver = 0;
for (int n = 0; n < n_operations; n += 1) {
	int base_i = n * n_operands;
	ulong tmp_acc = 0;
	if (is_mul[n]) {
		tmp_acc = 1;
		for (int ni = 0; ni < n_operands; ni += 1) {
			tmp_acc *= silver_numbers[base_i + ni];
		}
	} else {
		for (int ni = 0; ni < n_operands; ni += 1) {
			tmp_acc += silver_numbers[base_i + ni];
		}
	}
	silver += tmp_acc;
}

ulong gold = 0;
uint gold_n_index = 0;
for (int n = 0; n < n_operations; n += 1) {
	ulong tmp_acc = 0;
	uint nops = col_width[n];
	if (is_mul[n]) {
		tmp_acc = 1;
		for (int ni = 0; ni < nops; ni += 1) {
			tmp_acc *= gold_numbers[gold_n_index + ni];
		}
	} else {
		for (int ni = 0; ni < nops; ni += 1) {
			tmp_acc += gold_numbers[gold_n_index + ni];
		}
	}
	gold_n_index += nops;
	gold += tmp_acc;
}

Console.WriteLine($"Silver: {silver}");
Console.WriteLine($"Gold: {gold}");