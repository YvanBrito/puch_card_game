extends Node2D

const PATH = preload("uid://e2hs3210sihs")
const GOAL = preload("uid://22nwnwokciof")
@onready var card_manager: Node2D = $"../CardManager"

var fields = [
	[
		[1, 2, 3],
	],
	[
		[1, 2],
		[2, 3]
	],
	[
		[1, 2, 2],
		[2, 0, 2],
		[2, 2, 3]
	],
	[
		[1, 2, 0, 0],
		[0, 2, 2, 0],
		[0, 0, 2, 2],
		[0, 0, 0, 3]
	],
	[
		[1, 2, 2, 2],
		[0, 0, 2, 0],
		[2, 2, 2, 0],
		[2, 0, 2, 3]
	],
	[
		[1, 2, 2, 2],
		[0, 0, 0, 2],
		[2, 2, 2, 2],
		[3, 0, 0, 0]
	],
	[
		[1, 2, 0, 2, 2],
		[0, 2, 2, 2, 0],
		[2, 2, 0, 2, 2],
		[2, 0, 2, 0, 2],
		[2, 2, 2, 0, 3]
	],
	[
		[1, 0, 2, 2, 2],
		[2, 0, 2, 0, 2],
		[2, 2, 2, 0, 2],
		[0, 0, 0, 0, 2],
		[3, 2, 2, 2, 2]
	],
]

var current_field_index = 0
var current_field = fields[current_field_index]

var nodesField = []
var steps: Array[Vector2] = []
var next_step_index = 0
var actual_step: Vector2 = Vector2.ZERO
var initial_step: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var gap: int = 60
	for i in range(current_field.size()):
		nodesField.append([])
		for j in range(current_field[i].size()):
			var p = PATH.instantiate()
			if current_field[i][j] == 0:
				p.modulate = Color(p.modulate.r, p.modulate.g, p.modulate.b, 0)
			if current_field[i][j] == 1:
				initial_step = Vector2(i, j)
				actual_step = Vector2(i, j)
				p.modulate = Color(p.modulate.r, p.modulate.g, p.modulate.b, 255)
			if current_field[i][j] == 3:
				p = GOAL.instantiate()
			p.position = Vector2(j*gap,i*gap)
			add_child(p)
			nodesField[i].append(p)

func next_level(level: int):
	reset_field()
	for n in get_children():
		remove_child(n)

	nodesField = []
	current_field_index = level
	current_field = fields[current_field_index]
	_ready()

func reset_field():
	actual_step = initial_step
	steps = []
	next_step_index = 0
	for i in range(current_field.size()):
		for j in range(current_field[i].size()):
			if current_field[i][j] == 2 or current_field[i][j] == 3:
				nodesField[i][j].reset()

func add_step(step: Vector2):
	steps.append(step)

func play_animation():
	if next_step_index < steps.size():
		actual_step = actual_step + steps[next_step_index]
		if actual_step.x < 0 or actual_step.x >= current_field.size():
			card_manager.end_game(false)
		elif actual_step.y < 0 or actual_step.y >= current_field[actual_step.x].size():
			card_manager.end_game(false)
		elif current_field[actual_step.x][actual_step.y] == 0:
			card_manager.end_game(false)
		else:
			nodesField[actual_step.x][actual_step.y].animation_player.play("highlight")
	elif current_field[actual_step.x][actual_step.y] == 3:
		card_manager.end_game(true)
	else:
		card_manager.end_game(false)

func next_step():
	next_step_index = next_step_index + 1
	play_animation()
