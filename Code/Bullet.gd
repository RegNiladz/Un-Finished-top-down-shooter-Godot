extends RigidBody2D
func _ready():
	pass
func NoBullets():
	queue_free()




func _on_Area2D_body_entered(body):
	if "Zombie" in body.name:
		queue_free()
	if "ExplodingCrates" in body.name:
		$QueTim.start()
		

func _on_QueTim_timeout():
	
	queue_free()

func _on_quick_timeout():
	$BulletSprite.visible = false
	$BulletCollision.disabled = true
	queue_free()
