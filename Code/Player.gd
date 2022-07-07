extends KinematicBody2D
var movementSpeed = 500
var bulletSpeed = 10000
const bullet = preload("res://Bullet.tscn")
var BulletAmmo = 8
var Empty = 0
var TrickAmmoCount = 7
var firingAmount = 1
var Duration = 0.10
var CamFrequency = 2.5
onready var muzzleFlash = $MuzzleFlash
func _ready():
	Global.player = self

func _exit_tree():
	Global.player = null


func _physics_process(delta):
	var vel = Vector2() #Velocity
	if Input.is_action_pressed("up"): #Upper Movment
		vel.y -=1
	elif Input.is_action_pressed("down"): #Downward Movement
		vel.y +=1
	elif Input.is_action_pressed("right"): #Right Movement
		vel.x += 1
	elif Input.is_action_pressed("left"): #LeftMovement
		vel.x -=1
	elif Input.is_action_just_pressed("reload"): #Reload
		reloadAnimationSound()
		CamShakeReset()
		print(BulletAmmo)
	vel = vel.normalized()
	vel = move_and_slide(vel * movementSpeed)
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("fire"): #Firing
		fire() 
		print(BulletAmmo)
		TrickAmmoCount -=1
		if TrickAmmoCount == 0:
			$HUD/Panel/Ammo.text = String("0")
			
	if Input.is_action_just_released("fire"):
		$MuzzleFlash.visible = false
		$MuzzleBack.visible = false
	$HUD/Panel/Ammo.text = String(BulletAmmo)





	
func fire():
	var bullet_instance = bullet.instance()
	#var target = get_global_mouse_position()
	#var directionMouse = bullet_instance.global_position.direction_to(target).normalized()
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.global_position = get_node("AimingPosition").get_global_position()
	bullet_instance.apply_impulse(Vector2(),Vector2(bulletSpeed,0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child",bullet_instance)
	FiringSoundAnimation()
	BulletAmmo -= 1
	
	$GlockSound.play()
	$MuzzleFlash.visible = true
	$MuzzleBack.visible = true
	Global.camera.shake(Duration,CamFrequency)
	if BulletAmmo < 1:
		print("No More Bullets")
		bullet_instance.NoBullets()
		NoBulletsAnimationSound()
		BulletAmmo = 0
		firingAmount = 0
		$MuzzleFlash.visible = false
		$MuzzleBack.visible = false
		$GlockSound.stop()
		Duration = 0 
		CamFrequency = 0

	

func CamShakeReset():
	Duration = 0.10
	CamFrequency = 2.5
#Reload Animation
func reloadAnimationSound():
	$GlockReload.play()
	$PlayerSprite.play("reload")
	yield($PlayerSprite,"animation_finished")
	BulletAmmo =+ 8
	$HUD/Panel/Ammo.text = String(BulletAmmo)
	$PlayerSprite.play("idle")
#Reload Animation

#Firing Animation And Sound
func FiringSoundAnimation():
	$PlayerSprite.play("shoot")
	yield($PlayerSprite,"animation_finished")
	$PlayerSprite.play("idle")
#Firing Animation And Sound

#Empty Bullet Function
func NoBulletsAnimationSound():
	$PlayerSprite.play("idle")
	$Empty.play()
#Empty Bullet Function

func kill():
	get_tree().reload_current_scene()


func _on_PlayerArea_body_entered(body):
	if "Zombie" in body.name:
		print("Taking Damage")
		$HUD/Panel/BloodScreenTimer.start()
		


func _on_BloodScreenTimer_timeout():
	$HUD/Panel/BloodScreenTimer/BloodSprite.visible = true
	$HUD/Panel/BloodScreenTimer/PlayerHurt.play()
	$HUD/Panel/BloodScreenTimer/BloodFadeAnimation.play("BloodFade")
	var timer
	var sprite
	var t = rand_range(1,2) #(Timer,Range)
	yield(get_tree().create_timer(t),"timeout")
	$HUD/Panel/BloodScreenTimer/BloodLight.visible = false
	
	
func ExplosionDamage():
	print("Explosion Damage")
