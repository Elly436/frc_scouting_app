extends Node2D


func reset():
	$template.pointValue = 0
	$template.text = str($template.pointValue)
