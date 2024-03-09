extends Panel

signal openQR(texture)
signal select(selectedInstance)
signal close(selectedInstance)

var teamNumber
var matchNumber
var personalScore = 0
var totalScore = 0 
var driveCounts = []
var autoCounts = []
var constantCounts = []
var driveToggles = []
var autoToggles = []
var constantToggles = []
var driveDropdowns = []
var autoDropdowns = []
var constantDropdowns = []
var contents = ""
var outlier = false
var comment = ""

var qrCodeTexture:Texture 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update():
	$teamNum.text = str(teamNumber)
	$matchNum.text = str(matchNumber)
	$personalScore.text = str(personalScore)
	$totalScore.text = str(totalScore)
	$qr.texture_normal = qrCodeTexture


func _on_qr_pressed():
	openQR.emit(qrCodeTexture)


func _on_open_pressed():
	select.emit(self)


func _on_close_pressed():
	close.emit(self)
