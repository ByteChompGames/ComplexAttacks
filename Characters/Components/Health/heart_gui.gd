extends Panel
class_name HeartGUI

enum Fill
{
	FULL,
	HALF,
	EMPTY
}

var state : int = Fill.FULL

@onready var health_heart = $HealthHeart

func _ready():
	update_heart(state)

func update_heart(new_state : int):
	state = new_state
	match state:
		Fill.FULL:
			health_heart.play("full")
		Fill.HALF:
			health_heart.play("half")
		Fill.EMPTY:
			health_heart.play("empty")
