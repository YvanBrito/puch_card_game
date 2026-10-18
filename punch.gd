class_name Punch extends Node2D

var punched: bool = false
@onready var sprite_2d: Sprite2D = $Sprite2D

func reset():
	punched = false
	sprite_2d.modulate = Color(sprite_2d.modulate.r, sprite_2d.modulate.b, sprite_2d.modulate.a, 0)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			punched = true
			sprite_2d.modulate = Color.BLACK
