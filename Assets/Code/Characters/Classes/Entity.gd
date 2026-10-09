class_name Entity
extends CharacterBody2D

@export var health:int

func heal(points:int):
	health += points
