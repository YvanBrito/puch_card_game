extends Node2D

var card_being_dragged
var urna: bool = false
var mouse_distance: Vector2
var mouse_distance2: Vector2
var canCompare: bool = false
@onready var field: Node2D = $"../Field"
const PUNCHED_CARD = preload("uid://cuwpoiqu0qoka")
@onready var new_card_button: Button = $"../Control/NewCardButton"
var isCardPresent: bool = false
var punched_card
var cards_qtt = 2
var level = 0
@onready var cards_quantity_label: RichTextLabel = $"../Control/cards_quantity_label"
@onready var lost_panel: Panel = $"../Control/LostPanel"
@onready var back_menu_button: Button = $"../Control/LostPanel/BackMenuButton"
@onready var win_panel: Panel = $"../Control/WinPanel"
@onready var next_level_button: Button = $"../Control/WinPanel/NextLevelButton"
@onready var finish_game_panel: Panel = $"../Control/FinishGamePanel"
@onready var back_menu_button_finish_game: Button = $"../Control/FinishGamePanel/BackMenuButton"
@onready var errors_label: RichTextLabel = $"../Control/ErrorsLabel"

func _ready() -> void:
	new_card_button.pressed.connect(create_card)
	back_menu_button.pressed.connect(restart_scene)
	back_menu_button_finish_game.pressed.connect(restart_scene)
	next_level_button.pressed.connect(next_level)
	punched_card = PUNCHED_CARD.instantiate()
	add_child(punched_card)
	create_card()

func restart_scene():
	get_tree().reload_current_scene()

func next_level():
	level = level + 1
	punched_card.reset()
	cards_qtt = 2
	field.next_level(level)
	create_card()
	win_panel.visible = false

func create_card() -> void:
	punched_card.reset()
	cards_qtt = cards_qtt - 1
	cards_quantity_label.text = "You have\n" + str(cards_qtt) + "\ncards"
	isCardPresent = true
	punched_card.position = Vector2(900,100)
	punched_card.z_index = 0

func _process(delta: float) -> void:
	new_card_button.disabled = isCardPresent or cards_qtt == 0
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = mouse_pos + mouse_distance

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var card = raycast_check_for_card()
			if card:
				card_being_dragged = card
				for c in range(get_children().size()):
					if get_child(c).z_index > card_being_dragged.z_index:
						get_child(c).z_index = get_child(c).z_index - 1
				card_being_dragged.z_index = get_children().size()-1
				mouse_distance = (card_being_dragged.position - get_global_mouse_position())
		else:
			if urna and card_being_dragged: 
				errors_label.text = ""
				var anim: Animation = card_being_dragged.animation_player.get_animation("falling")
				anim.track_set_key_value(0, 0, card_being_dragged.position)
				anim.track_set_key_value(0, 1, Vector2(card_being_dragged.position.x, card_being_dragged.position.y+300))
				card_being_dragged.animation_player.play("falling")
			card_being_dragged = null

func check_collisions():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 2
	return space_state.intersect_point(parameters)

func raycast_check_for_card():
	var result = check_collisions()
	if result.size() > 0:
		var greatestZIndex: int = 0
		for r in range(result.size()):
			if result[r].collider.get_parent().z_index > result[greatestZIndex].collider.get_parent().z_index:
				greatestZIndex = r
		return result[greatestZIndex].collider.get_parent()
	return null

func process_data(commands: Array[String], errors: Array[String]):
	if errors.size() > 0:
		commands = []
		for e in range(errors.size()):
			errors_label.text = errors_label.text + errors[e] + "\n"

	var right = Vector2(0,1)
	var left = Vector2(0,-1)
	var up = Vector2(-1,0)
	var down = Vector2(1,0)
	for c in range(commands.size()):
		if commands[c] == "D":
			field.add_step(down)
		elif commands[c] == "U":
			field.add_step(up)
		elif commands[c] == "L":
			field.add_step(left)
		elif commands[c] == "R":
			field.add_step(right)
	field.play_animation()

func end_game(win: bool):
	isCardPresent = false
	if win:
		if level >= field.fields.size()-1:
			finish_game_panel.visible = true
		else:
			win_panel.visible = true
	else:
		if cards_qtt > 0:
			field.reset_field()
		else:
			lost_panel.visible = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	urna = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	urna = false
