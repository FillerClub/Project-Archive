/// @function piece_database(name, trait);
/// @param {string} name Name of the object to lookup.
/// @param {macro} trait Return specified trait of the object, if blank, returns every trait as an array instead.
/// @param {string} team Team of piece to return; MOVE trait only
/// @param {integer} toggle -1 or 1; PIECEDATA.MOVES trait only
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
SPDEFFECT = 9,				// Real
SLWEFFECT = 10,				// Real
MOVES = 11,					// Array, with subarrays: PIECEDATA.TYPE OF MOVELIST[ MOVELIST[ MOVE[x,y], [x +1,y -1], etc...]]
PLACEMENTONGRID = 12,		// Macro
PLACEMENTONPIECE = 13,		// Macro
CLASS = 14,					// Macro
TYPE = 15,					// Macro
BRIEFDESCRIPTION = 16,		// String
DESCRIPTION = 17,			// String
}
//Class info
#macro RANGECLASS #51ff62
#macro SUPPORTCLASS #f3c43f
#macro WANDERCLASS #c814ff
#macro DEFENSECLASS #4c2e16
#macro EXPLOSIVECLASS #ff1919

function piece_database(name, trait = -1) {
	with obj_piece_database {
		switch name {
			case "shooter":
				object = [	"shooter",obj_shooter,spr_shooter,spr_shooter_slot,
							2,6,2,1,10,1,1,
							[[["1", 1],["1", -1]], 
							[["1", 0]]],
							SAME,PLACEABLENONE,
							RANGECLASS,PIECE,
							"Shoots at enemy pieces and the enemy base.",
							"I love this piece. My mom gave this piece to me when I first started playing Adler's Game. Placing them all makes me feel safe, like a queen defending her castle. I keep its card on my nightstand to remind me of those times."]
			break;
			case "short":
				object = [	"short",obj_short_shooter,spr_short_shooter,spr_short_shooter_slot,
							3,16,10,1,10,1,1,
							[[[1, 1]]],
							SAME,PLACEABLENONE,
							RANGECLASS,PIECE,
							"Rapidly shoots at pieces in its area.",
							"TBA"]
			break;
			case "splitter":
				object = [	"splitter",obj_splitter,spr_piece_upgraded,spr_splitter_slot,
							4,8,4,1,10,1,1,
							[[["1", 1],["1", -1]], 
							[["1", 0]]],
							SAME,PLACEABLENONE,
							RANGECLASS,PIECE,
							"Shoots two bullets at a time, prioritizing its surrounding lanes.",
							"TBA"]
			break;
			case "piercer":
				object = [	"piercer",obj_piercer,spr_piercer,spr_piercer_slot,
							4,8,4,1,10,1,1,
							[[["-1", 1],["-1", -1]], 
							undefined,
							[["1",0]]],
							SAME,PLACEABLENONE,
							RANGECLASS,PIECE,
							"Shoots a piercing projectile throughout the row.",
							"TBA"]
			break;
			case "shotgun":
				object = [	"shotgun",obj_shotgun,spr_shotgun,spr_shotgun_slot,
							5,12,12,1,10,1,1,
							[[["1", 0],["-1", 1],["-1", 0],["-1", -1]]],
							SAME,PLACEABLENONE,
							RANGECLASS,PIECE,
							"High damage at a short distance.",
							"TBA"]
			break;
			case "accelerator":
				object = [	"accelerator",obj_accelerator,spr_accelerator,spr_accelerator_slot,
							1,4.5,6,1,10,0,1,
							[[[0, 1],[0,-1]]],
							SAME,PLACEABLENONE,
							SUPPORTCLASS,PIECE,
							"Passively increases timer speed. Gives an additional point for each timer up.",
							"I don't know what I would do without these things. They've single handedly turned games around for me in the past. Yeah they don't really do much on their own; they're quite fragile at that, but they are well worth the little time and resources it takes."]
			break;
			case "bishop":
				object = [	"bishop",obj_bishop,spr_bishop,spr_bishop_slot,
							3,10,6,1,10,1,1,
							[undefined,
							undefined,
							[[1,1]]],
							SAME,PLACEABLENONE,
							DEFENSECLASS,PIECE,
							"Able to be moved diagonally anywhere on the map.",
							"TBA"]
			break;
			case "wall":
				object = [	"wall",obj_generic_piece,spr_wall,spr_wall_slot,
							1,16,999,0,20,1,1,
							[undefined],
							SAME,PLACEABLENONE,
							DEFENSECLASS,PIECE,
							"Static piece, has a lot of health and is useful for stalling.",
							"TBA",]
			break;
			case "bomber":
				object = [	"bomber",obj_bomber,spr_bomber,spr_bomber_slot,
							3,16,21,2,10,1,1,
							[undefined],
							SAME,PLACEABLENONE,
							EXPLOSIVECLASS,PIECE,
							"Instead of moving, launches an explosive anywhere on the map.",
							"TBA"]
			break;
			case "stick":
				object = [	"stick",obj_stick,spr_stick,spr_stick_slot,
							1,30,1,0,5,0,1,
							[undefined, 
							[[1, 0],[-1, 0]]],
							SAME,PLACEABLENONE,
							EXPLOSIVECLASS,PIECE,
							"Able to take a piece easily, breaks upon use.",
							"A stick is a weird choice to add to the game. You'd think they'd add something with a little more flair like a living trapdoor, or an explosive mine maybe. But no, it's just a stick. No personality, not very interactive, only brown. I'm sorry but this thing is really boring."]
			break;
			case "crawler":
				object = [	"crawler",obj_crawler,spr_crawler,spr_crawler_slot,
							1,1.5,3,0,10,12,1,
							[undefined, 
							[["1", 0]]],
							SAME,PLACEABLENONE,
							WANDERCLASS,PIECE,
							"Crawls all the way to the enemy's base.",
							"Crawlers, despite their limited mobility, they always seem to get into the strangest places if when left by themselves. Plus, they always like herding into groups of other crawlers for whatever reason. They kinda freak me out for that but some people seem to really like crawlers, so I can't fault them for that."]
			break;
			case "drooper":
				object = [	"drooper",obj_drooper,spr_drooper,spr_drooper_slot,
							2,3,3,0,10,12,1,
							[undefined, 
							[["1", 0]]],
							SAME,PLACEABLENONE,
							WANDERCLASS,PIECE,
							"Crawler able to take pieces in its immediate column.",
							"Because of this piece's ability to drop from high up the map to take a piece, this crawler has a very peculiar feature to show for that. Its snout! Anytime the drooper attacks an enemy from above (or below), it would use its snoot to droop on the enemy piece. That's why it's called the droop snoot, the snoot would droop."]
			break;
			case "tank_crawler":
				object = [	"tank_crawler",obj_crawler,spr_tank_crawler,spr_tank_crawler_slot,
							2,2.5,2.5,0,15,12,1,
							[undefined, 
							[["1", 0]]],
							SAME,PLACEABLENONE,
							WANDERCLASS,PIECE,
							"Able to take more damage than a normal crawler.",
							//Change?
							"People are always confused as to why this thing has twice the health of a regular crawler. Are the spikes supposed to give it tougher skin? Is it just twice as massive? This piece recieves a large amount of ridicule because of the wacky logic behind it. Yet, I think it's tougher in a different way. I respect tank crawlers inspite of all the flack they get, they just disregard whatever hateful thing is said about them and keep doing their job. You go little champ!"]
			break;
			case "super_tank_crawler":
				object = [	"super_tank_crawler",obj_crawler,spr_super_tank_crawler,spr_super_tank_crawler_slot,
							3,3.5,2.5,0,20,12,1,
							[undefined, 
							[["1", 0]]],
							SAME,PLACEABLENONE,
							WANDERCLASS,PIECE,
							"Takes even more damage to kill.",
							"Even more spikes."]
			break;
			case "jumper":
				object = [	"jumper",obj_jumper,spr_jumper,spr_jumper_slot,
							3,8,3,0,10,12,1,
							[undefined, 
							[["1",0]],
							[["2",1],["2",-1]]],
							SAME,PLACEABLENONE,
							WANDERCLASS,PIECE,
							"Can make a jump over pieces.",
							"TBA"]
			break;
			case "barrel":
				object = [	"barrel",obj_generic_piece,spr_barrel_SCRAPPLS,spr_generic_piece,
							1,.5,1,1,10,1,1,
							[undefined],
							SAME,PLACEABLENONE,
							DEFENSECLASS,PIECE,
							"Just a barrel.",
							"Useless."]
			break;
			default:
				object = [	"debug",obj_debug_piece,spr_generic_piece,spr_generic_slot,
							0,.1,1,-1,10,1,1,
							[[[0,1],[0,-1]], 
							[["-1",1],["-1",0],["-1",-1]], 
							[["1",1],["1",0],["1",-1]]],
							SAME,PLACEABLENONE,
							RANGECLASS,PIECE,
							"What? Is this supposed to be here?",
							"Seriously, I don't remember seeing anything like this before. My phone must be bugged or something. Extremely odd."]
			break;
		}
		if trait >= 0 { return object[trait]; } else { return object; }
	}
}