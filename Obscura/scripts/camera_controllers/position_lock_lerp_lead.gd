class_name PositionLockLerpLead
extends CameraControllerBase

@export var lead_speed:float = 1.2
@export var catchup_delay_duration:float = 0.1
@export var catchup_speed:float = 0.9
@export var leash_distance:float = 5.0

var _timer:Timer

func _ready() -> void:
	super()
	position = target.position
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	_timer.start(catchup_delay_duration)

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	var true_lead_speed:float = target.velocity.length() * lead_speed / 60
	var true_catchup_speed:float = target.BASE_SPEED * catchup_speed / 60
	
	var direction:Vector3 = target.velocity.normalized()
	var diff_from_player:Vector3 = Vector3(tpos.x - cpos.x, 0, tpos.z - cpos.z)
	
	if diff_from_player.length() >= leash_distance and target.velocity.length() > 0:
		# Calculate next camera position
		var next_point:Vector3 = cpos + direction * lead_speed
		next_point.y = tpos.y
		
		# Clamp distance to leash
		var diff_from_next_point:Vector3 = (next_point - tpos).normalized()
		global_position = tpos + leash_distance * diff_from_next_point
		
		# Update other vars
		cpos = global_position
		diff_from_player = Vector3(tpos.x - cpos.x, 0, tpos.z - cpos.z)
	
	if target.velocity.length() > 0:
		global_position += true_lead_speed * direction
		_timer.start(catchup_delay_duration)
	else:
		if _timer.is_stopped():
			if diff_from_player.length() < true_catchup_speed:
				global_position = tpos
			else:
				direction = diff_from_player.normalized()
				#print(str(direction) + " " + str(diff_from_player))
				global_position += true_catchup_speed * direction

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
