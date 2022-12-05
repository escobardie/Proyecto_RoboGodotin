#Sierra.gd
extends Area


func _ready() -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node) -> void:
	var player: Godotin = body
	if body == player:
		player.respawn()
	#if body is Godotin:
	#	body.respawn()
