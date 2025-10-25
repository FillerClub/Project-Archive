/// @function piece_database(name, trait);
/// @param {string} name Name of the object to lookup.
/// @param {macro} trait Return specified trait of the object, if blank, returns every trait as an array instead.
/// @param {string} team Team of piece to return; MOVE trait only
/// @param {integer} toggle -1 or 1; "moves" trait only
enum PIECEDATA {
ALL = -1,					// Everything
NAME = 0,					// String
OBJECT = 1,					// Obj Asset
SPRITE = 2,					// Spr Asset
SLOTSPRITE = 3,				// Spr Asset
PLACECOST = 4,				// Integer
SLOTCOOLDOWN = 5,			// Real
MOVECOOLDOWN = 6,			// Real
MOVECOST = 7,				// Integer
HP = 8,						// Real
ATTACKPOWER = 9,					// Real
MOVES = 10,					// Array, with subarrays: "type" OF MOVELIST[ MOVELIST[ MOVE[x,y], [x +1,y -1], etc...]]
PLACEMENTONGRID = 11,		// Macro
PLACEMENTONPIECE = 12,		// Macro
CLASS = 13,					// Macro
TYPE = 14,					// Macro
BRIEFDESCRIPTION = 15,		// String
DESCRIPTION = 16,			// String
}
//Class info
#macro DEFENSECLASS #B26E47
#macro SUPPORTCLASS #72FFB1
#macro OFFENSECLASS #FF66AA
#macro CONTROLCLASS #8895D8

// Object types
//#macro 0 0
function make_piece(_name = "debug",_obj = obj_debug_piece,_spr = spr_generic_piece,_slotSpr = spr_generic_slot, _journalSpr = spr_journal_entry_photo,_anim = -1, _anim_scale = -1,
	_placeCost = 2,_slotCD = 10,_moveCD = 10,_moveCost = 0,_hp = {base:10},_atk = 10,_moves = 
	[[[0,1],[0,-1]],				// first array ONLY_MOVE  
	[["-1",1],["-1",0],["-1",-1]],	// second array ONLY_ATTACK // Numbers in strings are affectd by team & toggling variables
	[["1",1],["1",0],["1",-1]]],	// third array BOTH						
	_placeGrid = SAME, _placePiece = PLACEABLENONE, _class = DEFENSECLASS, _type = 0, _brief = "Not available", _desc = "Not available") constructor {
		
    name = _name;				object = _obj;				sprite = _spr;				slot_sprite = _slotSpr;		journal_sprite = _journalSpr;
	idle_animation = _anim;	anim_scale = _anim_scale;
    place_cost = _placeCost;	slot_cooldown = _slotCD;	move_cooldown = _moveCD;	move_cost = _moveCost;
    hp = _hp;					attack_power = _atk;		moves = _moves;
    grid_placement_behavior = _placeGrid;					piece_placement_behavior = _placePiece;
    class = _class;				type = _type;				short_description = _brief;
	full_description = _desc;
}
function piece_database(name, trait = -1) {
    // Helper to make pieces quickly
    var p = new make_piece(),
	returnPiece = -1;
	switch name {
		// Shooters
		case "shooter":
			p.name = "Cananon";						p.object = obj_shooter;		p.journal_sprite = spr_shooter_journal;
			p.sprite = spr_shootah;					p.slot_sprite = spr_shooter_slot;	p.idle_animation = sq_shooter_idle;
			p.place_cost = 4;						p.move_cost = 0;
			p.slot_cooldown = 6;					p.move_cooldown = 9;	
			p.hp = {base:10};						p.attack_power = 5;		
			p.moves = [/* ONLY_MOVE */[], /* ONLY_ATTACK */[],[["1", 0],[0, 1],[0, -1]]];
			p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
			p.class = DEFENSECLASS;					p.type = 0;				
			p.short_description = "Shoots at enemy pieces and the enemy base.";
			p.full_description = "TBA";
			returnPiece = p;
		break;
		case "small_shooter":
			p.name = "Cananonet";					p.object = obj_small_shooter;	
			p.sprite = spr_shootah;					p.slot_sprite = spr_shooter_slot;	p.idle_animation = sq_shooter_idle;
			p.place_cost = 1;						p.move_cost = 0;
			p.slot_cooldown = 5;					p.move_cooldown = 8;	
			p.hp = {base:5};						p.attack_power = 0;		
			p.moves = [/* ONLY_MOVE */[[0, 1],[0, -1],["1", 0]]];
			p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
			p.class = DEFENSECLASS;					p.type = 0;				
			p.short_description = "Shoots at enemy pieces and the enemy base.";
			p.full_description = "TBA";
			returnPiece = p;
		break;
		case "short":
			p.name = "Bastion";						p.object = obj_short_shooter;		
			p.sprite = spr_short_shooter;			p.slot_sprite = spr_short_shooter_slot;
			p.place_cost = 8;						p.move_cost = 0;
			p.slot_cooldown = 9.5;					p.move_cooldown = 17.5;	
			p.hp = {base:10};						p.attack_power = 5;		
			p.moves = [/*ONLY_MOVE*/[[1, 1]]];
			p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
			p.class = DEFENSECLASS;					p.type = 0;				
			p.short_description = "Rapidly shoots at pieces in its area.";
			p.full_description = "TBA";
			returnPiece = p;
		break;
		case "lobber":
			p.name = "Lobber";						p.object = obj_lobber;		
			p.sprite = spr_lobber;					p.slot_sprite = spr_lobber_slot;
			p.place_cost = 4;						p.move_cost = 0;
			p.slot_cooldown = 6;					p.move_cooldown = 7;	
			p.hp = {base:10};						p.attack_power = 5;		
			p.moves = [/* ONLY_MOVE */[[0, 1],[0, -1],[1, 0],[-1, 0]]];
			p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
			p.class = DEFENSECLASS;					p.type = 0;				
			p.short_description = "Lobs projectiles instead of shooting straight.";
			p.full_description = "TBA";
			returnPiece = p;
		break;
		case "mortar":
			p.name = "Mortar";						p.object = obj_mortar;		
			p.sprite = spr_mortar;					p.slot_sprite = spr_mortar_slot;
			p.place_cost = 10;						p.move_cost = 0;
			p.slot_cooldown = 10;					p.move_cooldown = 10.5;	
			p.hp = {base:10};						p.attack_power = 10;		
			p.moves = [[],[],/* BOTH */[[0, 1],[0, -1],[1, 0],[-1, 0],[1, 1],[1, -1],[-1, 1],[-1, -1]]];
			p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
			p.class = DEFENSECLASS;					p.type = 0;				
			p.short_description = "Lobs heavy projectiles dealing massive damage and splashes.";
			p.full_description = "TBA";
			returnPiece = p;
		break;
		case "double_shooter":
            p.name = "Grandshootah";				p.object = obj_double_shooter;
            p.sprite = spr_grandshootah;			p.slot_sprite = spr_double_shooter_slot;
            p.place_cost = 8;						p.move_cost = 0;
            p.slot_cooldown = 8;					p.move_cooldown = 15;
            p.hp = {base:10};						p.attack_power = 10;
            p.moves = [[],[],[["1",0],[0,1],[0,-1]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = DEFENSECLASS;					p.type = 0;
            p.short_description = "Does double the damage.";
            p.full_description = "TBA";
            returnPiece = p;
        break;
        case "splitter":
            p.name = "Splitter";					p.object = obj_splitter;
            p.sprite = spr_splitter;				p.slot_sprite = spr_splitter_slot;
            p.place_cost = 6;						p.move_cost = 0;
            p.slot_cooldown = 7;					p.move_cooldown = 7;
            p.hp = {base:10};						p.attack_power = 5;
            p.moves = [[[0, 1],[0, -1],[0, 2],[0, -2]], [["1", 0]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = DEFENSECLASS;					p.type = 0;
            p.short_description = "Can shoot in two lanes at once.";
            p.full_description = "TBA";
            returnPiece = p;
        break;
        case "big_shooter":
            p.name = "Big Shooter";					p.object = obj_big_shooter;
            p.sprite = spr_big_shooter;				p.slot_sprite = spr_big_shooter_slot;
            p.place_cost = 16;						p.move_cost = 4;
            p.slot_cooldown = 120;					p.move_cooldown = 8;
            p.hp = {base:10};						p.attack_power = 10;
            p.moves = [undefined, undefined, [[1, 1]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = DEFENSECLASS;					p.type = 0;
            p.short_description = "Sacrifices all of your pieces to feed the ultimate war machine. The more pieces the better!";
            p.full_description = "TBA";
            returnPiece = p;
        break;
        case "piercer":
            p.name = "Piercer";						p.object = obj_piercer;
            p.sprite = spr_piercer;					p.slot_sprite = spr_piercer_slot;
            p.place_cost = 4;						p.move_cost = 0;
            p.slot_cooldown = 6;					p.move_cooldown = 20;
            p.hp = {base:10};						p.attack_power = 20;
            p.moves = [[["-1", 1],["-1", -1]], undefined, [["1", 0]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = SUPPORTCLASS;					p.type = 0;
            p.short_description = "Shoots a piercing projectile, cannot attack walls but slows down pieces.";
            p.full_description = "TBA";
            returnPiece = p;
        break;
        case "shotgun":
            p.name = "Shotgun";						p.object = obj_shotgun;
            p.sprite = spr_shotgun;					p.slot_sprite = spr_shotgun_slot;
            p.place_cost = 10;						p.move_cost = 0;
            p.slot_cooldown = 12;					p.move_cooldown = 12;
            p.hp = {base:10};						p.attack_power = 5;
            p.moves = [[["1", 0],["-1", 1],["-1", 0],["-1", -1]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = DEFENSECLASS;					p.type = 0;
            p.short_description = "High damage at a short distance.";
            p.full_description = "TBA";
            returnPiece = p;
        break;
		// Supports
        case "accelerator":
            p.name = "Ira";						p.object = obj_accelerator;
            p.sprite = spr_accelerator;				p.slot_sprite = spr_accelerator_slot;	p.idle_animation = sq_ira_idle;
            p.place_cost = 2;						p.move_cost = 0;
            p.slot_cooldown = 14;					p.move_cooldown = 25;
            p.hp = {base:10};						p.attack_power = 1;
            p.moves = [[[1, 1],[1, -1],[-1, 1],[-1, -1]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = SUPPORTCLASS;					p.type = 0;
            p.short_description = "Produces points over a period of time. A worthwhile investment!";
            p.full_description = "I don't know what I would do without these things. They've single handedly turned games around for me in the past. Yeah they don't really do much on their own; they're quite fragile at that, but they are well worth the little time and resources it takes.";
            returnPiece = p;
        break;
        case "cross":
            p.name = "Cross";						p.object = obj_cross;
            p.sprite = spr_cross;					p.slot_sprite = spr_cross_slot;
            p.place_cost = 6;						p.move_cost = 0;
            p.slot_cooldown = 15;					p.move_cooldown = 6;
            p.hp = {base:10};						p.attack_power = 5;
            p.moves = [[[1, 0],[2, 0],[-1, 0],[-2, 0],[0, 1],[0, 2],[0, -1],[0, -2]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = SUPPORTCLASS;					p.type = 0;
            p.short_description = "Gives a buff to pieces surrounding it.";
            p.full_description = "TBA";
            returnPiece = p;
        break;
		// Control
        case "bishop":
            p.name = "Bishop";						p.object = obj_bishop;
            p.sprite = spr_bishop;					p.slot_sprite = spr_bishop_slot;
            p.place_cost = 9;						p.move_cost = 0;
            p.slot_cooldown = 10;					p.move_cooldown = 9.5;
            p.hp = {base:10,armor:5,shield:5};		p.attack_power = 25;
            p.moves = [undefined, undefined, [[1, 1]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = CONTROLCLASS;					p.type = 0;
            p.short_description = "Able to be moved diagonally anywhere on the map.";
            p.full_description = "TBA";
            returnPiece = p;
        break;
        case "pawn":
            p.name = "Pawn";						p.object = obj_pawn;
            p.sprite = spr_generic;					p.slot_sprite = spr_pawn_slot;
            p.place_cost = 0;						p.move_cost = 0;
            p.slot_cooldown = 5;					p.move_cooldown = 6;
            p.hp = {base:5};						p.attack_power = 5;
            p.moves = [[["1", 0],["2", 0]], [["1", 1],["1", -1]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = CONTROLCLASS;					p.type = 0;
            p.short_description = "Spammable defense, expires after a short amount of time.";
            p.full_description = "TBA";
            returnPiece = p;
        break;
        case "drum":
            p.name = "Drum";						p.object = obj_drum;
            p.sprite = spr_generic;					p.slot_sprite = spr_pawn_slot;
            p.place_cost = 2;						p.move_cost = 0;
            p.slot_cooldown = 8;					p.move_cooldown = 9;
            p.hp = {base:10};						p.attack_power = 15;
            p.moves = [[],[],/*BOTH*/[[1,0],[0,1],[-1,0],[0,-1]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = CONTROLCLASS;					p.type = 0;
            p.short_description = "Can move twice before being put on cooldown.";
            p.full_description = "TBA";
            returnPiece = p;
        break;
        case "wall":
            p.name = "Wall";						p.object = obj_wall;
            p.sprite = spr_wall;					p.slot_sprite = spr_wall_slot;
            p.place_cost = 2;						p.move_cost = 0;
            p.slot_cooldown = 20;					p.move_cooldown = 32;
            p.hp = {base:10, armor:10};				p.attack_power = 5;
            p.moves = [undefined];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = CONTROLCLASS;					p.type = 0;
            p.short_description = "Static piece with a lot of health. Useful for stalling.";
            p.full_description = "TBA";
            returnPiece = p;
        break;
        case "shield_gen":
            p.name = "Shield Generator";			p.object = obj_shield_generator;
            p.sprite = spr_wall;					p.slot_sprite = spr_wall_slot;
            p.place_cost = 3;						p.move_cost = 0;
            p.slot_cooldown = 16;					p.move_cooldown = 32;
            p.hp = {base:10, shield:10};			p.attack_power = 5;
            p.moves = [undefined];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = CONTROLCLASS;					p.type = 0;
            p.short_description = "Constantly regenerates its shield health.";
            p.full_description = "TBA";
            returnPiece = p;
        break;
        case "bomb":
            p.name = "Bomb";						p.object = obj_bomb;
            p.sprite = spr_bomb;					p.slot_sprite = spr_bomb_slot;
            p.place_cost = 7;						p.move_cost = 0;
            p.slot_cooldown = 30;					p.move_cooldown = 0;
            p.hp = {base:5};						p.attack_power = 25;
            p.moves = [undefined];
            p.grid_placement_behavior = NEUTRAL;	p.piece_placement_behavior = PLACEABLENONE;
            p.class = CONTROLCLASS;					p.type = 0;
            p.short_description = "Explodes dealing massive damage to its surroundings.";
            p.full_description = "TBA";
            returnPiece = p;
        break;
        case "smoke_bomb":
            p.name = "Smoke Bomb";					p.object = obj_smoke_bomb;
            p.sprite = spr_smoke_bomb;				p.slot_sprite = spr_smoke_bomb_slot;
            p.place_cost = 0;						p.move_cost = 0;
            p.slot_cooldown = 12;					p.move_cooldown = 0;
            p.hp = {base:5};						p.attack_power = 0;
            p.moves = [undefined];
            p.grid_placement_behavior = NEUTRAL;	p.piece_placement_behavior = PLACEABLENONE;
            p.class = CONTROLCLASS;					p.type = 0;
            p.short_description = "Slows enemy pieces in its radius when destroyed.";
            p.full_description = "TBA";
            returnPiece = p;
        break;
        case "bomber":
            p.name = "Bomber";						p.object = obj_bomber;
            p.sprite = spr_bomber;					p.slot_sprite = spr_bomber_slot;
            p.place_cost = 16;						p.move_cost = 0;
            p.slot_cooldown = 16;					p.move_cooldown = 21;
            p.hp = {base:10};						p.attack_power = 10;
            p.moves = [undefined];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = CONTROLCLASS;					p.type = 0;
            p.short_description = "Instead of moving, launches an explosive anywhere on the map.";
            p.full_description = "TBA";
            returnPiece = p;
        break;	
        case "stick":
            p.name = "Stick";						p.object = obj_stick;
            p.sprite = spr_stick;					p.slot_sprite = spr_stick_slot;
            p.place_cost = 1;						p.move_cost = 0;
            p.slot_cooldown = 30;					p.move_cooldown = 99;
            p.hp = {base:5};						p.attack_power = 25;
            p.moves = [undefined,[[1, 0],[-1, 0]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = SUPPORTCLASS;					p.type = 0;
            p.short_description = "Breaks upon taking a piece.";
            p.full_description = "TBA";
            returnPiece = p;
        break;	
		case "super_stick":
            p.name = "Super Stick";					p.object = obj_super_stick;
            p.sprite = spr_super_stick;				p.slot_sprite = spr_super_stick_slot;
            p.place_cost = 9;						p.move_cost = 0;
            p.slot_cooldown = 35;					p.move_cooldown = 8;
            p.hp = {base:15,armor:5,shield:5};		p.attack_power = 25;
            p.moves = [undefined,[[1,1]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = SUPPORTCLASS;					p.type = 0;
            p.short_description = "Doesn't break, and has a larger range. Overall more super.";
            p.full_description = "TBA";
            returnPiece = p;		
		break;
		// Crawlers
		case "crawler":
            p.name = "Crawler";						p.object = obj_crawler;		p.idle_animation = sq_crawler_idle;		p.anim_scale = 1;
            p.sprite = spr_crawler;					p.slot_sprite = spr_crawler_slot;
            p.place_cost = 1;						p.move_cost = 0;
            p.slot_cooldown = 9;					p.move_cooldown = 4;
            p.hp = {base:10};						p.attack_power = 10;
            p.moves = [undefined,[["1", 0]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = OFFENSECLASS;					p.type = 0;
            p.short_description = "Crawls all the way to the enemy's base.";
            p.full_description = "TBA";
            returnPiece = p;		
		break;
		case "flyer":
            p.name = "Flyer";						p.object = obj_flyer;
            p.sprite = spr_flyer;					p.slot_sprite = spr_flyer_slot;
            p.place_cost = 2;						p.move_cost = 0;
            p.slot_cooldown = 22;					p.move_cooldown = 4;
            p.hp = {base:10};						p.attack_power = 10;
            p.moves = [undefined,[["1", 0]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = OFFENSECLASS;					p.type = 0;
            p.short_description = "Flies all the way to the enemy's base. Can't be hit by grounded enemies.";
            p.full_description = "TBA";
            returnPiece = p;		
		break;
		case "drooper":
            p.name = "Drooper";						p.object = obj_drooper;
            p.sprite = spr_drooper;					p.slot_sprite = spr_drooper_slot;
            p.place_cost = 2;						p.move_cost = 0;
            p.slot_cooldown = 16;					p.move_cooldown = 4;
            p.hp = {base:10};						p.attack_power = 10;
            p.moves = [undefined,[["1", 0]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = OFFENSECLASS;					p.type = 0;
            p.short_description = "Crawler able to take pieces in its immediate column.";
            p.full_description = "Because of this piece's ability to drop from high up the map to take a piece, this crawler has a very peculiar feature to show for that. Its snout! Anytime the drooper attacks an enemy from above (or below), it would use its snoot to droop on the enemy piece. That's why it's called the droop snoot, the snoot would droop.";
            returnPiece = p;			
		break;
		case "tank_crawler":
            p.name = "Tanky Crawler";				p.object = obj_tank_crawler;		p.idle_animation = sq_crawler_idle;		p.anim_scale = 1;
            p.sprite = spr_tank_crawler;			p.slot_sprite = spr_tank_crawler_slot;
            p.place_cost = 3;						p.move_cost = 0;
            p.slot_cooldown = 20;					p.move_cooldown = 4;
            p.hp = {base:10,armor:5};				p.attack_power = 10;
            p.moves = [undefined,[["1", 0]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = OFFENSECLASS;					p.type = 0;
            p.short_description = "Able to take more damage than a normal crawler.";
            p.full_description = "TBA";
            returnPiece = p;				
		break;
		case "super_tank_crawler":
            p.name = "Very Tanky Crawler";			p.object = obj_tank_crawler;		p.idle_animation = sq_crawler_idle;		p.anim_scale = 1;
            p.sprite = spr_super_tank_crawler;		p.slot_sprite = spr_super_tank_crawler_slot;
            p.place_cost = 5;						p.move_cost = 0;
            p.slot_cooldown = 25;					p.move_cooldown = 4.5;
            p.hp = {base:10,armor:10};				p.attack_power = 20;
            p.moves = [undefined,[["1", 0]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = OFFENSECLASS;					p.type = 0;
            p.short_description = "Has armor, takes even more damage to kill.";
            p.full_description = "TBA";
            returnPiece = p;			
		break;	
		case "the_goliath":
            p.name = "The Goliath";					p.object = obj_goliath;
            p.sprite = spr_goliath;					p.slot_sprite = spr_goliath_slot;
            p.place_cost = 15;						p.move_cost = 0;
            p.slot_cooldown = 25;					p.move_cooldown = 12;
            p.hp = {base:10,armor:10,shield:10};	p.attack_power = 25;
            p.moves = [undefined,undefined,[[0,1],[0,-1]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = OFFENSECLASS;					p.type = 0;
            p.short_description = "Big guy";
            p.full_description = "TBA";
            returnPiece = p;			
		break;
		case "jumper":
			p.name = "Jumper";						p.object = obj_jumper;
            p.sprite = spr_jumper;					p.slot_sprite = spr_jumper_slot;
            p.place_cost = 3;						p.move_cost = 0;
            p.slot_cooldown = 16;					p.move_cooldown = 3;
            p.hp = {base:10};						p.attack_power = 10;
            p.moves = [undefined, [["1",0]], [["2",1],["2",-1]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = OFFENSECLASS;					p.type = 0;
            p.short_description = "Can make a jump over pieces.";
            p.full_description = "TBA";
            returnPiece = p;	
		break;
		// Debug
		case "barrel":
			p.name = "Barrel";						p.object = obj_wall;
            p.sprite = spr_barrel_SCRAPPLS;			p.slot_sprite = spr_generic_piece;
            p.place_cost = 1;						p.move_cost = 1;
            p.slot_cooldown = 1;					p.move_cooldown = 1;
            p.hp = {base:10};						p.attack_power = 1;
            p.moves = [undefined];
            p.grid_placement_behavior= PLACEABLEANY;p.piece_placement_behavior = PLACEABLENONE;
            p.class = SUPPORTCLASS;					p.type = 0;
            p.short_description = "Just a barrel.";
            p.full_description = "Useless.";
            returnPiece = p;			
		break;
		case "ball":
			p.name = "Ball";						p.object = obj_ball;
            p.sprite = spr_ball;					p.slot_sprite = spr_ball_slot;
            p.place_cost = 1;						p.move_cost = 0;
            p.slot_cooldown = 1;					p.move_cooldown = 1;
            p.hp = {base:10};						p.attack_power = 1;
            p.moves = [[],[],[[1,0],[0,1],[1,1],[-1,0],[0,-1],[-1,-1],[-1,1],[1,-1]]];
            p.grid_placement_behavior = SAME;		p.piece_placement_behavior = PLACEABLENONE;
            p.class = CONTROLCLASS;					p.type = 0;
            p.short_description = "Bounces";
            p.full_description = "Useless.";
            returnPiece = p;			
		break;
		case "Empty":
			p.name = "Nothing";						p.object = noone;
            p.sprite = spr_empty_slot;				p.slot_sprite = spr_empty_slot;
            p.class = #4C4C4C;						p.type = 0;
            returnPiece = p;			
		break;	
		default:
			returnPiece = p;
		break;
	}
	var finalReturn = variable_struct_get(returnPiece,trait);
	if is_undefined(finalReturn) {
        return returnPiece
    } else {
        return finalReturn;
    }
}