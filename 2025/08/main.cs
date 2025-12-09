using System.Collections;

const int n_connections = 1000;

List<Point> points = new();

using (var reader = new System.IO.StreamReader("input.txt")) {
	string? line;
	while ((line = reader.ReadLine()) != null) {
		var elements = line.Split(',');
		var p = new Point();
		p.x = int.Parse(elements[0]);
		p.y = int.Parse(elements[1]);
		p.z = int.Parse(elements[2]);
		points.Add(p);
	}
}


double DistanceOfTwoPoints(Point p1, Point p2) {
	double dx = p1.x - p2.x;
	double dy = p1.y - p2.y;
	double dz = p1.z - p2.z;
	return Math.Sqrt(dx * dx + dy * dy + dz * dz);
}

List<PointsDistances> distances = new();
for (int i = 0; i < points.Count - 1; i += 1) {
	for (int ii = i + 1; ii < points.Count; ii += 1) {
		var d = new PointsDistances();
		d.p1 = i;
		d.p2 = ii;
		d.distance = DistanceOfTwoPoints(points[i], points[ii]);
		distances.Add(d);
	}
}

distances.Sort((d1, d2) => d1.distance < d2.distance ? -1 : 1);

int current_pairing_id = 1;
int[] paired_ids = new int[points.Count]; 
int[] matching_ids = new int[n_connections];

for (int i = 0; i < n_connections; i += 1) {
	var c = distances[i];
	if (paired_ids[c.p1] == 0 && paired_ids[c.p2] == 0) {
		paired_ids[c.p1] = current_pairing_id;
		paired_ids[c.p2] = current_pairing_id;
		current_pairing_id += 1;
	} else if (paired_ids[c.p1] == 0 && paired_ids[c.p2] != 0) {
		paired_ids[c.p1] = paired_ids[c.p2];
	} else if (paired_ids[c.p1] != 0 && paired_ids[c.p2] == 0) {
		paired_ids[c.p2] = paired_ids[c.p1];
	} else {
		int id1 = paired_ids[c.p1];
		int id2 = paired_ids[c.p2];

		while (matching_ids[id1] != 0) id1 = matching_ids[id1];
		while (matching_ids[id2] != 0) id2 = matching_ids[id2];

		if (id1 != id2) {
			matching_ids[id2] = id1;
		}
	}
}

for (int i = 1; i < current_pairing_id; i += 1) {
	int label = i;
	while (matching_ids[label] != 0 && matching_ids[label] != label) {
		label = matching_ids[label];
	}
	matching_ids[i] = label;
}

for (int i = 0; i < paired_ids.Count(); i += 1) {
	paired_ids[i] = matching_ids[paired_ids[i]];
}

int[] circuit_sizes = new int[current_pairing_id];
for (int i = 0; i < paired_ids.Count(); i += 1) {
	circuit_sizes[paired_ids[i]] += paired_ids[i] == 0 ? 0 : 1;
}
Array.Sort(circuit_sizes, (a, b) => b - a);

int silver = 1;
for (int i = 0; i < 3; i += 1) {
	silver *= circuit_sizes[i];
}


BitArray is_on_gold = new(points.Count+1);
int is_on_gold_count = 0;
long gold = 0;
for (int i = 0; ; i += 1) {
	var c = distances[i];
	if (!is_on_gold.Get(c.p1)) {
		is_on_gold_count += 1;
		is_on_gold.Set(c.p1, true);
	}
	if (!is_on_gold.Get(c.p2)) {
		is_on_gold_count += 1;
		is_on_gold.Set(c.p2, true);
	}
	if (is_on_gold_count == points.Count) {
		gold = (long) points[c.p1].x * points[c.p2].x;
		break;
	}
}

Console.WriteLine($"Silver: {silver}");
Console.WriteLine($"Gold: {gold}");

public struct Point {
	public int x;
	public int y;
	public int z;
};


public struct PointsDistances {
	public int p1;
	public int p2;
	public double distance; 
}