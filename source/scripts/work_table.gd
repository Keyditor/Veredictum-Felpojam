extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var boss: Node2D = $Boss

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().paused = false   # pausa o jogo 3D
	Dialogic.signal_event.connect(on_dialogic_signal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		pass

func play_animation(animation_name: String):
	animation_player.play(animation_name)
	
func play_dialogue(timeline_name: String):
	Dialogic.start(timeline_name)

func on_dialogic_signal(argument: String):
	if argument == "boss_arrive":
		print("Chefe chegou!!!")
		play_animation("camera_up")
		await animation_player.animation_finished
		play_animation("boss_show_up")
	if argument == "boss_stay_calm":
		boss.play_animation("forward_palms")
	if argument == "boss_index_finger":
		boss.play_animation("index_finger")
	if argument == "boss_finger_tenting":
		boss.play_animation("finger_tenting")
	if argument == "boss_arms_crossed":
		boss.play_animation("arms_crossed")
	if argument == "boss_pocket_watch":
		boss.play_animation("pocket_watch")
	if argument == "boss_leave":
		play_animation("boss_leave")
		await animation_player.animation_finished
		play_animation("camera_down")
