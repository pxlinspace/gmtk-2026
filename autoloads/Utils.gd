extends Node


func shapecast_at_pos(pos: Vector3i) -> Array[Area3D]:
	var cast_pos := Vector3(pos) + Vector3(0.5, 0.0, 0.5)
	var space_state := get_viewport().world_3d.direct_space_state
	var query := PhysicsPointQueryParameters3D.new()
	query.position = Vector3(cast_pos)
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var results := space_state.intersect_point(query)
	var overlapping_areas: Array[Area3D] = []
	for result in results:
		if result.collider is Area3D:
			overlapping_areas.append(result.collider)
	return overlapping_areas
