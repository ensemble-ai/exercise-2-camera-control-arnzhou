class_name PushZone
extends CameraControllerBase

@export var push_ratio:float = 0.2
@export var speedup_zone_top_left:Vector2 = Vector2(-3, -3)
@export var speedup_zone_bottom_right:Vector2 = Vector2(3, 3)
@export var pushbox_top_left:Vector2 = Vector2(-6, -6)
@export var pushbox_bottom_right:Vector2 = Vector2(6, 6)


var pushbox_width:float = pushbox_bottom_right.x - pushbox_top_left.x
var pushbox_height:float = pushbox_bottom_right.y - pushbox_top_left.y

var speedup_width:float = speedup_zone_bottom_right.x - speedup_zone_top_left.x
var speedup_height:float = speedup_zone_bottom_right.y - speedup_zone_top_left.y

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	var in_inner_rect:bool = in_zone(speedup_zone_top_left, speedup_zone_bottom_right, speedup_width, speedup_height)
	var in_outer_rect:bool = in_zone(pushbox_top_left, pushbox_bottom_right, pushbox_width, pushbox_height)
	
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - pushbox_height / 2.0)
	var diff_between_bot_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + pushbox_height / 2.0)
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - pushbox_width / 2.0)
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + pushbox_width / 2.0)
	
	# In middle zone (do nothing)
	if in_inner_rect:
		pass
	# In speedup zone
	elif in_outer_rect:
		# Top check
		if diff_between_top_edges >= 0 and \
				diff_between_top_edges <= (pushbox_height - speedup_height) / 2 and \
				target.velocity.z < 0:
			global_position.z -= push_ratio * target.velocity.length() / 60
		# Bot check
		if diff_between_bot_edges <= 0 and \
				diff_between_bot_edges >= -(pushbox_height - speedup_height) / 2 and \
				target.velocity.z > 0:
			global_position.z += push_ratio * target.velocity.length() / 60
		# Left check
		if diff_between_left_edges >= 0 and \
				diff_between_left_edges <= (pushbox_width - speedup_width) / 2 and \
				target.velocity.x < 0:
			global_position.x -= push_ratio * target.velocity.length() / 60
		# Right check
		if diff_between_right_edges <= 0 and \
				diff_between_right_edges >= -(pushbox_width - speedup_width) / 2 and \
				target.velocity.x > 0:
			global_position.x += push_ratio * target.velocity.length() / 60
	# Outside both zones
	else:
		#left
		if diff_between_left_edges < 0:
			global_position.x += diff_between_left_edges
		#right
		if diff_between_right_edges > 0:
			global_position.x += diff_between_right_edges
		#top
		if diff_between_top_edges < 0:
			global_position.z += diff_between_top_edges
		#bottom
		if diff_between_bot_edges > 0:
			global_position.z += diff_between_bot_edges
	
	
	#boundary checks
	#left
	#var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width / 2.0)
	#if diff_between_left_edges < 0:
		#global_position.x += diff_between_left_edges
	##right
	#var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width / 2.0)
	#if diff_between_right_edges > 0:
		#global_position.x += diff_between_right_edges
	##top
	#var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height / 2.0)
	#if diff_between_top_edges < 0:
		#global_position.z += diff_between_top_edges
	##bottom
	#var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height / 2.0)
	#if diff_between_bottom_edges > 0:
		#global_position.z += diff_between_bottom_edges
		
	super(delta)



func in_zone(top_left:Vector2, bottom_right:Vector2, box_width:float, box_height:float) -> bool:
	#boundary checks
	#left
	var tpos:Vector3 = target.global_position
	var cpos:Vector3 = global_position
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width / 2.0)
	if diff_between_left_edges < 0:
		return false
	#right
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width / 2.0)
	if diff_between_right_edges > 0:
		return false
	#top
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height / 2.0)
	if diff_between_top_edges < 0:
		return false
	#bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height / 2.0)
	if diff_between_bottom_edges > 0:
		return false
	
	return true

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var push_left:float = pushbox_top_left.x
	var push_right:float = pushbox_bottom_right.x
	var push_top:float = pushbox_top_left.y
	var push_bottom:float = pushbox_bottom_right.y
	
	var speedup_left:float = speedup_zone_top_left.x
	var speedup_right:float = speedup_zone_bottom_right.x
	var speedup_top:float = speedup_zone_top_left.y
	var speedup_bottom:float = speedup_zone_bottom_right.y
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(push_right, 0, push_top))
	immediate_mesh.surface_add_vertex(Vector3(push_right, 0, push_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(push_right, 0, push_bottom))
	immediate_mesh.surface_add_vertex(Vector3(push_left, 0, push_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(push_left, 0, push_bottom))
	immediate_mesh.surface_add_vertex(Vector3(push_left, 0, push_top))
	
	immediate_mesh.surface_add_vertex(Vector3(push_left, 0, push_top))
	immediate_mesh.surface_add_vertex(Vector3(push_right, 0, push_top))
	immediate_mesh.surface_end()
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0, speedup_top))
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0, speedup_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0, speedup_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0, speedup_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0, speedup_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0, speedup_top))
	
	immediate_mesh.surface_add_vertex(Vector3(speedup_left, 0, speedup_top))
	immediate_mesh.surface_add_vertex(Vector3(speedup_right, 0, speedup_top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
