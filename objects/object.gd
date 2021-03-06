tool
extends StaticBody2D



# Declarations
onready var CollisionPolygon2DRef := CollisionPolygon2D.new()


enum Types { Pickable, Obstruction }
export(Types) var Type := Types.Pickable

export(float, 0.0, 100.0) var Damage := 0.0



# Core
func _ready():
	add_child(CollisionPolygon2DRef)
	add_to_group(Types.keys()[Type].to_lower())


func pick() -> void: queue_free()


func image_to_collision_polygon(texture : Texture):
	var bm = BitMap.new()
	bm.create_from_image_alpha(texture.get_data())
	var points = bm.opaque_to_polygons(
		Rect2(
			0,
			0,
			texture.get_width(),
			texture.get_height()
		)
	)
	if points.size() > 0:
		CollisionPolygon2DRef.set_polygon(points[0])


func _process(delta):
	if not Engine.editor_hint:
		if position.y < -40:
			queue_free()
