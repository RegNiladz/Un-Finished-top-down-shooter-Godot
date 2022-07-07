#https://godotforums.org/d/24294-adding-knockback-to-my-top-down-game/2
extends KinematicBody2D
var velocity = Vector2()
var MovementSpeed = 200
var ZombieHealth = 100
var bulletDamage = 10
var ExplodeDamage = 50
var Damage = 10
var Bullet = preload("res://Bullet.tscn")
var stun = false
func _physics_process(delta):
	var player = get_parent().get_node("Player")
	if stun == false:
		position += (player.position - position)/200
		look_at(player.position)
		move_and_collide(velocity)
		velocity = lerp(velocity, Vector2(0,0),0.3)
		_ready()


# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color("ffffff")
	$ZombieHitLight.visible = false
	#$Blood2.visible = false
	MovementSpeed = 200
	print(ZombieHealth)
	if ZombieHealth == 0:
		ZomDeath()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ZomAreaHitbox_body_entered(body):
	if "Player" in body.name:
		Attack()
	elif "Bullet" in body.name:
		stun = true
		$StunTime.start()
	elif "ExplosionRadius" in body.name:
		$StunTime.start()


func _on_StunTime_timeout():
	modulate = Color("f9133e")
	$ZombieHitLight.visible = true
	MovementSpeed = 5000
	$Blood2.visible = true
	$Blood2.play("BloodSplat")
	$Blood.play()
	TakingDamage()
	Global.camera.shake(0.1,5)
	velocity = - velocity * 4
	stun = false
	yield($Blood2,"animation_finished")
	$Blood2.visible = false
	
	 #(time of shake, shake value)

func TakingDamage():
	ZombieHealth -= Damage

func ZomDeath():
	$ZomSprite.play("Death")
	$Blood2.visible = true
	$Blood2.play("BloodSplat")
	$Headshot.play()
	MovementSpeed = 5000
	yield($ZomSprite, "animation_finished")
	queue_free()
func VanishBullet():
	var bulletinstance = Bullet.instance()
	bulletinstance.queue_free()

func Attack():
	$ZomSprite.play("Attack")
	yield($ZomSprite,"animation_finished")
	$ZomSprite.play("run")

func ExplodeDamage():
	$StunTime.start()
	Damage = 50
