tool
extends Control
class_name Gauge



# Declarations
signal hit(value)

export(bool) var Active := false

export(bool) var Oneshot := true

var MarkerRect : Rect2
var MarkerGrowth := 0.1
var MarkerPosition := 0.0
export(float, 0.0, 1.0) var MarkerRatio := 0.1
export(bool) var ConstantMaker := true
export(Color) var MarkerColor := Color.blue

var GoalRect : Rect2
export(float, 0.0, 1.0) var GoalRatio := 0.25
export(float, 0.0, 1.0) var GoalPosition := 0.5
export(Color) var GoalColor := Color.gold

export(Color) var BackgroundColor := Color.lightblue



# Core
func _ready():
	rect_clip_content = true


func _process(delta):
	update()
	if Input.is_action_just_released("action_activate"):
		if Oneshot: Active = false
		emit_signal("hit", 2.0 if GoalRect.encloses(MarkerRect) else MarkerPosition)

func _draw():
	draw_rect(Rect2(Vector2.ZERO, get_rect().size), BackgroundColor)
	
	var goal_size := Vector2(
		get_rect().size.x * GoalRatio,
		get_rect().size.y
	)
	var goal_position := Vector2(
		(get_rect().size.x - goal_size.x) * GoalPosition,
		0
	)
	GoalRect = Rect2(goal_position, goal_size)
	draw_rect(GoalRect, GoalColor)
	
	if Active or ConstantMaker:
		var marker_size := Vector2(
			get_rect().size.x * MarkerRatio,
			get_rect().size.y
		)
		var marker_position := Vector2(
			(get_rect().size.x - marker_size.x) * MarkerPosition,
			0
		)
		MarkerRect = Rect2(marker_position, marker_size)
		draw_rect(MarkerRect, MarkerColor)
		if Active:
			MarkerPosition += MarkerGrowth
			if MarkerPosition <= 0.0 or MarkerPosition >= 1.0:
				MarkerGrowth *= -1
