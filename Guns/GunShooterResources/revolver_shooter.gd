extends Resource

@export var recoil: float = 6
@export var firerate: float = 0.5

var bullet_scene: PackedScene = load("res://Guns/Bullets/player_bullet.tscn")

func shoot() -> Array[Bullet]:
	var bullets: Array[Bullet]
	var bullet = bullet_scene.instantiate()
	
	bullets.append(bullet)
	return bullets

func type():
	return "revolver"
