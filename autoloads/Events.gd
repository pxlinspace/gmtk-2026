extends Node

signal timestep(curr_timestep: int)
signal move_missed
signal win
signal item_gotten(tile_item: TileItem)
signal item_received(item_resource: ItemResource)
signal cam_shake(amount: float)
signal restart_level
