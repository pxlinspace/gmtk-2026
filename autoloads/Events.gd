extends Node

signal pre_timestep(curr_timestep: int)
signal timestep(curr_timestep: int)
signal pre_move_missed
signal move_missed

# triggered when player reaches holy light
signal win
# triggered when player completes the objective based on the level mode
signal mission_complete(level_mode: LevelResource.LevelMode)
# triggered when player touches the item pickup
signal item_gotten(tile_item: TileItem)
# triggered when player actually receives the item (after the animation)
signal item_received(item_resource: ItemResource)
# triggered instead of item_received when the item is a treasure
signal treasure_received
signal cam_shake(amount: float)
signal restart_level
signal toggle_pause(paused: bool)
signal all_treasure_gotten
signal all_enemies_killed
signal enemy_died(enemy: BaseEnemy)
signal player_beamed_down
signal player_pogo(distance: int)
