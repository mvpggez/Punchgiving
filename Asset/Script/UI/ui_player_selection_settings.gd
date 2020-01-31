#########################################################
# Copyright (C) 2019-2020 MVP Good Games Easy UG (haftungsbeschränkt) - All Rights Reserved
# E-Mail: info@mvpggez.com
# 
# This file is part of the game "Punchgiving".
# Full source code is available at https://github.com/mvpggez/PunchGiving
#########################################################

extends TextureRect

signal controlled_by_checkbox_changed(human_player_enabled)

export (NodePath) var player_checkbox
export (NodePath) var ai_checkbox

var controlled_by = "ai"

func _on_Player_CheckBox_toggled(button_pressed):
	if button_pressed:
		controlled_by = "human"
		emit_signal("controlled_by_checkbox_changed", true)
		get_node(ai_checkbox).pressed = false
	else:
		controlled_by = "ai"
		emit_signal("controlled_by_checkbox_changed", false)
		get_node(ai_checkbox).pressed = true

func _on_AI_CheckBox_toggled(button_pressed):
	if button_pressed:
		controlled_by = "ai"
		emit_signal("controlled_by_checkbox_changed", false)
		get_node(player_checkbox).pressed = false
	else:
		controlled_by = "human"
		emit_signal("controlled_by_checkbox_changed", true)
		get_node(player_checkbox).pressed = true