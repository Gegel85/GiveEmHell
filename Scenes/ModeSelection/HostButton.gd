extends Button

func _on_HostButton_button_up():
	if get_tree().network_peer:
		return
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(10800, 4)
	get_tree().network_peer = peer
	get_tree().change_scene('res://Scenes/NetworkLobby/NetworkLobby.tscn')
