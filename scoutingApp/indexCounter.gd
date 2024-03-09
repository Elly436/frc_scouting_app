extends Node2D

var dropdownOptions: Array


func _on_plus_pressed():
	addOption(int($indexCounter.text))
	$indexCounter.text = str(int($indexCounter.text) + 1)
	$indexCounter/minus.visible = true
	if int($indexCounter.text) <= len(dropdownOptions)-1:
		$option.text = dropdownOptions[int($indexCounter.text)]
		$pointValue.text = str($template.pointValue[int($indexCounter.text)])
	else:
		$option.text= ""
		$pointValue.text = ""
	


func _on_minus_pressed():
	addOption(int($indexCounter.text))
	if int($indexCounter.text) > 0:
		$indexCounter.text = str(int($indexCounter.text) - 1)
	if int($indexCounter.text) <= 0:
		$indexCounter/minus.visible = false
	if int($indexCounter.text) <= len(dropdownOptions)-1:
		$option.text = dropdownOptions[int($indexCounter.text)]
		$pointValue.text = str($template.pointValue[int($indexCounter.text)])
	else:
		$option.text= ""
		$pointValue.text = ""
		
func addOption(index):
	dropdownOptions.remove_at(index)
	$template.pointValue.remove_at(index)
	if $option.text != "":
		dropdownOptions.insert(index, $option.text)
		$template.pointValue.insert(index, int($pointValue.text))
	

func _on_category_text_changed(new_text):
	$template/category.text = new_text
	
func reset():
	$template.clear()
	$template.pointValue = []
	$indexCounter.text = "0"
	$indexCounter/minus.visible = false
	$option.text = ""
	$category.text = ""
	$template/category.text = ""
	$pointValue.text = ""
	dropdownOptions = []
	
	
