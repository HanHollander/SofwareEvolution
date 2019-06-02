module util::ProgressBar

import IO;
import util::Math;

int size = 50;

void progress(real max, real prog) {
	done = prog / max * size;
	str bar = "\r[";
	for (i <- [0..floor(done)])
		bar += "|";
	for (i <- [0..ceil(size - done)])
		bar += "-";
	bar += "] <toInt(prog / max * 100)>% ";
	print(bar);
}

void spinner(int status) {
	visit (status) {
		case 0: print("\r_ ");
		case 1: print("\r\\ ");
		case 2: print("\r| ");
		case _: print("\r/ ");
	}
}