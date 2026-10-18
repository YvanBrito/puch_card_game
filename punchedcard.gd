extends Node2D

var infoText: String
var isComparable: bool = false
var isBehind: bool = false

@onready var punches: Node2D = $punches
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var init: AudioStreamPlayer = $Init
@onready var end: AudioStreamPlayer = $End
const COLUMN = preload("uid://duyoieugk0bhq")
const PUNCH = preload("uid://dflpn07xb1mrc")

var punchesMatrix = []

const translate = {
	"A" : Vector2(11, 1),
	"B" : Vector2(11, 2),
	"C" : Vector2(11, 3),
	"D" : Vector2(11, 4),
	"E" : Vector2(11, 5),
	"F" : Vector2(11, 6),
	"G" : Vector2(11, 7),
	"H" : Vector2(11, 8),
	"I" : Vector2(11, 9),
	"J" : Vector2(12, 1),
	"K" : Vector2(12, 2),
	"L" : Vector2(12, 3),
	"M" : Vector2(12, 4),
	"N" : Vector2(12, 5),
	"O" : Vector2(12, 6),
	"P" : Vector2(12, 7),
	"Q" : Vector2(12, 8),
	"R" : Vector2(12, 9),
	"S" : Vector2(0, 2),
	"T" : Vector2(0, 3),
	"U" : Vector2(0, 4),
	"V" : Vector2(0, 5),
	"W" : Vector2(0, 6),
	"X" : Vector2(0, 7),
	"Y" : Vector2(0, 8),
	"Z" : Vector2(0, 9)
}

func _ready() -> void:
	pass
	for n in range(0, 16):
		var col = COLUMN.instantiate()
		col.position.y = 40
		col.position.x = 135 + (28 * n)
		punchesMatrix.append([])
		for m in range(0, 12):
			var p = PUNCH.instantiate()
			col.add_child(p)
			p.position.x = -109
			p.position.y = (m * 23) - 13
			punchesMatrix[n].append(p)
		add_child(col)

func _process(delta: float) -> void:
	pass

func collect_data():
	var commands: Array[String] = []
	var errors: Array[String] = []
	for i in range(punchesMatrix.size()):
		var col: Array[int] = []
		for j in range(punchesMatrix[i].size()):
			if punchesMatrix[i][j].punched:
				col.append(j)
		if col.size() > 0:
			if col.size() == 1:
				errors.append("Command incomplete")
			elif col.size() > 2:
				errors.append("Too many values in one column")
			elif col[0] == 2 and col[1] == 6:
				commands.append("U")
			elif col[0] == 0 and col[1] == 6:
				commands.append("D")
			elif col[0] == 1 and col[1] == 5:
				commands.append("L")
			elif col[0] == 1 and col[1] == 11:
				commands.append("R")
			elif col[0] == 0 and col[1] == 9:
				commands.append("G")
			else:
				errors.append("Command not valid")
	if commands.size() < 1:
		errors.append("No commands inserted")
	get_parent().process_data(commands, errors)
	
func reset():
	for i in range(punchesMatrix.size()):
		for j in range(punchesMatrix[i].size()):
			punchesMatrix[i][j].reset()

func play_init_soud():
	init.play()

func play_end_soud():
	end.play()
