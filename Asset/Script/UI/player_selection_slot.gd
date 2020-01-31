#########################################################
# Copyright (C) 2019-2020 MVP Good Games Easy UG (haftungsbeschränkt) - All Rights Reserved
# E-Mail: info@mvpggez.com
# 
# This file is part of the game "Punchgiving".
# Full source code is available at https://github.com/mvpggez/PunchGiving
#########################################################

extends TextureRect

signal added_player_count_changed(added_player_count)
signal human_player_added_with_controls(human_player_added,player_controls_assigned)

signal slot_status_update(slot_is_ready, slot_name, slot_removed)
var slot_removed = true
#var slot_name = self.name
var slot_name = get_instance_id()
var player_is_human = false
var slot_is_ready = false
var control_is_assigned = false



export (NodePath) var AssignControls

var added_player_count = 0
var added = false
export (int) var player_id = 1

func _ready():
	self.connect("input_assigned", self, "_on_input_assigned")
	get_node(AssignControls).visible = false
	pass


func add():
	if not added:
		get_node("player_selection_add_new_player").hide()
		added = true
		
		if added_player_count != 1:
			added_player_count = 1
			emit_signal("added_player_count_changed", added_player_count)

	slot_removed = false
	_update_slot_status()
	
func remove():
	if added:
		get_node("player_selection_add_new_player").show()
		added = false
		
		if added_player_count != 0:
			added_player_count = 0
			emit_signal("added_player_count_changed", added_player_count)
	
	slot_removed = true
	_update_slot_status()

var set_action = null

var action_jump
var action_left
var action_right
var action_attack
signal input_assigned
func on_assign_controls_button_pressed():
	$player_assign_controls.show()
	
	action_jump = "player_"+str(player_id)+"_jump"
	action_left = "player_"+str(player_id)+"_left"
	action_right = "player_"+str(player_id)+"_right"
	action_attack = "player_"+str(player_id)+"_attack"

	$player_assign_controls/Panel/VBoxContainer/Action.text  = "Press Key:\nJUMP"
	set_input_for_action("jump")
	yield(self, "input_assigned")
	
	$player_assign_controls/Panel/VBoxContainer/Action.text  = ("Press Key:\nLEFT")
	set_input_for_action("left")
	yield(self, "input_assigned")
	
	$player_assign_controls/Panel/VBoxContainer/Action.text  = ("Press Key:\nRIGHT")
	set_input_for_action("right")
	yield(self, "input_assigned")
	
	$player_assign_controls/Panel/VBoxContainer/Action.text  = ("Press Key:\nATTACK")
	set_input_for_action("attack")
	yield(self, "input_assigned")
	$player_assign_controls.hide()
	
	get_node("TextureButton/disabled").visible = false
	get_node("TextureButton/enabled").visible = true
	
	control_is_assigned = true
	_update_slot_status()

#This function expects a possible action as a parameter (jump, left, right, attack)
#The next input after calling this function will be assigned to that action
func set_input_for_action(action):
	if action in ["jump", "left", "right", "attack"]:
		set_action = action
		

func already_assigned(action, input_event):
	if InputMap.action_has_event(action_jump, input_event):
		if input_event is InputEventJoypadMotion:
			var event = InputMap.get_action_list(action)[0]
			print(event)
		else:
			return true
	return false

func assign_input_to_action(input_event):
	if already_assigned(action_jump, input_event):
		return
	elif already_assigned(action_left, input_event):
		return
	elif already_assigned(action_right, input_event):
		return
	elif already_assigned(action_attack, input_event):
		return
	
	InputMap.action_erase_events("player_"+str(player_id)+"_"+set_action)
	InputMap.action_add_event("player_"+str(player_id)+"_"+set_action, input_event)
	print(set_action, " assigned to ", input_event.as_text())
	set_action = null
	emit_signal("input_assigned")

func _input(event):
	if set_action:
		if (event is InputEventKey or event is InputEventJoypadButton) and event.pressed:
			assign_input_to_action(event)
		elif event is InputEventJoypadMotion and abs(event.axis_value) > 0.9:
			assign_input_to_action(event)
			

func GetPlayerName():
	return $Player_Name/LineEdit.text

func get_beard():
	return $VBoxContainer2.get_beard()

func get_control():
	return $TextureRect.controlled_by
	
func _on_remove_Button_pressed():
	remove()

func _on_add_Button_pressed():
	add()


#SAY: Signal to check if the player checked on the "Controlled by player" checkbox"
var human_players_without_assigned_controls = 0
var player_assigned_controls = false
# Signal emitted if human player was added and removed
# it will be emitted if the player was added and informs about the controls assignment status
# it will be emitted if the player was removed
func _on_TextureRect_controlled_by_checkbox_changed(human_player_enabled):
	if human_player_enabled:
		human_players_without_assigned_controls += 1
		emit_signal("human_player_added_with_controls",true, player_assigned_controls)
		
		#enable assign_controls
		get_node(AssignControls).visible = true
		
		player_is_human = true
		
	else:
		human_players_without_assigned_controls -= 1
		emit_signal("human_player_added_with_controls",false, player_assigned_controls)
		
		#disable assign_controls
		get_node(AssignControls).visible = false
		
		player_is_human = false
	
	_update_slot_status()

var assigned_controls_count = 0
func _on_input_assigned():
	player_assigned_controls = true
	assigned_controls_count += 1
	if human_players_without_assigned_controls == 1 and assigned_controls_count >= 4:
		emit_signal("human_player_added_with_controls", true, true)
	
		

func _update_slot_status():
	#check if player status is ready
	
	if !player_is_human:
		slot_is_ready = true
	elif player_is_human and control_is_assigned:
		slot_is_ready = true
	else:
		slot_is_ready = false
	
	emit_signal("slot_status_update", slot_is_ready, slot_name, slot_removed)
	return slot_is_ready