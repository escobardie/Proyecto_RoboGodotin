extends PathFollow


var velocidad_mov_sierra: float = 2

func _process(delta: float) -> void:
	set_offset(get_offset() + velocidad_mov_sierra * delta)
	
