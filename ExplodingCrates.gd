extends KinematicBody2D
var timer
var sprite
const Player = preload("res://Player.tscn")
const Zombie = preload("res://Zombie.tscn")

func _physics_process(delta):
	pass




func _ready():
	pass # Replace with function body.




func _on_CrateHitbox_body_entered(body):
	if "Bullet" in body.name:
		$CrateAnSprite.play("Warning")
		$CrateSprite.visible = false
		$CrateHitSound.play()
	#Exploding Timer
		yield($CrateAnSprite,"animation_finished")
		
		$CrateWall.disabled = true
		$CrateHitbox/ExplosionRange.disabled = true
	#Exploding Timer
		yield($CrateAnSprite,"animation_finished")
		Global.camera.shake(1,10)
		$ExplodingSound.play()
		$CrateAnSprite.play("Explode")
		$Radius/ExplosionRadius.disabled = false
		$CrateHitbox/ExplosionRange.disabled = true
		$Light2D.visible = true
		$Shadow.visible = false
		yield($CrateAnSprite,"animation_finished")
		$CrateAnSprite.visible = false
		
		yield($CrateAnSprite,"animation_finished")
		$Light2D.visible = false
		$ExplosionTime.start()
		


func _on_ExplosionTime_timeout():
	$CrateAnSprite.play("Crater")
	$FadeOutLight/FadeLight.visible = true
	$FadeOutLight.play("Fadeout")
	yield($ExplodingSound,"finished")
	$FadeOutLight.play("Fadeout")
	queue_free()

func _on_Radius_body_entered(body):
	var player_instance = Player.instance()
	player_instance.ExplosionDamage()
	if "Zombie" in body.name:
		var zom_instance = Zombie.instance()
		zom_instance.ExplodeDamage()
	$Radius.visible = false
	
	

