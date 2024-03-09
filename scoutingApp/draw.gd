extends Node2D

var points: PackedVector2Array
var removedPoints: PackedVector2Array


func _draw():
	#var imageTexture = ImageTexture.new()
	self.draw_polyline(points, Color.GREEN, 4.0)#draws a the shape stored in the points list


func _process(_delta):
	self.queue_redraw()


func _on_canvas_click_pressed():
	points.append(get_local_mouse_position())
	if len(points) > 0:
		self._draw()
	removedPoints = []
	print(self.texture)
	$canvas.texture = self.texture


func _on_redo_pressed():
	if len(removedPoints) >0:
		var point = removedPoints[len(removedPoints)-1]
		points.append(point)
		removedPoints.remove_at(len(removedPoints)-1)
		_draw()


func _on_undo_pressed():
	if len(points) >0:
		var point = points[len(points)-1]
		removedPoints.append(point)
		points.remove_at(len(points)-1)
		_draw()
		
		
