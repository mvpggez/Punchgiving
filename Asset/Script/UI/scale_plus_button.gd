#########################################################
# Copyright (C) 2019-2020 MVP Good Games Easy UG (haftungsbeschränkt) - All Rights Reserved
# E-Mail: info@mvpggez.com
# 
# This file is part of the game "Punchgiving".
# Full source code is available at https://github.com/mvpggez/PunchGiving
#########################################################

extends TextureButton

var new_pivot

func _ready():
	connect("mouse_entered", self, "_on_TextureButton_mouse_entered")
	connect("mouse_exited", self, "_on_TextureButton_mouse_exited")
	connect("button_up", self, "_on_button_up")
	pass



func _on_TextureButton_mouse_entered():
	set_scale(Vector2(1.1,1.1))


func _on_TextureButton_mouse_exited():
	set_scale(Vector2(1.0,1.0))


func _on_button_up():
	set_scale(Vector2(1.0,1.0))