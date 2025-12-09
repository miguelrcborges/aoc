HashSet<Point> splitters = new();
Point start_pos = new();

int height = 0;
using (var reader = new System.IO.StreamReader("input.txt")) {
	string? line;
	while ((line = reader.ReadLine()) != null) {
		for (int x = 0; x < line.Length; x += 1) {
			if (line[x] == 'S') {
				start_pos = new Point{ x = x, y = height };
			} else if (line[x] == '^') {
				splitters.Add(new Point{ x = x, y = height });
			}
		}
		height += 1;
	}
}

Dictionary<Point, ulong> silver_splitters = new();

ulong Travel(Point current_position) {
	while (current_position.y < height) {
		if (splitters.Contains(current_position)) {
			if (silver_splitters.ContainsKey(current_position)) {
				return silver_splitters[current_position];
			} else {
				ulong sum = Travel(new Point{ x = current_position.x - 1, y = current_position.y + 1 });
				sum += Travel(new Point{ x = current_position.x + 1, y = current_position.y + 1 });
				silver_splitters[current_position] = sum;
				return sum;
			}
		} else {
			current_position.y += 1;
		}
	}
	return 1;
}


ulong gold = Travel(start_pos);


Console.WriteLine($"Silver: {silver_splitters.Count()}");
Console.WriteLine($"Gold: {gold}");


public struct Point {
	public int x;
	public int y;
};
