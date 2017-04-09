#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

int args_check(int argc, const char **argv) {

	int delta = 20;
	if (argc < 2 || (argv[1][0] != '+' && argv[1][0] != '-')) {
		exit(1);
	}
	if (argc > 2) {
		delta = atoi(argv[2]);
		delta = delta % 801;
		if (delta < 10)
			delta = 10;
	}
	return ((argv[1][0] == '-')? -1: 1) * delta;
}

int main(int argc, const char **argv) {

	FILE *fbrightness;
	char currentbrightness[16];
	int ibrightness;
	int delta;

	delta = args_check(argc, argv);

	fbrightness = fopen("/sys/class/backlight/intel_backlight/brightness", "r+");
	
	if (!fbrightness) {
		printf("%s: Failed to open brightness file", argv[0]);
		return 1;
	}

	fgets(currentbrightness, 16, fbrightness);

	printf("Current brightness %s", currentbrightness);
	rewind(fbrightness);
	ibrightness = atoi(currentbrightness);

	ibrightness += delta;
	if (ibrightness < 10)
			ibrightness = 10;
	if (ibrightness > 800) {
		ibrightness = 800;
	}

	sprintf(currentbrightness, "%d", ibrightness);

	fputs(currentbrightness, fbrightness);
	fclose(fbrightness);
	return 0;
}
