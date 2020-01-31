#########################################################
# Copyright (C) 2019-2020 MVP Good Games Easy UG (haftungsbeschränkt) - All Rights Reserved
# E-Mail: info@mvpggez.com
# 
# This file is part of the game "Punchgiving".
# Full source code is available at https://github.com/mvpggez/PunchGiving
#########################################################

extends RigidBody

class_name Collectable

var collectable = true #used for identification
var collected = false

var countdown = 0

func _ready():
	add_to_group("points_of_interest")
	add_to_group("collectable")
	set_collision_layer(4)
	set_collision_mask(1+4)
	randomize()
	angular_velocity = Vector3(randf()*2-1,randf()*2-1,randf()*2-1)
	randomize_colors()
	can_sleep = false
	
var time = 0.0
func _physics_process(delta):
	time += delta
	if countdown > 0:
		countdown -= delta
		if countdown < 0:
			countdown = 0
		visible = fmod(time, 0.25)>0.125
	else:
		visible = true

func randomize_colors():
	pass
	
func collected_by(character):
	if not collected and not character.stunned and countdown == 0:
		character.add_score()
		collected = true
		queue_free()