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
ATTACKPOWER = 9,					// Real
MOVES = 10,					// Array, with subarrays: PIECEDATA.TYPE OF MOVELIST[ MOVELIST[ MOVE[x,y], [x +1,y -1], etc...]]
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

function piece_database(name, trait = -1) {
	with obj_piece_database {
		switch name {
			case "shooter":
				object = [	"shooter",obj_shooter,spr_shooter,spr_shooter_slot,
							2,6,2,1,10,5,
							[[[0, 1],[0, -1]], 
							[["1", 0]]],
							SAME,PLACEABLENONE,
							DEFENSECLASS,PIECE,
							"Shoots at enemy pieces and the enemy base.",
							"I love this piece. My mom gave this piece to me when I first started playing Adler's Game. Placing them all makes me feel safe, like a queen defending her castle. I keep its card on my nightstand to remind me of those times."]
			break;
			case "short":
				object = [	"short",obj_short_shooter,spr_short_shooter,spr_short_shooter_slot,
							3,10,10,1,10,10,
							[[[1, 1]]],
							SAME,PLACEABLENONE,
							DEFENSECLASS,PIECE,
							"Rapidly shoots at pieces in its area.",
							"TBA"]
			break;
			case "splitter":
				object = [	"splitter",obj_splitter,spr_piece_upgraded,spr_splitter_slot,
							4,8,4,1,15,10,
							[[[0, 1],[0, -1],[0,2],[0,-2]], 
							[["1", 0]]],
							SAME,PLACEABLENONE,
							DEFENSECLASS,PIECE,
							"Shoots two bullets at a time. Has more HP.",
							"TBA"]
			break;
			case "big_shooter":
				object = [	"big_shooter",obj_big_shooter,spr_big_shooter,spr_big_shooter_slot,
							9,120,8,4,10,10,
							[undefined,
							undefined,
							[[1,1]]],
							SAME,PLACEABLENONE,
							DEFENSECLASS,PIECE,
							"Sacrifices all of your pieces to feed the ultimate war machine. The more pieces the better!",
							"TBA"]
			break;
			case "piercer":
				object = [	"piercer",obj_piercer,spr_piercer,spr_piercer_slot,
							2,6,4,1,10,20,
							[[["-1", 1],["-1", -1]], 
							undefined,
							[["1",0]]],
							SAME,PLACEABLENONE,
							SUPPORTCLASS,PIECE,
							"Shoots a piercing projectile, cannot attack walls but slows down pieces.",
							"TBA"]
			break;
			case "shotgun":
				object = [	"shotgun",obj_shotgun,spr_shotgun,spr_shotgun_slot,
							5,12,12,1,10,5,
							[[["1", 0],["-1", 1],["-1", 0],["-1", -1]]],
							SAME,PLACEABLENONE,
							DEFENSECLASS,PIECE,
							"High damage at a short distance.",
							"TBA"]
			break;
			case "accelerator":
				object = [	"accelerator",obj_accelerator,spr_accelerator,spr_accelerator_slot,
							1,20,6,1,10,1,
							[[[1, 1],[1,-1],[-1,1],[-1,-1]]],
							SAME,PLACEABLENONE,
							SUPPORTCLASS,PIECE,
							"Produces points over a period of time. A worthwhile investment!",
							"I don't know what I would do without these things. They've single handedly turned games around for me in the past. Yeah they don't really do much on their own; they're quite fragile at that, but they are well worth the little time and resources it takes."]
			break;
			case "cross":
				object = [	"cross",obj_cross,spr_cross,spr_cross_slot,
							3,15,2.5,1,10,5,
							[[[1, 0],[2, 0],[-1,0],[-2,0],[0,1],[0,2],[0,-1],[0,-2]]],
							SAME,PLACEABLENONE,
							SUPPORTCLASS,PIECE,
							"Gives a buff to pieces surrounding it.",
							"TBA"]
			break;
			case "bishop":
				object = [	"bishop",obj_bishop,spr_bishop,spr_bishop_slot,
							3,10,2,1,15,20,
							[undefined,
							undefined,
							[[1,1]]],
							SAME,PLACEABLENONE,
							CONTROLCLASS,PIECE,
							"Able to be moved diagonally anywhere on the map.",
							"TBA"]
			break;
			case "wall":
				object = [	"wall",obj_wall,spr_wall,spr_wall_slot,
							1,16,2,1,20,20,
							[[["1", 0],["2",0]], 
							[["1", 1],["1", -1]]],
							SAME,PLACEABLENONE,
							CONTROLCLASS,PIECE,
							"Static piece, has a lot of health and is useful for stalling.",
							"TBA",]
			break;
			case "bomber":
				object = [	"bomber",obj_bomber,spr_bomber,spr_bomber_slot,
							3,16,21,2,10,10,
							[undefined],
							SAME,PLACEABLENONE,
							CONTROLCLASS,PIECE,
							"Instead of moving, launches an explosive anywhere on the map.",
							"TBA"]
			break;
			case "stick":
				object = [	"stick",obj_stick,spr_stick,spr_stick_slot,
							0,30,1,0,5,10,
							[undefined, 
							[[1, 0],[-1, 0]]],
							SAME,PLACEABLENONE,
							SUPPORTCLASS,PIECE,
							"Breaks upon taking a piece.",
							"A stick is a weird choice to add to the game. You'd think they'd add something with a little more flair like a living trapdoor, or an explosive mine maybe. But no, it's just a stick. No personality, not very interactive, only brown. I'm sorry but this thing is really boring."]
			break;
			case "super_stick":
				object = [	"super_stick",obj_super_stick,spr_super_stick,spr_super_stick_slot,
							6,50,5,0,20,20,
							[undefined, 
							[[1,1]]],
							SAME,PLACEABLENONE,
							SUPPORTCLASS,PIECE,
							"Doesn't break, and has a larger range. Overall more super.",
							"... another stick?"]
			break;
			case "crawler":
				object = [	"crawler",obj_crawler,spr_crawler,spr_crawler_slot,
							1,1.5,3.5,0,10,10,
							[undefined, 
							[["1", 0]]],
							SAME,PLACEABLENONE,
							OFFENSECLASS,PIECE,
							"Crawls all the way to the enemy's base.",
							"Crawlers, despite their limited mobility, they always seem to get into the strangest places if when left by themselves. Plus, they always like herding into groups of other crawlers for whatever reason. They kinda freak me out for that but some people seem to really like crawlers, so I can't fault them for that."]
			break;
			case "drooper":
				object = [	"drooper",obj_drooper,spr_drooper,spr_drooper_slot,
							2,3,3.5,0,10,10,
							[undefined, 
							[["1", 0]]],
							SAME,PLACEABLENONE,
							OFFENSECLASS,PIECE,
							"Crawler able to take pieces in its immediate column.",
							"Because of this piece's ability to drop from high up the map to take a piece, this crawler has a very peculiar feature to show for that. Its snout! Anytime the drooper attacks an enemy from above (or below), it would use its snoot to droop on the enemy piece. That's why it's called the droop snoot, the snoot would droop."]
			break;
			case "tank_crawler":
				object = [	"tank_crawler",obj_crawler,spr_tank_crawler,spr_tank_crawler_slot,
							2,2.5,3.5,0,15,10,
							[undefined, 
							[["1", 0]]],
							SAME,PLACEABLENONE,
							OFFENSECLASS,PIECE,
							"Able to take more damage than a normal crawler.",
							//Change?
							"People are always confused as to why this thing has twice the health of a regular crawler. Are the spikes supposed to give it tougher skin? Is it just twice as massive? This piece recieves a large amount of ridicule because of the wacky logic behind it. Yet, I think it's tougher in a different way. I respect tank crawlers inspite of all the flack they get, they just disregard whatever hateful thing is said about them and keep doing their job. You go little champ!"]
			break;
			case "super_tank_crawler":
				object = [	"super_tank_crawler",obj_crawler,spr_super_tank_crawler,spr_super_tank_crawler_slot,
							3,3.5,3.5,0,20,10,
							[undefined, 
							[["1", 0]]],
							SAME,PLACEABLENONE,
							OFFENSECLASS,PIECE,
							"Takes even more damage to kill.",
							"Even more spikes."]
			break;
			case "the_goliath":
				object = [	"the_goliath",obj_goliath,spr_goliath,spr_goliath_slot,
							7,30,10,2,40,20,
							[undefined,
							undefined,
							[[0,1],[0,-1]]],
							SAME,PLACEABLENONE,
							OFFENSECLASS,PIECE,
							"Big guy.",
							"TBA",]
			break;
			case "jumper":
				object = [	"jumper",obj_jumper,spr_jumper,spr_jumper_slot,
							3,8,3.5,0,10,10,
							[undefined, 
							[["1",0]],
							[["2",1],["2",-1]]],
							SAME,PLACEABLENONE,
							OFFENSECLASS,PIECE,
							"Can make a jump over pieces.",
							"TBA"]
			break;
			case "barrel":
				object = [	"barrel",obj_generic_piece,spr_barrel_SCRAPPLS,spr_generic_piece,
							1,.5,1,1,10,0,
							[undefined],
							SAME,PLACEABLENONE,
							DEFENSECLASS,PIECE,
							"Just a barrel.",
							"Useless."]
			break;
			default:
				object = [	"debug",obj_debug_piece,spr_generic_piece,spr_generic_slot,
							0,.1,1,-1,10,100,
							[[[0,1],[0,-1]], 
							[["-1",1],["-1",0],["-1",-1]], 
							[["1",1],["1",0],["1",-1]]],
							SAME,PLACEABLENONE,
							DEFENSECLASS,PIECE,
							"What? Is this supposed to be here?",
							"Seriously, I don't remember seeing anything like this before. My phone must be bugged or something. Extremely odd."]
			break;
		}
		if trait >= 0 { return object[trait]; } else { return object; }
	}
}