extends StaticBody2D

@export var ink_type: Enum.StampMarks
@onready var good_ink: Sprite2D = $GoodInk
@onready var bad_ink: Sprite2D = $BadInk

func _ready():
	if ink_type == Enum.StampMarks.Good:
		good_ink.visible = true
		bad_ink.visible = false
	else:
		bad_ink.visible = true
		good_ink.visible = false
		
