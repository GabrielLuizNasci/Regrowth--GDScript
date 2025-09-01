extends Node

#Sinais para mensagens de itens
signal BUL_create_bulletin
signal BUL_destroy_bulletin
signal BUL_destroy_all_bulletins

#Sinais para Uso do Arco
signal BOW_change_element
signal BOW_shoot_arrow

#Sinais de Equipamento,
signal EQU_equip_weapon
signal EQU_unequip_weapon
signal EQU_change_equippable_weapon

#Sinais para Jogador
signal PLA_freeze_player
signal PLA_unfreeze_player

signal PLA_change_energy
signal PLA_energy_updated
signal PLA_energy_increased

signal PLA_change_health
signal PLA_health_updated
signal PLA_health_increased

signal PLA_can_shoot
signal PLA_stamina_empty
signal PLA_stamina_refilled

#Sinais para camera
signal CAM_set_lock_on_target
signal CAM_clear_lock_on_target

signal HUD_hide_hud
signal HUD_show_hud
