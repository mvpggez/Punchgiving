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
##	new_pivot = Vector2(rect_size.x, sqrt(2) * rect_size.y*0.5)
#	new_pivot = Vector2(sqrt(2) * rect_size.y*0.5, sqrt(2) * rect_size.y*0.5)
#	set_pivot_offset(new_pivot)
#	print(new_pivot)
	pass



func _on_TextureButton_mouse_entered():
	set_scale(Vector2(1.1,1.1))


func _on_TextureButton_mouse_exited():
	set_scale(Vector2(1.0,1.0))