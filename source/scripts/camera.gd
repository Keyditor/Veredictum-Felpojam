extends Camera2D

var shake_duration: float = 0.0
var shake_intensity: float = 0.0

func start_shake(intensity, duration):
	shake_duration = duration
	shake_intensity = intensity
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.start("intro")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_duration > 0:
		shake_duration -= delta
		
		var offset_x = randf_range(-shake_intensity, shake_intensity)
		var offset_y = randf_range(-shake_intensity, shake_intensity)
		
		offset = Vector2(offset_x, offset_y)
	else:
		offset = Vector2.ZERO
