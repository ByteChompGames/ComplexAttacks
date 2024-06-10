extends Camera2D

@export var random_strength: float = 30 # how aggressive the camera will shake
@export var shake_fade : float = 5 # how long the camera will shake

var rng = RandomNumberGenerator.new()
var shake_strength: float =  0

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta) # slow shake to a stop over time
		offset = randomOffset() # set camera offset to random value

func apply_shake(): #sets the shake strength to the random value
	shake_strength = random_strength

func randomOffset() -> Vector2: # returns a random Vector2 based on the shake strength
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
