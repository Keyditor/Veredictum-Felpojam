extends Resource

class_name MailItem

@export var mail_type: Enum.MailTypes
@export var sender_name: String
@export var receiver_name: String
@export var stamped: Enum.StampMarks =  Enum.StampMarks.Neuter
@export var texture: Texture2D
@export var collider_position: Vector2
@export var collider_shape: Shape2D
