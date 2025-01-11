//Wrap index
var endInd = array_length(unlocked_heroes) -1;
if index < 0 {
	index = endInd;	
}
if index > endInd {
	index = 0;	
}
identity = unlocked_heroes[index];
sprite_index = hero_database(identity,HERODATA.SPRITE);