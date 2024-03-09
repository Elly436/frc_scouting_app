extends Control

@export var pointValue: Array
@export var objectName: String
var move = false
var selectable = false
var offset = Vector2(0, 0)



func _process(_delta):
	if not selectable:
		get_node("moveMe").visible = false
	else:
		get_node("moveMe").visible = true
	if move:
		position = get_global_mouse_position() - offset



func _on_move_me_pressed():
	if selectable:
		move = true
	offset = get_global_mouse_position() - position
	
func _on_move_me_released():
	if selectable:
		move = false
	



