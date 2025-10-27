// ==============================================================================
// EXAMPLE PIECE IMPLEMENTATION - Demonstrating Understanding of Piece Objects
// ==============================================================================

// This file demonstrates understanding of how piece objects work in Project Archive
// It shows: database entries, lifecycle, effects, movement, and custom behavior

// ==============================================================================
// 1. PIECE DATABASE ENTRY
// ==============================================================================

// Example of adding a new piece to piece_database() function
// This would go in scr_piece_database/scr_piece_database.gml

/*
case PIECE.EXAMPLE_DEFENDER:
    return make_piece(
        "Example Defender",              // NAME - Display name
        obj_example_defender,            // OBJECT - GameMaker object
        spr_example_defender,            // SPRITE - Visual sprite
        spr_example_defender_slot,       // SLOTSPRITE - UI slot sprite
        100,                             // PLACECOST - Cost to place
        3,                               // SLOTCOOLDOWN - Cooldown after placement
        0,                               // MOVECOOLDOWN - Movement cooldown (0 = static)
        0,                               // MOVECOST - Cost to move
        15,                              // HP - Starting health
        5,                               // ATTACKPOWER - Base damage
        [MOVE.NONE],                     // MOVES - Movement pattern (none = static defender)
        PLACEMENTONGRID.ANY,             // PLACEMENTONGRID - Where it can be placed
        PLACEMENTONPIECE.NOPIECE,        // PLACEMENTONPIECE - Can't place on other pieces
        PIECECLASS.DEFENSE,              // CLASS - Defense type
        PIECETYPE.STRUCTURE,             // TYPE - Structure category
        "A defensive structure",         // BRIEFDESCRIPTION
        "Shoots at enemies every 3 seconds with area effect" // DESCRIPTION
    );
*/

// ==============================================================================
// 2. PIECE OBJECT: obj_example_defender
// ==============================================================================

// --- CREATE EVENT (Create_0.gml) ---
// The Create event initializes the piece using parent obj_generic_piece
// obj_generic_piece handles all standard initialization from database

function example_defender_create() {
    // Parent Create event does:
    // 1. Load piece data via piece_database(identity)
    // 2. Set position based on grid_pos or piece_on_grid
    // 3. Initialize hp, cooldowns, animations
    // 4. Setup effects_array and effects_management_array
    // 5. Create time sources for blinking and error states

    event_inherited(); // CRITICAL: Call parent create first!

    // Custom initialization for this piece
    attack_range = 3;                    // Custom property: attack range in grid spaces
    attack_cooldown = 3;                 // Attacks every 3 seconds
    attack_timer = 0;                    // Current timer
    last_target = noone;                 // Track last attacked enemy
    area_effect_radius = GRIDSPACE * 1.5; // Damage radius

    // The parent has already set these from database:
    // - identity (PIECE.EXAMPLE_DEFENDER)
    // - team (0 or 1)
    // - grid_pos (grid position struct)
    // - hp (health struct: {base, armor, shield, over})
    // - animation (sequence from database)
    // - effects_array (current effect potencies)
    // - effects_management_array (active effects list)
}

// --- STEP EVENT (Step_0.gml) ---
// The Step event runs every frame and contains main logic

function example_defender_step() {
    // CRITICAL: Call piece() function - this is the main update loop
    // piece() handles:
    // - Time source processing (invincibility, error blinking)
    // - Animation management
    // - Pause handling
    // - Position updates
    // - Depth sorting
    // - AI control
    // - effect_process() - processes damage/buffs from effects
    // - manage_health() - checks for destruction
    // - effect_manager_process() - manages active effects

    piece(); // This MUST be called every frame!

    // Custom behavior after standard piece processing
    if (global.state == STATE.RUNNING) { // Only act when game is running

        // Update attack timer (affected by speed/slow effects)
        var speed_multiplier = 1 + effects_array[EFFECT.SPEED] - effects_array[EFFECT.SLOW];
        attack_timer += DELTA_TO_SECONDS * delta_time * speed_multiplier;

        // Check if ready to attack
        if (attack_timer >= attack_cooldown && move_cooldown_timer <= 0) {

            // Find enemies in range
            var target = find_enemy_in_range(attack_range);

            if (target != noone) {
                // Perform attack
                perform_area_attack(target);

                // Reset timer
                attack_timer = 0;

                // Set move cooldown to prevent immediate re-attack
                move_cooldown_timer = attack_cooldown;
            }
        }
    }
}

// --- HELPER FUNCTIONS ---

// Scan for enemies within range using grid-based distance
function find_enemy_in_range(range) {
    var closest = noone;
    var min_dist = range + 1;

    // Iterate through all pieces
    with (obj_generic_piece) {
        // Check if enemy team
        if (team != other.team) {
            // Calculate grid distance
            var dx = abs(grid_pos.x - other.grid_pos.x);
            var dy = abs(grid_pos.y - other.grid_pos.y);
            var dist = max(dx, dy); // Chebyshev distance (grid-based)

            if (dist <= range && dist < min_dist) {
                closest = id;
                min_dist = dist;
            }
        }
    }

    return closest;
}

// Perform area-of-effect attack
function perform_area_attack(target) {
    // Calculate world position of target
    var target_x = target.x;
    var target_y = target.y;

    // Find all enemies in area
    with (obj_generic_piece) {
        if (team != other.team) {
            var dist = point_distance(x, y, target_x, target_y);

            if (dist <= other.area_effect_radius) {
                // Deal damage using the effects system
                // Create a damage effect that applies immediately
                var damage_effect = effect_array_create(
                    EFFECT.NOTHING,           // No special effect type
                    other.attackPower,        // Use piece's attack power from database
                    1,                        // Duration (instant)
                    false,                    // No decay
                    other.id                  // Source object
                );

                // Add to target's effects management array
                array_push(effects_management_array, damage_effect);

                // Alternatively, damage directly through hp struct:
                // Apply_damage_to_hp(hp, other.attackPower, "base");
            }
        }
    }

    // Visual feedback (optional)
    // Could spawn explosion effect at target location
    // instance_create_layer(target_x, target_y, "Effects", obj_explosion);
}

// ==============================================================================
// 3. SPAWNING PIECES - Request System
// ==============================================================================

// Example of spawning a piece during gameplay
function example_spawn_piece_on_grid() {
    // Use the request system to spawn pieces
    // r_spawn_piece() creates a request that will be processed by obj_battle_handler

    var spawn_identity = PIECE.EXAMPLE_DEFENDER;
    var spawn_team = 0; // Team 0 (player)
    var spawn_grid_pos = {x: 5, y: 3}; // Grid position

    // Spawn on grid (not on another piece)
    r_spawn_piece(
        spawn_identity,
        spawn_team,
        spawn_grid_pos,
        true  // on_grid = true means using grid_pos
    );

    // The request will be processed in the next game loop
    // via read_requests() in obj_battle_handler
}

function example_spawn_piece_on_piece() {
    // Spawn a piece on top of another piece
    var base_piece = instance_find(obj_wall, 0); // Find a wall piece

    if (base_piece != noone) {
        r_spawn_piece(
            PIECE.SHOOTER,           // Spawn a shooter
            base_piece.team,         // Same team as base
            base_piece.id,           // Reference to base piece
            false                    // on_grid = false means spawning on piece
        );
    }
}

// ==============================================================================
// 4. EFFECTS SYSTEM DEMONSTRATION
// ==============================================================================

// Example of applying effects to a piece
function example_apply_speed_buff(target_piece, duration) {
    // Create a speed effect using the effect_array_create function
    var speed_effect = effect_array_create(
        EFFECT.SPEED,      // Effect type
        0.5,               // Potency (50% speed increase)
        duration,          // Duration in seconds
        false,             // No decay (constant effect)
        id                 // Source object (this piece)
    );

    // Add to target's effects management array
    // This will be processed by effect_manager_process() each frame
    with (target_piece) {
        array_push(effects_management_array, speed_effect);
    }
}

function example_apply_damage_over_time(target_piece, damage_per_second, duration) {
    // Apply poison effect (damage over time)
    var poison_effect = effect_array_create(
        EFFECT.POISON,     // Poison type
        damage_per_second, // Damage per second
        duration,          // Total duration
        false,             // No decay
        id                 // Source
    );

    with (target_piece) {
        array_push(effects_management_array, poison_effect);
    }
}

// ==============================================================================
// 5. MOVEMENT SYSTEM DEMONSTRATION
// ==============================================================================

// Example of moving a piece
function example_move_piece(piece_to_move, target_grid_pos) {
    // Before moving, validate the move is legal
    // Use piece_attack() which validates moves against piece's MOVES array

    with (piece_to_move) {
        // Set execute state to trigger move validation
        execute = "move";

        // piece_attack() will be called from Step event
        // It validates the move against the piece's movement pattern
        // If valid, it calls r_move_piece() to queue the move

        // For direct movement (bypassing validation), use request:
        var move_valid = true; // You would validate this properly

        if (move_valid && move_cooldown_timer <= 0) {
            r_move_piece(
                id,              // Piece to move
                target_grid_pos, // Target position
                noone,           // No target piece (just moving)
                false            // Not an attack move
            );
        }
    }
}

// ==============================================================================
// 6. HEALTH SYSTEM DEMONSTRATION
// ==============================================================================

// The hp struct has multiple layers: {base, armor, shield, over}
function example_damage_piece(target_piece, damage_amount) {
    with (target_piece) {
        // Damage is applied through the health management system
        // The manage_health() function (called by piece()) handles destruction

        // Direct damage to base health
        hp.base -= damage_amount;

        // Or damage specific layer
        if (hp.shield > 0) {
            var shield_damage = min(hp.shield, damage_amount);
            hp.shield -= shield_damage;
            damage_amount -= shield_damage;
        }

        if (damage_amount > 0 && hp.armor > 0) {
            var armor_damage = min(hp.armor, damage_amount);
            hp.armor -= armor_damage;
            damage_amount -= armor_damage;
        }

        if (damage_amount > 0) {
            hp.base -= damage_amount;
        }

        // manage_health() will check if hp.base <= 0 and destroy piece
    }
}

function example_heal_piece(target_piece, heal_amount) {
    with (target_piece) {
        // Apply overhealth (temporary health above max)
        var overheal_effect = effect_array_create(
            EFFECT.OVERHEALTH,
            heal_amount,
            10,    // Lasts 10 seconds
            true,  // Decays over time
            other.id
        );
        array_push(effects_management_array, overheal_effect);
    }
}

// ==============================================================================
// 7. KEY CONCEPTS SUMMARY
// ==============================================================================

/*
PIECE LIFECYCLE:
1. Create: Initialize from database via piece_database(identity)
2. Every Frame: Call piece() which processes:
   - Animations
   - Effects (buffs/debuffs/damage)
   - Health management
   - Destruction checks
3. Custom behavior in Step event after piece() call
4. Destruction: manage_health() destroys when hp.base <= 0

COORDINATE SYSTEMS:
- grid_pos: {x, y} - Grid coordinates (0-based)
- x, y: World coordinates (pixels)
- Conversion: world = grid * GRIDSPACE + offsets

REQUEST SYSTEM:
- r_spawn_piece() - Queue piece creation
- r_move_piece() - Queue piece movement
- read_requests() - Process queued requests each frame

EFFECTS:
- effects_array[]: Current potency of each effect (recalculated each frame)
- effects_management_array: Active effect objects with duration
- Processed by effect_process() and effect_manager_process()

MOVEMENT:
- Movement patterns defined in database (MOVES array)
- Validated by piece_attack() before execution
- Applied via r_move_piece() request
- Cooldown enforced via move_cooldown_timer

TEAM SYSTEM:
- team 0 vs team 1
- Movement patterns can flip based on team (via string notation)
*/
