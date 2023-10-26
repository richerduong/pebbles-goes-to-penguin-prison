extends Node

class_name Inventory

class Gun:
	var __gun_scene: String
	var __ammo: int
	
	func _init(gun_scene: String, ammo: int):
		__gun_scene = gun_scene
		__ammo = ammo

var __max_guns: int
var __inventory: Array

func _init(max_guns: int):
	__max_guns = max_guns

func add_gun(gun_scene: String, ammo: int = 15) -> bool:
	if __inventory.size() == __max_guns:
		return false
	var gun = Gun.new(gun_scene, ammo)
	__inventory.append(gun)
	return true

func get_gun(index: int) -> Gun:
	if index < 0 or index > __inventory.size() - 1:
		push_error()
	return __inventory[index]
