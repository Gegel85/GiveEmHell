extends VBoxContainer

var ips = []

func _ready():
	load_ips()
	$OptionButton.items.clear()
	$OptionButton.add_item("Pick from history list...")
	for ip in ips:
		$OptionButton.add_item(ip)
	if not ips.empty():
		$OptionButton.select(0)

func save_ips():
	var ipsFile = File.new()

	ipsFile.open("user://ips.save", File.WRITE)
	for ip in ips:
		ipsFile.store_line(ip)
	ipsFile.close()

func load_ips():
	var ipsFile = File.new()

	ips = []
	if not ipsFile.file_exists("user://ips.save"):
		return
	ipsFile.open("user://ips.save", File.READ)
	while ipsFile.get_position() < ipsFile.get_len():
		ips.append(ipsFile.get_line())
	ipsFile.close()

func _on_JoinButton_button_up():
	hostVisible(true)
	$HostInfo.grab_focus()

func _on_HostInfo_text_entered(new_text):
	var i = ips.find(new_text)
	if i == -1:
		ips.append(new_text)
		$OptionButton.add_item(new_text)
		$OptionButton.select($OptionButton.get_item_count())
	else:
		ips.remove(i)
		ips.insert(0, new_text)
	save_ips()
	if get_tree().network_peer:
		return
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(new_text, 10800)
	get_tree().network_peer = peer
	get_tree().set_input_as_handled()
	get_tree().change_scene("res://Scenes/NetworkLobby/NetworkLobby.tscn")

func _on_OptionButton_item_selected(index):
	if index > 0:
		$HostInfo.text = $OptionButton.get_item_text(index)

func hostVisible(visible):
	$HostInfo.visible = visible
	$JoinButton.visible = !visible
	$OptionButton.visible = visible and not ips.empty()

func _on_HostInfo_text_changed(new_text):
	$OptionButton.select(0)
