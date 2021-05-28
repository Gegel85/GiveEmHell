extends VBoxContainer

func _on_JoinButton_button_up():
	hostVisible(true)
	$HostInfo.grab_focus()

func _on_HostInfo_text_entered(new_text):
	if get_tree().network_peer:
		return
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(new_text, 10800)
	get_tree().network_peer = peer
	get_tree().set_input_as_handled()
	get_tree().change_scene("res://Scenes/NetworkLobby/NetworkLobby.tscn")

func _on_HostInfo_focus_exited():
	$HostInfo.clear()
	hostVisible(false)

func hostVisible(visible):
	$HostInfo.visible = visible
	$JoinButton.visible = !visible
