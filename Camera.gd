extends Camera2D

const deadZone = 175

@export var randomStrength : float = 30.0
@export var shakeFade : float = 5.0

var rng = RandomNumberGenerator.new()

var shake_strength : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		offset = randomOffset()

func apply_shake(customStrength : float = 0):
	shake_strength = customStrength if customStrength > 0 else randomStrength


func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))


func _input(event : InputEvent):
	if event is InputEventMouseMotion:
		var _target = event.position - get_viewport().size * 0.5
		var length = _target.length() * 0.9
		
		if length < deadZone:
			self.position = Vector2(0,0)
		else:
			self.position = _target.normalized() * (length - deadZone) * 0.5
