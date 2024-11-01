class_name PositionLockLerp
extends CameraControllerBase

@export var follow_speed:float = 0.8
@export var catchup_speed:float = 0.6
@export var leash_distance:float = 5.0

func _ready() -> void:
	super()
	print(target.global_position)

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	var true_follow_speed:float = target.velocity.length() * follow_speed / 60
	var true_catchup_speed:float = target.BASE_SPEED * catchup_speed / 60
	
	# Vector difference from player to cursor center
	var diff_from_player:Vector3 = Vector3(tpos.x - cpos.x, 0, tpos.z - cpos.z)
	
	if diff_from_player.length() >= leash_distance and target.velocity.length() > 0:
		global_position = tpos - leash_distance * diff_from_player.normalized()
	else:
		if target.velocity.length() > 0:
			# Set camera directly on top of player if the two are close enough
			if diff_from_player.length() < true_follow_speed:
				global_position = tpos
			else:
				global_position += true_follow_speed * diff_from_player.normalized()
		else:
			if diff_from_player.length() < true_catchup_speed:
				global_position = tpos
			else:
				global_position += true_catchup_speed * diff_from_player.normalized()
	
	super(delta)

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	var cross_length:float = 5
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(cross_length / 2, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(-cross_length / 2, 0, 0))
	
	immediate_mesh.surface_add_vertex(Vector3(0, 0, cross_length / 2))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -cross_length / 2))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
	return
