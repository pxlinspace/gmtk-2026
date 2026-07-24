extends Node

signal pre_timestep(curr_timestep: int)
signal timestep(curr_timestep: int)
signal pre_move_missed
signal move_missed

signal win
signal item_gotten(tile_item: TileItem)
signal item_received(item_resource: ItemResource)
signal treasure_received
signal cam_shake(amount: float)
signal restart_level
signal toggle_pause(paused: bool)
signal all_treasure_gotten
