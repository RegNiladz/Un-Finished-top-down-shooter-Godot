extends Node
var amp = 0
var priority = 0
const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT
onready var camera = get_parent()
func start(duration = 0.2, frequency = 15, amp = 16):
	if priority >= self.priority:
		self.priority
		self.amp = amp
		$Duration.wait_time = duration
		$ShakeTime.wait_time = 1 / float (frequency)
		$Duration.start()
		$ScreenShake.start()
		ScreenShake()


func ScreenShake(): 
	var rand = Vector2()
	rand.x = rand_range(-amp, amp) #Random Shaking Horizontal
	rand.y = rand_range(-amp, amp) #Random Shaking Vertical
	$ScreenShake.interpolate_property(camera,"offset",camera.offset, rand, $ShakeTime.wait_time, TRANS, EASE)
	$ScreenShake.start()

func ShakeReset():
	$ScreenShake.interpolate_property(camera,"offset",camera.offset,Vector2(), $ShakeTime.wait_time, TRANS, EASE)
	$ScreenShake.start()
	priority = 0
func _on_ShakeTime_timeout():
	ScreenShake()


func _on_Duration_timeout():
	ShakeReset()
	$Duration.stop()
