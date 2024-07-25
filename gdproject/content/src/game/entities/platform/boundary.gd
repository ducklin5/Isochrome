extends RigidBody2D

func enable():
	collision_layer = 4
	collision_mask = 4

func disable():
	collision_layer = 0
	collision_mask = 0
