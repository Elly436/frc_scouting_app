extends Control

const save_path = "user://save_data.save"
var scoreScreensInfo = {}
var currentScoreType = ""
var savedItems = []

@onready var save_resource = saveInfo.new()

@onready var gameCreator = preload("res://gameCreator.tscn")
@onready var saveTemplate = preload("res://homeSavedItem.tscn")
@onready var gameLoader = preload("res://game_loader.tscn")
@onready var popup = $Popups/Popup
var score_screenInstance
var selected
var scoreScreenSharedName


# Called when the node enters the scene tree for the first time.
func _ready():
	loadData()
	#verify_save_directory(save_file_path)
	_updateMatchTypes()
	pass # Replace with function body.


func _exit_tree(): #called when a screen is closed
	save()
	pass

func verify_save_directory(path):
	DirAccess.make_dir_absolute(path)
	
	
func loadSaves(items):
	for save in items:
		var saveInstance = saveTemplate.instantiate()
		$ScrollContainer/GridContainer.add_child(saveInstance)
		selected = saveInstance
		saveInstance.teamNumber = save[0]
		saveInstance.matchNumber = save[1]
		saveInstance.personalScore = save[2]
		saveInstance.totalScore = save[3]
		saveInstance.driveCounts = save[4]
		saveInstance.autoCounts = save[5]
		saveInstance.constantCounts = save[6]
		saveInstance.driveToggles = save[7]
		saveInstance.autoToggles = save[8]
		saveInstance.constantToggles = save[9]
		saveInstance.autoDropdowns = save[10]
		saveInstance.driveDropdowns = save[11]
		saveInstance.constantDropdowns = save[12]
		saveInstance.contents = save[13]
		saveInstance.outlier = save[14]
		saveInstance.auto_path = save[15]
		saveInstance.comment = save[16]
		if len(save) >= 18:
			saveInstance.get_node("check").button_pressed = save[17]
		var qr_code: QrCode = QrCode.new()
		qr_code.error_correct_level = 0
		var texture = qr_code.get_texture(saveInstance.contents)
		saveInstance.qrCodeTexture = texture
		saveInstance.update()
		saveInstance.openQR.connect(_on_open_QR)
		saveInstance.select.connect(_on_switch_selected)
		saveInstance.close.connect(_on_delete_save)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func newScoringInstance():
	score_screenInstance = gameLoader.instantiate()
	self.add_child(score_screenInstance)
	score_screenInstance.save.connect(_on_save)
	score_screenInstance.teamNumber = selected.teamNumber
	score_screenInstance.matchNumber = selected.matchNumber
	score_screenInstance.score = selected.personalScore
	score_screenInstance.finalScore = selected.totalScore
	score_screenInstance.driveCounts = selected.driveCounts
	score_screenInstance.autoCounts = selected.autoCounts
	score_screenInstance.constantCounts = selected.constantCounts
	score_screenInstance.driveToggles = selected.driveToggles
	score_screenInstance.autoToggles = selected.autoToggles
	score_screenInstance.constantToggles = selected.constantToggles
	score_screenInstance.autoDropdowns = selected.autoDropdowns
	score_screenInstance.driveDropdowns = selected.driveDropdowns
	score_screenInstance.constantDropdowns = selected.constantDropdowns
	score_screenInstance.contents = selected.contents
	score_screenInstance.outlier = selected.outlier
	score_screenInstance.auto_path = selected.auto_path
	score_screenInstance.comment = selected.comment
	score_screenInstance.inHomeScreen = true
	score_screenInstance.texture = selected.qrCodeTexture
	score_screenInstance.update()
	score_screenInstance.showButtons()
	save()
	

func _on_create_pressed():
	if $OptionButton.get_item_text($OptionButton.selected) != "":
		score_screenInstance = gameLoader.instantiate()
		self.add_child(score_screenInstance)
		score_screenInstance.save.connect(_on_save)
		score_screenInstance.showButtons()
		score_screenInstance.init()
	else:
		$Popups/missingMatchType.visible = true

	
func _on_switch_selected(selectedInstance):
	selected = selectedInstance
	newScoringInstance()
	
func _on_delete_save(selectedInstance):
	selected = selectedInstance
	$Popups/deleteMessage.visible = true

func _on_save(inHomeScreen):
	var saveInstance
	if inHomeScreen:
		saveInstance = selected
	else:
		saveInstance = saveTemplate.instantiate()
		$ScrollContainer/GridContainer.add_child(saveInstance)
		selected = saveInstance
	saveInstance.teamNumber = score_screenInstance.teamNumber
	saveInstance.matchNumber = score_screenInstance.matchNumber
	saveInstance.personalScore = score_screenInstance.score
	saveInstance.totalScore = score_screenInstance.finalScore
	saveInstance.driveCounts = score_screenInstance.driveCounts
	saveInstance.autoCounts = score_screenInstance.autoCounts
	saveInstance.constantCounts = score_screenInstance.constantCounts
	saveInstance.driveToggles = score_screenInstance.driveToggles
	saveInstance.autoToggles = score_screenInstance.autoToggles
	saveInstance.constantToggles = score_screenInstance.constantToggles
	saveInstance.autoDropdowns = score_screenInstance.autoDropdowns
	saveInstance.driveDropdowns = score_screenInstance.driveDropdowns
	saveInstance.constantDropdowns = score_screenInstance.constantDropdowns
	saveInstance.contents = score_screenInstance.contents
	saveInstance.outlier = score_screenInstance.outlier
	saveInstance.auto_path = score_screenInstance.auto_path
	saveInstance.comment = score_screenInstance.comment
	saveInstance.qrCodeTexture = score_screenInstance.texture
	saveInstance.update()
	saveInstance.openQR.connect(_on_open_QR)
	saveInstance.select.connect(_on_switch_selected)
	saveInstance.close.connect(_on_delete_save)
	saveInstance.get_node("check").button_pressed = false
	save()
	

func _on_open_QR(selectedInstance):
	popup.visible = true
	var texture = selectedInstance.get_node("qr").texture_normal
	selected = selectedInstance
	popup.get_node("QRCode").texture = texture
	popup.get_node("check").button_pressed = selected.get_node("check").button_pressed
	if $ScrollContainer/GridContainer.get_children().find(selected) <= 0:
		$Popups/Popup/last.visible = false
	else:
		$Popups/Popup/last.visible = true
		
	if $ScrollContainer/GridContainer.get_children().find(selected) >= len($ScrollContainer/GridContainer.get_children())-1:
		$Popups/Popup/next.visible = false
	else:
		$Popups/Popup/next.visible = true

func _on_close_pressed():
	popup.visible = false
	selected.get_node("check").button_pressed = popup.get_node("check").button_pressed


func _on_delete_save_pressed():
	selected.queue_free()
	$Popups/deleteMessage.visible = false


func _on_cancel_pressed():
	$Popups/deleteMessage.visible = false
	$Popups/missingMatchType.visible = false


func _on_option_button_item_selected(index):
	if $OptionButton.get_item_text(index) == "new match type":
		Global.currentScoreType = ""
		var gameCreatorInstance = gameCreator.instantiate()
		add_child(gameCreatorInstance)
		gameCreatorInstance.updateMatchTypes.connect(_updateMatchTypes)
	elif $OptionButton.get_item_text(index) == "shared match type":
		_on_get_shared_button_down()
		_updateMatchTypes()
	else:
		Global.currentScoreType = $OptionButton.get_item_text(index)
		#$shareButton.visible = true
		
func _updateMatchTypes():
	$OptionButton.clear()
	$OptionButton.add_item("new match type", 0)
	#$OptionButton.add_item("shared match type", 1)

	for matchType in Global.scoreScreensInfo.keys():
		$OptionButton.add_item(matchType)
	$OptionButton.selected = $OptionButton.item_count -1
	if $OptionButton.get_item_text($OptionButton.selected) != "new match type" and $OptionButton.get_item_text($OptionButton.selected) != "shared match type":
		Global.currentScoreType = $OptionButton.get_item_text($OptionButton.selected)
	else:
		$OptionButton.selected = -1
	save()
	print(Global.scoreScreensInfo)


func _on_create_new_match_type_pressed():
	Global.currentScoreType = ""
	var gameCreatorInstance = gameCreator.instantiate()
	add_child(gameCreatorInstance)
	gameCreatorInstance.updateMatchTypes.connect(_updateMatchTypes)
	$Popups/missingMatchType.visible = false
	
func _on_reset_button_pressed():
	$Popups/resetMessage.visible = true

func _on_get_shared_button_down():
	
	pass # Replace with function body.


func _on_download_pressed():
	
	_updateMatchTypes()
	$Popups/foundShare.visible = false
	$OptionButton.selected = $OptionButton.item_count-1
	pass # Replace with function body.

func _on_stop_sharing_pressed():
	$Popups/sharing.visible = false
	pass # Replace with function body.

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	#save_resource.savedItems = []
	savedItems = []
	for save in $ScrollContainer/GridContainer.get_children():
		var saveInfo = [save.teamNumber, save.matchNumber, save.personalScore, save.totalScore, 
		save.driveCounts, save.autoCounts, save.constantCounts, save.driveToggles, save.autoToggles,
		save.constantToggles, save.autoDropdowns, save.driveDropdowns, save.constantDropdowns, 
		save.contents, save.outlier, save.auto_path, save.comment, save.get_node("check").button_pressed]
		#save_resource.savedItems.append(saveInfo)
		savedItems.append(saveInfo)
	#save_resource.scoreScreensInfo = Global.scoreScreensInfo
	#save_resource.currentScoreType = Global.currentScoreType
	scoreScreensInfo = Global.scoreScreensInfo
	currentScoreType = Global.currentScoreType
	file.store_var(scoreScreensInfo)
	file.store_var(currentScoreType)
	file.store_var(savedItems)
	
func loadData():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		Global.scoreScreensInfo = file.get_var()
		Global.scoreScreensInfo["idaho"] = [[], [[Vector2(-46.16669, 25), "auto amp", 2], [Vector2(156.8333, 24), "auto speaker", 5]], [[Vector2(-34.16669, -188), "teleop amp", 1], [Vector2(-167.1667, -293), "speaker no boost", 2], [Vector2(89.83331, -294), "speaker boosted", 5], [Vector2(-34.16669, -97), "trap", 5]], [], [[Vector2(-248.6667, 12), "leave", 2]], [], [[Vector2(-82.83316, 152), "pickup", [0, 0], ["ground", "operator"]]], [[Vector2(-250, 152), "start position", [0, 0, 0], ["left", "middle", "right"]]], [[Vector2(-276.3332, 49), "end position", [0, 1, 3, 4], ["none", "park", "onstage no boost", "onstage boosted"]], [Vector2(19.66669, 47), "harmony", [0, 2, 4], ["none", "2 robots", "3 robot"]]]]
		Global.scoreScreensInfo["test_2"] = [[], [], [[Vector2(-150.1667, -273), "dskd", 3]], [], [[Vector2(-209.6667, 53), "dcsnl", 3]], [], [], [], [[Vector2(53.66669, -266), "hullo", [2, 3, 4], ["csdd", "rfwq", "dskl"]]]]
		Global.currentScoreType = file.get_var()
		loadSaves(file.get_var())
		_updateMatchTypes()
	else:
		print("no data saved")
		Global.scoreScreensInfo["test_2"] = [[], [], [[Vector2(-150.1667, -273), "dskd", 3]], [], [[Vector2(-209.6667, 53), "dcsnl", 3]], [], [], [], [[Vector2(53.66669, -266), "hullo", [2, 3, 4], ["csdd", "rfwq", "dskl"]]]]


func _on_save_pressed():
	save()
	pass # Replace with function body.


func _on_load_pressed():
	loadData()
	pass # Replace with function body.


func _on_delete_all_pressed():
	$Popups/resetMessage.visible = false
	$Popups/deleting.visible = true
	for savedMatch in $ScrollContainer/GridContainer.get_children():
		savedMatch.queue_free()
	$Popups/deleting.visible = false
	save()
	pass # Replace with function body.


func _on_cancel_reset_pressed():
	$Popups/resetMessage.visible = false
	pass # Replace with function body.


func _on_delete_template_pressed():
	$Popups/deleteMessage2.visible = true
	pass # Replace with function body.


func _on_delete_template_popup_button_pressed():
	Global.scoreScreensInfo.erase(Global.currentScoreType)
	Global.currentScoreType = ""
	$Popups/deleteMessage2.visible = false
	_updateMatchTypes()
	pass # Replace with function body.
	

func _on_cancel_template_deleting_pressed():
	$Popups/deleteMessage2.visible = false
	pass # Replace with function body.


func _on_last_QR_pressed():
	selected.get_node("check").button_pressed = popup.get_node("check").button_pressed
	var last_index = $ScrollContainer/GridContainer.get_children().find(selected) - 1
	selected = $ScrollContainer/GridContainer.get_children()[last_index]
	_on_open_QR(selected)
	if last_index <= 0:
		$Popups/Popup/last.visible = false
	else:
		$Popups/Popup/last.visible = true
	pass # Replace with function body.


func _on_next_QR_pressed():
	selected.get_node("check").button_pressed = popup.get_node("check").button_pressed
	var next_index = $ScrollContainer/GridContainer.get_children().find(selected) + 1
	selected = $ScrollContainer/GridContainer.get_children()[next_index]
	_on_open_QR(selected)
	if next_index >= len($ScrollContainer/GridContainer.get_children())-1:
		$Popups/Popup/next.visible = false
	else:
		$Popups/Popup/next.visible = true
	pass # Replace with function body.
