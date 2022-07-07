extends Camera2D
var shakeAmmount = 0
var defaultOffSet = offset
onready var tween = $Tween
onready var timer = $CameraTimer
func _ready():
	set_process(false)
	Global.camera = self
	randomize()
	

func _process(delta):
	offset = Vector2(rand_range(-1,1) * shakeAmmount, rand_range(-1,1) * shakeAmmount)
	
func shake(time,amount):
	timer.wait_time = time
	shakeAmmount = amount
	set_process(true)
	timer.start()

func _on_CameraTimer_timeout():
	set_process(false)
	tween.interpolate_property(self,"offset", offset, defaultOffSet, 0.1, 6, 2)
	tween.start()
