extends Resource

@export var recoil: float = 15
@export var firerate: float = 0.8

var bullet_scene: PackedScene = load("res://Guns/Bullets/player_bullet.tscn")

func shoot() -> Array[Bullet]:
	var bullets: Array[Bullet]
	
	var bullet1 = bullet_scene.instantiate()
	var bullet2 = bullet_scene.instantiate()
	var bullet3 = bullet_scene.instantiate()
	
	bullet1.rotation -= 0.15
	bullet2.rotation += 0.15
	
	bullets.append(bullet1)
	bullets.append(bullet2)
	bullets.append(bullet3)
	
	return bullets

func type():
	return "shotgun"
