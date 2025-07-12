function class_priority(_class) {
	switch (_class) {
		case DEFENSECLASS: return 0;
		case OFFENSECLASS: return 1;
		case CONTROLCLASS: return 2;
		case SUPPORTCLASS: return 3;
		default: return -1;
	}
}