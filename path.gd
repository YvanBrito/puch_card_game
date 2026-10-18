extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pop: AudioStreamPlayer = $Pop
var color: Color

func next_step():
	get_parent().next_step()

func reset():
	animation_player.stop()

func play_pop():
	pop.play()
