extends Control

var result = []
var setup = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 1
	for ring in $bg.get_children():
		ring.toggled.connect(_on_ring_toggled.bind(i))
		i +=1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_ring_toggled(button_pressed, number): #when a ring is pressed, add it to the result array if it was not pressed yet and removes it if it was already in
	if not setup:
		if button_pressed:
			result.append(number)
			updateNumbers()
				
		else:
			result.erase(number)
			$bg.get_children()[number-1].get_node("number").text = ""
			updateNumbers()
	pass
	

func updateNumbers():
	for i in range(len(result)):
			var ringNum = result[i]-1
			$bg.get_children()[ringNum].get_node("number").text = str(i+1)
			$bg.get_children()[ringNum].button_pressed = true
			


func _on_flip_pressed():
	for ring in $bg.get_children():
		ring.position = Vector2(363 - ring.position[0], ring.position[1])
	pass # Replace with function body.
