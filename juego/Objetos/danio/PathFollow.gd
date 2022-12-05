extends PathFollow


onready var velocidad_mov_sierra: float

func _ready() -> void:
	var random = RandomNumberGenerator.new()
	random.randomize()
	velocidad_mov_sierra = random.randi_range(2, 5)

func _process(delta: float) -> void:
	set_offset(get_offset() + velocidad_mov_sierra * delta)
	
