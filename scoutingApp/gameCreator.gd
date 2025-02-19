extends Control

signal updateMatchTypes

var objectType = 0
@onready var dropdownTemplate = $newObject/objectView/dropdown/template
@onready var counterTemplate = $newObject/objectView/counter/template
@onready var toggleTemplate = $newObject/objectView/toggle/template
var timePeriod = 2

var testSubject

var matchType: String

# Called when the node enters the scene tree for the first time.
func _ready():
	$template/"auto path".visible = Global.isAutoPathVisible


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func loadObjects(info):
	var constantCountersInfo = info[0]
	var autoCountersInfo = info[1]
	var driveCountersInfo = info[2]
	var constantTogglesInfo = info[3]
	var autoTogglesInfo = info[4]
	var driveTogglesInfo = info[5]
	var constantDropdownsInfo = info[6]
	var autoDropdownsInfo = info[7]
	var driveDropdownsInfo = info[8]
	
	for objectInfo in constantCountersInfo:
		var counter = counterTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		counter.objectName = objectName
		counter.get_node("name").text = objectName
		counter.pointValue = pointValue
		counter.visible = true
		$template/constantCounters.add_child(counter)
		counter.position = pos
		
	for objectInfo in autoCountersInfo:
		var counter = counterTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		counter.objectName = objectName
		counter.get_node("name").text = objectName
		counter.pointValue = pointValue
		$template/autoCounters.add_child(counter)
		counter.position = pos
		
	for objectInfo in driveCountersInfo:
		var counter = counterTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		counter.objectName = objectName
		counter.get_node("name").text = objectName
		counter.pointValue = pointValue
		$template/driveCounters.add_child(counter)
		counter.position = pos
	
	for objectInfo in constantTogglesInfo:
		var toggle = toggleTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		toggle.objectName = objectName
		toggle.get_node("name").text = objectName
		toggle.pointValue = pointValue
		$template/constantToggles.add_child(toggle)
		toggle.position = pos
		
	for objectInfo in autoTogglesInfo:
		var toggle = toggleTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		toggle.objectName = objectName
		toggle.get_node("name").text = objectName
		toggle.pointValue = pointValue
		$template/autoToggles.add_child(toggle)
		toggle.position = pos
		
	for objectInfo in driveTogglesInfo:
		var toggle = toggleTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		toggle.objectName = objectName
		toggle.get_node("name").text = objectName
		toggle.pointValue = pointValue
		$template/driveToggles.add_child(toggle)
		toggle.position = pos
		
	for objectInfo in constantDropdownsInfo:
		var dropdown = dropdownTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		var selectables = objectInfo[3]
		dropdown.objectName = objectName
		dropdown.get_node("category").text = objectName
		dropdown.pointValue = pointValue
		for selectable in selectables:
			dropdown.add_item(selectable)
		$template/constantDropdowns.add_child(dropdown)
		dropdown.position = pos
		
	for objectInfo in autoDropdownsInfo:
		var dropdown = dropdownTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		var selectables = objectInfo[3]
		dropdown.objectName = objectName
		dropdown.get_node("category").text = objectName
		dropdown.pointValue = pointValue
		for selectable in selectables:
			dropdown.add_item(selectable)
		$template/autoDropdowns.add_child(dropdown)
		dropdown.position = pos
		
	for objectInfo in driveDropdownsInfo:
		var dropdown = dropdownTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		var selectables = objectInfo[3]
		dropdown.objectName = objectName
		dropdown.get_node("category").text = objectName
		dropdown.pointValue = pointValue
		for selectable in selectables:
			dropdown.add_item(selectable)
		$template/driveDropdowns.add_child(dropdown)
		dropdown.position = pos

func _on_create_object_pressed():
	if objectType == 2:
		$newObject/objectView/dropdown.addOption(int($newObject/objectView/dropdown/indexCounter.text))
		var object = dropdownTemplate.duplicate()
		object.selectable = true
		object.objectName = $newObject/objectView/dropdown/category.text
		for selectable in $newObject/objectView/dropdown.dropdownOptions:
			object.add_item(selectable)
		if timePeriod == 0:
			$template/autoDropdowns.add_child(object)
		elif timePeriod == 1:
			$template/driveDropdowns.add_child(object)
		elif timePeriod == 2:
			$template/constantDropdowns.add_child(object)
		elif timePeriod == 3:
			$template/autoDropdowns.add_child(object)
			object = dropdownTemplate.duplicate()
			object.selectable = true
			object.objectName = $newObject/objectView/dropdown/category.text
			$template/driveDropdowns.add_child(object)
		$newObject/objectView/dropdown.reset()
	if objectType == 0:
		var object = counterTemplate.duplicate()
		object.pointValue = $newObject/pointValue.text
		object.selectable = true
		if timePeriod == 0:
			$template/autoCounters.add_child(object)
		elif timePeriod == 1:
			$template/driveCounters.add_child(object)
		elif timePeriod == 2:
			$template/constantCounters.add_child(object)
		elif timePeriod == 3:
			$template/autoCounters.add_child(object)
			object = counterTemplate.duplicate()
			object.pointValue = $newObject/pointValue.text
			object.selectable = true
			$template/driveCounters.add_child(object)
		$newObject/objectView/counter.reset()
	if objectType == 1:
		var object = toggleTemplate.duplicate()
		object.pointValue = $newObject/pointValue.text
		object.selectable = true
		if timePeriod == 0:
			$template/autoToggles.add_child(object)
		elif timePeriod == 1:
			$template/driveToggles.add_child(object)
		elif timePeriod == 2:
			$template/constantToggles.add_child(object)
		elif timePeriod == 3:
			$template/autoToggles.add_child(object)
			object = toggleTemplate.duplicate()
			object.pointValue = $newObject/pointValue.text
			object.selectable = true
			$template/driveToggles.add_child(object)
		$newObject/objectView/toggle.reset()
			
	$newObject.visible = false
	$template.creatingInit()
	$newObject/pointValue.text = ""


func _on_new_object_pressed():
	$newObject.visible = true


func _on_option_button_item_selected(index):
	objectType = index
	for object in $newObject/objectView.get_children():
		object.visible = false
	if objectType == 2:
		$newObject/pointValue.visible = false
	else:
		$newObject/pointValue.visible = true
	$newObject/objectView.get_children()[index].visible = true


func _on_time_period_item_selected(index):
	timePeriod = index


func _on_test_pressed():
	testSubject = $template.duplicate()
	add_child(testSubject)
	testSubject.init()
	$template/background2.visible = true
	$back.visible = true
	$back.move_to_front()
	

func _on_back_pressed():
	testSubject.queue_free()
	$template/background2.visible = false
	$back.visible = false


func _on_create_game_pressed():
	$nameMatchType.visible = true


func _on_ok_pressed():
	matchType = $nameMatchType/matchName.text
	Global.scoreScreensInfo[matchType] = getScoreScreenInfo()
	print(getScoreScreenInfo())
	queue_free() #goes back to the main menu
	updateMatchTypes.emit()

func getScoreScreenInfo(): #returns a list of lists of lists with the position and other info of each object in the scene
	var info = [[], [], [], [], [], [], [], [], []]
	for object in $template/constantCounters.get_children():
		info[0].append([object.position, object.objectName, object.pointValue])
	for object in $template/autoCounters.get_children():
		info[1].append([object.position, object.objectName, object.pointValue])
	for object in $template/driveCounters.get_children():
		info[2].append([object.position, object.objectName, object.pointValue])
	for object in $template/constantToggles.get_children():
		info[3].append([object.position, object.objectName, object.pointValue])
	for object in $template/autoToggles.get_children():
		info[4].append([object.position, object.objectName, object.pointValue])
	for object in $template/driveToggles.get_children():
		info[5].append([object.position, object.objectName, object.pointValue])
	for object in $template/constantDropdowns.get_children():
		var selectables = []
		for i in range(object.get_item_count()):
			selectables.append(object.get_item_text(i))
		info[6].append([object.position, object.objectName, object.pointValue, selectables])
	for object in $template/autoDropdowns.get_children():
		var selectables = []
		for i in range(object.get_item_count()):
			selectables.append(object.get_item_text(i))
		info[7].append([object.position, object.objectName, object.pointValue, selectables])
	for object in $template/driveDropdowns.get_children():
		var selectables = []
		for i in range(object.get_item_count()):
			selectables.append(object.get_item_text(i))
		info[8].append([object.position, object.objectName, object.pointValue, selectables])
	return info

func _on_cancel_pressed():
	$nameMatchType.visible = false


func _on_back_home_pressed():
	queue_free()
