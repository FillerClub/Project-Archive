if instance_exists(journal_link) && instance_exists(journal_index_link) {
	var list = journal_index_link.list,
	index = clamp(journal_link.index -1,-1,array_length(list) -1);
	if index < 0 {
		draw_photo = -1;
		with trait_text_link {
			strg = "";
		}
		with description_link {
			strg = "";
		}
		with bio_link {
			strg = "";
		}
		with moves_link {
			moves = -1;
		}
		with name_link {
			strg = "";
		}
	} else {
		draw_photo = list[index].sprite;
		with trait_text_link {
			strg = "Cost: " +string(list[index].cost) +"\nHealth: " +string(total_health(list[index].hp)) +"\nAttack Power: " +string(list[index].attack_power) +"\nSlot Cooldown: " +string(list[index].slot_cooldown) +" seconds\nMove Cooldown: " +string(list[index].move_cooldown)
		}
		with description_link {
			strg = list[index].short_description;
		}
		with bio_link {
			strg = "Bios TBA...";//list[index].full_description;
		}
		with moves_link {
			moves = list[index].moves;	
		}
		with name_link {
			strg = list[index].name;
		}		
	}
}