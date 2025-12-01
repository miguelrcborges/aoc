#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

#define min(x, y) ((x)<(y)?(x):(y))
#define max(x, y) ((x)>(y)?(x):(y))


int main(int argc, char **argv) {
	if (argc < 2) {
		fputs("Provide a file to open.\n", stderr);
		return 1;
	}

	FILE *f = fopen(argv[1], "rb");
	if (f == NULL) {
		fputs("Provide a file to open.\n", stderr);
		return 1;
	}

	fseek(f, 0, SEEK_END);
	long input_size = ftell(f);
	fseek(f, 0, SEEK_SET);
	
	char *input = malloc(input_size);
	fread(input, 1, input_size, f);
	fclose(f);
	unsigned input_pitch = (strchr(input, '\n') - input) + 1;
	unsigned width = (input_pitch >= 2 && input[input_pitch-2] == '\r') ? input_pitch-2 : input_pitch-1;
	unsigned height = input_size / input_pitch;
#define INPUT(x, y) input[(x)+((y)*input_pitch)]

	unsigned *labelled_map = malloc(width * height * sizeof(unsigned));
#define OUT(x, y) labelled_map[(x)+((y)*width)]
	unsigned *label_equivalents_map = calloc(sizeof(*label_equivalents_map), width*height);

	unsigned running_label_id = 0;
	for (unsigned y = 0; y < height; y += 1) {
		for (unsigned x = 0; x < width; x += 1) {
			if (y > 0 && (INPUT(x, y-1) == INPUT(x, y))) {
				OUT(x, y) = OUT(x, y-1);
				if (x > 0 && (INPUT(x-1, y) == INPUT(x, y))) {
					unsigned value_to_set = min(OUT(x, y-1), OUT(x-1, y));
					unsigned label_to_set = max(OUT(x, y-1), OUT(x-1, y));
					while (label_to_set != value_to_set && value_to_set) {
						unsigned tmp = label_equivalents_map[label_to_set];
						unsigned tmp2 = value_to_set;
						// printf("Setting label %u equivalent to %u.\n", label_to_set, value_to_set);
						label_equivalents_map[label_to_set] = value_to_set;
						label_to_set = max(tmp, tmp2);
						value_to_set = min(tmp, tmp2);
					}
				}
			} else if (x > 0 && (INPUT(x-1, y) == INPUT(x, y))) {
				OUT(x, y) = OUT(x-1, y);
			} else {
				running_label_id += 1;
				OUT(x, y) = running_label_id;
			}
		}
	}

	for (unsigned i = 1; i <= running_label_id; i += 1) {
		label_equivalents_map[i] = label_equivalents_map[i] ? label_equivalents_map[label_equivalents_map[i]] : i;
	}

	for (unsigned y = 0; y < height; y += 1) {
		for (unsigned x = 0; x < width; x += 1) {
			OUT(x, y) = label_equivalents_map[OUT(x, y)];
		}
	}

	/*
	for (unsigned y = 0; y < height; y += 1) {
		for (unsigned x = 0; x < width; x += 1) {
			printf("%4u ", OUT(x, y));
		}
		puts("");
	}
	*/

	unsigned *areas = calloc(sizeof(*label_equivalents_map), running_label_id+1);
	unsigned *perimeters = calloc(sizeof(*label_equivalents_map), running_label_id+1);
	unsigned *sides = calloc(sizeof(*label_equivalents_map), running_label_id+1);
	for (unsigned y = 0; y < height; y += 1) {
		for (unsigned x = 0; x < width; x += 1) {
			static unsigned sides_lookup[] = {0, 0, 2, 4, 8};
			unsigned label = OUT(x, y);
			areas[label] += 1;
			unsigned not_neighbours = 0;
#define XINVALID(x) ((x) >= width)
#define YINVALID(y) ((y) >= width)
			unsigned top_check = YINVALID(y-1) || OUT(x, y-1) != label;
			unsigned left_check = XINVALID(x-1) || OUT(x-1, y) != label;
			unsigned right_check = XINVALID(x+1) || OUT(x+1, y) != label;
			unsigned bottom_check = YINVALID(y+1) || OUT(x, y+1) != label;
			not_neighbours = top_check ? not_neighbours+1 : not_neighbours;
			not_neighbours = left_check ? not_neighbours+1 : not_neighbours;
			not_neighbours = right_check ? not_neighbours+1 : not_neighbours;
			not_neighbours = bottom_check ? not_neighbours+1 : not_neighbours;
#undef XINVALID
#undef YINVALID
			perimeters[label] += not_neighbours;
#define VALID(x, y) ((x < width) && (y < height))
			unsigned topleft = VALID(x-1, y-1) && OUT(x-1, y-1) == label;
			unsigned topright = VALID(x+1, y-1) && OUT(x+1, y-1) == label;
			unsigned bottomleft = VALID(x-1, y+1) && OUT(x-1, y+1) == label;
			unsigned bottomright = VALID(x+1, y+1) && OUT(x+1, y+1) == label;
#undef VALID
			static unsigned side_effects[] = {0, 1, 2};
			unsigned sides_delta = 0;
			sides_delta += top_check && left_check ? 2 : 0;
			sides_delta += top_check && right_check ? 2 : 0;
			sides_delta += bottom_check && left_check ? 2 : 0;
			sides_delta += bottom_check && right_check ? 2 : 0;
			sides_delta += top_check ? (!left_check) * topleft + (!right_check) * topright : 0;
			sides_delta += left_check ? (!top_check) * topleft + (!bottom_check) * bottomleft : 0;
			sides_delta += bottom_check ? (!right_check) * bottomright + (!left_check) * bottomleft : 0;
			sides_delta += right_check ? (!bottom_check) * bottomright + (!top_check) * topright : 0;
			// printf("(%u) %u %u: %u\n", label, x, y, sides_delta);
			sides[label] += sides_delta;
		}
	}

	unsigned long result1 = 0;
	unsigned long result2 = 0;
	for (unsigned i = 1; i <= running_label_id; i += 1) {
		sides[i] >>= 1;
		// printf("Label %d  has area = %d and perimeter = %d and sides = %d.\n", i, areas[i], perimeters[i], sides[i]); 
		result1 += (unsigned long)areas[i] * (unsigned long)perimeters[i];
		result2 += (unsigned long)areas[i] * (unsigned long)sides[i];
	}

	printf("Silver: %lu\n", result1);
	printf("Gold: %lu\n", result2);

	return 0;
}
