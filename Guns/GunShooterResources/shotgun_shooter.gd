extends Resource

@export var recoil: float = 15
@export var firerate: float = 0.8

const bullet_lifetime: float = 0.1

var bullet_scene: PackedScene = load("res://Guns/Bullets/player_bullet.tscn")

func shoot() -> Array[Bullet]:
	var bullets: Array[Bullet]
	
	var bullet1 = bullet_scene.instantiate() as Bullet
	var bullet2 = bullet_scene.instantiate() as Bullet
	var bullet3 = bullet_scene.instantiate() as Bullet
	
	bullet1.rotation -= 0.15
	bullet2.rotation += 0.15
	
	bullets.append(bullet1)
	bullets.append(bullet2)
	bullets.append(bullet3)
	
	return bullets
