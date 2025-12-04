struct Point
{
	public int y;
	public int x;
};

static class Program
{

	static bool CheckValid(int x, int y, char[][] map)
	{
		if (map[y][x] != '@') return false;

		int n_nbgs = 0;
		for (int dy = -1; dy <= 1; dy += 1)
		{
			if (y + dy < 0) continue;
			if (y + dy >= map.Length) continue;
			for (int dx = -1; dx <= 1; dx += 1)
			{
				if (x + dx < 0) continue;
				if (x + dx >= map[y].Length) continue;
				if (map[y + dy][x + dx] == '@') n_nbgs += 1;
			}
		}
		return n_nbgs <= 4;
	}


	static void Main()
	{
		var input = System.IO.File.ReadAllLines("input.txt").Select(line => line.ToCharArray()).ToArray();

		long silver = 0;
		long gold = 0;

		List<Point> inital_valid = [];
		Queue<Point> gold_jobs = [];

		for (int y = 0; y < input.Length; y += 1)
		{
			for (int x = 0; x < input[y].Length; x += 1)
			{
				if (CheckValid(x, y, input)) {
					inital_valid.Add(new Point { y = y, x = x });
				}
			}
		}

		silver = inital_valid.Count;
		
		foreach (var p in inital_valid) {
			input[p.y][p.x] = '.';
			gold_jobs.Enqueue(p);
		}
		gold = silver;

		while (gold_jobs.Count > 0)
		{
			var p = gold_jobs.Dequeue();
			for (int dy = -1; dy <= 1; dy += 1) {
				if (p.y + dy < 0) continue;
				if (p.y + dy >= input.Length) continue;
				for (int dx = -1; dx <= 1; dx += 1)
				{
					if (p.x + dx < 0) continue;
					if (p.x + dx >= input[p.y].Length) continue;
					if (CheckValid(p.x + dx, p.y + dy, input)) {
						input[p.y + dy][p.x + dx] = '.';
						gold += 1;
						gold_jobs.Enqueue(new Point { y = p.y + dy, x = p.x + dx });
					}
				}
			}
		}

		Console.WriteLine($"Silver: {silver}");
		Console.WriteLine($"Gold: {gold}");
	}
}