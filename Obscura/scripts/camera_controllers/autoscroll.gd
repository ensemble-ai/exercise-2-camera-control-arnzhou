class_name Autoscroll
extends CameraControllerBase


@export var top_left:Vector2 = Vector2(-12, -6)
@export var bottom_right:Vector2 = Vector2(-6, 6)
@export var autoscroll_speed:Vector3 = Vector3(.2, 0, 0)

var _box_width:float = bottom_right.x - top_left.x
var _box_height:float = bottom_right.y - top_left.y
var _box_center:Vector2 = Vector2((top_left.x + bottom_right.x) / 2.0, (top_left.y + bottom_right.y) / 2.0)
var _max_dist:Vector2 = Vector2((_box_width - target.WIDTH) / 2.0, (_box_height - target.HEIGHT) / 2.0)

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()

	global_position += autoscroll_speed
	
	var tpos = target.global_position
	var cpos = global_position
	
	#boundary checks
	#left
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x + _box_center.x - _box_width / 2.0)
	if diff_between_left_edges < 0:
		#print(str(diff_between_left_edges))
		target.global_position.x = (cpos.x + _box_center.x) - _max_dist.x
		#print("L")
	#right
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + _box_center.x + _box_width / 2.0)
	if diff_between_right_edges > 0:
		target.global_position.x = (cpos.x + _box_center.x) + _max_dist.x
		#print("R")
	#top
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z + _box_center.y - _box_height / 2.0)
	if diff_between_top_edges < 0:
		target.global_position.z = (cpos.z + _box_center.y) - _max_dist.y
		#print("U")
	#bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + _box_center.y + _box_height / 2.0)
	if diff_between_bottom_edges > 0:
		target.global_position.z = (cpos.z + _box_center.y) + _max_dist.y
		#print("D")
	
	#var box_center_x:float = global_position.x + (top_left.x + bottom_right.x) / 2
	## x distance from target center to box center
	#var rel_dist_x:float = tpos.x - box_center_x
	#print(str(box_center_x) + " " + str(tpos.x) + " " + str(rel_dist_x))
	## max x distance allowed from target center to box center
	#var max_dist_x:float = _box_width / 2 - target.WIDTH / 2
	#
	#if rel_dist_x > max_dist_x:
		#target.global_position.x = box_center_x + max_dist_x
		#print("RIGHT EDGE REACHED")
	#elif rel_dist_x < -max_dist_x:
		#target.global_position.x = box_center_x - max_dist_x
		#print("LEFT EDGE REACHED")
	
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var top:float = top_left.y
	var bottom:float = bottom_right.y
	var left:float = top_left.x
	var right:float = bottom_right.x
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
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
