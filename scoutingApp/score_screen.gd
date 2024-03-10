extends Control

var teamNumber
var matchNumber
var score = 0
var finalScore = 0
var driveCounts = []
var autoCounts = []
var constantCounts = []
var driveToggles = []
var autoToggles = []
var constantToggles = []
var driveDropdowns = []
var autoDropdowns = []
var constantDropdowns = []
var auto = true
var outlier= false
var auto_path = []
var comment = ""

var inHomeScreen = false
var saved = true

var contents

var texture: ImageTexture

var substation

var move

signal save(inHomeScreen)

@onready var popup = $Popup
@onready var qr_code_image := $Popup/QRCode

@onready var dropdownTemplate = $dropdown/template
@onready var counterTemplate = $counter/template
@onready var toggleTemplate = $toggle/template

func _ready():
	if Global.currentScoreType == "":
		return
	var info = Global.scoreScreensInfo[Global.currentScoreType]
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
		counter.position = pos
		counter.objectName = objectName
		counter.get_node("name").text = objectName
		counter.pointValue = pointValue
		counter.visible = true
		$constantCounters.add_child(counter)
		
	for objectInfo in autoCountersInfo:
		var counter = counterTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		counter.position = pos
		counter.objectName = objectName
		counter.get_node("name").text = objectName
		counter.pointValue = pointValue
		$autoCounters.add_child(counter)
		
	for objectInfo in driveCountersInfo:
		var counter = counterTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		counter.position = pos
		counter.objectName = objectName
		counter.get_node("name").text = objectName
		counter.pointValue = pointValue
		$driveCounters.add_child(counter)
	
	for objectInfo in constantTogglesInfo:
		var toggle = toggleTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		toggle.position = pos
		toggle.objectName = objectName
		toggle.get_node("name").text = objectName
		toggle.pointValue = pointValue
		$constantToggles.add_child(toggle)
	for objectInfo in autoTogglesInfo:
		var toggle = toggleTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		toggle.position = pos
		toggle.objectName = objectName
		toggle.get_node("name").text = objectName
		toggle.pointValue = pointValue
		$autoToggles.add_child(toggle)
	for objectInfo in driveTogglesInfo:
		var toggle = toggleTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		toggle.position = pos
		toggle.objectName = objectName
		toggle.get_node("name").text = objectName
		toggle.pointValue = pointValue
		$driveToggles.add_child(toggle)
	for objectInfo in constantDropdownsInfo:
		var dropdown = dropdownTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		var selectables = objectInfo[3]
		dropdown.position = pos
		dropdown.objectName = objectName
		dropdown.get_node("category").text = objectName
		dropdown.pointValue = pointValue
		for selectable in selectables:
			dropdown.add_item(selectable)
		dropdown.scale
		$constantDropdowns.add_child(dropdown)
	for objectInfo in autoDropdownsInfo:
		var dropdown = dropdownTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		var selectables = objectInfo[3]
		dropdown.position = pos
		dropdown.objectName = objectName
		dropdown.get_node("category").text = objectName
		dropdown.pointValue = pointValue
		for selectable in selectables:
			dropdown.add_item(selectable)
		$autoDropdowns.add_child(dropdown)
	for objectInfo in driveDropdownsInfo:
		var dropdown = dropdownTemplate.duplicate()
		var pos:Vector2 = objectInfo[0]
		var objectName = objectInfo[1]
		var pointValue = objectInfo[2]
		var selectables = objectInfo[3]
		dropdown.position = pos
		dropdown.objectName = objectName
		dropdown.get_node("category").text = objectName
		dropdown.pointValue = pointValue
		for selectable in selectables:
			dropdown.add_item(selectable)
		$driveDropdowns.add_child(dropdown)
	
# Called when the node enters the scene tree for the first time.
func init(): #initializes all of the buttons, binds the necessary signals with a point value stored in the object
	var i = 0
	for counter in get_node("autoCounters").get_children():
		var add = counter.get_node("add")
		var substract = counter.get_node("substract")
		var pointValue = counter.pointValue
		counter.selectable = false
		autoCounts.insert(i, 0)
		add.pressed.connect(_add_score.bind(counter, i, pointValue, autoCounts))
		substract.pressed.connect(_minus_score.bind(counter, i, pointValue, autoCounts))
		i += 1

	i = 0
	for counter in get_node("driveCounters").get_children():
		var add = counter.get_node("add")
		var substract = counter.get_node("substract")
		var pointValue = counter.pointValue
		counter.selectable = false
		driveCounts.insert(i, 0)
		add.pressed.connect(_add_score.bind(counter, i, pointValue, driveCounts))
		substract.pressed.connect(_minus_score.bind(counter, i, pointValue, driveCounts))
		i += 1
	i = 0
	for counter in get_node("constantCounters").get_children():
		var add = counter.get_node("add")
		var substract = counter.get_node("substract")
		var pointValue = counter.pointValue
		counter.selectable = false
		constantCounts.insert(i, 0)
		add.pressed.connect(_add_score.bind(counter, i, pointValue, constantCounts))
		substract.pressed.connect(_minus_score.bind(counter, i, pointValue, constantCounts))
		i += 1
	i = 0
	for button in get_node("autoToggles").get_children():
		var pointValue = button.pointValue
		button.selectable = false
		button.pressed.connect(_toggle.bind(button, i, pointValue, autoToggles))
		autoToggles.insert(i, 0)
		i+=1
	i = 0
	for button in get_node("driveToggles").get_children():
		var pointValue = button.pointValue
		button.selectable = false
		button.pressed.connect(_toggle.bind(button, i, pointValue, driveToggles))
		driveToggles.insert(i, 0)
		i+=1
	i = 0
	for button in get_node("constantToggles").get_children():
		var pointValue = button.pointValue
		button.selectable = false
		button.pressed.connect(_toggle.bind(button, i, pointValue, constantToggles))
		constantToggles.insert(i,0)
		i+=1
	i = 0
	for dropdown in get_node("constantDropdowns").get_children():
		var pointValue = dropdown.pointValue
		score += pointValue[0]
		dropdown.selectable = false
		dropdown.item_selected.connect(_change_dropdown)
		constantDropdowns.insert(i,0)
		i+=1
	i = 0
	for dropdown in get_node("autoDropdowns").get_children():
		var pointValue = dropdown.pointValue
		score += pointValue[0]
		dropdown.selectable = false
		dropdown.item_selected.connect(_change_dropdown)
		autoDropdowns.insert(i,0)
		i+=1
	i = 0
	for dropdown in get_node("driveDropdowns").get_children():
		var pointValue = dropdown.pointValue
		score += pointValue[0]
		dropdown.selectable = false
		dropdown.item_selected.connect(_change_dropdown)
		driveDropdowns.insert(i,0)
		i+=1
	$personalScoreLabel.text = str(score)
	$"auto path".setup = false

func showButtons():
	$generateQRCode.visible = true
	$homeButton.visible = true
	$save.visible = true

func creatingInit(): #initializes all of the buttons, binds the necessary signals with a point value stored in the object
	var i = 0
	for counter in get_node("autoCounters").get_children():
		var add = counter.get_node("add")
		var substract = counter.get_node("substract")
		var pointValue = counter.pointValue
		autoCounts.insert(i, 0)
		add.pressed.connect(_add_score.bind(counter, i, pointValue, autoCounts))
		substract.pressed.connect(_minus_score.bind(counter, i, pointValue, autoCounts))
		i += 1
		
	i = 0
	for counter in get_node("driveCounters").get_children():
		var add = counter.get_node("add")
		var substract = counter.get_node("substract")
		var pointValue = counter.pointValue
		driveCounts.insert(i, 0)
		add.pressed.connect(_add_score.bind(counter, i, pointValue, driveCounts))
		substract.pressed.connect(_minus_score.bind(counter, i, pointValue, driveCounts))
		i += 1
	i = 0
	for counter in get_node("constantCounters").get_children():
		var add = counter.get_node("add")
		var substract = counter.get_node("substract")
		var pointValue = counter.pointValue
		constantCounts.insert(i, 0)
		add.pressed.connect(_add_score.bind(counter, i, pointValue, constantCounts))
		substract.pressed.connect(_minus_score.bind(counter, i, pointValue, constantCounts))
		i += 1
	i = 0
	for button in get_node("autoToggles").get_children():
		var pointValue = button.pointValue
		button.pressed.connect(_toggle.bind(button, i, pointValue, autoToggles))
		autoToggles.insert(i, 0)
		i+=1
	i = 0
	for button in get_node("driveToggles").get_children():
		var pointValue = button.pointValue
		button.pressed.connect(_toggle.bind(button, i, pointValue, driveToggles))
		driveToggles.insert(i, 0)
		i+=1
	i = 0
	for button in get_node("constantToggles").get_children():
		var pointValue = button.pointValue
		button.pressed.connect(_toggle.bind(button, i, pointValue, constantToggles))
		constantToggles.insert(i,0)
		i+=1
	i = 0
	for dropdown in get_node("constantDropdowns").get_children():
		var pointValue = dropdown.pointValue
		score += pointValue[0]
		dropdown.item_selected.connect(_change_dropdown)
		constantDropdowns.insert(i,0)
		i+=1
	i = 0
	for dropdown in get_node("autoDropdowns").get_children():
		var pointValue = dropdown.pointValue
		score += pointValue[0]
		dropdown.item_selected.connect(_change_dropdown)
		autoDropdowns.insert(i,0)
		i+=1
	i = 0
	for dropdown in get_node("driveDropdowns").get_children():
		var pointValue = dropdown.pointValue
		score += pointValue[0]
		dropdown.item_selected.connect(_change_dropdown)
		driveDropdowns.insert(i,0)
		i+=1
	$personalScoreLabel.text = str(score)
	$"auto path".setup = false

func missingImportantInfo():
	teamNumber = $teamNumber.text
	matchNumber = $matchNumber.text
	if not teamNumber or not matchNumber:
		$missingInfo.visible = true
		return true

func update(): #shows the values stored in the match save in the main menu
	var i = 0
	for counter in get_node("driveCounters").get_children():
		var add = counter.get_node("add")
		var substract = counter.get_node("substract")
		var pointValue = counter.pointValue
		add.pressed.connect(_add_score.bind(counter, i, pointValue, driveCounts))
		substract.pressed.connect(_minus_score.bind(counter, i, pointValue, driveCounts))
		counter.text = str(driveCounts[i])
		i+=1
	i = 0
	for counter in get_node("autoCounters").get_children():
		var add = counter.get_node("add")
		var substract = counter.get_node("substract")
		var pointValue = counter.pointValue
		add.pressed.connect(_add_score.bind(counter, i, pointValue, autoCounts))
		substract.pressed.connect(_minus_score.bind(counter, i, pointValue, autoCounts))
		counter.text = str(autoCounts[i])
		i+=1
	i = 0
	for counter in get_node("constantCounters").get_children():
		var add = counter.get_node("add")
		var substract = counter.get_node("substract")
		var pointValue = counter.pointValue
		add.pressed.connect(_add_score.bind(counter, i, pointValue, constantCounts))
		substract.pressed.connect(_minus_score.bind(counter, i, pointValue, constantCounts))
		counter.text = str(constantCounts[i])
		i+=1
	i = 0
	for button in get_node("autoToggles").get_children():
		var pointValue = button.pointValue
		button.pressed.connect(_toggle.bind(button, i, pointValue, autoToggles))
		button.button_pressed = autoToggles[i]
		i+=1
	i = 0
	for button in get_node("driveToggles").get_children():
		var pointValue = button.pointValue
		button.pressed.connect(_toggle.bind(button, i, pointValue, driveToggles))
		button.button_pressed = driveToggles[i]
		i+=1
	i = 0
	for button in get_node("constantToggles").get_children():
		var pointValue = button.pointValue
		button.pressed.connect(_toggle.bind(button, i, pointValue, constantToggles))
		button.button_pressed = constantToggles[i]
		i+=1
	i = 0
	for dropdown in get_node("driveDropdowns").get_children():
		dropdown.item_selected.connect(_change_dropdown)
		dropdown.selected = driveDropdowns[i]
		i+=1
	i = 0
	for dropdown in get_node("autoDropdowns").get_children():
		dropdown.item_selected.connect(_change_dropdown)
		dropdown.selected = autoDropdowns[i]
		i+=1
	i = 0
	for dropdown in get_node("constantDropdowns").get_children():
		dropdown.item_selected.connect(_change_dropdown)
		dropdown.selected = constantDropdowns[i]
		i+=1
	
	$teamNumber.text = teamNumber
	$matchNumber.text = matchNumber
	$personalScoreLabel.text = str(score)
	$finalScore.text = str(finalScore)
	$outlier.button_pressed = outlier
	$comment.text = comment
	$"auto path".result = auto_path
	$"auto path".updateNumbers()
	$"auto path".setup = false
	

func _add_score(button, index, value, countList):
	countList[index] += 1
	button.text = str(countList[index])
	score += value
	$personalScoreLabel.text = str(score)
	saved = false
	

#when the minus sign is clicked, updates the score and the counter
func _minus_score(button, index, value, countList): 
	countList[index] -= 1
	button.text = str(countList[index])
	score -= value
	$personalScoreLabel.text = str(score)
	saved = false


func _on_auto_pressed():
	$autoCounters.visible = true
	$driveCounters.visible = false
	$autoToggles.visible = true
	$driveToggles.visible = false
	$autoDropdowns.visible = true
	$driveDropdowns.visible = false
	$"auto path".visible = true



func _on_drive_pressed():
	$autoCounters.visible = false
	$driveCounters.visible = true
	$autoToggles.visible = false
	$driveToggles.visible = true
	$autoDropdowns.visible = false
	$driveDropdowns.visible = true
	$"auto path".visible = false

func _toggle(button, index, pointValue, list):
	list[index] = button.button_pressed
	if button.button_pressed:
		score += pointValue
	else:
		score -= pointValue
	$personalScoreLabel.text = str(score)
	saved = false

func _change_dropdown(index):
	var i = 0 
	for dropdown in get_node("constantDropdowns").get_children():
		score -= dropdown.pointValue[constantDropdowns[i]]
		score += dropdown.pointValue[dropdown.selected]
		constantDropdowns[i] = dropdown.selected
		i+=1
	i = 0 
	for dropdown in get_node("autoDropdowns").get_children():
		score -= dropdown.pointValue[autoDropdowns[i]]
		score += dropdown.pointValue[dropdown.selected]
		autoDropdowns[i] = dropdown.selected
		i+=1
	i = 0 
	for dropdown in get_node("driveDropdowns").get_children():
		score -= dropdown.pointValue[driveDropdowns[i]]
		score += dropdown.pointValue[dropdown.selected]
		driveDropdowns[i] = dropdown.selected
		i+=1
	$personalScoreLabel.text = str(score)
	saved = false

func _on_outlier_pressed():
	outlier = $outlier.button_pressed
	saved = false


func _on_comment_text_changed(new_text):
	comment = new_text
	saved = false
	pass # Replace with function body.

func _on_generate_qr_code_pressed():
	$Popup.visible = true
	
	generateQRCode()
	
	

func generateQRCode():
	contents = "team:" + $teamNumber.text + "*match:" + $matchNumber.text + "*personal_score:" + str(score) + "*total_score:" + $finalScore.text + "*outlier:" + str(int($outlier.button_pressed)) + "*comment:" + comment + "*auto path:" + str($"auto path".result)
	
	var i = 0 
	for objectNumber in autoCounts:
		contents += "*" + $autoCounters.get_children()[i].objectName + ":" + str(objectNumber)
		i += 1
	
	i = 0
	for objectNumber in driveCounts:
		contents += "*" + $driveCounters.get_children()[i].objectName + ":" + str(objectNumber)
		i += 1
	
	i = 0
	for objectNumber in constantCounts:
		contents += "*" + $constantCounters.get_children()[i].objectName + ":" + str(objectNumber)
		i += 0
		
	i = 0
	for toggled in autoToggles:
		contents += "*" + $autoToggles.get_children()[i].objectName + ":" + str(int(toggled))
		i += 1
	
	i = 0
	for toggled in driveToggles:
		contents += "*" + $driveToggles.get_children()[i].objectName + ":" + str(int(toggled))
		i += 1
		
	i = 0
	for toggled in constantToggles:
		contents += "*" + $constantToggles.get_children()[i].objectName + ":" + str(int(toggled))
		i += 1
		
	i = 0
	for selected in autoDropdowns:
		contents += "*" + $autoDropdowns.get_children()[i].objectName + ":" + str(selected)
		i += 1
		
	i = 0
	for selected in driveDropdowns:
		contents += "*" + $driveDropdowns.get_children()[i].objectName + ":" + str(selected)
		i += 1
	
	i = 0
	for selected in constantDropdowns:
		contents += "*" + $constantDropdowns.get_children()[i].objectName + ":" + str(selected)
		i += 1
	
	var qr_code: QrCode = QrCode.new()
	qr_code.error_correct_level = 0
	texture = qr_code.get_texture(contents)

	qr_code_image.texture = texture
	qr_code_image.move_to_front()
	

func _on_window_close_requested():
	popup.hide()

func _on_close_pressed():
	$Popup.visible = false

func _on_home_pressed():
	if saved == true:
		queue_free()
	else:
		$homeUnsavedMessage.visible = true

func _on_save_pressed():
	if not missingImportantInfo():
		$saving.visible = true
		teamNumber = $teamNumber.text
		matchNumber = $matchNumber.text
		finalScore = $finalScore.text
		auto_path = $"auto path".result
		print(auto_path)
		generateQRCode()
		save.emit(inHomeScreen)
		inHomeScreen = true
		saved = true
		queue_free()

func _on_save_then_home_pressed():
	if not missingImportantInfo():
		_on_save_pressed()
		queue_free()
	else:
		$homeUnsavedMessage.visible = false
		$missingInfo.visible = true

func _on_go_home_without_saving_pressed():
	queue_free()


func _on_close_missing_info_warning():
	$missingInfo.visible = false

